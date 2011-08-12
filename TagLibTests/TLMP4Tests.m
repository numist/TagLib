//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLMP4Tests.h"
#import "TLMP4Atoms.h"
#import "TLMP4Tag.h"

@implementation TLMP4Tests

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

/*
 * XXX: At the moment, this library is only expected to work on little-endian machines.
 */
- (void)testMachineEndianness
{
    STAssertTrue(NSHostByteOrder() == NS_LittleEndian, @"%@", @"TagLib MPEG-4 support does not support big-endian machines right now");
}

- (void)testBasicAtomParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
}

- (void)testBadFile
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/empty.aiff"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    if (atoms) {
        TLLog(@"%@", [atoms description]);
    }
    STAssertNil(atoms, @"%@", @"Found atoms in a non-MPEG-4 file");
}

- (void)testFindIlst
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");

    TLMP4Atom *ilst = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    STAssertNotNil(ilst, @"%@", @"Atom moov.udta.meta.ilst not found");
}

- (void)testFindIlstPath
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    NSArray *result = [atoms getAtomsWithPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    STAssertNotNil(result, @"%@", @"Atom moov.udta.meta.ilst not found");
    STAssertTrue([result count] == 4, @"Returned array has %u elements", [result count]);
    STAssertEqualObjects([[result objectAtIndex:0] name], @"moov", @"Returned array has %@ as the first element", [[result objectAtIndex:0] name]);
    STAssertEqualObjects([[result objectAtIndex:1] name], @"udta", @"Returned array has %@ as the second element", [[result objectAtIndex:1] name]);
    STAssertEqualObjects([[result objectAtIndex:2] name], @"meta", @"Returned array has %@ as the third element", [[result objectAtIndex:2] name]);
    STAssertEqualObjects([[result objectAtIndex:3] name], @"ilst", @"Returned array has %@ as the fourth element", [[result objectAtIndex:3] name]);
}

- (void)testBasicTagParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Tag *tag = [[TLMP4Tag alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([tag artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [tag artist]);
}

@end
