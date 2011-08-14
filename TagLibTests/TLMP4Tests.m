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
#import "TLMP4Properties.h"

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

- (void)testFindAll
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Atom *moov = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", nil]];
    STAssertNotNil(moov, @"%@", @"Atom moov not found");
    
    STAssertTrue([[moov findAllWithName:@"tvsh" recursive:YES] count] == 0, @"%@", @"shouldn't have found nested atom tvsh");
    STAssertTrue([[moov findAllWithName:@"stsz"] count] == 0, @"%@", @"shouldn't have found nested atom stsz");
    STAssertTrue([[moov findAllWithName:@"stsz" recursive:YES] count] == 1, @"%@", @"should have found nested atom stsz");
}

- (void)testBasicTagParsing
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Tag *tag = [(TLMP4Tag *)[TLMP4Tag alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([tag artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [tag artist]);
}

- (void)testBasicProperties
{
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:@"TagLibTests/data/has-tags.m4a"];
    STAssertNotNil(file, @"%@", @"Could not open file for testing");
    
    TLMP4Atoms *atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
    STAssertNotNil(atoms, @"%@", @"Failed to parse atoms from file");
    
    TLMP4Properties *properties = [(TLMP4Properties *)[TLMP4Properties alloc] initWithFile:file atoms:atoms];
    STAssertNotNil(properties, @"%@", @"Failed to parse properties from file");
    
    STAssertTrue([properties length] == 3, @"test file has unexpected length %u", [properties length]);
    STAssertTrue([properties bitrate] == 3, @"test file has unexpected bitrate %u", [properties bitrate]);
    STAssertTrue([properties sampleRate] == 44100, @"test file has unexpected sample rate %u", [properties sampleRate]);
    STAssertTrue([properties channels] == 2, @"test file has unexpected channels %u", [properties channels]);
    STAssertTrue([properties bitsPerSample] == 16, @"test file has unexpected bitsPerSample %u", [properties bitsPerSample]);
}

@end
