//
//  TLMP4Tags_Private.h
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

#pragma mark -
#pragma mark Protected ivars
@property (retain, nonatomic, readonly) NSDictionary *atoms;

#pragma mark -
#pragma mark File access methods
- (NSData *)getData;

// Media properties
@property (copy,nonatomic,readwrite) NSNumber *channels;
@property (copy,nonatomic,readwrite) NSNumber *bitsPerSample;
@property (copy,nonatomic,readwrite) NSNumber *sampleRate;
@property (copy,nonatomic,readwrite) NSNumber *bitRate;

- (id)initWithPath:(NSString *)pathArg error:(NSError **)error;

- (TLMP4Atom *)findAtom:(NSArray *)path;
- (NSArray *)getAtom:(NSString *)name recursive:(BOOL)recursive;
- (id)getILSTData:(TLMP4AtomInfo *)atomInfo;

// Public properties
#include "TLMP4Tags_Common.h"

@end
