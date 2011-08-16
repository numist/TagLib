//
//  TLMP4Tag+FileParser.h
//  TagLib
//
//  Created by Scott Perry on 8/10/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "TLMP4Tag.h"

@interface TLMP4Tag (FileParser)
- (void) parseFile:(NSFileHandle *)file withAtoms:(TLMP4Atoms *)atoms;
@end
