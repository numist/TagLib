//
//  TLMP4Tags_Common.h
//  TagLib
//
//  Created by Scott Perry on 09/12/12.
//  This file is intended to be #included within an @interface block for TLMP4Tag
//

- (id)initWithPath:(NSString *)pathArg error:(NSError **)error;

- (TLMP4Atom *)findAtom:(NSArray *)path;
- (NSArray *)getAtom:(NSString *)name recursive:(BOOL)recursive;
- (id)getILSTData:(TLMP4AtomInfo *)atomInfo error:(NSError **)error;

#pragma mark -
#pragma mark Extra item types on top of TLTag's standard properties.
@property (copy,nonatomic,readwrite) NSString *encoder;
@property (copy,nonatomic,readwrite) NSImage *artwork;
@property (copy,nonatomic,readwrite) NSString *TVShowName;
@property (copy,nonatomic,readwrite) NSString *TVEpisodeID;
@property (copy,nonatomic,readwrite) NSNumber *TVSeason;
@property (copy,nonatomic,readwrite) NSNumber *TVEpisode;
@property (copy,nonatomic,readwrite) NSString *albumArtist;
@property (copy,nonatomic,readwrite) NSNumber *totalTracks;
@property (copy,nonatomic,readwrite) NSNumber *totalDisks;
@property (copy,nonatomic,readwrite) NSString *copyright;
@property (copy,nonatomic,readwrite) NSNumber *compilation;
@property (copy,nonatomic,readwrite) NSNumber *gaplessPlayback;
@property (copy,nonatomic,readwrite) NSNumber *stik;
@property (copy,nonatomic,readwrite) NSNumber *rating;
@property (copy,nonatomic,readwrite) NSDate *purchaseDate;
@property (copy,nonatomic,readwrite) NSString *purchaserID;
@property (copy,nonatomic,readwrite) NSString *composer;
@property (copy,nonatomic,readwrite) NSNumber *BPM;
@property (copy,nonatomic,readwrite) NSString *grouping;
@property (copy,nonatomic,readwrite) NSString *mediaDescription;
@property (copy,nonatomic,readwrite) NSString *lyrics;
@property (copy,nonatomic,readwrite) NSNumber *podcast;
