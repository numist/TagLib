//
//  NSData+Endian.h
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import <Foundation/Foundation.h>

@interface NSData (Endian)
- (void)getBytes:(void *)buffer endianness:(int32_t)endianness;
- (void)getBytes:(void *)buffer length:(NSUInteger)length endianness:(int32_t)endianness;
- (void)getBytes:(void *)buffer range:(NSRange)range endianness:(int32_t)endianness;
@end
