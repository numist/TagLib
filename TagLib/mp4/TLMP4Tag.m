//
//  MP4Tag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "debugger.h"
#import "NSData+Endian.h"
#import "TLID3v1Genres.h"
#import "TLMP4AtomInfo.h"
#import "TLMP4Tag.h"
#import "TLMP4Tag+FileParser.h"

@interface TLMP4Tag ()
@property (retain, nonatomic, readwrite) TLMP4Atoms *atoms;

TODO("There is be a better way to do this that doesn't involved persistent object-level storage. This is only used by the FileParser category.");
@property (assign, nonatomic, readwrite) NSFileHandle *file;
@end

@implementation TLMP4Tag
@synthesize atoms, items, file;

- (id)initWithFile: (NSFileHandle *)fileArg atoms:(TLMP4Atoms *)atomsArg
{
    self = [super init];
    if (!self || !fileArg || !atomsArg) return nil;

    self.items = [[NSMutableDictionary alloc] init];
    self.atoms = atomsArg;
        
    // sanity check before handing off control to the parser
    TLMP4Atom *ilst = [self.atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    if (!ilst) {
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        return nil;
    }
    [self parseFile:fileArg withAtoms:self.atoms];

    return self;
}

- (id)init;
{
    return [self initWithFile:nil atoms:nil];
}

/*
 * Getters
 */

- (NSString *) title
{
    NSArray *result = [self.items objectForKey:kTitle];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) artist
{
    NSArray *result = [self.items objectForKey:kArtist];
    TLCheck(!result || [result count] == 1);
    if (!result) {
        TLLog(@"%@", @"failing over to ©art in search for artist");
        result = [self.items objectForKey:@"©art"];
        TLCheck(!result || [result count] == 1);
    }
    return [result objectAtIndex:0];
}

- (NSString *) album
{
    NSArray *result = [self.items objectForKey:kAlbum];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) comment
{
    NSArray *result = [self.items objectForKey:kComment];
    TLCheck(!result || [result count] == 1);
    return [result objectAtIndex:0];
}

- (NSString *) genre
{
    NSArray *result = [self.items objectForKey:kGenre];
    TLCheck(!result || [result count] == 1);

    if (!result) {
        // fail over to using the genre code
        result = [self.items objectForKey:kGenreCode];
        TLCheck(!result || [result count] == 1);
        if (result) {
            return [TLID3v1Genres genreForIndex:[[result objectAtIndex:0] unsignedCharValue] - 1];
        }
    }
    return [result objectAtIndex:0];
}

- (NSNumber *) year
{
    NSString *result = [self yearAsString];
    TLCheck(result);
    return result ? [NSNumber numberWithLong:[result integerValue]] : nil;
}

- (NSString *) yearAsString
{
    NSArray *values = [self.items objectForKey:kYear];
    TLCheck(!values || [values count] == 1);
    NSString *result = [values objectAtIndex:0];
    TLCheck(result);
    return result;
}

- (NSNumber *) track
{
    NSArray *result = [self.items objectForKey:kTrackNumber];
    TLCheck(!result || ([result count] == 1 && [[result objectAtIndex:0] count] == 2));
    return [[result objectAtIndex:0] objectAtIndex:0];
}

/*
 * Setters
 */

- (void) setTitle: (NSString *) title
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:title] forKey:kTitle];
}

- (void) setArtist: (NSString *) artist
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:artist] forKey:kArtist];
}

- (void) setAlbum: (NSString *) album
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:album] forKey:kAlbum];
}

- (void) setComment: (NSString *) comment
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:comment] forKey:kComment];
}

- (void) setGenre: (NSString *) genre
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:genre] forKey:kGenre];
}

- (void) setYear: (NSNumber *) year
{
    TLNotTested();
    if (![year isEqualToNumber:[NSNumber numberWithLong:0]]) {
        [self setYearAsString:[NSString stringWithFormat:@"%@", year]];
    } else {
        [self setYearAsString:@""];
    }
}

- (void) setYearAsString: (NSString *) date
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:date] forKey:kYear];
}

- (void) setTrack: (NSNumber *) track
{
    TLNotTested();
    [self.items setObject:[NSArray arrayWithObject:[NSArray arrayWithObjects:track, [NSNumber numberWithInt:0], nil]]
                  forKey:kTrackNumber];
}

- (NSString *) description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"TLMP4Tag(%lu)", [self.items count]];
    
    if ([self.items count]) {
        [result appendString:@": {"];
        [result appendString:[self.items description]];
        [result appendString:@"} End of tags"];
    }
    return result;
}


@end
