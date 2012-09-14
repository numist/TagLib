//
//  MP4Atom.m
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Atom.h"
#import "debugger.h"
#import "NSData+Endian.h"
#import "TLMP4Tags_Private.h"
#import "NSData+GetTypedData.h"
#import "TLID3v1Genres.h"
#import "ISO8601DateFormatter.h"

@interface TLMP4Atom ()
@property (nonatomic, readwrite) NSDictionary *children;
@property (weak, nonatomic, readwrite) TLMP4Tags *parent;
@property (nonatomic, readwrite) uint64_t dataOffset;

- (NSArray *)parseDataWithExpectedFlags:(TLMP4AtomFlags)flags freeForm:(BOOL)freeForm;
- (NSArray *)parseDataWithExpectedFlags:(TLMP4AtomFlags)flags;
- (NSArray *)parseData;
- (NSData *)getAtomInternalData;

- (NSArray *)parseFreeForm;
- (NSArray *)parseIntPairWithFlags:(TLMP4AtomFlags)flags;
- (NSNumber *)parseBoolWithFlags:(TLMP4AtomFlags)flags;
- (NSNumber *)parseIntWithFlags:(TLMP4AtomFlags)flags;
- (NSString *)parseGnreWithFlags:(TLMP4AtomFlags)flags;
- (NSImage *)parseCovr;
- (NSString *)parseTextWithFlags:(TLMP4AtomFlags)flags;
- (NSDate *)parseDateWithFlags:(TLMP4AtomFlags)flags;
@end

@implementation TLMP4Atom
@synthesize offset = _offset;
@synthesize length = _length;
@synthesize name = _name;
@synthesize children = _children;
@synthesize parent = _parent;
@synthesize dataOffset = _dataOffset;

- (id)initWithOffset:(uint64_t)atomOffset parent:(TLMP4Tags *)parent;
{
    self = [super init];
    if (!self) return nil;
    
    NSData *data = [parent getData];
    
    // Establish EOF boundary and seek to offset
    uint64_t fileSize = [data length];
    uint64_t offset = atomOffset;
    
    // Read atom header
    if (offset + 8 > fileSize) {
        TLLog(@"MP4: Truncated file?");
        data = nil;
        return nil;
    }
    NSData *header = [data subdataWithRange:NSMakeRange(offset, 8)];
    offset += 8;
    
    uint64_t length = 0;
    [header getBytes:&length length:4 endianness:OSBigEndian];
    if (length == 1) {
        if (offset + 8 > fileSize) {
            TLLog(@"MP4: Truncated file?");
            data = nil;
            return nil;
        }
        [[data subdataWithRange:NSMakeRange(offset, 8)] getBytes:&length endianness:OSBigEndian];
        offset += 8;
        if (length > UINT32_MAX) {
            TLCheck(length <= UINT32_MAX);
            TLLog(@"MP4: 64-bit atoms are not tested (or supported, please share this file for testing!). (Got %llu bytes)", length);
            data = nil;
            return nil;
        }
        // The atom has a 64-bit length, but it's actually a 32-bit value
    }
    if (length < 8 || length + atomOffset > fileSize) {
        TLLog(@"MP4: Invalid atom size: %llu", length);
        data = nil;
        return nil;
    }
    
    NSString *name = [[NSString alloc] initWithBytes:[[header subdataWithRange:NSMakeRange(4, 4)] bytes]
                                          length:4 encoding:NSMacOSRomanStringEncoding];
    
    
    _offset = atomOffset;
    _length = length;
    _name = name;
    _parent = parent;
    _dataOffset = offset;

    data = nil;
    
    return self;
}

#pragma mark - JIT ivar getters

- (NSDictionary *)children;
{
    // Only some atoms have children, apparently they're categorized by name?
    static NSArray *containers = nil;
    if (!containers) containers = @[@"moov", @"udta", @"mdia", @"meta", @"ilst", @"stbl", @"minf", @"moof", @"traf", @"trak"];
    if (![containers containsObject:self.name]) return nil;
    
    // Memoize children on demand
    if (!_children) {
        NSMutableDictionary *children = [[NSMutableDictionary alloc] init];
        
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
        
        _children = children;
    }
    
    return _children;
}

#pragma mark Subdata getters

- (TLMP4Atom *)getChild:(NSString *)nameArg;
{
    return [self.children objectForKey:nameArg];
}

- (NSArray *)getChild:(NSString *)name recursive:(BOOL)recursive;
{
    if (!recursive) return @[[self getChild:name]];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *atomName in self.children) {
        if ([name isEqualToString:atomName]) {
            [result addObject:[self.children objectForKey:atomName]];
        }
        [result addObjectsFromArray:[[self.children objectForKey:atomName] getChild:name recursive:recursive]];
    }
    return result;
}

