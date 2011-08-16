//
//  TLMP4AtomNames.h
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Copyright 2011 Scott Perry.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import <Foundation/Foundation.h>

extern NSString * const kAlbum;				// flags: 1 type: text
extern NSString * const kArtist;            // flags: 1 type: text
extern NSString * const kAlbumArtist;       // flags: 1 type: text
extern NSString * const kComment;           // flags: 1 type: text
extern NSString * const kYear;              // flags: 1 type: text
extern NSString * const kTitle;             // flags: 1 type: text
extern NSString * const kGenre;             // flags: 1 type: text
extern NSString * const kGenreCode;         // flags: 0 type: uint8
extern NSString * const kTrackNumber;       // flags: 0 type: uint8
extern NSString * const kDiskNumber;        // flags: 0 type: uint8
extern NSString * const kComposer;          // flags: 1 type: text
extern NSString * const kEncoder;           // flags: 1 type: text
extern NSString * const kBPM;               // flags: 21 type: uint8
extern NSString * const kCopyright;         // flags: 1 type: text
extern NSString * const kCompilation;       // flags: 21 type: uint8
extern NSString * const kArtwork;           // flags: 13 type: jpeg | flags: 14 type: png
extern NSString * const kRating;            // flags: 21 type: uint8
extern NSString * const kGrouping;          // flags: 1 type: text
extern NSString * const kPodcast;           // flags: 21 type: uint8
extern NSString * const kCategory;          // flags: 1 type: text
extern NSString * const kKeyword;           // flags: 1 type: text
extern NSString * const kPodcastURL;        // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
extern NSString * const kEpisodeGUID;       // flags: 21 | 0 (Apple changed from 21 to the current 0 around iTunes 6.0.3) type: uint8
extern NSString * const kDescription;       // flags: 1 type: text
extern NSString * const kLyrics;            // flags: 1 type: text (Lyrics is the only text atom that doesnt't fall under a 255byte limit)
extern NSString * const kTVNetworkName;     // flags: 1 type: text
extern NSString * const kTVShowName;        // flags: 1 type: text
extern NSString * const kTVEpisodeNumber;   // flags: 1 type: text
extern NSString * const kTVSeason;          // flags: 21 type: uint8
extern NSString * const kTVEpisode;         // flags: 21 type: uint8
extern NSString * const kPurchaseDate;      // flags: 1 type: text
extern NSString * const kGaplessPlayback;   // flags: 21 type: uint8
extern NSString * const kStik;              // flags: 21 type: uint8

enum TLMP4AtomFlags {
    TLMP4AtomFlagsAll = -1,
    TLMP4AtomFlagsNewNumber = 0,
    TLMP4AtomFlagsText = 1,
    TLMP4AtomFlagsJPEG = 13,
    TLMP4AtomFlagsPNG = 14,
    TLMP4AtomFlagsNumber = 21
};

BOOL TLMP4AtomIsValid(NSString *name);
