//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Atom.h"
#import "debugger.h"
#import "NSData+Endian.h"
#import "TLMP4Tag_Private.h"

@interface TLMP4Atom () {
    NSNumber *_flags;
}
@property (nonatomic, readwrite) NSMutableDictionary *children;
@property (weak, nonatomic, readwrite) TLMP4Tag *parent;
@end

@implementation TLMP4Atom
@synthesize offset = _offset;
@synthesize length = _length;
@synthesize name = _name;
@synthesize children = _children;
@synthesize parent = _parent;

- (id)initWithOffset:(uint64_t)offsetArg length:(uint64_t)lengthArg name:(NSString *)nameArg parent:(TLMP4Tag *)parentArg;
{
    self = [super init];
    if (!self || !lengthArg || !nameArg) return nil;
    
    _offset = offsetArg;
    _length = lengthArg;
    _name = nameArg;
    _parent = parentArg;
    
    return self;
}

#pragma mark - JIT ivar getters

- (NSDictionary *)children;
{
    // Pointless call to make sure we've loaded children.
    (void)[self getChild:@""];
    return _children;
}

- (TLMP4AtomFlags)flags;
{
    if (!_flags) {
        // TODO: get flags
    }
    return (TLMP4AtomFlags)[_flags integerValue];
}

#pragma mark Subdata getters

- (TLMP4Atom *)getChild:(NSString *)nameArg;
{
    if (!self.children) {
        // TODO: Get children of this atom!
        self.children = [[NSMutableDictionary alloc] init];
    }
    return [self.children objectForKey:nameArg];
}

- (TLMP4DataType)likelyDataType;
{
    return [TLMP4AtomInfo dataTypeFromFlags:self.flags];
}

- (id)getDataWithType:(TLMP4DataType)type checkFlags:(TLMP4AtomFlags)flags;
{
    id data = nil;
    
    // This is a little strict, but it'll do for now
    TLAssert(flags < 0 || flags == self.flags);
    
    if (type == TLMP4DataTypeAuto) {
        type = [TLMP4AtomInfo dataTypeFromFlags:self.flags];
        // This is a little strict, but it'll do for now
        TLAssert(type != TLMP4DataTypeUnknown);
    }
    
    // TODO: get and cast the data
    TLAssert(0);
    return data;
}

- (id)getDataWithType:(TLMP4DataType)type;
{
    return [self getDataWithType:type checkFlags:-1];
}

- (id)getData;
{
    return [self getDataWithType:TLMP4DataTypeAuto];
}

// TODO: check
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"Atom: %@, length %llu, offset %llu", self.name, self.length, self.offset];
    
    if ([self.children count]) {
        [result appendFormat:@" has %lu children: {\n", [self.children count]];
        for (TLMP4Atom *child in [self.children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:@"\t"]];
        }
        [result appendFormat:@"} End of atom: %@", self.name];
    }
    return result;
}

// TODO: check
- (NSString *)descriptionWithIndent:(NSString *)indent
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@Atom: %@, length %llu, offset %llu", indent, self.name, self.length, self.offset];
    
    if ([self.children count]) {
        [result appendFormat:@" has %lu children: {\n", [self.children count]];
        NSString *newIndent = [NSString stringWithFormat:@"%@%@", @"\t", indent];
        for (TLMP4Atom *child in [self.children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:newIndent]];
        }
        [result appendFormat:@"%@} End of atom: %@", indent, self.name];
    }
    return result;
}

@end
