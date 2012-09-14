//
//  TLMP4Tag_Methods.h
//  TagLib
//
//  Created by Scott Perry on 09/12/12.
//  This file is intended to be #included within an @interface block for TLMP4Tag
//

- (id)initWithPath:(NSString *)path;

- (TLMP4Atom *)findAtom:(NSArray *)path;
- (NSArray *)getAtom:(NSString *)name recursive:(BOOL)recursive;
- (id)getILSTData:(TLMP4AtomInfo *)atomInfo;

#pragma mark -
#pragma mark Extra item types on top of TLTag's standard properties.
@property (copy,nonatomic,readwrite) NSString *encoder;
@property (copy,nonatomic,readwrite) NSImage *artwork;
@property (copy,nonatomic,readwrite) NSString *TVShowName;
@property (copy,nonatomic,readwrite) NSString *TVEpisodeID;
@property (assign,nonatomic,readwrite) NSInteger TVSeason;
@property (assign,nonatomic,readwrite) NSInteger TVEpisode;
@property (copy,nonatomic,readwrite) NSString *albumArtist;
@property (assign,nonatomic,readwrite) NSInteger totalTracks;
@property (assign,nonatomic,readwrite) NSInteger totalDisks;
@property (copy,nonatomic,readwrite) NSString *copyright;
@property (assign,nonatomic,readwrite) BOOL compilation;
@property (assign,nonatomic,readwrite) BOOL gaplessPlayback;
@property (assign,nonatomic,readwrite) NSInteger stik;
@property (assign,nonatomic,readwrite) NSInteger rating;
@property (copy,nonatomic,readwrite) NSDate *purchaseDate;
@property (copy,nonatomic,readwrite) NSString *purchaserID;
