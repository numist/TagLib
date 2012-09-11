//
//  NSData+GetTypedData.h
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_GetTypedData)

- (NSString *)stringWithEncoding:(NSStringEncoding)enc;
- (NSString *)stringWithLength:(NSUInteger)length encoding:(NSStringEncoding)enc;
- (NSString *)stringWithRange:(NSRange)range encoding:(NSStringEncoding)enc;

- (NSNumber *)numberWithEndianness:(int32_t)endianness;
- (NSNumber *)numberWithLength:(NSUInteger)length endianness:(int32_t)endianness;
- (NSNumber *)numberWithRange:(NSRange)range endianness:(int32_t)endianness;

- (uint8)  unsignedCharAtOffset:(NSUInteger)offset;
- (uint16) unsignedShortAtOffset:(NSUInteger)offset endianness:(int32_t)endianness;
- (uint32) unsignedIntAtOffset:(NSUInteger)offset endianness:(int32_t)endianness;
- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset endianness:(int32_t)endianness;

@end
