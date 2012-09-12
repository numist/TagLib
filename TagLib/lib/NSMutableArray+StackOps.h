//
//  NSMutableArray+StackOps.h
//  TagLib
//
//  Created by Scott Perry on 09/12/12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (StackOps)
- (id)popObjectAtIndex:(NSUInteger)index;
- (id)popLastObject;
- (id)popFirstObject;
@end
