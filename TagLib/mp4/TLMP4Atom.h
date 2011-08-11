//
//  MP4Atom.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import <Foundation/Foundation.h>

@interface TLMP4Atom : NSObject {
    unsigned long long offset;
    unsigned long long length;
    NSString *name;
    NSMutableDictionary *children;
}
@property(nonatomic, readonly) unsigned long long offset;
@property(nonatomic, readonly) unsigned long long length;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSMutableDictionary *children;

- (NSDictionary *) children;
- (TLMP4Atom *) initWithFile: (NSFileHandle *)file;
- (BOOL) getAtoms: (NSMutableArray *)atoms withPath: (NSMutableArray *)path;
- (NSArray *) findAllWithName: (NSString *)name;
- (NSArray *) findAllWithName: (NSString *)name recursive: (BOOL)recursive;
- (NSString *) descriptionWithIndent:(NSString *)indent;
@end
