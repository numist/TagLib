//
//  LocalTests.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//

#import "debugger.h"
#import "LocalTests.h"
#import "TLMP4Tag.h"

@interface LocalTests ()
+ (TLMP4Tag *)blockingMP4TagWithPath:(NSString *)path;
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

+ (TLMP4Tag *)blockingMP4TagWithPath:(NSString *)path;
{
    TLMP4Tag *tag = [[TLMP4Tag alloc] initWithPath:path];
    
    // Basic block until tags have been parsed
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    } while (![tag isReady]);
    
    return tag;
}

- (void)testBasicHorribleTagParsing
{
    NSString *file = @"TagLibTests/data/Local-horrible.m4a";
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Tag *tag = [LocalTests blockingMP4TagWithPath:file];
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
    
    TLMP4Tag *tag = [LocalTests blockingMP4TagWithPath:file];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertFalse([tag isEmpty], @"%@ contains no tags?", file);
}

- (void)testBasicPoorLenoTagParsing
{
    NSString *file = @"TagLibTests/data/Local-poorleno.m4a";

    if(![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Tag *tag = [LocalTests blockingMP4TagWithPath:file];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertFalse([tag isEmpty], @"%@ contains no tags?", file);
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
