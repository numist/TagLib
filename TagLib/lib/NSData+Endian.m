//
//  NSData+Swapped.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "NSData+Endian.h"

@implementation NSData (Endian)

- (void)getBytes:(void *)buffer endianness:(int32_t)endianness
{
    [self getBytes:buffer length:[self length] endianness:endianness];
}

- (void)getBytes:(void *)buffer length:(NSUInteger)length endianness:(int32_t)endianness
{
    [self getBytes:buffer range:NSMakeRange(0, length) endianness:endianness];
}

- (void)getBytes:(void *)buffer range:(NSRange)range endianness:(int32_t)endianness
{
    // sanity endianness check
    TLAssert(endianness == OSLittleEndian || endianness == OSBigEndian);
    TLAssert(OSHostByteOrder() == OSLittleEndian || OSHostByteOrder() == OSBigEndian);
    
    switch (range.length) {
        case 0:
        case 1:
            // what I don't even…
            [self getBytes:buffer range:range];
            return;
            
        case 2:
            switch (endianness) {
                case OSLittleEndian:
                    *(uint16_t *)buffer = OSReadLittleInt16([self bytes], range.location);
                    break;
                case OSBigEndian:
                    *(uint16_t *)buffer = OSReadBigInt16([self bytes], range.location);
                    break;
                default:
                    TLNotReached();
            }
            break;
            
        case 4:
            switch (endianness) {
                case OSLittleEndian:
                    *(uint32_t *)buffer = OSReadLittleInt32([self bytes], range.location);
                    break;
                case OSBigEndian:
                    *(uint32_t *)buffer = OSReadBigInt32([self bytes], range.location);
                    break;
                default:
                    TLNotReached();
            }
            break;

        case 8:
            switch (endianness) {
                case OSLittleEndian:
                    *(uint64_t *)buffer = OSReadLittleInt64([self bytes], range.location);
                    break;
                case OSBigEndian:
                    *(uint64_t *)buffer = OSReadBigInt64([self bytes], range.location);
                    break;
                default:
                    TLNotReached();
            }
            break;
            
        default:
            [self getBytes:buffer range:range];
            
            if (OSHostByteOrder() != endianness) {
                TLAssert(range.length % 2 == 0);
                TLLog(@"Swapping %lu bytes the slow way", range.length);

                uint8 *workingBuf = buffer;
                for (unsigned long early = 0, late = range.length - 1;
                     early < late; ++early, --late) {
                
                    uint8 tmp = workingBuf[early];
                    workingBuf[early] = workingBuf[late];
                    workingBuf[late] = tmp;
                }
            }
            break;
    }
}

@end
