//
//  MP4Tag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Tag.h"
#import "TLID3v1Genres.h"
#import "TLMP4AtomNames.h"

@interface TLMP4Tag () {
    NSMutableDictionary *_items;
    TLMP4Atoms *_atoms;
    NSFileHandle *_file;
}

- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom;
- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)expectedFlags;
- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags freeForm: (BOOL)freeForm;
- (void) parseTextForAtom: (TLMP4Atom *)atom;
- (void) parseTextForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags;
- (void) parseFreeFormForAtom: (TLMP4Atom *)atom;
- (void) parseIntForAtom: (TLMP4Atom *)atom;
- (void) parseGnreForAtom: (TLMP4Atom *)atom;
- (void) parseIntPairForAtom: (TLMP4Atom *)atom;
- (void) parseBoolForAtom: (TLMP4Atom *)atom;
- (void) parseCovrForAtom: (TLMP4Atom *)atom;

@end


@implementation TLMP4Tag

- (NSDictionary *) itemListMap
{
    return self->itemListMap;
}

- (TLMP4Tag *) initWithFile: (NSFileHandle *)file atoms: (TLMP4Atoms *)atoms
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self->_items = [[NSMutableDictionary alloc] init];
    self->_atoms = atoms;
    self->_file = file;

    TLMP4Atom *ilst = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    if (!ilst) {
        TLLog(@"%@", "Atom moov.udta.meta.ilst not found.");
        return nil;
    }
    
    for (TLMP4Atom *atom in [ilst children]) {
        [self->_file seekToFileOffset:[atom offset]];
        if ([[atom name] isEqualToString:@"----"]) {
            [self parseFreeFormForAtom:atom];
        } else if ([[atom name] isEqualToString:kTrackNumber] ||
                   [[atom name] isEqualToString:kDiskNumber]) {
            [self parseIntPairForAtom:atom];
        } else if ([[atom name] isEqualToString:kCompilation] ||
                   [[atom name] isEqualToString:kGaplessPlayback] ||
                   [[atom name] isEqualToString:kPodcast]) {
            [self parseBoolForAtom:atom];
        } else if ([[atom name] isEqualToString:kBPM]) {
            [self parseIntForAtom:atom];
        } else if ([[atom name] isEqualToString:kGenreCode]) {
            [self parseGnreForAtom:atom];
        } else if ([[atom name] isEqualToString:kArtwork]) {
            [self parseCovrForAtom:atom];
        } else {
            [self parseTextForAtom:atom];
        }
    }

    return self;
}

- (BOOL) save
{
    return NO;
}

- (NSString *) title
{
    return [self->_items objectForKey:kTitle];
}

- (NSString *) artist
{
    return [self->_items objectForKey:kArtist];
}

- (NSString *) album
{
    return [self->_items objectForKey:kAlbum];
}

- (NSString *) comment
{
    return [self->_items objectForKey:kComment];
}

- (NSString *) genre
{
    return [self->_items objectForKey:kGenre];
}

- (NSNumber *) year
{
    long result = [[self->_items objectForKey:kYear] integerValue];
    return result ? [NSNumber numberWithLong:result] : nil;
}

- (NSNumber *) track
{
    return [[self->_items objectForKey:kTrackNumber] objectAtIndex:0];
}

- (void) setTitle: (NSString *) title
{
    [self->_items setObject:title forKey:kTitle];
}

- (void) setArtist: (NSString *) artist
{
    [self->_items setObject:artist forKey:kArtist];
}

- (void) setAlbum: (NSString *) album
{
    [self->_items setObject:album forKey:kAlbum];
}

- (void) setComment: (NSString *) comment
{
    [self->_items setObject:comment forKey:kComment];
}

- (void) setGenre: (NSString *) genre
{
    [self->_items setObject:genre forKey:kGenre];
}

- (void) setYear: (NSNumber *) year
{
    if (![year isEqualToNumber:[NSNumber numberWithLong:0]]) {
        [self->_items setObject:year forKey:kYear];
    } else {
        [self->_items setObject:@"" forKey:kYear];
    }
}

- (void) setTrack: (NSNumber *) track
{
    [self->_items setObject:[NSArray arrayWithObjects:track, [NSNumber numberWithInt:0], nil]
                  forKey:kTrackNumber];
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
    NSData *datum = [data objectAtIndex:0];
    TLLog(@"datum size: %u", [datum length]);
    
    if ([datum length]) {
        [self->_items setValue:[NSString stringWithCString:[datum bytes] encoding:NSUTF8StringEncoding]
                        forKey:[atom name]];
    }
}

- (void) parseFreeFormForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom expectedFlags:1 freeForm:YES];
    TLCheck([data count] > 2);
    
    NSString *name = [NSString stringWithFormat:@"----:%@:%@",
                      [NSString stringWithCString:[[data objectAtIndex:0] bytes]
                                         encoding:NSMacOSRomanStringEncoding],
                      [NSString stringWithCString:[[data objectAtIndex:1] bytes]
                                         encoding:NSMacOSRomanStringEncoding]];
    
    NSMutableString *value = [[NSMutableString alloc] init];
    for (unsigned int i = 2; i < [data count]; ++i) {
        [value appendString:[NSString stringWithCString:[[data objectAtIndex:i] bytes]
                                               encoding:NSUTF8StringEncoding]];
    }
    
    [self->_items setValue:value forKey:name];
}

- (void) parseIntForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSData *datum = [data objectAtIndex:0];
    TLLog(@"datum size: %u", [datum length]);
    
    if ([datum length]) {
        unsigned int value;
        [datum getBytes:&value];
        if (value > UINT16_MAX) {
            TLLog(@"Parsed value (%u) that won't fit in 16 bits", value);
        }
        [self->_items setValue:[NSNumber numberWithUnsignedShort:value] forKey:[atom name]];
    }
}

- (void) parseGnreForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSData *datum = [data objectAtIndex:0];
    TLLog(@"datum size: %u", [datum length]);
    
    if ([datum length]) {
        unsigned int index;
        [datum getBytes:&index];
        if (index != 0) {
            NSString *genre = [TLID3v1Genres genreForIndex:(index - 1)];
            if (genre) {
                [self->_items setValue:genre forKey:[atom name]];
            }
        }
    }
}

- (void) parseIntPairForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSData *datum = [data objectAtIndex:0];
    TLLog(@"datum size: %u, parsing bytes in range (2, 4)", [datum length]);
    
    if ([datum length]) {
        unsigned short a, b;
        [datum getBytes:&a range:NSMakeRange(2, 2)];
        [datum getBytes:&b range:NSMakeRange(4, 2)];
        [self->_items setValue:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedShort:a], [NSNumber numberWithUnsignedShort:b], nil]
                        forKey:[atom name]];
    }
}

- (void) parseBoolForAtom: (TLMP4Atom *)atom
{
    NSArray *data = [self parseDataForAtom:atom];
    TLCheck([data count] == 1);
    NSData *datum = [data objectAtIndex:0];
    TLLog(@"datum size: %u", [datum length]);
    
    if ([datum length]) {
        NSNumber *result = nil;
        if ([datum length]) {
            uint8 value;
            [datum getBytes:&value length:1];
            if (value == 1) {
                result = [NSNumber numberWithBool:YES];
            }
        }
        if (result == nil) {
            result = [NSNumber numberWithBool:NO];
        }
        [self->_items setValue:result forKey:[atom name]];
    }
}

- (void) parseCovrForAtom: (TLMP4Atom *)atom
{
    #pragma unused(atom)
    TODO(implement);
}

@end
