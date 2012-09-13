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
@property (nonatomic, readwrite) NSDictionary *children;
@property (weak, nonatomic, readwrite) TLMP4Tag *parent;
@property (nonatomic, readwrite) uint64_t dataOffset;
@end

@implementation TLMP4Atom
@synthesize offset = _offset;
@synthesize length = _length;
@synthesize name = _name;
@synthesize children = _children;
@synthesize parent = _parent;
@synthesize dataOffset = _dataOffset;

- (id)initWithOffset:(uint64_t)offset parent:(TLMP4Tag *)parent;
{
    self = [super init];
    if (!self) return nil;
    
    NSFileHandle *handle = [parent beginReadingFile];
    
    NSLog(@"Parsing atom at offset %llu", offset);
    
    // Establish EOF boundary and seek to offset
    [handle seekToEndOfFile];
    uint64_t fileSize = [handle offsetInFile];
    [handle seekToFileOffset:offset];
    
    // Read atom header
    NSData *header = [handle readDataOfLength:8];
    if ([header length] != 8) {
        TLLog(@"MP4: Couldn't read 8 bytes of data for atom header. (Got %lu bytes)",
              [header length]);
        (void)[parent endReadingFile];
        return nil;
    }
    
    uint64_t length = 0;
    [header getBytes:&length length:4 endianness:OSBigEndian];
    NSLog(@"Length could be %llu?", length);
    if (length == 1) {
        [[handle readDataOfLength:8] getBytes:&length endianness:OSBigEndian];
        if (length > UINT32_MAX) {
            TLCheck(length <= UINT32_MAX);
            TLLog(@"MP4: 64-bit atoms are not supported. (Got %llu bytes)", length);
            (void)[parent endReadingFile];
            return nil;
        }
        // The atom has a 64-bit length, but it's actually a 32-bit value
    }
    if (length < 8 || length + offset > fileSize) {
        TLLog(@"MP4: Invalid atom size: %llu", length);
        (void)[parent endReadingFile];
        return nil;
    }
    
    NSString *name = [[NSString alloc] initWithBytes:[[header subdataWithRange:NSMakeRange(4, 4)] bytes]
                                          length:4 encoding:NSMacOSRomanStringEncoding];
    
    
    _offset = offset;
    _length = length;
    _name = name;
    _parent = parent;
    _dataOffset = [handle offsetInFile];

    NSLog(@"Successfully parsed atom %@ at offset %llu", [self name], [self offset]);
    
    handle = [parent endReadingFile];
    
    return self;
}

#pragma mark - JIT ivar getters

- (NSDictionary *)children;
{
    // Pointless call to make sure we've loaded children.
    if (!_children) {
        (void)[self getChild:@""];
    }
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
    static NSSet *containers = nil;
    if (!containers) {
        containers = [NSSet setWithObjects:@"moov", @"udta", @"mdia", @"meta",
                      @"ilst", @"stbl", @"minf", @"moof", @"traf", @"trak",
                      nil];
    }
    
    if (!_children) {
        NSMutableDictionary *children = [[NSMutableDictionary alloc] init];
        
        // Only some atoms have children, apparently they're categorized by name?
        if (![containers containsObject:self.name]) return nil;
        
        uint64_t offset = self.dataOffset;
        
        if ([self.name isEqualToString:@"meta"]) {
            offset += 4;
        }
            
        while (offset < self.offset + self.length) {
            TLMP4Atom *child = [[TLMP4Atom alloc] initWithOffset:offset parent:self.parent];
            if (!child) {
                self.children = nil;
                TLNotTested();
                return nil;
            }
            [children setValue:child forKey:[child name]];
            offset += [child length];
        }
        
        self.children = children;
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
    if (flags >= 0 && flags != self.flags) {
        NSLog(@"atom: %@ incoming flags: %d, my flags:%d", self.name, flags, self.flags);
        return nil;
    }
    
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
