//
//  TLMP4AtomNames.m
//  TagLib
//
//  Created by Scott Perry on 8/9/11.
//  Tag information from: http://atomicparsley.sourceforge.net/mpeg-4files.html
//

#import "TLMP4AtomInfo.h"

TLMP4AtomInfo *kAlbum;
TLMP4AtomInfo *kArtist;
TLMP4AtomInfo *kAlbumArtist;
TLMP4AtomInfo *kComment;
TLMP4AtomInfo *kYear;
TLMP4AtomInfo *kTitle;
TLMP4AtomInfo *kGenre;
TLMP4AtomInfo *kGenreCode;
TLMP4AtomInfo *kTrackNumber;
TLMP4AtomInfo *kDiskNumber;
TLMP4AtomInfo *kComposer;
TLMP4AtomInfo *kEncoder;
TLMP4AtomInfo *kBPM;
TLMP4AtomInfo *kCopyright;
TLMP4AtomInfo *kCompilation;
TLMP4AtomInfo *kArtwork;
TLMP4AtomInfo *kArtworkJPG;
TLMP4AtomInfo *kArtworkPNG;
TLMP4AtomInfo *kRating;
TLMP4AtomInfo *kGrouping;
TLMP4AtomInfo *kPodcast;
TLMP4AtomInfo *kCategory;
TLMP4AtomInfo *kKeyword;
TLMP4AtomInfo *kPodcastURL;
TLMP4AtomInfo *kEpisodeGUID;
TLMP4AtomInfo *kPodcastURLNew;
TLMP4AtomInfo *kEpisodeGUIDNew;
TLMP4AtomInfo *kPodcastURLOld;
TLMP4AtomInfo *kEpisodeGUIDOld;
TLMP4AtomInfo *kDescription;
TLMP4AtomInfo *kLyrics;
TLMP4AtomInfo *kTVNetworkName;
TLMP4AtomInfo *kTVShowName;
TLMP4AtomInfo *kTVEpisodeID;
TLMP4AtomInfo *kTVSeason;
TLMP4AtomInfo *kTVEpisode;
TLMP4AtomInfo *kPurchaseDate;
TLMP4AtomInfo *kGaplessPlayback;
TLMP4AtomInfo *kStik;

@interface TLMP4AtomInfo ()
- (id)initWithName:(NSString *)name flags:(TLMP4AtomFlags)flags type:(TLMP4DataType)type;
@end

@implementation TLMP4AtomInfo
@synthesize name = _name;
@synthesize flags = _flags;
@synthesize type = _type;

static NSMutableArray *atoms = nil;

- (id)initWithName:(NSString *)name flags:(TLMP4AtomFlags)flags type:(TLMP4DataType)type;
{
    self = [super init];
    if (!self) return nil;
    if (!atoms) atoms = [[NSMutableArray alloc] init];
    
    _name = name;
    _flags = flags;
    _type = type;
    
    [atoms addObject:self];
    
    return self;
}

