//
//  TLMP4AtomNames.m
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Copyright 2011 Scott Perry.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import "TLMP4AtomNames.h"

NSString * const kAlbum = @"©alb";           // flags: 1 type: text
NSString * const kArtist = @"©art";          // flags: 1 type: text
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
NSString * const kArtwork = @"covr";         // flags: ≥ 13 type: jpeg | png
NSString * const kRating = @"rtng";          // flags: 21 type: uint8
NSString * const kGrouping = @"©grp";        // flags: 1 type: text
NSString * const kPodcast = @"pcst";         // flags: 21 type: uint8
NSString * const kCategory = @"catg";        // flags: 1 type: text
NSString * const kKeyword = @"keyw";         // flags: 1 type: text
NSString * const kPodcastURL = @"purl";      // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
NSString * const kEpisodeGUID = @"egid";     // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
NSString * const kDescription = @"desc";     // flags: 1 type: text
NSString * const kLyrics = @"©lyr";          // flags: 1 type: text (Lyrics is the only text atom that doesnt't fall under a 255byte limit)
NSString * const kTVNetworkName = @"tvnn";   // flags: 1 type: text
NSString * const kTVShowName = @"tvsh";      // flags: 1 type: text
NSString * const kTVEpisodeNumber = @"tven"; // flags: 1 type: text
NSString * const kTVSeason = @"tvsn";        // flags: 21 type: uint8
NSString * const kTVEpisode = @"tves";       // flags: 21 type: uint8
NSString * const kPurchaseDate = @"purd";    // flags: 1 type: text
NSString * const kGaplessPlayback = @"pgap"; // flags: 21 type: uint8
