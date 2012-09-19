//
//  TLMP4Tags+Parser.m
//  TagLib
//
//  Created by Scott Perry on 09/16/12.
//
//

#import "TLMP4Tags+Parser.h"

#import "TLMP4AtomInfo.h"
#import "TLMP4Atom.h"
#import "NSData+GetTypedData.h"
#import "TLMP4Tags_Private.h"
#import "TLErrorWrapper.h"

@implementation TLMP4Tags (Parser)

- (void)load;
{
    id data;
    
    if (![self findAtom:@[@"moov", @"udta", @"meta", @"ilst"]]) return;
    
    data = [self getILSTData:kAlbum];
    if (data) {
        [self setAlbum:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kArtist];
    if (data) {
        [self setArtist:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kAlbumArtist];
    if (data) {
        [self setAlbumArtist:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kComment];
    if (data) {
        [self setComment:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kYear];
    if (data) {
        [self setYear:(NSDate *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTitle];
    if (data) {
        [self setTitle:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kGenreCode];
    if (data) {
        [self setGenre:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kGenre];
    if (data) {
        [self setGenre:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTrackNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self setTrackNumber:(NSNumber *)arr[0]];
            [self setTotalTracks:(NSNumber *)arr[1]];
        }
        if (pendingError) return;
    }
    
    data = [self getILSTData:kDiskNumber];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            [self setDiskNumber:(NSNumber *)arr[0]];
            [self setTotalDisks:(NSNumber *)arr[1]];
        }
        if (pendingError) return;
    }
    
    data = [self getILSTData:kComposer];
    if (data) {
        [self setComposer:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kEncoder];
    if (data) {
        [self setEncoder:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kBPM];
    if (data) {
        [self setBPM:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kCopyright];
    if (data) {
        [self setCopyright:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kCompilation];
    if (data) {
        [self setCompilation:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kArtwork];
    if (data) {
        [self setArtwork:(NSImage *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kRating];
    if (data) {
        [self setRating:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kGrouping];
    if (data) {
        [self setGrouping:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kPodcast];
    if (data) {
        [self setPodcast:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kCategory];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // [self setCategory:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kKeyword];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // [self setKeyword:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kPodcastURL];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // [self setPodcastURL:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kEpisodeGUID];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // [self setEpisodeGUID:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kDescription];
    if (data) {
        [self setMediaDescription:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kLyrics];
    if (data) {
        [self setLyrics:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTVNetworkName];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        // [self setTVNetworkName:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTVShowName];
    if (data) {
        [self setTVShowName:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTVEpisodeID];
    if (data) {
        [self setTVEpisodeID:(NSString *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTVSeason];
    if (data) {
        [self setTVSeason:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kTVEpisode];
    if (data) {
        [self setTVEpisode:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kPurchaseDate];
    if (data) {
        [self setPurchaseDate:(NSDate *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kGaplessPlayback];
    if (data) {
        [self setGaplessPlayback:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kStik];
    if (data) {
        [self setStik:(NSNumber *)data];
    }
    if (pendingError) return;
    
    data = [self getILSTData:kPurchaserID];
    if (data) {
        [self setPurchaserID:(NSString *)data];
    }
    if (pendingError) return;
    
    // Get properties for the media
    [self getProperties];

    return;
}

- (void)getProperties;
{
    NSData *data;
    TLMP4Atom *atom;
    
    //
    // Find first of tracks, to get properties from
    //
    atom = [self findAtom:@[@"moov"]];
    if (!atom) {
        setError(kTLErrorCorruptFile, @"Atom 'moov' not found");
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
            [self setChannels:[NSNumber numberWithUnsignedShort:[data unsignedShortAtOffset:40 endianness:OSBigEndian]]];
            [self setBitsPerSample:[NSNumber numberWithUnsignedShort:[data unsignedShortAtOffset:42 endianness:OSBigEndian]]];
            [self setSampleRate:[NSNumber numberWithUnsignedInt:[data unsignedIntAtOffset:46 endianness:OSBigEndian]]];
            
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
                    [self setBitRate:[NSNumber numberWithUnsignedInt:(([data unsignedIntAtOffset:pos endianness:OSBigEndian] + 500) / 1000)]];
                }
            }
        }
    } else {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.minf.stbl.stsd' not found");
        TLNotTested();
    }
    data = nil;
    atom = nil;
    // Max data position for read: 90
    
    return;
}

@end
