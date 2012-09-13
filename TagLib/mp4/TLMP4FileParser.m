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
#import "NSData+GetTypedData.h"

@interface TLMP4FileParser ()
@property (retain, nonatomic, readwrite) TLMP4Tag *tag;
@property (assign, nonatomic, readwrite) BOOL success;
- (void)getProperties;
@end

@implementation TLMP4FileParser
@synthesize tag = _tag;
@synthesize success = _success;

- (id)initTag:(TLMP4Tag *)target;
{
    self = [super init];
    if (!self || ![target path]) return nil;
    
    _tag = target;
    _success = NO;
    
    return self;
}

- (void)main;
{
    id data;
    
    if (![self.tag findAtom:@[@"moov", @"udta", @"meta", @"ilst"]]) {
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        [self finished];
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
    
    [self getProperties];
    
    self.success = YES;
    [self finished];
}

- (void)getProperties;
{
    NSData *data;
    TLMP4Atom *atom;
    
    // Get properties: length, bitrate, sampleRate, channels, bitsPerSample.
    atom = [self.tag findAtom:@[@"moov"]];
    if (!atom) {
        TLLog(@"%@", @"MP4: Atom 'moov' not found");
        return;
    }
    
    TLMP4Atom *trak = nil;
    for (trak in [atom getChild:@"trak" recursive:YES]) {
        TLMP4Atom *hdlr = [[trak getChild:@"mdia"] getChild:@"hdlr"];
        if (!hdlr) {
            TLLog(@"%@", @"MP4: Atom 'trak.mdia.hdlr' not found");
            return;
        }
        
        TLCheck([hdlr length] < 255);
        data = [hdlr getData];

        if ([[data stringWithRange:NSMakeRange(16, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"soun"]) {
            break;
        }
        trak = nil;
    }
    if (!trak) {
        TLLog(@"%@", @"MP4: No audio tracks");
        return;
    }
    data = nil;
    atom = nil;
    
    atom = [[trak getChild:@"mdia"] getChild:@"mdhd"];
    if (!atom) {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.mdhd' not found");
        return;
    }
    TLCheck([atom length] < 255);
    data = [atom getData];
    // Hint to the compiler that this lvar can be reused—it's not used again after this
    atom = nil;
    
    if ([data unsignedCharAtOffset:8] == 0) {
        uint32 unit = [data unsignedIntAtOffset:20 endianness:OSBigEndian];
        uint32 totalLength = [data unsignedIntAtOffset:24 endianness:OSBigEndian];
        NSLog(@"Property(length) = %u", (uint32_t)(totalLength / unit)); // TODO: assign properties
    } else {
        uint64 unit = [data unsignedLongLongAtOffset:28 endianness:OSBigEndian];
        uint64 totalLength = [data unsignedLongLongAtOffset:36 endianness:OSBigEndian];
        NSLog(@"Property(length) = %llu", (uint64_t)totalLength / unit); // TODO: assign properties
        TLNotTested();
    }
    
    atom = [[[[trak getChild:@"mdia"] getChild:@"minf"] getChild:@"stbl"] getChild:@"stsd"];
    if (!atom) {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.minf.stbl.stsd' not found")
        return;
    }
    TLCheck([atom length] < 255);
    data = [atom getData];
    // Hint to the compiler that this lvar can be reused—it's not used again after this
    atom = nil;
                       
    if ([[data stringWithRange:NSMakeRange(20, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"mp4a"]) {
        NSLog(@"Property(channels) = %u", [data unsignedShortAtOffset:40 endianness:OSBigEndian]); // TODO: assign properties
        NSLog(@"Property(bitsPerSample) = %u", [data unsignedShortAtOffset:42 endianness:OSBigEndian]); // TODO: assign properties
        NSLog(@"Property(sampleRate) = %u", [data unsignedIntAtOffset:46 endianness:OSBigEndian]); // TODO: assign properties
        
        if ([[data stringWithRange:NSMakeRange(56, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"esds"] &&
            [data unsignedCharAtOffset:64] == 0x03) {
            uint32 pos = 65;
            NSData *marker = [NSData dataWithBytes:"\x80\x80\x80" length:3];
            if ([[data subdataWithRange:NSMakeRange(pos, 3)] isEqualTo:marker]) {
                pos +=3;
            }
            pos += 4;
            if ([data unsignedCharAtOffset:pos] == 0x04) {
                pos += 1;
                if ([[data subdataWithRange:NSMakeRange(pos, 3)] isEqualTo:marker]) {
                    pos +=3;
                }
                pos += 10;
                NSLog(@"Property(bitRate) = %u", ([data unsignedIntAtOffset:pos endianness:OSBigEndian] + 500) / 1000); // TODO: assign properties
            }
        }
    }
}

- (void)finished;
{
    if (!self.success) {
        // TODO: clear all tag info
    }
    
    [self.tag setReady:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLTagDidFinishLoading"
                                                        object:self.tag];
}

@end
