//
//  TLMP4FileParser.m
//  TagLib
//
//  Created by Scott Perry on 09/11/12.
//
//

#import "TLMP4FileParser.h"
#import "TLMP4AtomInfo.h"
#import "TLMP4Atom.h"

@interface TLMP4FileParser ()
@property (retain, nonatomic, readwrite) TLMP4Tag *tag;
@property (retain, nonatomic, readwrite) NSFileHandle *handle;
@end

@implementation TLMP4FileParser
@synthesize tag = _tag;
@synthesize handle = _handle;

- (id)initTag:(TLMP4Tag *)target;
{
    self = [super init];
    if (!self || ![target path]) return nil;
    
    _tag = target;
    
    return self;
}

- (void)main;
{
    // Artificially inflate the refCount so we only open the file once.
    (void)[self.tag beginReadingFile];
    TLAssert(self.handle);
    
    TLMP4Atom *ilst = [self.tag findAtom:@[@"moov", @"udta", @"meta", @"ilst"]];
    id data;
    
    data = [[ilst getChild:kAlbum] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        [self.tag setAlbum:(NSString *)data];
    }
    
    data = [[ilst getChild:kAlbumArtist] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setAlbumArtist:(NSString *)data];
    }
    
    data = [[ilst getChild:kComment] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        [self.tag setComment:(NSString *)data];
    }
    
    data = [[ilst getChild:kYear] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: Convert to an NSDate!
        // [tag setYear:(NSString *)data];
    }
    
    data = [[ilst getChild:kTitle] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        [self.tag setTitle:(NSString *)data];
    }
    
    // TODO: atom getData must do genre conversion itself
    data = [[ilst getChild:kGenreCode] getDataWithType:TLMP4DataTypeGenre];
    if (data) {
        TLNotTested();
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [[ilst getChild:kGenre] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [[ilst getChild:kTrackNumber] getDataWithType:TLMP4DataTypeIntPair];
    // TODO:
    if (data) {
        TLNotTested();
        //[tag setTrackNumber:(NSNumber *)…];
        // TODO: mp4-specific tag
        //[tag setTotalTracks:(NSNumber *)…]
    }
    
    data = [[ilst getChild:kDiskNumber] getDataWithType:TLMP4DataTypeIntPair];
    // TODO:
    if (data) {
        TLNotTested();
        //[tag setDiskNumber:(NSNumber *)…];
        // TODO: mp4-specific tag
        //[tag setTotalDisks:(NSNumber *)…];
    }
    
    data = [[ilst getChild:kComposer] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setComposer:(NSString *)data];
    }
    
    data = [[ilst getChild:kEncoder] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setEncoder:(NSString *)data];
    }
    
    data = [[ilst getChild:kBPM] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setBPM:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kCopyright] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setCopyright:(NSString *)data];
    }
    
    data = [[ilst getChild:kCompilation] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setCompilation:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kArtwork] getDataWithType:TLMP4DataTypeImage];
    // TODO: data is probably a collection of images
    if (data) {
        TLNotTested();
        //[tag setArtwork:(NSImage *)data];
    }
    
    data = [[ilst getChild:kRating] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setRating:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kGrouping] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setGrouping:(NSString *)data];
    }
    
    data = [[ilst getChild:kPodcast] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setPodcast:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kCategory] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setCategory:(NSString *)data];
    }
    
    data = [[ilst getChild:kKeyword] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setKeyword:(NSString *)data];
    }
    
    data = [[ilst getChild:kPodcastURL] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setPodcastURL:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kEpisodeGUID] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setEpisodeGUID:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kDescription] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setDescription:(NSString *)data];
    }
    
    data = [[ilst getChild:kLyrics] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setLyrics:(NSString *)data];
    }
    
    data = [[ilst getChild:kTVNetworkName] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setTVNetworkName:(NSString *)data];
    }
    
    data = [[ilst getChild:kTVShowName] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setTVShowName:(NSString *)data];
    }
    
    data = [[ilst getChild:kTVEpisodeNumber] getDataWithType:TLMP4DataTypeText];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setTVEpisodeNumber:(NSString *)data];
    }
    
    data = [[ilst getChild:kTVSeason] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setTVSeason:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kTVEpisode] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setTVEpisode:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kPurchaseDate] getDataWithType:TLMP4DataTypeText];
    // TODO: this should probably be an NSDate
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setPurchaseDate:(NSString *)data];
    }
    
    data = [[ilst getChild:kGaplessPlayback] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setGaplessPlayback:(NSNumber *)data];
    }
    
    data = [[ilst getChild:kStik] getDataWithType:TLMP4DataTypeInt];
    if (data) {
        TLNotTested();
        // TODO: mp4-specific tag
//        [tag setStik:(NSNumber *)data];
    }
    
    // TODO: Also set properties: length, bitrate, sampleRate, channels, bitsPerSample.
    
    // Done. Artificially deflate the refCount back to normal.
    (void)[self.tag endReadingFile];
    [self.tag setReady:YES];
    
    // TODO: This is probably not right, but it'll work for now
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLTagDidFinishLoading"
                                                        object:self.tag];
}

#if 0
{
    // sanity check before handing off control to the parser
    TLMP4Atom *ilst = [self.atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    if (!ilst) {
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        return nil;
    }
}
#endif

@end
