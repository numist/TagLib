//
//  TLMP4Atoms.m
//  TagLib
//
//  Created by Scott Perry on 8/11/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "debugger.h"
#import "TLMP4File.h"
#import "TLMP4Tests.h"

@interface TLMP4Tests () {
@private
    TLMP4File *has_tags;
}
@end

@implementation TLMP4Tests

- (void)setUp
{
    [super setUp];
    
    self->has_tags = [(TLMP4File *)[TLMP4File alloc] initWithPath:@"TagLibTests/data/has-tags.m4a"];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBasicAtomParsing
{
    STAssertNotNil(self->has_tags, @"%@", @"failed to parse atoms from file");
}

- (void)testBadFile
{
    TLMP4File *mp4file = [(TLMP4File *)[TLMP4File alloc] initWithPath:@"TagLibTests/data/empty.aiff"];
    if (mp4file) {
        TLLog(@"%@", [mp4file description]);
    }
    STAssertNil(mp4file, @"%@", @"Found atoms in a non-MPEG-4 file");
}

- (void)testFindIlst
{
    TLMP4Atoms *atoms = [self->has_tags atoms];
    TLMP4Atom *ilst = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", @"udta", @"meta", @"ilst", nil]];
    STAssertNotNil(ilst, @"%@", @"Atom moov.udta.meta.ilst not found");
}

- (void)testFindIlstPath
{
    TLMP4Atoms *atoms = [self->has_tags atoms];
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
    TLMP4Atoms *atoms = [self->has_tags atoms];
    TLMP4Atom *moov = [atoms findAtomAtPath:[NSArray arrayWithObjects:@"moov", nil]];
    STAssertNotNil(moov, @"%@", @"Atom moov not found");
    
    STAssertTrue([[moov findAllWithName:@"tvsh" recursive:YES] count] == 0, @"%@", @"shouldn't have found nested atom tvsh");
    STAssertTrue([[moov findAllWithName:@"stsz"] count] == 0, @"%@", @"shouldn't have found nested atom stsz");
    STAssertTrue([[moov findAllWithName:@"stsz" recursive:YES] count] == 1, @"%@", @"should have found nested atom stsz");
}

- (void)testBasicTagParsing
{
    TLMP4Tag *tag = [self->has_tags tag];
    STAssertNotNil(tag, @"%@", @"Failed to parse tags from file");
    STAssertEqualObjects([tag artist], @"Test Artist", @"error reading artist, got %@ instead of \"Test Artist\"", [tag artist]);
}

- (void)testNoReadProperties
{
    TLMP4File *file = [(TLMP4File *)[TLMP4File alloc] initWithPath:@"TagLibTests/data/has-tags.m4a" readProperties:NO];
    STAssertNil([file properties], @"%@", @"shouldn't have read properties when told");
}

- (void)testBasicProperties
{    
    TLMP4Properties *properties = [self->has_tags properties];
    
    STAssertTrue([properties length] == 3, @"test file has unexpected length %u", [properties length]);
    STAssertTrue([properties bitrate] == 3, @"test file has unexpected bitrate %u", [properties bitrate]);
    STAssertTrue([properties sampleRate] == 44100, @"test file has unexpected sample rate %u", [properties sampleRate]);
    STAssertTrue([properties channels] == 2, @"test file has unexpected channels %u", [properties channels]);
    STAssertTrue([properties bitsPerSample] == 16, @"test file has unexpected bitsPerSample %u", [properties bitsPerSample]);
}

@end
