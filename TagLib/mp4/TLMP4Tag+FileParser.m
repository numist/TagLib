//
//  TLMP4Tag+FileParser.m
//  TagLib
//
//  Created by Scott Perry on 8/10/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLMP4Tag+FileParser.h"
#import "TLMP4AtomInfo.h"

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
    unsigned int pos = 0;
    while (pos < [data length]) {
        unsigned int length;
        [data getBytes:&length range:NSMakeRange(pos, 4)];
        
        NSString *name = [[NSString alloc] initWithBytes:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                                                  length:4
                                                encoding:NSMacOSRomanStringEncoding];
        
        int32_t atomFlags;
        [data getBytes:&atomFlags range:NSMakeRange(pos + 8, 4)];
        
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
            if (flags == -1 || flags == atomFlags) {
                [result addObject:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]];
            }
        }
        
        pos += length;
        ++i;
    }
    
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
        TLLog(@"text atom: %@ datum size: %u", [atom name], [datum length]);
        
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
    TLLog(@"freeform atom: %@ datums: %u, generated name %@", [atom name], [data count] - 2, name);    
    
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
        TLCheck([datum length] >= 2);
        TLLog(@"numeric atom: %@ datum size: %u, reading 0, 1", [atom name], [datum length]);
        
        if ([datum length] >= 1) {
            uint32 value;
            [datum getBytes:&value length:4];
            if (value > UINT8_MAX) {
                TLLog(@"Parsed value (%u) that won't fit in 8 bits, skipping", value);
            } else {
                [result addObject:[NSNumber numberWithUnsignedChar:value]];
            }
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
        TLCheck([datum length] >= 4);
        TLLog(@"gnre atom: %@ datum size: %u, reading 0, 4", [atom name], [datum length]);
        
        if ([datum length] >= 1) {
            uint32 index;
            [datum getBytes:&index length:4];
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
        TLLog(@"intpair atom: %@ datum size: %u, reading 2, 4", [atom name], [datum length]);
        
        if ([datum length] >= 6) {
            unsigned short a, b;
            [datum getBytes:&a range:NSMakeRange(2, 2)];
            [datum getBytes:&b range:NSMakeRange(4, 2)];
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
        TLLog(@"bool atom: %@ datum size: %u, reading 0, 1", [atom name], [datum length]);
        
        if ([datum length] >= 1) {
            if ([datum length]) {
                uint8 value;
                [datum getBytes:&value length:1];
                if (value == 1) {
                    [result addObject:[NSNumber numberWithBool:YES]];
                }
            }
            if (result == nil) {
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
        [data getBytes:&length range:NSMakeRange(pos, 4)];
        NSString *name = [NSString alloc];
        [name initWithCString:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                     encoding:NSMacOSRomanStringEncoding];
        uint32 flags;
        [data getBytes:&flags range:NSMakeRange(pos + 8, 4)];
        
        if (![name isEqualToString:@"data"]) {
            TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
            [result removeAllObjects];
            break;
        }
        
        TLLog(@"covr atom: %@ datum size: %u, reading all", [atom name], length - 16);
        TLCheck((flags == FlagsJPEG || flags == FlagsPNG) && length > 16);
        if ((flags == FlagsJPEG || flags == FlagsPNG) && length > 16) {
            [result addObject:[[NSImage alloc] initWithData:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]]];
        }
    }
    
    if ([result count]) {
        [self->_items setValue:result forKey:[atom name]];
    }
}

@end
