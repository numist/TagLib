//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Atom.h"
#import "NSData+Swapped.h"

static NSSet *containers = nil;

@implementation TLMP4Atom

@synthesize offset;
@synthesize length;
@synthesize name;
@synthesize children;

- (NSDictionary *) children
{
    return self->children;
}

- (TLMP4Atom *) initWithFile: (NSFileHandle *)file
{
    NSParameterAssert(file);
    
    self = [super init];

    if (!containers) {
        containers = [NSSet setWithObjects:@"moov", @"udta", @"mdia", @"meta",
                      @"ilst", @"stbl", @"minf", @"moof", @"traf", @"trak",
                      nil];
    }

    if (!self) {
        return nil;
    }
    
    self->offset = [file offsetInFile];
    self->children = [[NSMutableDictionary alloc] init];
    unsigned long totalLength = [file seekToEndOfFile];
    [file seekToFileOffset:self->offset];

    NSData *header = [file readDataOfLength:8];
    if ([header length] != 8) {
        TLLog(@"MP4: Couldn't read 8 bytes of data for atom header. (Got %lu bytes)",
              [header length]);
        self->length = 0;
        [file seekToEndOfFile];
        return nil;
    }
    
    [header getSwappedBytes:&self->length length:4];
    if (self->length == 1) {
        [[file readDataOfLength:8] getBytes:&self->length];
        if (self->length > UINT32_MAX) {
            TLLog(@"MP4: 64-bit atoms are not supported. (Got %llu bytes)",
                  self->length);
            [file seekToEndOfFile];
            return nil;
        }
        // The atom has a 64-bit length, but it's actually a 32-bit value
    }
    if (self->length < 8 || self->length > totalLength) {
        TLLog(@"MP4: Invalid atom size: %llu", self->length);
        [file seekToEndOfFile];
        return nil;
    }
    
    self->name = [[NSString alloc] initWithBytes:[[header subdataWithRange:NSMakeRange(4, 4)] bytes]
                length:4 encoding:NSMacOSRomanStringEncoding];

    if ([containers containsObject:self->name]) {
        if ([self->name isEqualToString:@"meta"]) {
            [file seekToFileOffset:[file offsetInFile] + 4];
        }

        while ([file offsetInFile] < self->offset + self->length) {
            TLMP4Atom *child = [[TLMP4Atom alloc] initWithFile:file];
            if (!child) {
                [file seekToEndOfFile];
                return nil;
            }
            [self->children setValue:child forKey:[child name]];
        }
    }
    
    [file seekToFileOffset:self->offset + self->length];
    return self;
}

- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path
{
    TLMP4Atom *atom;

    [atoms addObject:self];

    if ([path count] == 0) {
        return true;
    } else if (!(atom = [children objectForKey:[path objectAtIndex:0]])) {
        [atoms removeAllObjects];
        return false;
    }

    [path removeObjectAtIndex:0];
    return [atom getAtoms:atoms withPath:path];
}

- (NSArray *) findAllWithName: (NSString *)findName
{
    return [self findAllWithName:findName recursive:false];
}

- (NSArray *) findAllWithName: (NSString *)findName recursive: (BOOL)recursive
{
    NSMutableArray *hits = [[NSMutableArray alloc] init];
    TLMP4Atom *hit;
    
    if ((hit = [children objectForKey:findName])) {
        [hits addObject:hit];
    }
    
    if (recursive) {
        NSEnumerator *enumerator = [children objectEnumerator];
        for (TLMP4Atom *child in enumerator) {
            [hits addObjectsFromArray:[child findAllWithName:findName recursive:recursive]];
        }
    }
    
    return hits;
}

- (NSString *) description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"Atom: %@, length %u, offset %u", self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %u children: {\n", [self->children count]];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:@"\t"]];
        }
        [result appendFormat:@"} End of atom: %@", self->name];
    }
    return result;
}

- (NSString *) descriptionWithIndent:(NSString *)indent
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@Atom: %@, length %u, offset %u", indent, self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %u children: {\n", [self->children count]];
        NSString *newIndent = [NSString stringWithFormat:@"%@%@", @"\t", indent];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:newIndent]];
        }
        [result appendFormat:@"%@} End of atom: %@", indent, self->name];
    }
    return result;
}

@end
