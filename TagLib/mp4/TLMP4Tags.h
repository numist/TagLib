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

// Media properties
@property (copy,nonatomic,readonly) NSNumber *channels;
@property (copy,nonatomic,readonly) NSNumber *bitsPerSample;
@property (copy,nonatomic,readonly) NSNumber *sampleRate;
@property (copy,nonatomic,readonly) NSNumber *bitRate;
@property (copy,nonatomic,readonly) NSNumber *length;

// Public properties
#include "TLMP4Tags_Common.h"

@end
