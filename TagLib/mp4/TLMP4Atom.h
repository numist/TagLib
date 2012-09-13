//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

// Forward declare parent type
@class TLMP4Tag;

typedef enum {
    TLMP4DataTypeUnknown,
    TLMP4DataTypeAuto,
    TLMP4DataTypeFreeForm,
    TLMP4DataTypeIntPair,
    TLMP4DataTypeBool,
    TLMP4DataTypeInt,
    TLMP4DataTypeGenre,     // Int -> string, looked up in ID3 table
    TLMP4DataTypeImage,
    TLMP4DataTypeText
} TLMP4DataType;

@interface TLMP4Atom : NSObject
@property (nonatomic, readonly) uint64_t offset;
@property (nonatomic, readonly) uint64_t length;
@property (nonatomic, readonly) NSString *name;

- (id)initWithOffset:(uint64_t)offset
              length:(uint64_t)length
                name:(NSString *)name
              parent:(TLMP4Tag *)parent;

- (NSDictionary *) children;
- (TLMP4Atom *)getChild:(NSString *)name;

- (TLMP4DataType)dataType;
- (id)getDataWithType:(TLMP4DataType)expectedType;
- (id)getData;

- (NSString *) descriptionWithIndent:(NSString *)indent;
@end
