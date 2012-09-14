//
//  TLMP4Tag_Private.h
//  TagLib
//
//  Created by Scott Perry on 9/11/12.
//

#import <Foundation/Foundation.h>

#import "TLTags.h"

@class TLMP4Atom;
@class TLMP4AtomInfo;

@interface TLMP4Tags : TLTags

#pragma mark -
#pragma mark Redeclare publicly-readonly ivars
@property (copy, nonatomic, readwrite) NSString *path;
@property (getter=isReady, assign, nonatomic, readwrite) BOOL ready;

#pragma mark -
#pragma mark Protected ivars
@property (retain, nonatomic, readonly) NSDictionary *atoms;

#pragma mark -
#pragma mark File access methods
@property (retain, nonatomic, readwrite) NSFileHandle *handle;
@property (assign, nonatomic, readwrite) int32_t handleRefCount;
- (NSFileHandle *)beginReadingFile;
- (id)endReadingFile;

// Media properties
@property (assign,nonatomic,readwrite) NSInteger channels;
@property (assign,nonatomic,readwrite) NSInteger bitsPerSample;
@property (assign,nonatomic,readwrite) NSInteger sampleRate;
@property (assign,nonatomic,readwrite) NSInteger bitRate;

// Public class methods
#include "TLMP4Tag_Common.h"

@end
