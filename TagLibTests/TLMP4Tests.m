//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "TLMP4Tags.h"
#import "TLMP4Tests.h"
#import "TLErrorWrapper.h"

@interface TLMP4Tests ()
+ (TLMP4Tags *)blockingMP4TagWithPath:(NSString *)path error:(NSError **)error;
@end

@implementation TLMP4Tests

+ (TLTags *)blockingMP4TagWithPath:(NSString *)path error:(NSError **)terror;
{
    TLAssert([[NSFileManager defaultManager] fileExistsAtPath:path]);

    __block TLTags *tags = nil;
    __block NSError *error = nil;
    
    // Annoying hack to make object creation block
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [TLTags tagsForPath:path do:^(TLTags *t, NSError *e){
        error = e;
        tags = t;
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_release(sem);
    
    if (terror) {
        *terror = error;
    }
    
    return tags;
}

#pragma mark - Basic file loading
- (void)testBasicBadFile
{
    NSString *path = @"TagLibTests/data/empty.aiff";
    NSError *error;
    
    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNotNil(error, @"No error?");
    STAssertEquals((NSUInteger)[error code], (NSUInteger)kTLErrorFileNotRecognized, @"Unexpected error: %@ (expected Code %u)", error, kTLErrorCorruptFile);
    STAssertNil(mp4, @"File parsed?: %@", path);
}

- (void)testBasicCovrJunk
{
    NSString *path = @"TagLibTests/data/covr-junk.m4a";
    NSError *error;

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNotNil(error, @"No error?");
    STAssertEquals((NSUInteger)[error code], (NSUInteger)kTLErrorFileNotRecognized, @"Unexpected error: %@", error);
    STAssertNil(mp4, @"File parsed?: %@", path);
}

- (void)testBasicGnre
{
    NSString *path = @"TagLibTests/data/gnre.m4a";
    NSError *error;

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNil(error, @"Unexpected error: %@", error);
    STAssertNotNil(mp4, @"File failed to load?: %@", path);
    
    STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
}

- (void)testBasicHasTags
{
    NSString *path = @"TagLibTests/data/has-tags.m4a";
    NSError *error;

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNil(error, @"Unexpected error: %@", error);
    STAssertNotNil(mp4, @"File failed to load?: %@", path);
    
    STAssertFalse([mp4 isEmpty], @"%@", @"Failed to parse atoms in MPEG-4 file %@", path);
}

// Did this test work on TagLib(C++)?
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
    NSString *path = @"TagLibTests/data/no-tags.m4a";
    NSError *error;

    TLTags *mp4 = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNil(error, @"Unexpected error: %@", error);
    STAssertNotNil(mp4, @"File failed to load?: %@", path);
    
    STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in non-MPEG-4 file %@", path);
}

#pragma mark - Atom operations

- (void)testBasicTagParsing
{
    NSError *error;
    NSString *path = @"TagLibTests/data/has-tags.m4a";
    TLTags *has_tags = [TLMP4Tests blockingMP4TagWithPath:path error:&error];
    STAssertNotNil(has_tags, @"File failed to load?: %@", path);
    STAssertNil(error, @"Unexpected error: %@", error);
    STAssertFalse([has_tags isEmpty], @"%@", @"Failed to parse any tags from file");
    STAssertEqualObjects([has_tags artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [has_tags artist]);
}

- (void)testBasicProperties
{
    NSError *error;
    TLTags *has_tags = [TLMP4Tests blockingMP4TagWithPath:@"TagLibTests/data/has-tags.m4a" error:&error];
    STAssertNil(error, @"Unexpected error: %@", error);
    TLMP4Tags *mp4 = [has_tags MP4Tags];
    STAssertNotNil(mp4, @"Object was not an MP4 tags object?");

    STAssertTrue([[mp4 length] unsignedIntegerValue] == 3, @"test file has unexpected length %u", [mp4 length]);
    STAssertTrue([[mp4 bitRate] unsignedIntegerValue]  == 3, @"test file has unexpected bitrate %u", [mp4 bitRate]);
    STAssertTrue([[mp4 sampleRate] unsignedIntegerValue] == 44100, @"test file has unexpected sample rate %u", [mp4 sampleRate]);
    STAssertTrue([[mp4 channels] unsignedShortValue] == 2, @"test file has unexpected channels %u", [mp4 channels]);
    STAssertTrue([[mp4 bitsPerSample] unsignedShortValue] == 16, @"test file has unexpected bitsPerSample %u", [mp4 bitsPerSample]);
}

@end
