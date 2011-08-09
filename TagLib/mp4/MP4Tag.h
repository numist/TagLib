//
//  MP4Tag.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>
#import "TLTag.h"
#import "MP4Atoms.h"


@interface MP4Tag : TLTag {
    NSMutableDictionary *itemListMap;
}
@property(nonatomic, readonly) NSMutableDictionary *itemListMap;

- (MP4Tag *) initWithFile: (NSFileHandle *)file atoms: (MP4Atoms *)atoms;
- (BOOL) save;

// NOTE:
// - (NSString *) albumArtist;
// - (void) setAlbumArtist: (NSString *)albumArtist;
// etc.

@end
