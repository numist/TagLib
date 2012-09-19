//
//  NSMutableArray+StackOps.m
//  TagLib
//
//  Created by Scott Perry on 09/12/12.
//
//

#import "NSMutableArray+StackOps.h"

@implementation NSMutableArray (StackOps)
- (id)popObjectAtIndex:(NSUInteger)index;
{
    id data = [self objectAtIndex:index];
    [self removeObjectAtIndex:index];
    return data;
}

- (id)popLastObject;
{
    return [self popObjectAtIndex:([self count] - 1)];
}

- (id)popFirstObject;
{
    return [self popObjectAtIndex:0];
}

@end
