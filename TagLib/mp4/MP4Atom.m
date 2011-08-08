//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "MP4Atom.h"

@interface MP4Atom() {
    long offset;
    long length;
    NSString *selfName;
    NSMutableDictionary *children;
    NSMutableArray *containers;
}
@end

@implementation MP4Atom

- (id)init
{
    NSAssert(false, @"%@", @"Attempt to create MP4Atom object without a file");
    return nil;
}

- (MP4Atom *) initWithFile: (NSFileHandle *)file
{
    NSAssert(false, @"%@", @"This function is not yet implemented!");
    return nil;
}

- (MP4Atom *) findAtomAtPath: (NSMutableArray *)path
{
    MP4Atom *child = [children objectForKey:[path objectAtIndex:0]];
    
    [path removeObjectAtIndex:0];
    if ([path count] == 0) {
        return child;
    }
    return [child findAtomAtPath:path];
}

- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path
{
    MP4Atom *atom = [children objectForKey:[path objectAtIndex:0]];
    
    if (!atom) {
        return false;
    }
    
    [path removeObjectAtIndex:0];
    if ([path count] == 0) {
        return true;
    }
    
    return [atom getAtoms:atoms withPath:path];
}

- (NSArray *) findAllWithName: (NSString *)name
{
    return [self findAllWithName:name recursive:false];
}

- (NSArray *) findAllWithName: (NSString *)name recursive: (BOOL)recursive
{
    NSMutableArray *hits = [[NSMutableArray alloc] init];
    MP4Atom *hit;
    
    if ((hit = [children objectForKey:name])) {
        [hits addObject:hit];
    }
    
    if (recursive) {
        NSEnumerator *enumerator = [children objectEnumerator];
        for (MP4Atom *child in enumerator) {
            [hits addObjectsFromArray:[child findAllWithName:name recursive:recursive]];
        }
    }
    
    return hits;
}

@end
