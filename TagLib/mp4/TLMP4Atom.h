//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

#import "TLMP4AtomInfo.h"

// Forward declare parent type
@class TLMP4Tags;

@interface TLMP4Atom : NSObject
@property (nonatomic, readonly) uint64_t offset;
@property (nonatomic, readonly) uint64_t length;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *children;

- (id)initWithOffset:(uint64_t)offset parent:(TLMP4Tags *)parent;

- (TLMP4Atom *)getChild:(NSString *)name;
- (NSArray *)getChild:(NSString *)name recursive:(BOOL)recursive;

- (id)getDataWithType:(TLMP4DataType)type checkFlags:(TLMP4AtomFlags)flags;
- (id)getDataWithType:(TLMP4DataType)type;
- (NSData *)getData;
- (NSData *)getDataWithRange:(NSRange)range;

- (NSString *) descriptionWithIndent:(NSString *)indent;
@end
