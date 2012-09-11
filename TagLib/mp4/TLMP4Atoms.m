//
//  MP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "debugger.h"
#import "TLMP4Atoms.h"

@interface TLMP4Atoms ()
    - (NSArray *) _getAtomsWithPath: (NSMutableArray *)path;
@end

@implementation TLMP4Atoms

@synthesize atoms;

- (NSDictionary *) atoms
{
    TLNotTested();
    return self->atoms;
}

- (TLMP4Atoms *) initWithFile: (NSFileHandle *)file
{
    if (!file) {
        return nil;
    }

    self = [super init];
    if (self) {
        self->atoms = [[NSMutableDictionary alloc] init];
        unsigned long long end = [file seekToEndOfFile];
        [file seekToFileOffset:0];
        
        while ([file offsetInFile] + 8 < end) {
            TLMP4Atom *atom = [(TLMP4Atom *)[TLMP4Atom alloc] initWithFile:file];
            // NOTE: in the C++ impl, returns incomplete atom set
            if (!atom) {
                return nil;
            }
            [self->atoms setValue:atom forKey:[atom name]];
        }
        if ([self->atoms count] == 0) {
            return nil;
        }
    }
    return self;
}

- (TLMP4Atoms *) init
{
    return [self initWithFile:nil];
}

- (TLMP4Atom *) findAtomAtPath: (NSArray *)path
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

- (NSArray *) getAtomsWithPath: (NSArray *)path
{
    NSMutableArray *writablePath = [NSMutableArray arrayWithArray:path];
    return [self _getAtomsWithPath:writablePath];
}

- (NSArray *) _getAtomsWithPath: (NSMutableArray *)path
{
    NSParameterAssert([path count] > 0);
    
    NSMutableArray *foundAtoms = [[NSMutableArray alloc] initWithCapacity:[path count]];
    TLMP4Atom *match = [self->atoms objectForKey:[path objectAtIndex:0]];
    if (!match) {
        return nil;
    }
    
    [path removeObjectAtIndex:0];
    if (![match getAtoms:foundAtoms withPath:path]) {
        return nil;
    }
    return foundAtoms;
}

- (NSString *) description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"TLMP4Atoms(%lu)", [self->atoms count]];
    
    if ([self->atoms count]) {
        [result appendString:@": {\n"];
        for (TLMP4Atom *atom in [self->atoms objectEnumerator]) {
            [result appendFormat:@"%@\n", [atom descriptionWithIndent:@"\t"]];
        }
        [result appendString:@"} End of atoms"];
    }
    return result;
}

@end
