//
//  NSData+Swapped.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "NSData+Swapped.h"

@implementation NSData (Swapped)

- (void)getSwappedBytes:(void *)buffer
{
    [self getSwappedBytes:buffer length:[self length]];
}

- (void)getSwappedBytes:(void *)buffer length:(NSUInteger)length
{
    [self getSwappedBytes:buffer range:NSMakeRange(0, length)];
}

- (void)getSwappedBytes:(void *)buffer range:(NSRange)range
{
    [self getBytes:buffer range:range];
    TLCheck(((long)buffer & 1) == 0 || range.length <= 1);

    switch (range.length) {
        case 0:
        case 1:
            // what I don't even…
            return;
            
        case 2:
            *(uint16 *)buffer = NSSwapShort(*(uint16 *)buffer);
            break;
            
        case 4:
            *(uint32 *)buffer = NSSwapInt(*(uint32 *)buffer);
            break;

        case 8:
            *(uint64 *)buffer = NSSwapLongLong(*(uint64 *)buffer);
            break;
            
        default:
            TLAssert(range.length % 2 == 0);
            TLLog(@"Swapping %u bytes the slow way", range.length);
            uint8 *workingBuf = buffer;
            for (unsigned long early = 0, late = range.length - 1;
                 early < late; ++early, --late) {
                
                uint8 tmp = workingBuf[early];
                workingBuf[early] = workingBuf[late];
                workingBuf[late] = tmp;
                
                TLAssert(early != late);
            }
            break;
    }
}
@end
