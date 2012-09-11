//
//  NSData+Swapped.h
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Swapped)
- (void)getSwappedBytes:(void *)buffer;
- (void)getSwappedBytes:(void *)buffer length:(NSUInteger)length;
- (void)getSwappedBytes:(void *)buffer range:(NSRange)range;
@end
