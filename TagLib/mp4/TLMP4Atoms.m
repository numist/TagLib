//
//  MP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Atoms.h"

@implementation TLMP4Atoms

@synthesize atoms;

- (NSDictionary *) atoms
{
    return self->atoms;
}

- (TLMP4Atoms *) initWithFile: (NSFileHandle *)file
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    unsigned long long end = [file seekToEndOfFile];
    [file seekToFileOffset:0];
    
    TODO("+8 isn't really necessary, is it? the MP4Atom ctor should handle it");
    while ([file offsetInFile] + 8 < end) {
        TLMP4Atom * atom = [[TLMP4Atom alloc] initWithFile:file];
        // NOTE: in the C++ impl, returns incomplete atom set
        if ([atom length] == 0) {
            return nil;
        }
        [self->atoms setValue:atom forKey:[atom name]];
    }

    return self;
}

- (TLMP4Atom *) findAtomAtPath: (NSMutableArray *)path
{
    NSParameterAssert([path count] > 0);
    
    /*
     * NOTE: if this is too slow, use MP4Atom findAtomAtPath:
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
    return [[self getAtomsWithPath:path] lastObject];
}

- (NSArray *) getAtomsWithPath: (NSMutableArray *)path
{
    NSParameterAssert([path count] > 0);

    NSMutableArray *foundAtoms = [[NSMutableArray alloc] initWithCapacity:[path count]];
    TLMP4Atom *match = [self->atoms objectForKey:[path objectAtIndex:0]];
    if (!match) {
        return nil;
    }
    
    [foundAtoms addObject:match];
    [path removeObjectAtIndex:0];
    if (![match getAtoms:foundAtoms withPath:path]) {
        return nil;
    }
    return foundAtoms;
}


@end
