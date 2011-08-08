//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "MP4Atom.h"

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

- (MP4Atom *) find: (NSMutableArray *)path
{
    MP4Atom *child = [children objectForKey:[path objectAtIndex:0]];
    
    [path removeObjectAtIndex:0];
    if ([path count] == 0) {
        return child;
    }
    return [child find:path];
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

- (NSArray *) findAll: (NSString *)name
{
    return [self findAll:name recursive:false];
}

- (NSArray *) findAll: (NSString *)name recursive: (BOOL)recursive
{
    NSMutableArray *hits = [[NSMutableArray alloc] init];
    MP4Atom *hit;
    
    if((hit = [children objectForKey:name])) {
        [hits addObject:hit];
    }
    
    if(recursive) {
        NSEnumerator *enumerator = [children objectEnumerator];
        for (MP4Atom *child in enumerator) {
            [hits addObjectsFromArray:[child findAll:name recursive:recursive]];
        }
    }
    
    return hits;
}

@end
