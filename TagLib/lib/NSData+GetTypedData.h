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

- (NSNumber *)number;
- (NSNumber *)numberSwapped:(BOOL)swapped;
- (NSNumber *)numberWithLength:(NSUInteger)length;
- (NSNumber *)numberWithLength:(NSUInteger)length swapped:(BOOL)swapped;
- (NSNumber *)numberWithRange:(NSRange)range;
- (NSNumber *)numberWithRange:(NSRange)range swapped: (BOOL)swapped;

- (uint8) unsignedCharAtOffset:(NSUInteger)offset;
- (uint16) unsignedShortAtOffset:(NSUInteger)offset;
- (uint32) unsignedIntAtOffset:(NSUInteger)offset;
- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset;

- (uint16) unsignedShortAtOffset:(NSUInteger)offset swapped:(BOOL)swapped;
- (uint32) unsignedIntAtOffset:(NSUInteger)offset swapped:(BOOL)swapped;
- (uint64) unsignedLongLongAtOffset:(NSUInteger)offset swapped:(BOOL)swapped;

@end
