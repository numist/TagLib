//
//  TLMP4Tag.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

#import "TLMP4Atoms.h"
#import "TLTag.h"

@interface TLMP4Tag : TLTag
@property (retain, nonatomic, readwrite) NSMutableDictionary *items;

- (TLMP4Tag *) initWithFile: (NSFileHandle *)file atoms:(TLMP4Atoms *)atoms;

// NOTE:
// - (NSString *) albumArtist;
// - (void) setAlbumArtist: (NSString *)albumArtist;
// - (NSNumber *) totalTracks;
// - (void) setTotalTracks: (NSNumber *)totalTracks;
// etc.

- (NSString *) yearAsString;
- (void) setYearAsString: (NSString *)date;

@end
