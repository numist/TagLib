//
//  TLMP4Tag_Methods.h
//  TagLib
//
//  Created by Scott Perry on 09/12/12.
//  This file is intended to be #included within an @interface block for TLMP4Tag
//

- (id)initWithPath:(NSString *)path;

- (TLMP4Atom *)findAtom:(NSArray *)path;
- (id)getILSTData:(TLMP4AtomInfo *)atomInfo;

#pragma mark -
#pragma mark Extra item types on top of TLTag's standard getters/setters.
// - (NSString *) albumArtist;
// - (void) setAlbumArtist: (NSString *)albumArtist;
// - (NSNumber *) totalTracks;
// - (void) setTotalTracks: (NSNumber *)totalTracks;
// etc.
