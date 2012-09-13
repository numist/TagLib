//
//  LocalTests.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "debugger.h"
#import "LocalTests.h"
#import "TLMP4Tag.h"

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

#if 0

- (void)testHorribleTagParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/Local-horrible.m4a"];
    if (file == nil) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Tag *tag = [(TLMP4Tag *)[TLMP4Tag alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    
    //TLLog(@"%@", tag);
}

- (void)testFireflyTagParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/Local-firefly.m4v"];
    if (file == nil) {
        TLLog(@"%@", @"sorry, you don't have the file required to run this test");
        return;
    }
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Tag *tag = [(TLMP4Tag *)[TLMP4Tag alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");

    //TLLog(@"%@", tag);
}

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
