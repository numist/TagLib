//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "TLMP4Tag.h"
#import "TLMP4Tests.h"

@interface TLMP4Tests ()
+ (TLMP4Tag *)blockingMP4TagWithPath:(NSString *)path;
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
+ (TLMP4Tag *)blockingMP4TagWithPath:(NSString *)path;
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return nil;

    TLMP4Tag *tag = [[TLMP4Tag alloc] initWithPath:path];
    
    // Basic block until tags have been parsed
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    } while (![tag isReady]);
    
    return tag;
}

#pragma mark - Basic file loading
- (void)testBasicBadFile
{
    BOOL hasTags = NO;
    NSString *path = @"TagLibTests/data/empty.aiff";
    
    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    STAssertTrue([mp4 isReady], @"File is not ready?");
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

    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    STAssertTrue([mp4 isReady], @"File is not ready?");
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

    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    STAssertTrue([mp4 isReady], @"File is not ready?");
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

    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    STAssertTrue([mp4 isReady], @"File is not ready?");
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
//    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
//    STAssertNotNil(mp4, @"File does not exist?: %@", path);
//    
//    STAssertTrue([mp4 isReady], @"File is not ready?");
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

    TLMP4Tag *mp4 = [TLMP4Tests blockingMP4TagWithPath:path];
    STAssertNotNil(mp4, @"File does not exist?: %@", path);
    
    STAssertTrue([mp4 isReady], @"File is not ready?");
    if (hasTags) {
        STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
    } else {
        STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
    }
}

#pragma mark - Atom operations

- (void)testFindIlst
{
    TLMP4Tag *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    TLMP4Atom *ilst = [has_tags findAtom:@[@"moov", @"udta", @"meta", @"ilst"]];
    STAssertNotNil(ilst, @"%@", @"Atom moov.udta.meta.ilst not found");
}

- (void)testBasicTagParsing
{
    TLMP4Tag *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertTrue([has_tags isReady], @"%@", @"Tag object was not loaded");
    STAssertFalse([has_tags isEmpty], @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([has_tags artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [has_tags artist]);
}

- (void)testBasicProperties
{
    TLMP4Tag *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a"];
    
    //STAssertTrue([has_tags length] == 3, @"test file has unexpected length %u", [has_tags length]);
    STAssertTrue([has_tags bitRate] == 3, @"test file has unexpected bitrate %u", [has_tags bitRate]);
    STAssertTrue([has_tags sampleRate] == 44100, @"test file has unexpected sample rate %u", [has_tags sampleRate]);
    STAssertTrue([has_tags channels] == 2, @"test file has unexpected channels %u", [has_tags channels]);
    STAssertTrue([has_tags bitsPerSample] == 16, @"test file has unexpected bitsPerSample %u", [has_tags bitsPerSample]);
}

@end
