//
//  TLMP4AtomNames.m
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Copyright 2011 Scott Perry.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import "TLMP4AtomInfo.h"

NSString * const kAlbum = @"©alb";           // flags: 1 type: text
NSString * const kArtist = @"©ART";          // flags: 1 type: text
NSString * const kAlbumArtist = @"aART";     // flags: 1 type: text
NSString * const kComment = @"©cmt";         // flags: 1 type: text
NSString * const kYear = @"©day";            // flags: 1 type: text
NSString * const kTitle = @"©nam";           // flags: 1 type: text
NSString * const kGenre = @"©gen";           // flags: 1 type: text
NSString * const kGenreCode = @"gnre";       // flags: 0 type: uint8
NSString * const kTrackNumber = @"trkn";     // flags: 0 type: uint8
NSString * const kDiskNumber = @"disk";      // flags: 0 type: uint8
NSString * const kComposer = @"©wrt";        // flags: 1 type: text
NSString * const kEncoder = @"©too";         // flags: 1 type: text
NSString * const kBPM = @"tmpo";             // flags: 21 type: uint8
NSString * const kCopyright = @"cprt";       // flags: 1 type: text
NSString * const kCompilation = @"cpil";     // flags: 21 type: uint8
NSString * const kArtwork = @"covr";         // flags: 13 type: jpeg | flags: 14 type: png
NSString * const kRating = @"rtng";          // flags: 21 type: uint8
NSString * const kGrouping = @"©grp";        // flags: 1 type: text
NSString * const kPodcast = @"pcst";         // flags: 21 type: uint8
NSString * const kCategory = @"catg";        // flags: 1 type: text
NSString * const kKeyword = @"keyw";         // flags: 1 type: text
NSString * const kPodcastURL = @"purl";      // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8 (really? a whole URL?)
NSString * const kEpisodeGUID = @"egid";     // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8 (really? a whole GUID?)
NSString * const kDescription = @"desc";     // flags: 1 type: text
NSString * const kLyrics = @"©lyr";          // flags: 1 type: text (Lyrics is the only text atom that doesnt't fall under a 255byte limit)
NSString * const kTVNetworkName = @"tvnn";   // flags: 1 type: text
NSString * const kTVShowName = @"tvsh";      // flags: 1 type: text
NSString * const kTVEpisodeNumber = @"tven"; // flags: 1 type: text
NSString * const kTVSeason = @"tvsn";        // flags: 21 type: uint8
NSString * const kTVEpisode = @"tves";       // flags: 21 type: uint8
NSString * const kPurchaseDate = @"purd";    // flags: 1 type: text
NSString * const kGaplessPlayback = @"pgap"; // flags: 21 type: uint8
NSString * const kStik = @"stik";            // flags: 21 type: uint8

BOOL TLMP4AtomIsValid(NSString *name) {
    static NSSet *validAtoms = nil;
    
    if (!validAtoms) {
        validAtoms = [NSSet setWithObjects:@"----", kAlbum, kArtist, kAlbumArtist, kComment, kYear, kTitle, kGenre, kGenreCode, kTrackNumber, kDiskNumber, kComposer, kEncoder, kBPM, kCopyright, kCompilation, kArtwork, kRating, kGrouping, kPodcast, kCategory, kKeyword, kPodcastURL, kEpisodeGUID, kDescription, kLyrics, kTVNetworkName, kTVShowName, kTVEpisodeNumber, kTVSeason, kTVEpisode, kPurchaseDate, kGaplessPlayback, kStik, nil]; 
    }
    return [validAtoms containsObject:name];
}
