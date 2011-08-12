//
//  TLMP4Tag+FileParser.m
//  TagLib
//
//  Created by Scott Perry on 8/10/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLMP4Tag+FileParser.h"
#import "TLMP4AtomInfo.h"
#import "TLID3v1Genres.h"
#import "NSData+Swapped.h"

@implementation TLMP4Tag (FileParser)

- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom
{
    return [self parseDataForAtom:atom expectedFlags:-1];
}

- (NSArray *) parseDataForAtom: (TLMP4Atom *) atom expectedFlags: (int32_t)flags
{
    return [self parseDataForAtom:atom expectedFlags:flags freeForm:NO];
}

- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags freeForm: (BOOL)freeForm
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSData *data = [self->_file readDataOfLength:([atom length] - 8)];
    int i = 0;
    uint32 pos = 0;
    while (pos < [data length]) {
        uint32 length;
        [data getSwappedBytes:&length range:NSMakeRange(pos, 4)];
        
        NSString *name = [[NSString alloc] initWithBytes:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                                                  length:4
                                                encoding:NSMacOSRomanStringEncoding];
        
        uint32 atomFlags;
        [data getSwappedBytes:&atomFlags range:NSMakeRange(pos + 8, 4)];
        
        if (freeForm && i < 2) {
            if (i == 0 && ![name isEqualToString:@"mean"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"mean\"", name);
                return nil;
            } else if (i == 1 && ![name isEqualToString:@"name"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"name\"", name);
                return nil;
            }
            [result addObject:[data subdataWithRange:NSMakeRange(pos + 12, length - 12)]];
        } else {
            if (![name isEqualToString:@"data"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
                return nil;
            }
            if (flags < 0 || (uint32)flags == atomFlags) {
                [result addObject:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]];
            }
        }
        
        pos += length;
        ++i;
    }
    TLAssert(pos == [data length]);
    
    return result;
}

- (void) parseTextForAtom: (TLMP4Atom *)atom
{
    [self parseTextForAtom:atom expectedFlags:-1];
}

- (void) parseTextForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags
{
    NSArray *data = [self parseDataForAtom:atom expectedFlags:flags];
    TLCheck([data count] == 1);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSData *datum in data) {
        TLCheck([datum length] >= 2);
        if ([datum length] >= 1) {
            [result addObject:[NSString stringWithCString:[datum bytes] encoding:NSUTF8StringEncoding]];
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseFreeFormForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom expectedFlags:1 freeForm:YES];
    TLCheck([data count] > 2);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *name = [NSString stringWithFormat:@"----:%@:%@",
                      [NSString stringWithCString:[[data objectAtIndex:0] bytes]
                                         encoding:NSMacOSRomanStringEncoding],
                      [NSString stringWithCString:[[data objectAtIndex:1] bytes]
                                         encoding:NSMacOSRomanStringEncoding]];
    
    for (unsigned int i = 2; i < [data count]; ++i) {
        [result addObject:[NSString stringWithCString:[[data objectAtIndex:i] bytes]
                                             encoding:NSUTF8StringEncoding]];
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:name];
    }
}

- (void) parseIntForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSData *datum in data) {
        TLCheck([datum length] == 1 || [datum length] == 4);
        if ([datum length] >= 1) {
            uint32 value;
            [datum getSwappedBytes:&value];
            if (value > UINT8_MAX) {
                TLNotTested();
            }
            [result addObject:[NSNumber numberWithUnsignedInt:value]];
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseGnreForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSData *datum in data) {
        TLCheck([datum length] == 2);
        if ([datum length] >= 2) {
            uint32 index;
            [datum getSwappedBytes:&index length:2];
            // NOTE: index of 0 is "unset" in ID3/MP4. lookups shift by 1.
            if (index != 0 && [TLID3v1Genres genreForIndex:(index - 1)]) {
                [result addObject:[NSNumber numberWithUnsignedChar:index]];
            }
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseIntPairForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSData *datum in data) {
        TLCheck([datum length] >= 6);
        if ([datum length] >= 6) {
            unsigned short a, b;
            [datum getSwappedBytes:&a range:NSMakeRange(2, 2)];
            [datum getSwappedBytes:&b range:NSMakeRange(4, 2)];
            [result addObject:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedShort:a], [NSNumber numberWithUnsignedShort:b], nil]];
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseBoolForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSData *datum in data) {
        TLCheck([datum length] >= 1);
        if ([datum length] >= 1) {
            uint8 value = 0;
            if ([datum length]) {
                [datum getSwappedBytes:&value length:1];
                if (value == 1) {
                    [result addObject:[NSNumber numberWithBool:YES]];
                }
            }
            if (!value) {
                [result addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseCovrForAtom: (TLMP4Atom *)atom
{
    NSData *data = [self->_file readDataOfLength:[atom length] - 8];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    uint32 pos = 0;
    while (pos < [data length]) {
        uint32 length;
        [data getSwappedBytes:&length range:NSMakeRange(pos, 4)];
        NSString *name = [[NSString alloc] initWithCString:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                                                  encoding:NSMacOSRomanStringEncoding];
        uint32 flags;
        [data getSwappedBytes:&flags range:NSMakeRange(pos + 8, 4)];
        
        if (![name isEqualToString:@"data"]) {
            TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
            [result removeAllObjects];
            break;
        }
        
        TLCheck((flags == FlagsJPEG || flags == FlagsPNG) && length > 16);
        if ((flags == FlagsJPEG || flags == FlagsPNG) && length > 16) {
            NSImage *art = [[NSImage alloc] initWithData:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]];
            TLCheck([art isValid]);
            [result addObject:art];
        }
        
        pos += length;
    }
    TLAssert(pos == [data length]);
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

@end
