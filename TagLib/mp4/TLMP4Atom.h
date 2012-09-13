//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

#import "TLMP4AtomInfo.h"

// Forward declare parent type
@class TLMP4Tag;

@interface TLMP4Atom : NSObject
@property (nonatomic, readonly) uint64_t offset;
@property (nonatomic, readonly) uint64_t length;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *children;

- (id)initWithOffset:(uint64_t)offset parent:(TLMP4Tag *)parent;

- (TLMP4AtomFlags)flags;

- (TLMP4Atom *)getChild:(NSString *)name;
- (TLMP4DataType)likelyDataType;

- (id)getDataWithType:(TLMP4DataType)type checkFlags:(TLMP4AtomFlags)flags;
- (id)getDataWithType:(TLMP4DataType)type;
- (id)getData;

- (NSString *) descriptionWithIndent:(NSString *)indent;
@end
