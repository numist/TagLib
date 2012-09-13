//
//  TLMP4Tag_Private.h
//  TagLib
//
//  Created by Scott Perry on 9/11/12.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

#import "TLMP4Atom.h"
#import "TLTag.h"

@interface TLMP4Tag : TLTag

#pragma mark -
#pragma mark Redeclare publicly-readonly ivars
@property (copy, nonatomic, readwrite) NSString *path;
@property (getter=isReady, assign, nonatomic, readwrite) BOOL ready;

#pragma mark -
#pragma mark Protected ivars
@property (retain, nonatomic, readwrite) NSMutableDictionary *atoms;

#pragma mark -
#pragma mark File access methods
@property (retain, nonatomic, readwrite) NSFileHandle *handle;
@property (assign, nonatomic, readwrite) int32_t handleRefCount;
- (NSFileHandle *)beginReadingFile;
- (id)endReadingFile;

// Public class methods
#include "TLMP4Tag_Common.h"

@end
