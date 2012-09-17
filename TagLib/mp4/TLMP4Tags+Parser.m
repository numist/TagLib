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

@implementation TLMP4Tags (Parser)

- (void)loadWithError:(NSError **)error;
{
    id data;
    NSError *terror;
    
    if (![self findAtom:@[@"moov", @"udta", @"meta", @"ilst"]]) {
        TLLog(@"%@", @"Atom moov.udta.meta.ilst not found.");
        // TODO: NSError
        return;
    }
    
    // TODO: NSError
    data = [self getILSTData:kAlbum error:&terror];
    if (data) {
        [self setAlbum:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kArtist error:&terror];
    if (data) {
        [self setArtist:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kAlbumArtist error:&terror];
    if (data) {
        [self setAlbumArtist:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kComment error:&terror];
    if (data) {
        [self setComment:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kYear error:&terror];
    if (data) {
        [self setYear:(NSDate *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTitle error:&terror];
    if (data) {
        [self setTitle:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kGenreCode error:&terror];
    if (data) {
        [self setGenre:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kGenre error:&terror];
    if (data) {
        [self setGenre:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTrackNumber error:&terror];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            if (terror) {
                if (error) {
                    *error = terror;
                }
                return;
            }
            [self setTrackNumber:(NSNumber *)arr[0]];
            [self setTotalTracks:(NSNumber *)arr[1]];
        }
    }
    
    data = [self getILSTData:kDiskNumber error:&terror];
    if (data) {
        NSArray *arr = (NSArray *)data;
        if ([arr count] == 2) {
            if (terror) {
                if (error) {
                    *error = terror;
                }
                return;
            }
            [self setDiskNumber:(NSNumber *)arr[0]];
            [self setTotalDisks:(NSNumber *)arr[1]];
        }
    }
    
    data = [self getILSTData:kComposer error:&terror];
    if (data) {
        [self setComposer:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kEncoder error:&terror];
    if (data) {
        [self setEncoder:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kBPM error:&terror];
    if (data) {
        [self setBPM:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kCopyright error:&terror];
    if (data) {
        [self setCopyright:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kCompilation error:&terror];
    if (data) {
        [self setCompilation:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kArtwork error:&terror];
    if (data) {
        [self setArtwork:(NSImage *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kRating error:&terror];
    if (data) {
        [self setRating:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kGrouping error:&terror];
    if (data) {
        [self setGrouping:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kPodcast error:&terror];
    if (data) {
        [self setPodcast:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kCategory error:&terror];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        if (terror) {
            if (error) {
                *error = terror;
            }
            return;
        }
        // TODO: mp4-specific tag
        //        [tag setCategory:(NSString *)data];
    }
    
    data = [self getILSTData:kKeyword error:&terror];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        if (terror) {
            if (error) {
                *error = terror;
            }
            return;
        }
        // TODO: mp4-specific tag
        //        [tag setKeyword:(NSString *)data];
    }
    
    data = [self getILSTData:kPodcastURL error:&terror];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        if (terror) {
            if (error) {
                *error = terror;
            }
            return;
        }
        // TODO: mp4-specific tag
        //        [tag setPodcastURL:(NSNumber *)data];
    }
    
    data = [self getILSTData:kEpisodeGUID error:&terror];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        if (terror) {
            if (error) {
                *error = terror;
            }
            return;
        }
        // TODO: mp4-specific tag
        //        [tag setEpisodeGUID:(NSNumber *)data];
    }
    
    data = [self getILSTData:kDescription error:&terror];
    if (data) {
        [self setMediaDescription:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kLyrics error:&terror];
    if (data) {
        [self setLyrics:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTVNetworkName error:&terror];
    if (data) {
        NSLog(@"%s:%d: %@", __FILE__, __LINE__, data);
        TLNotTested();
        if (terror) {
            if (error) {
                *error = terror;
            }
            return;
        }
        // TODO: mp4-specific tag
        //        [tag setTVNetworkName:(NSString *)data];
    }
    
    data = [self getILSTData:kTVShowName error:&terror];
    if (data) {
        [self setTVShowName:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTVEpisodeID error:&terror];
    if (data) {
        [self setTVEpisodeID:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTVSeason error:&terror];
    if (data) {
        [self setTVSeason:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kTVEpisode error:&terror];
    if (data) {
        [self setTVEpisode:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kPurchaseDate error:&terror];
    if (data) {
        [self setPurchaseDate:(NSDate *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kGaplessPlayback error:&terror];
    if (data) {
        [self setGaplessPlayback:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kStik error:&terror];
    if (data) {
        [self setStik:(NSNumber *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    data = [self getILSTData:kPurchaserID error:&terror];
    if (data) {
        [self setPurchaserID:(NSString *)data];
    }
    if (terror) {
        if (error) {
            *error = terror;
        }
        return;
    }
    
    // Get properties for the media
    [self getPropertiesWithError:&terror];
    if (terror) {
        *error = terror;
        return;
    }
    
    if (error) *error = nil;
    return;
}

- (void)getPropertiesWithError:(NSError **)error;
{
    NSData *data;
    TLMP4Atom *atom;
    
    //
    // Find first of tracks, to get properties from
    //
    atom = [self findAtom:@[@"moov"]];
    if (!atom) {
        TLLog(@"%@", @"MP4: Atom 'moov' not found");
        // TODO: NSError: Corrupt file
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
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.minf.stbl.stsd' not found")
        TLNotTested();
    }
    data = nil;
    atom = nil;
    // Max data position for read: 90
    
    if (error) *error = nil;
    
    return;
}

@end
