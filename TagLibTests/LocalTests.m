//
//  LocalTests.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "LocalTests.h"
#import "TLMP4Tags.h"

@interface LocalTests ()
+ (TLMP4Tags *)blockingMP4TagWithPath:(NSString *)path;
@end

@implementation LocalTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

+ (TLTags *)blockingMP4TagWithPath:(NSString *)path;
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
    
    if (error) {
        NSLog(@"Error creating tags object: %@", [error localizedDescription]);
    }
    
    return tags;
}

- (void)testBasicHorribleTagParsing
{
    NSString *file = @"TagLibTests/data/Local-horrible.m4a";
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Tags *tag = [LocalTests blockingMP4TagWithPath:file];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertFalse([tag isEmpty], @"%@ contains no tags?", file);
}

- (void)testBasicFireflyTagParsing
{
    NSString *file = @"TagLibTests/data/Local-firefly.m4v";
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Tags *tag = [LocalTests blockingMP4TagWithPath:file];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertFalse([tag isEmpty], @"%@ contains no tags?", file);
}

- (void)testPoorLenoTags
{
    NSString *file = @"TagLibTests/data/Local-poorleno.m4a";

    if(![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Tags *tag = [LocalTests blockingMP4TagWithPath:file];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertFalse([tag isEmpty], @"%@ contains no tags?", file);
    
    // properties
    STAssertEquals([[tag channels] unsignedShortValue], (uint16_t)2, @"media expected to have 2 channels");
    STAssertEquals([[tag bitsPerSample] unsignedShortValue], (uint16_t)16, @"media expected to have 16 bits per sample");
    STAssertEquals([[tag sampleRate] unsignedIntValue], (uint32_t)44100, @"media expected to have sample rate of 44100 Hz");
    STAssertEquals([[tag bitRate] unsignedIntValue], (uint32_t)256, @"media expected to have bitrate of 256 kbps");
    
    // TL generic tags
    STAssertTrue([[tag title] isEqualToString:@"Poor Leno (Istanbul Forever Take)"], @"title expected to be \"Poor Leno (Istanbul Forever Take)\" (was: %@)", [tag title]);
    STAssertTrue([[tag artist] isEqualToString:@"Röyksopp"], @"artist is expected to be \"Röyksopp\" (was: \"%@\")", [tag artist]);
    STAssertTrue([[tag album] isEqualToString:@"Röyksopp's Night Out (Live)"], @"album is expected to be \"Röyksopp's Night Out (Live)\" (was: \"%@\")", [tag album]);
    STAssertNil([tag comment], @"comment expected to be nil");
    STAssertTrue([[tag genre] isEqualToString:@"Electronic"], @"genre expected to be \"Electronic\" (was: %@)", [tag genre]);
    NSDate *year = [NSDate dateWithTimeIntervalSince1970:1139212800];
    STAssertEquals([tag year], year, @"year expected to be %@ (was: %@)", year, [tag year]);
    STAssertEquals([[tag trackNumber] unsignedShortValue], (uint16_t)5, @"trackNumber expected to be 5 (was: %@)", [tag trackNumber]);
    STAssertEquals([[tag diskNumber] unsignedShortValue], (uint16_t)1, @"diskNumber expected to be 1 (was: %@)", [tag diskNumber]);
    
    // MP4-specific tags
    STAssertNil([tag encoder], @"encoder expected to be nil");
    STAssertEquals([[tag artwork] size], NSMakeSize(600, 600), @"artwork expected to be 600x600 (was: %u)", [[tag artwork] size]);
    STAssertNil([tag TVShowName], @"TVShowName expected to be nil");
    STAssertNil([tag TVEpisodeID], @"TVShowID expected to be nil");
    STAssertNil([tag TVSeason], @"TVSeason expected to be nil");
    STAssertNil([tag TVEpisode], @"TVEpisode expected to be nil");
    STAssertTrue([[tag albumArtist] isEqualToString:@"Röyksopp"], @"albumArtist is expected to be \"Röyksopp\" (was: \"%@\")", [tag albumArtist]);
    STAssertEquals([[tag totalTracks] unsignedShortValue], (uint16_t)9, @"totalTracks is expected to be 9 (was: %@)", [tag totalTracks]);
    STAssertEquals([[tag totalDisks] unsignedShortValue], (uint16_t)1, @"totalDisks is expected to be 1 (was: %@)", [tag totalDisks]);
    NSString *copyright = @"℗ 2006 Virgin Music a division of EMI Music France , under exclusive license to Wall of Sound for UK / Ireland";
    STAssertTrue([[tag copyright] isEqualToString:copyright], @"copyright is expected to be \"%@\" (was: \"%@\"", copyright, [tag copyright]);
    STAssertNotNil([tag compilation], @"compilation is expected to be set");
    STAssertEquals([[tag compilation] boolValue], NO, @"compilation is expected to be NO (was: %@)", [tag compilation]);
    STAssertNotNil([tag gaplessPlayback], @"gaplessPlayback is expected to be set");
    STAssertEquals([[tag gaplessPlayback] boolValue], NO, @"gaplessPlayback is expected to be NO (was: %@)", [tag gaplessPlayback]);
    STAssertEquals([[tag stik] unsignedIntValue], (uint32_t)1, @"stik is expected to be 1 (was: %@)", [tag stik]);
    STAssertNotNil([tag rating], @"rating is expected to be set");
    STAssertEquals([[tag rating] unsignedIntValue], (uint32_t)0, @"rating is expected to be 0 (was: %@)", [tag rating]);
    NSDate *purchaseDate = [NSDate dateWithTimeIntervalSince1970:1347562655];
    STAssertEquals([tag purchaseDate], purchaseDate, @"purchaseDate expected to be %@ (was: %@)", purchaseDate, [tag purchaseDate]);
    STAssertTrue([[tag purchaserID] isEqualToString:@"nulami@numist.net"], @"purchaserID expected to be nulami@numist.net (was: %@)", [tag purchaserID]);
    STAssertNil([tag composer], @"composer expected to be nil");
    STAssertNil([tag BPM], @"BPM expected to be nil");
    STAssertNil([tag grouping], @"grouping expected to be nil");
    STAssertNil([tag mediaDescription], @"description expected to be nil");
    STAssertNil([tag lyrics], @"lyrics expected to be nil");
    STAssertNil([tag podcast], @"podcast expected to be nil");
}

#if 0

- (void)testStringYear
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/Local-horrible.m4a"];
    if (file == nil) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"Failed to parse atoms from file");
        
    TLMP4Tag *tag = [[TLMP4Tag alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(tag, @"Failed to parse tags from file");
    
    NSString *year = [tag yearAsString];
    STAssertTrue([year isEqualToString:@"2008-09-02T07:00:00Z"], @"tag had unexpected year %@", year);
    STAssertTrue([[tag year] isEqual:[NSNumber numberWithInt:2008]], @"tag reporting incorrect year %@", [tag year]);
}

#endif

@end
