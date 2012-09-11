//
//  TLMP4Tag+FileParser.m
//  TagLib
//
//  Created by Scott Perry on 8/10/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Tag+FileParser.h"
#import "TLMP4AtomInfo.h"
#import "TLID3v1Genres.h"
#import "NSData+GetTypedData.h"

@implementation TLMP4Tag (FileParser)

- (void) parseFile:(NSFileHandle *)file withAtoms:(TLMP4Atoms *)atoms
{
    TLMP4Atom *ilst = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    if (!ilst) {
        return;
    }
    
    self->_file = file;
    
    for (TLMP4Atom *atom in [[ilst children] objectEnumerator]) {
        if (!TLMP4AtomIsValid([atom name])) {
            TLLog(@"discarded invalid atom %@", [atom name]);
            continue;
        }
        
        [self->_file seekToFileOffset:[atom offset] + 8];
        if ([[atom name] isEqualToString:@"----"]) {
            [self parseFreeFormForAtom:atom];
        } else if ([[atom name] isEqualToString:kTrackNumber] ||
                   [[atom name] isEqualToString:kDiskNumber]) {
            [self parseIntPairForAtom:atom];
        } else if ([[atom name] isEqualToString:kCompilation] ||
                   [[atom name] isEqualToString:kGaplessPlayback] ||
                   [[atom name] isEqualToString:kPodcast]) {
            [self parseBoolForAtom:atom];
        } else if ([[atom name] isEqualToString:kBPM] ||
                   [[atom name] isEqualToString:kStik] ||
                   [[atom name] isEqualToString:kTVSeason] ||
                   [[atom name] isEqualToString:kTVEpisode] ||
                   [[atom name] isEqualToString:kRating]) {
            [self parseIntForAtom:atom];
        } else if ([[atom name] isEqualToString:kGenreCode]) {
            [self parseGnreForAtom:atom];
        } else if ([[atom name] isEqualToString:kArtwork]) {
            [self parseCovrForAtom:atom];
        } else {
            [self parseTextForAtom:atom];
        }
    }
    
    self->_file = nil;
}

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
        uint32 length = [data unsignedIntAtOffset:pos endianness:OSBigEndian];        
        NSString *name = [data stringWithRange:NSMakeRange(pos + 4, 4) encoding:NSMacOSRomanStringEncoding];
        uint32 atomFlags = [data unsignedIntAtOffset:(pos + 8) endianness:OSBigEndian];
        
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
            [result addObject:[datum stringWithEncoding:NSUTF8StringEncoding]];
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
                      [[data objectAtIndex:0] stringWithEncoding:NSMacOSRomanStringEncoding],
                      [[data objectAtIndex:1] stringWithEncoding:NSMacOSRomanStringEncoding]];
    
    for (unsigned int i = 2; i < [data count]; ++i) {
        [result addObject:[[data objectAtIndex:i] stringWithEncoding:NSMacOSRomanStringEncoding]];
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
        if ([datum length]) {
            NSNumber *value = [datum numberWithEndianness:OSBigEndian];
            if ([value isGreaterThan:[NSNumber numberWithUnsignedInt:UINT8_MAX]]) {
                TLNotTested();
            }
            [result addObject:value];
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
        if ([datum length]) {
            NSNumber *index = [datum numberWithEndianness:OSBigEndian];
            // NOTE: index of 0 is "unset" in ID3/MP4. lookups shift by 1.
            if (index != 0 && [TLID3v1Genres genreForIndex:([index integerValue] - 1)]) {
                [result addObject:index];
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
        TLCheck([datum length] == 6 || [datum length] == 8);
        if ([datum length] >= 6) {
            [result addObject:[NSArray arrayWithObjects:[datum numberWithRange:NSMakeRange(2, 2) endianness:OSBigEndian],
                                                        [datum numberWithRange:NSMakeRange(4, 2) endianness:OSBigEndian], nil]];
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
        if ([datum length]) {
            uint8 value = 0;
            if ([datum length]) {
                value = [datum unsignedCharAtOffset:0];
                TLCheck(value <= 1);
                if (value == 1) {
                    [result addObject:[NSNumber numberWithBool:1]];
                }
            }
            if (!value) {
                [result addObject:[NSNumber numberWithBool:0]];
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
        uint32 length = [data unsignedIntAtOffset:pos endianness:OSBigEndian];
        NSString *name = [[NSString alloc] initWithCString:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                                                  encoding:NSMacOSRomanStringEncoding];
        uint32 flags = [data unsignedIntAtOffset:(pos + 8) endianness:OSBigEndian];
        
        if (![name isEqualToString:@"data"]) {
            TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
            [result removeAllObjects];
            break;
        }
        
        TLCheck((flags == TLMP4AtomFlagsJPEG || flags == TLMP4AtomFlagsPNG) && length > 16);
        if ((flags == TLMP4AtomFlagsJPEG || flags == TLMP4AtomFlagsPNG) && length > 16) {
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
