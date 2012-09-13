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
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        return;
    }
    
    data = [self.tag getILSTData:kAlbum];
    if (data) {
        [self.tag setAlbum:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kArtist];
    if (data) {
        [self.tag setArtist:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kAlbumArtist];
    if (data) {
        [self.tag setAlbumArtist:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kComment];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setComment:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kYear];
    if (data) {
        [self.tag setYear:(NSDate *)data];
    }
    
    data = [self.tag getILSTData:kTitle];
    if (data) {
        [self.tag setTitle:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kGenreCode];
    if (data) {
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kGenre];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        [self.tag setGenre:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTrackNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self.tag setTrackNumber:[(NSNumber *)arr[0] integerValue]];
            [self.tag setTotalTracks:[(NSNumber *)arr[1] integerValue]];
        }
    }
    
    data = [self.tag getILSTData:kDiskNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self.tag setDiskNumber:[(NSNumber *)arr[0] integerValue]];
            [self.tag setTotalDisks:[(NSNumber *)arr[1] integerValue]];
        }
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
        [self.tag setEncoder:(NSString *)data];
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
        [self.tag setCopyright:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kCompilation];
    if (data) {
        [self.tag setCompilation:[(NSNumber *)data boolValue]];
    }
    
    data = [self.tag getILSTData:kArtwork];
    if (data) {
        [self.tag setArtwork:(NSImage *)data];
    }
    
    data = [self.tag getILSTData:kRating];
    if (data) {
        [self.tag setRating:[(NSNumber *)data integerValue]];
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
        [self.tag setTVShowName:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVEpisodeID];
    if (data) {
        [self.tag setTVEpisodeID:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kTVSeason];
    if (data) {
        [self.tag setTVSeason:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tag getILSTData:kTVEpisode];
    if (data) {
        [self.tag setTVEpisode:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tag getILSTData:kPurchaseDate];
    // TODO: this should probably be an NSDate, perhaps year should have its own TLMP4DataType entry?
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPurchaseDate:(NSString *)data];
    }
    
    data = [self.tag getILSTData:kGaplessPlayback];
    if (data) {
        [self.tag setGaplessPlayback:[(NSNumber *)data boolValue]];
    }
    
    data = [self.tag getILSTData:kStik];
    if (data) {
        [self.tag setStik:[(NSNumber *)data integerValue]];
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

@end
