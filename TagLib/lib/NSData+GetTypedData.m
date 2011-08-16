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

- (NSNumber *)number
{
    return [self numberSwapped:NO];
}

- (NSNumber *)numberSwapped:(BOOL)swapped
{
    return [self numberWithLength:[self length] swapped:swapped];
}

- (NSNumber *)numberWithLength:(NSUInteger)length
{
    return [self numberWithLength:length swapped:NO];
}

- (NSNumber *)numberWithLength:(NSUInteger)length swapped:(BOOL)swapped
{
    return [self numberWithRange:NSMakeRange(0, length) swapped:swapped];
}

- (NSNumber *)numberWithRange:(NSRange)range
{
    return [self numberWithRange:range swapped:NO];
}

- (NSNumber *)numberWithRange:(NSRange)range swapped: (BOOL)swapped
{
    // only accept data sizes that fit in an NSNumber
    TLCheck(0 < range.length &&
             range.length <= 8 &&
             (range.length & (range.length - 1)) == 0);

    switch (range.length) {
        case 1:
            return [NSNumber numberWithUnsignedChar:[self unsignedCharAtOffset:range.location]];
        case 2:
            return [NSNumber numberWithUnsignedShort:[self unsignedShortAtOffset:range.location swapped:swapped]];
        case 4:
            return [NSNumber numberWithUnsignedInt:[self unsignedIntAtOffset:range.location swapped:swapped]];
        case 8:
            return [NSNumber numberWithUnsignedLongLong:[self unsignedLongLongAtOffset:range.location swapped:swapped]];
        default:
            return nil;
    }
}

- (uint8) unsignedCharAtOffset:(NSUInteger)offset
{
    uint8 value;
    [self getBytes:&value range:NSMakeRange(offset, sizeof(uint8))];
    return value;
}

- (uint16) unsignedShortAtOffset:(NSUInteger)offset
{
    return [self unsignedShortAtOffset:offset swapped:NO];
}

- (uint32) unsignedIntAtOffset:(NSUInteger)offset
{
    return [self unsignedIntAtOffset:offset swapped:NO];
}

- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset
{
    return [self unsignedLongLongAtOffset:offset swapped:NO];
}

- (uint16) unsignedShortAtOffset:(NSUInteger)offset swapped:(BOOL)swapped
{
    uint16 value;
    swapped ? [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint16))]
            : [self getBytes:&value range:NSMakeRange(offset, sizeof(uint16))];
    return value;
}

- (uint32) unsignedIntAtOffset:(NSUInteger)offset swapped:(BOOL)swapped
{
    uint32 value;
    swapped ? [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint32))]
    : [self getBytes:&value range:NSMakeRange(offset, sizeof(uint32))];
    return value;
}

- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset swapped:(BOOL)swapped
{
    uint64 value;
    swapped ? [self getSwappedBytes:&value range:NSMakeRange(offset, sizeof(uint64))]
    : [self getBytes:&value range:NSMakeRange(offset, sizeof(uint64))];
    return value;
}

@end