+ (void)initialize;
{
    kAlbum = [[TLMP4AtomInfo alloc] initWithName:@"©alb"
                                           flags:TLMP4AtomFlagsText
                                            type:TLMP4DataTypeText];
    kArtist = [[TLMP4AtomInfo alloc] initWithName:@"©ART"
                                            flags:TLMP4AtomFlagsText
                                             type:TLMP4DataTypeText];
    kAlbumArtist = [[TLMP4AtomInfo alloc] initWithName:@"aART"
                                                 flags:TLMP4AtomFlagsText
                                                  type:TLMP4DataTypeText];
    kComment = [[TLMP4AtomInfo alloc] initWithName:@"©cmt"
                                             flags:TLMP4AtomFlagsText
                                              type:TLMP4DataTypeText];
    kYear = [[TLMP4AtomInfo alloc] initWithName:@"©day"
                                          flags:TLMP4AtomFlagsText
                                           type:TLMP4DataTypeYear];
    kTitle = [[TLMP4AtomInfo alloc] initWithName:@"©nam"
                                           flags:TLMP4AtomFlagsText
                                            type:TLMP4DataTypeText];
    kGenre = [[TLMP4AtomInfo alloc] initWithName:@"©gen"
                                           flags:TLMP4AtomFlagsText
                                            type:TLMP4DataTypeText];
    kGenreCode = [[TLMP4AtomInfo alloc] initWithName:@"gnre"
                                               flags:TLMP4AtomFlagsNumber
                                                type:TLMP4DataTypeGenre];
    kTrackNumber = [[TLMP4AtomInfo alloc] initWithName:@"trkn"
                                                 flags:TLMP4AtomFlagsNumber
                                                  type:TLMP4DataTypeIntPair];
    kDiskNumber = [[TLMP4AtomInfo alloc] initWithName:@"disk"
                                                flags:TLMP4AtomFlagsNumber
                                                 type:TLMP4DataTypeIntPair];
    kComposer = [[TLMP4AtomInfo alloc] initWithName:@"©wrt"
                                              flags:TLMP4AtomFlagsText
                                               type:TLMP4DataTypeText];
    kEncoder = [[TLMP4AtomInfo alloc] initWithName:@"©too"
                                             flags:TLMP4AtomFlagsText
                                              type:TLMP4DataTypeText];
    kBPM = [[TLMP4AtomInfo alloc] initWithName:@"tmpo"
                                         flags:TLMP4AtomFlagsOldNumber
                                          type:TLMP4DataTypeInt];
    kCopyright = [[TLMP4AtomInfo alloc] initWithName:@"cprt"
                                               flags:TLMP4AtomFlagsText
                                                type:TLMP4DataTypeText];
    kCompilation = [[TLMP4AtomInfo alloc] initWithName:@"cpil"
                                                 flags:TLMP4AtomFlagsOldNumber
                                                  type:TLMP4DataTypeBool];
    kArtwork = [[TLMP4AtomInfo alloc] initWithName:@"covr"
                                             flags:TLMP4AtomFlagsAll
                                              type:TLMP4DataTypeImage];
    kRating = [[TLMP4AtomInfo alloc] initWithName:@"rtng"
                                            flags:TLMP4AtomFlagsOldNumber
                                             type:TLMP4DataTypeInt];
    kGrouping = [[TLMP4AtomInfo alloc] initWithName:@"©grp"
                                              flags:TLMP4AtomFlagsText
                                               type:TLMP4DataTypeText];
    kPodcast = [[TLMP4AtomInfo alloc] initWithName:@"pcst"
                                             flags:TLMP4AtomFlagsOldNumber
                                              type:TLMP4DataTypeBool];
    kCategory = [[TLMP4AtomInfo alloc] initWithName:@"catg"
                                              flags:TLMP4AtomFlagsText
                                               type:TLMP4DataTypeText];
    kKeyword = [[TLMP4AtomInfo alloc] initWithName:@"keyw"
                                             flags:TLMP4AtomFlagsText
                                              type:TLMP4DataTypeText];
    kPodcastURL = [[TLMP4AtomInfo alloc] initWithName:@"purl"
                                                flags:TLMP4AtomFlagsAll
                                                 type:TLMP4DataTypeInt];
    kEpisodeGUID = [[TLMP4AtomInfo alloc] initWithName:@"egid"
                                                 flags:TLMP4AtomFlagsAll
                                                  type:TLMP4DataTypeInt];
    kDescription = [[TLMP4AtomInfo alloc] initWithName:@"desc"
                                                 flags:TLMP4AtomFlagsText
                                                  type:TLMP4DataTypeText];
    kLyrics = [[TLMP4AtomInfo alloc] initWithName:@"©lyr"
                                            flags:TLMP4AtomFlagsText
                                             type:TLMP4DataTypeText];
    kTVNetworkName = [[TLMP4AtomInfo alloc] initWithName:@"tvnn"
                                                   flags:TLMP4AtomFlagsText
                                                    type:TLMP4DataTypeText];
    kTVShowName = [[TLMP4AtomInfo alloc] initWithName:@"tvsh"
                                                flags:TLMP4AtomFlagsText
                                                 type:TLMP4DataTypeText];
    kTVEpisodeID = [[TLMP4AtomInfo alloc] initWithName:@"tven"
                                                     flags:TLMP4AtomFlagsText
                                                      type:TLMP4DataTypeText];
    kTVSeason = [[TLMP4AtomInfo alloc] initWithName:@"tvsn"
                                              flags:TLMP4AtomFlagsOldNumber
                                               type:TLMP4DataTypeInt];
    kTVEpisode = [[TLMP4AtomInfo alloc] initWithName:@"tves"
                                               flags:TLMP4AtomFlagsOldNumber
                                                type:TLMP4DataTypeInt];
    kPurchaseDate = [[TLMP4AtomInfo alloc] initWithName:@"purd"
                                                  flags:TLMP4AtomFlagsText
                                                   type:TLMP4DataTypeDate];
    kGaplessPlayback = [[TLMP4AtomInfo alloc] initWithName:@"pgap"
                                                     flags:TLMP4AtomFlagsOldNumber
                                                      type:TLMP4DataTypeBool];
    kStik = [[TLMP4AtomInfo alloc] initWithName:@"stik"
                                          flags:TLMP4AtomFlagsOldNumber
                                           type:TLMP4DataTypeInt];
    
    // Differing kArtwork image formats
    (void)[[TLMP4AtomInfo alloc] initWithName:@"covr"
                                        flags:TLMP4AtomFlagsJPEG
                                         type:TLMP4DataTypeImage];
    (void)[[TLMP4AtomInfo alloc] initWithName:@"covr"
                                        flags:TLMP4AtomFlagsPNG
                                         type:TLMP4DataTypeImage];
    // New-format kPodcastURL and kEpisodeGUID flags
    (void)[[TLMP4AtomInfo alloc] initWithName:@"purl"
                                        flags:TLMP4AtomFlagsNumber
                                         type:TLMP4DataTypeInt];
    (void)[[TLMP4AtomInfo alloc] initWithName:@"egid"
                                        flags:TLMP4AtomFlagsNumber
                                         type:TLMP4DataTypeInt];
    // Old-format kPodcastURL and kEpisodeGUID flags
    (void)[[TLMP4AtomInfo alloc] initWithName:@"purl"
                                        flags:TLMP4AtomFlagsOldNumber
                                         type:TLMP4DataTypeInt];
    (void)[[TLMP4AtomInfo alloc] initWithName:@"egid"
                                        flags:TLMP4AtomFlagsOldNumber
                                         type:TLMP4DataTypeInt];
}

// Returns YES if the atom is recognized
+ (TLMP4AtomInfo *)validateAtom:(NSString *)name withFlags:(NSInteger)flags;
{
    
    for (TLMP4AtomInfo *atom in atoms) {
        // Skip meta atoms
        if ([atom flags] < 0) continue;

        if ([[atom name] isEqualToString:name]) {
            if (flags < 0) return atom;
            if (flags == [atom flags]) return atom;
        }
    }
    return nil;
}

+ (TLMP4DataType)likelyDataTypeFromFlags:(TLMP4AtomFlags)flags;
{
    switch (flags) {
        case TLMP4AtomFlagsJPEG:
        case TLMP4AtomFlagsPNG:
            return TLMP4DataTypeImage;
        case TLMP4AtomFlagsNumber:
        case TLMP4AtomFlagsOldNumber:
            return TLMP4DataTypeInt;
        case TLMP4AtomFlagsText:
            return TLMP4DataTypeText;
        default:
            TLLog(@"Unknown flags: %d", flags);
        case TLMP4AtomFlagsAll:
            return TLMP4DataTypeUnknown;
    }
}

@end
