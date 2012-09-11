//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "debugger.h"
#import "NSData+Endian.h"
#import "TLMP4Atom.h"

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
    if (!file) {
        return nil;
    }
    
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
    unsigned long long totalLength = [file seekToEndOfFile];
    [file seekToFileOffset:self->offset];

    NSData *header = [file readDataOfLength:8];
    if ([header length] != 8) {
        TLLog(@"MP4: Couldn't read 8 bytes of data for atom header. (Got %lu bytes)",
              [header length]);
        self->length = 0;
        [file seekToEndOfFile];
        return nil;
    }
    
    [header getBytes:&self->length length:4 endianness:OSBigEndian];
    if (self->length == 1) {
        [[file readDataOfLength:8] getBytes:&self->length endianness:OSBigEndian];
        if (self->length > UINT32_MAX) {
            TLCheck(self->length <= UINT32_MAX);
            TLLog(@"MP4: 64-bit atoms are not supported. (Got %llu bytes)",
                  self->length);
            [file seekToEndOfFile];
            return nil;
        }
        // The atom has a 64-bit length, but it's actually a 32-bit value
    }
    if (self->length < 8 || self->length + self->offset > totalLength) {
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
            if (!child || [file offsetInFile] > self->offset + self->length) {
                if (child) {
                    TLLog(@"child atom(%@) exceededs boundary of parent", [child name]);
                }
                [file seekToEndOfFile];
                return nil;
            }
            [self->children setValue:child forKey:[child name]];
        }
    }
    
    [file seekToFileOffset:self->offset + self->length];
    return self;
}

- (TLMP4Atom *) init
{
    return [self initWithFile:nil];
}

- (TLMP4Atom *) getAtomWithPath: (NSArray *)path
{
    NSParameterAssert([path count] > 0);
    
    /*
     * NOTE: if this is too slow, implement MP4Atom findAtomAtPath:
     *
     *  - (MP4Atom *) findAtomAtPath: (NSMutableArray *)path
     *  {
     *      if ([path count] == 0) {
     *          return self;
     *      }
     *    
     *      MP4Atom *child = [children objectForKey:[path objectAtIndex:0]];
     *      [path removeObjectAtIndex:0];
     *      return [child findAtomAtPath:path];
     *  }
     */
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self getAtoms:result withPath:[NSMutableArray arrayWithArray:path]];
    return [result lastObject];
}

- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path
{
    TLMP4Atom *atom;

    [atoms addObject:self];

    if ([path count] == 0) {
        return YES;
    } else if (!(atom = [children objectForKey:[path objectAtIndex:0]])) {
        [atoms removeAllObjects];
        return NO;
    }

    [path removeObjectAtIndex:0];
    return [atom getAtoms:atoms withPath:path];
}

- (NSArray *) findAllWithName: (NSString *)findName
{
    return [self findAllWithName:findName recursive:NO];
}

- (NSArray *) findAllWithName: (NSString *)findName recursive: (BOOL)recursive
{
    NSMutableArray *hits = [[NSMutableArray alloc] init];
    TLMP4Atom *hit;
    
    if ((hit = [children objectForKey:findName])) {
        [hits addObject:hit];
    }
    
    if (recursive) {
        for (TLMP4Atom *child in [children objectEnumerator]) {
            [hits addObjectsFromArray:[child findAllWithName:findName recursive:recursive]];
        }
    }
    
    return hits;
}

- (NSString *) description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"Atom: %@, length %llu, offset %llu", self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %lu children: {\n", [self->children count]];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:@"\t"]];
        }
        [result appendFormat:@"} End of atom: %@", self->name];
    }
    return result;
}

- (NSString *) descriptionWithIndent:(NSString *)indent
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@Atom: %@, length %llu, offset %llu", indent, self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %lu children: {\n", [self->children count]];
        NSString *newIndent = [NSString stringWithFormat:@"%@%@", @"\t", indent];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:newIndent]];
        }
        [result appendFormat:@"%@} End of atom: %@", indent, self->name];
    }
    return result;
}

@end
