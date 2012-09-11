//
//  NSData+Swapped.h
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Endian)
- (void)getBytes:(void *)buffer endianness:(int32_t)endianness;
- (void)getBytes:(void *)buffer length:(NSUInteger)length endianness:(int32_t)endianness;
- (void)getBytes:(void *)buffer range:(NSRange)range endianness:(int32_t)endianness;
@end
