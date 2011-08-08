//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MP4Atom : NSObject {
    @protected
        long offset;
        long length;
        NSString *selfName;
        NSMutableDictionary *children;

    @private
        NSMutableArray *containers;
}

- (MP4Atom *) initWithFile: (NSFileHandle *)file;
- (MP4Atom*) find: (NSArray *)path;
- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path;
- (NSArray *) findAll: (NSString *)name;
- (NSArray *) findAll: (NSString *)name recursive: (BOOL)recursive;

@end
