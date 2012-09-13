//
//  NSData+GetTypedData.m
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//

#import "debugger.h"
#import "NSData+Endian.h"
#import "NSData+GetTypedData.h"

@implementation NSData (NSData_GetTypedData)

#pragma mark -
#pragma mark String creation from data
// Note: safe for character and char-multibyte encodings only. Not UTF-16 safe.

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

- (NSNumber *)numberWithEndianness:(int32_t)endianness
{
    return [self numberWithLength:[self length] endianness:endianness];
}

- (NSNumber *)numberWithLength:(NSUInteger)length endianness:(int32_t)endianness
{
    return [self numberWithRange:NSMakeRange(0, length) endianness:endianness];
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
#pragma mark Size-sensitive data getters

- (uint8) unsignedCharAtOffset:(NSUInteger)offset
{
    uint8 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint8))];
    return value;
}

- (uint16) unsignedShortAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    uint16 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint16)) endianness:endianness];
    return value;
}

- (uint32) unsignedIntAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    uint32 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint32)) endianness:endianness];
    return value;
}

- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset endianness:(int32_t)endianness
{
    uint64 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint64)) endianness:endianness];
    return value;
}

@end
