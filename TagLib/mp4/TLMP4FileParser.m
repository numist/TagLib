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
@end

@implementation TLMP4FileParser
@synthesize tag = _tag;

- (id)initTag:(TLMP4Tag *)target;
{
    self = [super init];
    if (!self || ![target path]) return nil;
    
    _tag = target;
    
    return self;
}

- (void)main;
{
    id data;
    
    if (![self.tag findAtom:@[@"moov", @"udta", @"meta", @"ilst"]]) {
        [self finished];
        return;
    }
    
    data = [self.tag getILSTData:kAlbum];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setAlbum:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kAlbumArtist];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setAlbumArtist:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kComment];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setComment:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kYear];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: Convert to an NSDate!
        // [tag setYear:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTitle];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setTitle:(NSString *)data];
    }
    
    // TODO: atom getData must do genre conversion itself
    data = [self.tag getILSTData:kGenreCode];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kGenre];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTrackNumber];
    // TODO:
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        //[tag setTrackNumber:(NSNumber *)…];
        // TODO: mp4-specific tag
        //[tag setTotalTracks:(NSNumber *)…]
    }
    
    data = [self.tag getILSTData:kDiskNumber];
    // TODO:
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        //[tag setDiskNumber:(NSNumber *)…];
        // TODO: mp4-specific tag
        //[tag setTotalDisks:(NSNumber *)…];
    }
    
    data = [self.tag getILSTData:kComposer];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setComposer:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kEncoder];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setEncoder:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kBPM];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setBPM:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kCopyright];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setCopyright:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kCompilation];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setCompilation:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kArtwork];
    // TODO: data is probably a collection of images
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        //[tag setArtwork:(NSImage *)data];
    }
    
    data = [self.tag getILSTData:kRating];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setRating:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kGrouping];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setGrouping:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kPodcast];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPodcast:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kCategory];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setCategory:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kKeyword];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setKeyword:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kPodcastURL];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPodcastURL:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kEpisodeGUID];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setEpisodeGUID:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kDescription];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setDescription:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kLyrics];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setLyrics:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVNetworkName];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVNetworkName:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVShowName];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVShowName:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVEpisodeNumber];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVEpisodeNumber:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVSeason];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVSeason:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kTVEpisode];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVEpisode:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kPurchaseDate];
    // TODO: this should probably be an NSDate
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPurchaseDate:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kGaplessPlayback];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setGaplessPlayback:(NSNumber *)data];
    }
    
    data = [self.tag getILSTData:kStik];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setStik:(NSNumber *)data];
    }
    
    // TODO: Also set properties: length, bitrate, sampleRate, channels, bitsPerSample.
    
    [self finished];
}

- (void)finished;
{
    [self.tag setReady:YES];
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
