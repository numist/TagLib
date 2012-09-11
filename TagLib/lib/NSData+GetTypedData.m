//
//  NSData+GetTypedData.m
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "NSData+GetTypedData.h"
#import "NSData+Swapped.h"

@implementation NSData (NSData_GetTypedData)

#pragma mark -
#pragma mark String creation from data

- (NSString *)stringWithEncoding:(NSStringEncoding) enc
{
    return [self stringWithLength:[self length] encoding:enc];
}

- (NSString *)stringWithLength:(NSUInteger)length encoding:(NSStringEncoding)enc
{
    return [self stringWithRange:NSMakeRange(0, length) encoding:enc];
}

- (NSString *)stringWithRange:(NSRange)range encoding:(NSStringEncoding)enc
{
    return [NSString stringWithCString:[[self subdataWithRange:range] bytes] encoding:enc];
}

#pragma mark -
#pragma mark Number creation from data

- (NSNumber *)number
{
    return [self numberWithEndianness:OSUnknownByteOrder];
}

- (NSNumber *)numberWithEndianness:(int32_t)endianness
{
    return [self numberWithLength:[self length] endianness:endianness];
}

- (NSNumber *)numberWithLength:(NSUInteger)length
{
    return [self numberWithLength:length endianness:OSUnknownByteOrder];
}

- (NSNumber *)numberWithLength:(NSUInteger)length endianness:(int32_t)endianness
{
    return [self numberWithRange:NSMakeRange(0, length) endianness:endianness];
}

- (NSNumber *)numberWithRange:(NSRange)range
{
    return [self numberWithRange:range endianness:OSUnknownByteOrder];
}

- (NSNumber *)numberWithRange:(NSRange)range endianness:(int32_t)endianness
{
    // only accept data sizes that fit in an NSNumber
    TLCheck(0 < range.length &&
             range.length <= 8 &&
             (range.length & (range.length - 1)) == 0);

    switch (range.length) {
        case 1:
            return [NSNumber numberWithUnsignedChar:[self unsignedCharAtOffset:range.location]];
        case 2:
            return [NSNumber numberWithUnsignedShort:[self unsignedShortAtOffset:range.location endianness:endianness]];
        case 4:
            return [NSNumber numberWithUnsignedInt:[self unsignedIntAtOffset:range.location endianness:endianness]];
        case 8:
            return [NSNumber numberWithUnsignedLongLong:[self unsignedLongLongAtOffset:range.location endianness:endianness]];
        default:
            return nil;
    }
}

#pragma mark -
#pragma mark Actual byte twiddling

- (uint8) unsignedCharAtOffset:(NSUInteger)offset
{
    uint8 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint8))];
    return value;
}

- (uint16) unsignedShortAtOffset:(NSUInteger)offset
{
    return [self unsignedShortAtOffset:offset endianness:OSUnknownByteOrder];
}

- (uint32) unsignedIntAtOffset:(NSUInteger)offset
{
    return [self unsignedIntAtOffset:offset endianness:OSUnknownByteOrder];
}

- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset
{
    return [self unsignedLongLongAtOffset:offset endianness:OSUnknownByteOrder];
}

- (uint16) unsignedShortAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    if (endianness == OSUnknownByteOrder) {
        TLAssert(OSHostByteOrder() == OSLittleEndian || OSHostByteOrder() == OSBigEndian);
        TLLog(@"Unknown byte order while requesting multibyte data, assuming OSHostByteOrder(%@)",
              (OSHostByteOrder() == OSLittleEndian ? @"little" : @"big"));
    }

    uint16 value;
    endianness == OSHostByteOrder()
    ? [self getBytes:&value range:NSMakeRange(offset, sizeof(uint16))]
    : [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint16))];
    return value;
}

- (uint32) unsignedIntAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    if (endianness == OSUnknownByteOrder) {
        TLAssert(OSHostByteOrder() == OSLittleEndian || OSHostByteOrder() == OSBigEndian);
        TLLog(@"Unknown byte order while requesting multibyte data, assuming OSHostByteOrder(%@)",
              (OSHostByteOrder() == OSLittleEndian ? @"little" : @"big"));
    }

    uint32 value;
    endianness == OSHostByteOrder()
    ? [self getBytes:&value range:NSMakeRange(offset, sizeof(uint32))]
    : [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint32))];
    return value;
}

- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    if (endianness == OSUnknownByteOrder) {
        TLAssert(OSHostByteOrder() == OSLittleEndian || OSHostByteOrder() == OSBigEndian);
        TLLog(@"Unknown byte order while requesting multibyte data, assuming OSHostByteOrder(%@)",
              (OSHostByteOrder() == OSLittleEndian ? @"little" : @"big"));
    }

    uint64 value;
    endianness == OSHostByteOrder()
    ? [self getBytes:&value range:NSMakeRange(offset, sizeof(uint64))]
    : [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint64))];
    return value;
}

@end
