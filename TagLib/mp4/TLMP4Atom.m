//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "MP4Atom.h"

static NSSet *containers = nil;

@implementation MP4Atom

@synthesize offset;
@synthesize length;
@synthesize name;
@synthesize children;

- (NSDictionary *) children
{
    return self->children;
}

- (MP4Atom *) initWithFile: (NSFileHandle *)file
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
    self->name = [NSString alloc];
    self->children = [NSMutableDictionary alloc];

    NSData *header = [file readDataOfLength:8];
    if ([header length] != 8) {
        TLLog(@"MP4: Couldn't read 8 bytes of data for atom header. (Got %lu bytes)",
              [header length]);
        self->length = 0;
        [file seekToEndOfFile];
        return nil;
    }
    
    [header getBytes:&self->length length:4];
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
    if (self->length < 8) {
        TLLog(@"MP4: Invalid atom size: %llu", self->length);
        [file seekToEndOfFile];
        return nil;
    }
    
    [self->name initWithBytes:[[header subdataWithRange:NSMakeRange(4, 4)] bytes]
                length:4 encoding:NSMacOSRomanStringEncoding];

    if ([containers containsObject:self->name]) {
        if ([self->name isEqualToString:@"meta"]) {
            [file seekToFileOffset:[file offsetInFile] + 4];
        }

        while ([file offsetInFile] < self->offset + self->length) {
            MP4Atom *child = [[MP4Atom alloc] initWithFile:file];
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
    MP4Atom *atom;

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
    MP4Atom *hit;
    
    if ((hit = [children objectForKey:findName])) {
        [hits addObject:hit];
    }
    
    if (recursive) {
        NSEnumerator *enumerator = [children objectEnumerator];
        for (MP4Atom *child in enumerator) {
            [hits addObjectsFromArray:[child findAllWithName:findName recursive:recursive]];
        }
    }
    
    return hits;
}

@end
