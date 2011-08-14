//
//  TLMP4Properties.m
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Properties.h"
#import "NSData+GetTypedData.h"

@implementation TLMP4Properties
@synthesize length;
@synthesize bitrate;
@synthesize sampleRate;
@synthesize channels;
@synthesize bitsPerSample;

- (id)init
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (TLMP4Properties *) initWithFile: (NSFileHandle *)file atoms: (TLMP4Atoms *)atoms
{
    self = [super init];
    if (!self) {
        return nil;
    }

    TLMP4Atom *moov = [atoms findAtomAtPath:[NSArray arrayWithObject:@"moov"]];
    if (!moov) {
        TLLog(@"%@", @"MP4: Atom 'moov' not found");
        return nil;
    }
    
    TLMP4Atom *trak = nil;
    NSArray *trakList = [moov findAllWithName:@"trak"];
    for (trak in trakList) {
        TLMP4Atom *hdlr = [trak getAtomWithPath:[NSArray arrayWithObjects:@"mdia", @"hdlr", nil]];
        if (!hdlr) {
            TLLog(@"%@", @"MP4: Atom 'trak.mdia.hdlr' not found");
            return nil;
        }
        
        [file seekToFileOffset:[hdlr offset]];
        if ([[[file readDataOfLength:[hdlr length]] stringWithRange:NSMakeRange(16, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"soun"]) {
            break;
        }
        trak = nil;
    }
    if (!trak) {
        TLLog(@"%@", @"MP4: No audio tracks");
        return nil;
    }
    
    TLMP4Atom *mdhd = [trak getAtomWithPath:[NSArray arrayWithObjects:@"mdia", @"mdhd", nil]];
    if (!mdhd) {
        TLLog(@"%@", @"MP4: Atom 'trak.mdia.mdhd' not found");
        return nil;
    }

    [file seekToFileOffset:[mdhd offset]];
    NSData *data = [file readDataOfLength:[mdhd length]];
    
    if ([data unsignedCharAtOffset:8] == 0) {
        uint32 unit = [data unsignedIntAtOffset:20 swapped:YES];
        uint32 totalLength = [data unsignedIntAtOffset:24 swapped:YES];
        self->length = totalLength / unit;
    } else {
        uint64 unit = [data unsignedLongLongAtOffset:28 swapped:YES];
        uint64 totalLength = [data unsignedLongLongAtOffset:36 swapped:YES];
        self->length = (uint32)(totalLength / unit);
    }
    
    TLMP4Atom *atom = [trak getAtomWithPath:[NSArray arrayWithObjects:@"mdia", @"minf", @"stbl", @"stsd", nil]];
    if (!atom) {
        return nil;
    }
    
    [file seekToFileOffset:[atom offset]];
    data = [file readDataOfLength:[atom length]];
    if ([[data stringWithRange:NSMakeRange(20, 4) encoding:NSMacOSRomanStringEncoding] isEqualToString:@"mp4a"]) {
        self->channels = [data unsignedShortAtOffset:40 swapped:YES];
        self->bitsPerSample = [data unsignedShortAtOffset:42 swapped:YES];
        self->sampleRate = [data unsignedIntAtOffset:46 swapped:YES];
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
                self->bitrate = ([data unsignedIntAtOffset:pos swapped:YES] + 500) / 1000;
            }
        }
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TLMP4Properties: {length:%u bitrate:%u sampleRate:%u channels:%u bitsPerSample:%u}",
            self->length, self->bitrate, self->sampleRate, self->channels, self->bitsPerSample];
}

@end
