//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MP4Atom : NSObject

- (MP4Atom *) initWithFile: (NSFileHandle *)file;
- (MP4Atom*) findAtomAtPath: (NSArray *)path;
- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path;
- (NSArray *) findAllWithName: (NSString *)name;
- (NSArray *) findAllWithName: (NSString *)name recursive: (BOOL)recursive;

@end
