//
//  MP4AtomNames.m
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Copyright 2011 Scott Perry.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import "MP4AtomNames.h"

kAlbum = @"©alb";           // flags: 1 type: text
kArtist = @"©art";          // flags: 1 type: text
kAlbumArtist = @"aART";     // flags: 1 type: text
kComment = @"©cmt";         // flags: 1 type: text
kYear = @"©day";            // flags: 1 type: text
kTitle = @"©nam";           // flags: 1 type: text
kGenre = @"©gen";           // flags: 1 type: text
kGenreCode = @"gnre";       // flags: 0 type: uint8
kTrackNumber = @"trkn";     // flags: 0 type: uint8
kDiskNumber = @"disk";      // flags: 0 type: uint8
kComposer = @"©wrt";        // flags: 1 type: text
kEncoder = @"©too";         // flags: 1 type: text
kBPM = @"tmpo";             // flags: 21 type: uint8
kCopyright = @"cprt";       // flags: 1 type: text
kCompilation = @"cpil";     // flags: 21 type: uint8
kArtwork = @"covr";         // flags: ≥ 13 type: jpeg | png
kRating = @"rtng";          // flags: 21 type: uint8
kGrouping = @"©grp";        // flags: 1 type: text
kPodcast = @"pcst";         // flags: 21 type: uint8
kCategory = @"catg";        // flags: 1 type: text
kKeyword = @"keyw";         // flags: 1 type: text
kPodcastURL = @"purl";      // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
kEpisodeGUID = @"egid";     // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
kDescription = @"desc";     // flags: 1 type: text
kLyrics = @"©lyr";          // flags: 1 type: text (Lyrics is the only text atom that doesnt't fall under a 255byte limit)
kTVNetworkName = @"tvnn";   // flags: 1 type: text
kTVShowName = @"tvsh";      // flags: 1 type: text
kTVEpisodeNumber = @"tven"; // flags: 1 type: text
kTVSeason = @"tvsn";        // flags: 21 type: uint8
kTVEpisode = @"tves";       // flags: 21 type: uint8
kPurchaseDate = @"purd";    // flags: 1 type: text
kGaplessPlayback = @"pgap"; // flags: 21 type: uint8