#pragma mark Data blob getters

- (id)getDataWithType:(TLMP4DataType)type checkFlags:(TLMP4AtomFlags)flags;
{
    if (type == TLMP4DataTypeAuto) {
        type = [TLMP4AtomInfo likelyDataTypeFromFlags:flags];
        // This is a little strict, but it'll do for now
        TLAssert(type != TLMP4DataTypeUnknown);
    }
    
    switch (type) {
        case TLMP4DataTypeFreeForm:
            // Discarding flags, sorry
            return [self parseFreeForm];
        case TLMP4DataTypeIntPair:
            return [self parseIntPairWithFlags:flags];
        case TLMP4DataTypeBool:
            return [self parseBoolWithFlags:flags];
        case TLMP4DataTypeInt:
            return [self parseIntWithFlags:flags];
        case TLMP4DataTypeGenre:
            return [self parseGnreWithFlags:flags];
        case TLMP4DataTypeImage:
            // Discarding flags, sorry
            return [self parseCovr];
        case TLMP4DataTypeText:
            return [self parseTextWithFlags:flags];
        case TLMP4DataTypeDate:
            return [self parseDateWithFlags:flags];
        default:
            TLNotReached();
            return nil;
    }
    return nil;
}

- (id)getDataWithType:(TLMP4DataType)type;
{
    return [self getDataWithType:type checkFlags:-1];
}

- (NSData *)getDataWithRange:(NSRange)range;
{
    range.location += self.offset;
    
    NSData *fileData = [self.parent getData];
    NSData *data = [fileData subdataWithRange:range];
    
    fileData = nil;
    
    return data;
}

- (NSData *)getData;
{
    return [self getDataWithRange:NSMakeRange(0, self.length)];
}

- (NSData *)getAtomInternalData;
{
    NSRange range;
    range.location = self.dataOffset - self.offset;
    range.length = self.length - range.location;
    return [self getDataWithRange:range];
}

#pragma mark - Data parsing

- (NSArray *)parseDataWithExpectedFlags:(TLMP4AtomFlags)flags freeForm:(BOOL)freeForm;
{
    NSData *data = [self getData];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];

    int i = 0;
    uint64_t pos = self.dataOffset - self.offset;
    while (pos < [data length]) {
        uint32 length = [data unsignedIntAtOffset:pos endianness:OSBigEndian];
        NSString *name = [data stringWithRange:NSMakeRange(pos + 4, 4) encoding:NSMacOSRomanStringEncoding];
        uint32 atomFlags = [data unsignedIntAtOffset:(pos + 8) endianness:OSBigEndian];
        
        if (freeForm && i < 2) {
            if (i == 0 && ![name isEqualToString:@"mean"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"mean\"", name);
                return nil;
            } else if (i == 1 && ![name isEqualToString:@"name"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"name\"", name);
                return nil;
            }
            [result addObject:[data subdataWithRange:NSMakeRange(pos + 12, length - 12)]];
        } else {
            if (![name isEqualToString:@"data"]) {
                TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
                return nil;
            }
            // ???: huh, I wonder what's in NSMakeRange(pos + 12, 4)?
            if (flags < 0 || (uint32)flags == atomFlags) {
                [result addObject:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]];
            }
        }
        
        pos += length;
        ++i;
    }
    TLCheck(pos == [data length]);
    
    return result;
}

- (NSArray *)parseDataWithExpectedFlags:(TLMP4AtomFlags)flags;
{
    return [self parseDataWithExpectedFlags:flags freeForm:NO];
}

- (NSArray *)parseData;
{
    TLNotTested();
    return [self parseDataWithExpectedFlags:-1];
}

- (NSArray *)parseFreeForm;
{
    NSArray *data = [self parseDataWithExpectedFlags:1 freeForm:YES];
    TLCheck([data count] > 2);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    // Avoid an out of bounds exception
    if ([data count] < 2) return nil;
    
    NSString *name = [NSString stringWithFormat:@"----:%@:%@",
                      [[data objectAtIndex:0] stringWithEncoding:NSMacOSRomanStringEncoding],
                      [[data objectAtIndex:1] stringWithEncoding:NSMacOSRomanStringEncoding]];
    [result addObject:name];
    
    for (unsigned int i = 2; i < [data count]; ++i) {
        [result addObject:[[data objectAtIndex:i] stringWithEncoding:NSMacOSRomanStringEncoding]];
    }
    
    TLLog(@"Parsed freeform: %@", result);
    return result;
}

