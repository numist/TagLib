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
#import "TLMP4Tags_Private.h"

@interface TLMP4FileParser ()
@property (retain, nonatomic, readwrite) TLMP4Tags *tags;
@property (assign, nonatomic, readwrite) BOOL success;
- (void)getProperties;
@end

static const uint64_t kWorryLength = 255;

@implementation TLMP4FileParser
@synthesize tags = _tag;
@synthesize success = _success;

- (id)initTag:(TLMP4Tags *)target;
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
    
    if (![self.tags findAtom:@[@"moov", @"udta", @"meta", @"ilst"]]) {
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        [self finished];
        return;
    }
    
    data = [self.tags getILSTData:kAlbum];
    if (data) {
        [self.tags setAlbum:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kArtist];
    if (data) {
        [self.tags setArtist:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kAlbumArtist];
    if (data) {
        [self.tags setAlbumArtist:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kComment];
    if (data) {
        [self.tags setComment:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kYear];
    if (data) {
        [self.tags setYear:(NSDate *)data];
    }
    
    data = [self.tags getILSTData:kTitle];
    if (data) {
        [self.tags setTitle:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kGenreCode];
    if (data) {
        [self.tags setGenre:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kGenre];
    if (data) {
        [self.tags setGenre:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kTrackNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self.tags setTrackNumber:[(NSNumber *)arr[0] integerValue]];
            [self.tags setTotalTracks:[(NSNumber *)arr[1] integerValue]];
        }
    }
    
    data = [self.tags getILSTData:kDiskNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self.tags setDiskNumber:[(NSNumber *)arr[0] integerValue]];
            [self.tags setTotalDisks:[(NSNumber *)arr[1] integerValue]];
        }
    }
    
    data = [self.tags getILSTData:kComposer];
    if (data) {
        [self.tags setComposer:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kEncoder];
    if (data) {
        [self.tags setEncoder:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kBPM];
    if (data) {
        [self.tags setBPM:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tags getILSTData:kCopyright];
    if (data) {
        [self.tags setCopyright:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kCompilation];
    if (data) {
        [self.tags setCompilation:[(NSNumber *)data boolValue]];
    }
    
    data = [self.tags getILSTData:kArtwork];
    if (data) {
        [self.tags setArtwork:(NSImage *)data];
    }
    
    data = [self.tags getILSTData:kRating];
    if (data) {
        [self.tags setRating:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tags getILSTData:kGrouping];
    if (data) {
        [self.tags setGrouping:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kPodcast];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPodcast:(NSNumber *)data];
    }
    
    data = [self.tags getILSTData:kCategory];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setCategory:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kKeyword];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setKeyword:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kPodcastURL];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setPodcastURL:(NSNumber *)data];
    }
    
    data = [self.tags getILSTData:kEpisodeGUID];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setEpisodeGUID:(NSNumber *)data];
    }
    
    data = [self.tags getILSTData:kDescription];
    if (data) {
        [self.tags setDescription:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kLyrics];
    if (data) {
        [self.tags setLyrics:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kTVNetworkName];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // TODO: mp4-specific tag
        //        [tag setTVNetworkName:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kTVShowName];
    if (data) {
        [self.tags setTVShowName:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kTVEpisodeID];
    if (data) {
        [self.tags setTVEpisodeID:(NSString *)data];
    }
    
    data = [self.tags getILSTData:kTVSeason];
    if (data) {
        [self.tags setTVSeason:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tags getILSTData:kTVEpisode];
    if (data) {
        [self.tags setTVEpisode:[(NSNumber *)data integerValue]];
    }
    
    data = [self.tags getILSTData:kPurchaseDate];
    if (data) {
        [self.tags setPurchaseDate:(NSDate *)data];
    }
    
    data = [self.tags getILSTData:kGaplessPlayback];
    if (data) {
        [self.tags setGaplessPlayback:[(NSNumber *)data boolValue]];
    }
    
    data = [self.tags getILSTData:kStik];
    if (data) {
        [self.tags setStik:[(NSNumber *)data integerValue]];
    }

    data = [self.tags getILSTData:kPurchaserID];
    if (data) {
        [self.tags setPurchaserID:(NSString *)data];
    }
    
    [self getProperties];
    
    self.success = YES;
    [self finished];
}

- (void)getProperties;
{
    NSData *data;
    TLMP4Atom *atom;
    
    //
    // Find first of tracks, to get properties from
    //
    atom = [self.tags findAtom:@[@"moov"]];
    if (!atom) {
        TLLog(@"%@", @"MP4: Atom 'moov' not found");
        return;
    }

    TLMP4Atom *trak = nil;
    for (trak in [atom getChild:@"trak" recursive:YES]) {
        TLMP4Atom *hdlr = [[trak getChild:@"mdia"] getChild:@"hdlr"];
        if (!hdlr) {
            TLLog(@"%@", @"MP4: Atom 'trak.mdia.hdlr' not found -- invalid track?");
            TLNotTested();
            trak = nil;
            continue;
        }
        
        data = [hdlr getDataWithRange:NSMakeRange(16, 4)];
        if ([[data stringWithEncoding:NSMacOSRomanStringEncoding] isEqualToString:@"soun"]) {
            break;
        }
        trak = nil;
    }
    
    // If there are no tracks, there are no properties!
    if (!trak) {
        TLLog(@"%@", @"MP4: No tracks");
        return;
    }
    data = nil;
    atom = nil;
    
    //
    // Property: length
    //
    atom = [[trak getChild:@"mdia"] getChild:@"mdhd"];
    if (atom) {
        data = [atom getDataWithRange:NSMakeRange(8, 36)];
        if ([data unsignedCharAtOffset:0] == 0) {
            uint32 unit = [data unsignedIntAtOffset:12 endianness:OSBigEndian];
            uint32 totalLength = [data unsignedIntAtOffset:16 endianness:OSBigEndian];
            NSLog(@"Property(length) = %u", (uint32_t)(totalLength / unit)); // TODO: assign properties
        } else {
            uint64 unit = [data unsignedLongLongAtOffset:20 endianness:OSBigEndian];
            uint64 totalLength = [data unsignedLongLongAtOffset:28 endianness:OSBigEndian];
            NSLog(@"Property(length) = %llu", (uint64_t)totalLength / unit); // TODO: assign properties
            TLNotTested();
        }
    } else {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.mdhd' not found");
        TLNotTested();
    }
    data = nil;
    atom = nil;
    
    //
    // All the other properties live together in stsd
    //
    atom = [[[[trak getChild:@"mdia"] getChild:@"minf"] getChild:@"stbl"] getChild:@"stsd"];
    if (atom) {
        data = [atom getDataWithRange:NSMakeRange(0, 90)];
        if ([[data stringWithRange:NSMakeRange(20, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"mp4a"]) {
            [self.tags setChannels:[data unsignedShortAtOffset:40 endianness:OSBigEndian]];
            [self.tags setBitsPerSample:[data unsignedShortAtOffset:42 endianness:OSBigEndian]];
            [self.tags setSampleRate:[data unsignedIntAtOffset:46 endianness:OSBigEndian]];
            
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
                    [self.tags setBitRate:(([data unsignedIntAtOffset:pos endianness:OSBigEndian] + 500) / 1000)];
                }
            }
        }
    } else {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.minf.stbl.stsd' not found")
        TLNotTested();
    }
    data = nil;
    atom = nil;
    // Max data position for read: 90
}

- (void)finished;
{
    if (!self.success) {
        // TODO: clear all tag info
    }
    
    [self.tags setReady:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLTagDidFinishLoading"
                                                        object:self.tags];
}

@end
