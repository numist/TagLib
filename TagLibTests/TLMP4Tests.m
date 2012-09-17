//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "TLMP4Tags.h"
#import "TLMP4Tests.h"

@interface TLMP4Tests ()
+ (TLMP4Tags *)blockingMP4TagWithPath:(NSString *)path;
@end

@implementation TLMP4Tests

//- (void)setUp
//{
//    [super setUp];
//}
//
//- (void)tearDown
//{
//    [super tearDown];
//}
//
+ (TLTags *)blockingMP4TagWithPath:(NSString *)path;
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return nil;

    return [[TLMP4Tags alloc] initWithPath:path error:nil];
}

#pragma mark - Basic file loading
- (void)testBasicBadFile
{
    BOOL hasTags = NO;
    NSString *path = @"TagLibTests/data/empty.aiff";
    
    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

- (void)testBasicCovrJunk
{
    BOOL hasTags = YES;
    NSString *path = @"TagLibTests/data/covr-junk.m4a";

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

- (void)testBasicGnre
{
    BOOL hasTags = YES;
    NSString *path = @"TagLibTests/data/gnre.m4a";

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

- (void)testBasicHasTags
{
    BOOL hasTags = YES;
    NSString *path = @"TagLibTests/data/has-tags.m4a";

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

// TODO: Did this test work on TagLib(C++)?
//- (void)testBasicIlstIsLast
//{
//    BOOL hasTags = YES;
//    NSString *path = @"TagLibTests/data/ilst-is-last.m4a";
//
//    TLTag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
//    STAssertNotNil(mp4, @"File does not exist?: %@", path);
//
//    if (hasTags) {
//        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
//    } else {
//        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
//    }
//}

- (void)testBasicNoTags
{
    BOOL hasTags = NO;
    NSString *path = @"TagLibTests/data/no-tags.m4a";

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

#pragma mark - Atom operations

- (void)testFindIlst
{
    TLTags *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    TLMP4Tags *mp4 = [has_tags MP4Tags];
    STAssertNotNil(mp4, @"Object was not an MP4 tags object?");
    TLMP4Atom *ilst = [mp4 findAtom:@[@"moov", @"udta", @"meta", @"ilst"]];
    STAssertNotNil(ilst, @"%@", @"Atom moov.udta.meta.ilst not found");
}

- (void)testBasicTagParsing
{
    TLTags *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertFalse([has_tags isEmpty], @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([has_tags artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [has_tags artist]);
}

- (void)testBasicProperties
{
    TLTags *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    TLMP4Tags *mp4 = [has_tags MP4Tags];
    STAssertNotNil(mp4, @"Object was not an MP4 tags object?");

    //STAssertTrue([has_tags length] == 3, @"test file has unexpected length %u", [has_tags length]);
    STAssertTrue([[mp4 bitRate] unsignedIntegerValue]  == 3, @"test file has unexpected bitrate %u", [mp4 bitRate]);
    STAssertTrue([[mp4 sampleRate] unsignedIntegerValue] == 44100, @"test file has unexpected sample rate %u", [mp4 sampleRate]);
    STAssertTrue([[mp4 channels] unsignedShortValue] == 2, @"test file has unexpected channels %u", [mp4 channels]);
    STAssertTrue([[mp4 bitsPerSample] unsignedShortValue] == 16, @"test file has unexpected bitsPerSample %u", [mp4 bitsPerSample]);
}

@end
