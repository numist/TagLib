//
//  TagLibTests.m
//  TagLibTests
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TagLibTests.h"
#import "TLMP4Atoms.h"

@implementation TagLibTests

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

- (void)testBasicAtomParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    if (atoms) {
        TLLog(@"%@", [atoms description]);
    }
}

- (void)testBadFile
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/empty.aiff"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNil(atoms, @"%@", @"Found atoms in a non-MPEG-4 file");
    if (atoms) {
        TLLog(@"%@", [atoms description]);
    }
}

@end
