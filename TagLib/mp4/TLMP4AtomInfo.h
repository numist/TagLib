//
//  TLMP4AtomInfo.h
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import <Foundation/Foundation.h>

#import "debugger.h"

typedef enum {
    TLMP4DataTypeUnknown,
    TLMP4DataTypeAuto,
    TLMP4DataTypeFreeForm,
    TLMP4DataTypeIntPair,
    TLMP4DataTypeBool,
    TLMP4DataTypeInt,
    TLMP4DataTypeGenre,
    TLMP4DataTypeImage,
    TLMP4DataTypeText,
    TLMP4DataTypeDate
} TLMP4DataType;

typedef enum {
    TLMP4AtomFlagsAll = -1,
    TLMP4AtomFlagsNumber = 0,
    TLMP4AtomFlagsText = 1,
    TLMP4AtomFlagsJPEG = 13,
    TLMP4AtomFlagsPNG = 14,
    TLMP4AtomFlagsOldNumber = 21
} TLMP4AtomFlags;

@interface TLMP4AtomInfo : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) TLMP4AtomFlags flags;
@property (nonatomic, readonly) TLMP4DataType type;
+ (TLMP4AtomInfo *)validateAtom:(NSString *)name withFlags:(NSInteger)flags;
+ (TLMP4DataType)likelyDataTypeFromFlags:(TLMP4AtomFlags)flags;
@end

extern TLMP4AtomInfo *kAlbum;
extern TLMP4AtomInfo *kArtist;
extern TLMP4AtomInfo *kAlbumArtist;
extern TLMP4AtomInfo *kComment;
extern TLMP4AtomInfo *kYear;
extern TLMP4AtomInfo *kTitle;
extern TLMP4AtomInfo *kGenre;
extern TLMP4AtomInfo *kGenreCode;
extern TLMP4AtomInfo *kTrackNumber;
extern TLMP4AtomInfo *kDiskNumber;
extern TLMP4AtomInfo *kComposer;
extern TLMP4AtomInfo *kEncoder;
extern TLMP4AtomInfo *kBPM;
extern TLMP4AtomInfo *kCopyright;
extern TLMP4AtomInfo *kCompilation;
extern TLMP4AtomInfo *kArtwork;
extern TLMP4AtomInfo *kRating;
extern TLMP4AtomInfo *kGrouping;
extern TLMP4AtomInfo *kPodcast;
extern TLMP4AtomInfo *kCategory;
extern TLMP4AtomInfo *kKeyword;
extern TLMP4AtomInfo *kPodcastURL;
extern TLMP4AtomInfo *kEpisodeGUID;
extern TLMP4AtomInfo *kDescription;
extern TLMP4AtomInfo *kLyrics;
extern TLMP4AtomInfo *kTVNetworkName;
extern TLMP4AtomInfo *kTVShowName;
extern TLMP4AtomInfo *kTVEpisodeID;
extern TLMP4AtomInfo *kTVSeason;
extern TLMP4AtomInfo *kTVEpisode;
extern TLMP4AtomInfo *kPurchaseDate;
extern TLMP4AtomInfo *kGaplessPlayback;
extern TLMP4AtomInfo *kStik;
extern TLMP4AtomInfo *kPurchaserID;
