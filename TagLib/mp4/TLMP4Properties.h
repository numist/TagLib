//
//  TLMP4Properties.h
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

#import "TLMP4Atoms.h"

@interface TLMP4Properties : NSObject {
    @private
    uint32 length;
    uint32 bitrate;
    uint32 sampleRate;
    uint32 channels;
    uint32 bitsPerSample;
}
@property(nonatomic, readonly) uint32 length;
@property(nonatomic, readonly) uint32 bitrate;
@property(nonatomic, readonly) uint32 sampleRate;
@property(nonatomic, readonly) uint32 channels;
@property(nonatomic, readonly) uint32 bitsPerSample;

- (TLMP4Properties *) initWithFile: (NSFileHandle *)file atoms: (TLMP4Atoms *)atoms;

@end