- (NSArray *)parseIntPairWithFlags:(TLMP4AtomFlags)flags;
{
    NSArray *data = [self parseDataWithExpectedFlags:flags];
    TLCheck([data count] == 1);
    
    TLCheck([data count] == 1);
    for (NSData *datum in data) {
        TLCheck([datum length] == 6 || [datum length] == 8);
        if ([datum length] >= 6) {
            return @[[datum numberWithRange:NSMakeRange(2, 2) endianness:OSBigEndian],
                     [datum numberWithRange:NSMakeRange(4, 2) endianness:OSBigEndian]];
        }
    }
    
    return nil;
}

- (NSNumber *)parseBoolWithFlags:(TLMP4AtomFlags)flags;
{
    NSArray *data = [self parseDataWithExpectedFlags:flags];
    TLCheck([data count] == 1);

    for (NSData *datum in data) {
        TLCheck([datum length] >= 1);
        if ([datum length]) {
            uint8 value = [datum unsignedCharAtOffset:0];
            TLCheck(value <= 1);
            if (value == 1) {
                return [NSNumber numberWithBool:YES];
            } else {
                return [NSNumber numberWithBool:NO];
            }
        }
    }
    
    return nil;
}

- (NSNumber *)parseIntWithFlags:(TLMP4AtomFlags)flags;
{
    NSArray *data = [self parseDataWithExpectedFlags:flags];
    TLCheck([data count] == 1);
    
    for (NSData *datum in data) {
        TLCheck([datum length] == 1 || [datum length] == 2 || [datum length] == 4);
        if ([datum length]) {
            NSNumber *value = [datum numberWithEndianness:OSBigEndian];
            if ([value isGreaterThan:[NSNumber numberWithUnsignedInt:UINT8_MAX]]) {
                TLNotTested();
            }
            return value;
        }
    }
    
    return nil;
}

- (NSString *)parseGnreWithFlags:(TLMP4AtomFlags)flags;
{
    NSNumber *genreCode = [self parseIntWithFlags:flags];
    TLCheck([genreCode integerValue] < INT16_MAX);
    
    if ([TLID3v1Genres genreForIndex:([genreCode shortValue] - 1)]) {
        return [TLID3v1Genres genreForIndex:[genreCode shortValue] - 1];
    }
    
    return nil;
}

- (NSImage *)parseCovr;
{
    /* NOTE: NSData -subDataWithRange: insists in multiple places in the docs that it returns a copy of the data.
     * I'm going to trust it for now and use it to back the NSImage.
     * If there are weird image bugs, start here to make sure that the subData copy isn't being lost when the file's data is unmapped.
     */
    NSData *data = [self getAtomInternalData];

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    uint32 pos = 0;
    while (pos < [data length]) {
        uint32 length = [data unsignedIntAtOffset:pos endianness:OSBigEndian];
        NSString *name = [[NSString alloc] initWithCString:[[data subdataWithRange:NSMakeRange(pos + 4, 4)] bytes]
                                                  encoding:NSMacOSRomanStringEncoding];
        uint32 flags = [data unsignedIntAtOffset:(pos + 8) endianness:OSBigEndian];
        
        if (![name isEqualToString:@"data"]) {
            TLLog(@"MP4: Unexpected atom \"%@\", expecting \"data\"", name);
            return nil;
        }
        
        TLCheck(flags == TLMP4AtomFlagsJPEG || flags == TLMP4AtomFlagsPNG);
        TLCheck(length > 16);

        if ((flags == TLMP4AtomFlagsJPEG || flags == TLMP4AtomFlagsPNG) && length > 16) {
            NSImage *art = [[NSImage alloc] initWithData:[data subdataWithRange:NSMakeRange(pos + 16, length - 16)]];
            TLCheck([art isValid]);
            [result addObject:art];
        }
        
        pos += length;
    }
    TLCheck(pos == [data length]);
    
    return [result objectAtIndex:0];
}

- (NSString *)parseTextWithFlags:(TLMP4AtomFlags)flags;
{
    NSArray *data = [self parseDataWithExpectedFlags:flags];
    TLCheck([data count] == 1);
    
    for (NSData *datum in data) {
        TLCheck([datum length] >= 2);
        if ([datum length] >= 1) {
            return [datum stringWithEncoding:NSUTF8StringEncoding];
        }
    }

    return nil;
}

- (NSDate *)parseDateWithFlags:(TLMP4AtomFlags)flags;
{
    NSString *text = [self parseTextWithFlags:flags];

    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+0]];
    ISO8601DateFormatter *format = [[ISO8601DateFormatter alloc] init];
    
    return [format dateFromString:text];
}

#pragma mark - NSObject overloads

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
