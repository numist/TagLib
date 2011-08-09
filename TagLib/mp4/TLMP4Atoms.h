//
//  MP4Atoms.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>
#import "TLMP4Atom.h"

@interface TLMP4Atoms : NSObject {
    NSMutableDictionary *atoms;
}
@property(nonatomic, readonly) NSMutableDictionary *atoms;

- (NSDictionary *) atoms;
- (TLMP4Atoms *) initWithFile: (NSFileHandle *)file;
- (TLMP4Atom *) findAtomAtPath: (NSMutableArray *)path;
- (NSArray *) getAtomsWithPath: (NSMutableArray *)path;
@end
