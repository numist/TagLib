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

@interface TLMP4Atom ()
@property (nonatomic, readonly) NSMutableDictionary *children;
@property (weak, nonatomic, readwrite) TLMP4Tag *parent;
@end

@implementation TLMP4Atom
@synthesize offset, length, name, children;

- (id)initWithOffset:(uint64_t)offsetArg length:(uint64_t)lengthArg name:(NSString *)nameArg;
{
    self = [super init];
    if (!self || !lengthArg || !nameArg) return nil;
    
    offset = offsetArg;
    length = lengthArg;
    name = nameArg;
    children = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)addChild:(TLMP4Atom *)child;
{
    [[self children] setValue:child forKey:[child name]];
}

- (NSDictionary *) children;
{
    return [children copy];
}

- (TLMP4Atom *)getChild:(NSString *)nameArg;
{
    return [children objectForKey:nameArg];
}

- (TLMP4DataType)dataType;
{
    // TODO: get dataType from flags
    TLAssert(0);
}

- (id)getDataWithType:(TLMP4DataType)expectedType;
{
    id data = nil;

    if (!expectedType) {
        expectedType = [self dataType];
        TLLog(@"Assuming type %d", expectedType);
        TLNotTested();
    }
    
    // TODO: implement
    TLAssert(0);
    return data;
}

- (id)getData;
{
    return [self getDataWithType:TLMP4DataTypeAuto];
}

// TODO: check
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"Atom: %@, length %llu, offset %llu", self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %lu children: {\n", [self->children count]];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:@"\t"]];
        }
        [result appendFormat:@"} End of atom: %@", self->name];
    }
    return result;
}

// TODO: check
- (NSString *)descriptionWithIndent:(NSString *)indent
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@Atom: %@, length %llu, offset %llu", indent, self->name, self->length, self->offset];
    
    if ([self->children count]) {
        [result appendFormat:@" has %lu children: {\n", [self->children count]];
        NSString *newIndent = [NSString stringWithFormat:@"%@%@", @"\t", indent];
        for (TLMP4Atom *child in [self->children objectEnumerator]) {
            [result appendFormat:@"%@\n", [child descriptionWithIndent:newIndent]];
        }
        [result appendFormat:@"%@} End of atom: %@", indent, self->name];
    }
    return result;
}

@end
