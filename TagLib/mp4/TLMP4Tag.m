//
//  MP4Tag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Tag.h"
#import "TLMP4Tag+FileParser.h"
#import "TLID3v1Genres.h"
#import "TLMP4AtomInfo.h"

@implementation TLMP4Tag

- (NSDictionary *) items
{
    return self->_items;
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

/*
 * Getters
 */

- (NSString *) title
{
    NSArray *result = [self->_items objectForKey:kTitle];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) artist
{
    NSArray *result = [self->_items objectForKey:kArtist];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) album
{
    NSArray *result = [self->_items objectForKey:kAlbum];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) comment
{
    NSArray *result = [self->_items objectForKey:kComment];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) genre
{
    NSArray *result = [self->_items objectForKey:kGenre];
    TLCheck(!result || [result count] == 1);

    if (!result) {
        // fail over to using the genre code
        result = [self->_items objectForKey:kGenreCode];
        TLCheck(!result || [result count] == 1);
        if (result) {
            return [TLID3v1Genres genreForIndex:[[result objectAtIndex:0] unsignedCharValue] - 1];
        }
    }
    return [result objectAtIndex:0];
}

- (NSNumber *) year
{
    // NOTE: kYear (©dat) is a string, so convert to number before return.
    NSArray *values = [self->_items objectForKey:kYear];
    TLCheck(!values || [values count] == 1);
    NSNumber *result = [values objectAtIndex:0];
    return result ? [NSNumber numberWithLong:[result integerValue]] : nil;
}

- (NSNumber *) track
{
    NSArray *result = [self->_items objectForKey:kTrackNumber];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

/*
 * Setters
 */

- (void) setTitle: (NSString *) title
{
    [self->_items setObject:[NSArray arrayWithObject:title] forKey:kTitle];
}

- (void) setArtist: (NSString *) artist
{
    [self->_items setObject:[NSArray arrayWithObject:artist] forKey:kArtist];
}

- (void) setAlbum: (NSString *) album
{
    [self->_items setObject:[NSArray arrayWithObject:album] forKey:kAlbum];
}

- (void) setComment: (NSString *) comment
{
    [self->_items setObject:[NSArray arrayWithObject:comment] forKey:kComment];
}

- (void) setGenre: (NSString *) genre
{
    [self->_items setObject:[NSArray arrayWithObject:genre] forKey:kGenre];
}

- (void) setYear: (NSNumber *) year
{
    if (![year isEqualToNumber:[NSNumber numberWithLong:0]]) {
        [self->_items setObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@", year]] forKey:kYear];
    } else {
        [self->_items setObject:[NSArray arrayWithObject:@""] forKey:kYear];
    }
}

- (void) setTrack: (NSNumber *) track
{
    [self->_items setObject:[NSArray arrayWithObject:[NSArray arrayWithObjects:track, [NSNumber numberWithInt:0], nil]]
                  forKey:kTrackNumber];
}




@end
