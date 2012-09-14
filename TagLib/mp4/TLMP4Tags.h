//
//  TLMP4Tags.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import <Foundation/Foundation.h>

#import "TLTags.h"

@class TLMP4Atom;
@class TLMP4AtomInfo;

@interface TLMP4Tags : TLTags
@property (copy, nonatomic, readonly) NSString *path;
@property (getter=isReady, assign, nonatomic, readonly) BOOL ready;

// Media properties
@property (copy,nonatomic,readonly) NSNumber *channels;
@property (copy,nonatomic,readonly) NSNumber *bitsPerSample;
@property (copy,nonatomic,readonly) NSNumber *sampleRate;
@property (copy,nonatomic,readonly) NSNumber *bitRate;

// Public class methods
#include "TLMP4Tag_Common.h"

@end
