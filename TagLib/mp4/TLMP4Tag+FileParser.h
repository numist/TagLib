//
//  TLMP4Tag+FileParser.h
//  TagLib
//
//  Created by Scott Perry on 8/10/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLMP4Tag.h"

@interface TLMP4Tag (FileParser)

- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom;
- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)expectedFlags;
- (NSArray *) parseDataForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags freeForm: (BOOL)freeForm;
- (void) parseTextForAtom: (TLMP4Atom *)atom;
- (void) parseTextForAtom: (TLMP4Atom *)atom expectedFlags: (int32_t)flags;
- (void) parseFreeFormForAtom: (TLMP4Atom *)atom;
- (void) parseIntForAtom: (TLMP4Atom *)atom;
- (void) parseGnreForAtom: (TLMP4Atom *)atom;
- (void) parseIntPairForAtom: (TLMP4Atom *)atom;
- (void) parseBoolForAtom: (TLMP4Atom *)atom;
- (void) parseCovrForAtom: (TLMP4Atom *)atom;

@end
