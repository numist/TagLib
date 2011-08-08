//
//  ID3v1Genres.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Scott Wheeler.
//

#import "ID3v1Genres.h"

static NSString *genres[] = {
    @"Blues",
    @"Classic Rock",
    @"Country",
    @"Dance",
    @"Disco",
    @"Funk",
    @"Grunge",
    @"Hip-Hop",
    @"Jazz",
    @"Metal",
    @"New Age",
    @"Oldies",
    @"Other",
    @"Pop",
    @"R&B",
    @"Rap",
    @"Reggae",
    @"Rock",
    @"Techno",
    @"Industrial",
    @"Alternative",
    @"Ska",
    @"Death Metal",
    @"Pranks",
    @"Soundtrack",
    @"Euro-Techno",
    @"Ambient",
    @"Trip-Hop",
    @"Vocal",
    @"Jazz+Funk",
    @"Fusion",
    @"Trance",
    @"Classical",
    @"Instrumental",
    @"Acid",
    @"House",
    @"Game",
    @"Sound Clip",
    @"Gospel",
    @"Noise",
    @"Alternative Rock",
    @"Bass",
    @"Soul",
    @"Punk",
    @"Space",
    @"Meditative",
    @"Instrumental Pop",
    @"Instrumental Rock",
    @"Ethnic",
    @"Gothic",
    @"Darkwave",
    @"Techno-Industrial",
    @"Electronic",
    @"Pop-Folk",
    @"Eurodance",
    @"Dream",
    @"Southern Rock",
    @"Comedy",
    @"Cult",
    @"Gangsta",
    @"Top 40",
    @"Christian Rap",
    @"Pop/Funk",
    @"Jungle",
    @"Native American",
    @"Cabaret",
    @"New Wave",
    @"Psychedelic",
    @"Rave",
    @"Showtunes",
    @"Trailer",
    @"Lo-Fi",
    @"Tribal",
    @"Acid Punk",
    @"Acid Jazz",
    @"Polka",
    @"Retro",
    @"Musical",
    @"Rock & Roll",
    @"Hard Rock",
    @"Folk",
    @"Folk/Rock",
    @"National Folk",
    @"Swing",
    @"Fusion",
    @"Bebob",
    @"Latin",
    @"Revival",
    @"Celtic",
    @"Bluegrass",
    @"Avantgarde",
    @"Gothic Rock",
    @"Progressive Rock",
    @"Psychedelic Rock",
    @"Symphonic Rock",
    @"Slow Rock",
    @"Big Band",
    @"Chorus",
    @"Easy Listening",
    @"Acoustic",
    @"Humour",
    @"Speech",
    @"Chanson",
    @"Opera",
    @"Chamber Music",
    @"Sonata",
    @"Symphony",
    @"Booty Bass",
    @"Primus",
    @"Porn Groove",
    @"Satire",
    @"Slow Jam",
    @"Club",
    @"Tango",
    @"Samba",
    @"Folklore",
    @"Ballad",
    @"Power Ballad",
    @"Rhythmic Soul",
    @"Freestyle",
    @"Duet",
    @"Punk Rock",
    @"Drum Solo",
    @"A Cappella",
    @"Euro-House",
    @"Dance Hall",
    @"Goa",
    @"Drum & Bass",
    @"Club-House",
    @"Hardcore",
    @"Terror",
    @"Indie",
    @"BritPop",
    @"Negerpunk",
    @"Polsk Punk",
    @"Beat",
    @"Christian Gangsta Rap",
    @"Heavy Metal",
    @"Black Metal",
    @"Crossover",
    @"Contemporary Christian",
    @"Christian Rock",
    @"Merengue",
    @"Salsa",
    @"Thrash Metal",
    @"Anime",
    @"Jpop",
    @"Synthpop"
};

static NSDictionary *genreMap = nil;

@interface ID3v1Genres ()

+ (void) generateGenreMap;

@end

@implementation ID3v1Genres

+ (NSArray *) genreList
{
    return [NSArray arrayWithObjects:genres count:ARRAYSIZE(genres)];
}

+ (NSDictionary *) genreMap
{
    [ID3v1Genres generateGenreMap];

    return genreMap;
}

+ (NSString *) genreForIndex: (uint16) i
{
    if (i < ARRAYSIZE(genres)) {
        return genres[i];
    } else {
        return nil;
    }
}

+ (uint16) indexForGenre: (NSString *)genre
{
    [ID3v1Genres generateGenreMap];
    
    return [[genreMap objectForKey:genre] unsignedShortValue];
}

+ (void) generateGenreMap
{
    if (LIKELY(genreMap)) {
        return;
    }
    
    NSMutableDictionary *map = [[NSMutableDictionary alloc] initWithCapacity:ARRAYSIZE(genres)];
    
    for (uint16 i = 0; i < ARRAYSIZE(genres); i++) {
        [map setValue:[NSNumber numberWithUnsignedInt:i] forKey:genres[i]];
    }
    
    genreMap = map;
}

@end
