//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "debugger.h"
#import "TLMP4Tag.h"
#import "TLMP4Tests.h"

@interface TLMP4Tests ()
@property (nonatomic,retain) TLMP4Tag *has_tags;
@end

@implementation TLMP4Tests
@synthesize has_tags;

- (void)setUp
{
    [super setUp];
    
    self.has_tags = [[TLMP4Tag alloc] initWithPath:@"TagLibTests/data/has-tags.m4a"];
    
    // Basic block until tags have been parsed
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    } while (![self.has_tags isReady]);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBadFile
{
    TLMP4Tag *mp4 = [[TLMP4Tag alloc] initWithPath:@"TagLibTests/data/empty.aiff"];
    // Basic block until tags have been parsed
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    } while (![self.has_tags isReady]);

    if (![mp4 isEmpty]) {
        TLLog(@"%@", [mp4 description]);
    }
    STAssertTrue([mp4 isEmpty], @"%@", @"Found atoms in a non-MPEG-4 file");
}

- (void)testFindIlst
{
    TLMP4Atom *ilst = [self.has_tags findAtom:@[@"moov", @"udta", @"meta", @"ilst"]];
    STAssertNotNil(ilst, @"%@", @"Atom moov.udta.meta.ilst not found");
}

- (void)testBasicTagParsing
{
    STAssertFalse([self.has_tags isEmpty], @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([self.has_tags artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [self.has_tags artist]);
}

//- (void)testBasicProperties
//{    
//    TLMP4Properties *properties = [self.has_tags properties];
//    
//    STAssertTrue([properties length] == 3, @"test file has unexpected length %u", [properties length]);
//    STAssertTrue([properties bitrate] == 3, @"test file has unexpected bitrate %u", [properties bitrate]);
//    STAssertTrue([properties sampleRate] == 44100, @"test file has unexpected sample rate %u", [properties sampleRate]);
//    STAssertTrue([properties channels] == 2, @"test file has unexpected channels %u", [properties channels]);
//    STAssertTrue([properties bitsPerSample] == 16, @"test file has unexpected bitsPerSample %u", [properties bitsPerSample]);
//}

@end
