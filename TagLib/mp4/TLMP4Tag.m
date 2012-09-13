//
//  MP4Tag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "debugger.h"
#import "NSData+Endian.h"
#import "TLID3v1Genres.h"
#import "TLMP4AtomInfo.h"
#import "TLMP4Tag_Private.h"
#import "TLMP4FileParser.h"
#import "NSMutableArray+StackOps.h"
#import "TLMP4Atom.h"

@interface TLMP4Tag ()
@end

@implementation TLMP4Tag
@synthesize path = _path;
@synthesize atoms = _atoms;

- (TLMP4Tag *)initWithPath:(NSString *)pathArg;
{
    self = [super init];
    if (!self || !pathArg) return nil;

    _path = pathArg;

    [[[TLMP4FileParser alloc] initTag:self] main];

    return self;
}

- (id)init;
{
    return [self initWithPath:nil];
}

#pragma mark -
#pragma mark File access methods
@synthesize handle = _handle;
@synthesize handleRefCount = _handleRefCount;
- (NSFileHandle *)beginReadingFile;
{
    @synchronized(self) {
        if (!self.handle) {
            TLAssert(!self.handleRefCount);
            self.handle = [NSFileHandle fileHandleForReadingAtPath:self.path];
        }
        if (!self.handle) {
            TLAssert(!self.handleRefCount);
            return nil;
        }
        self.handleRefCount++;
    }

    return self.handle;
}

- (id)endReadingFile;
{
    @synchronized(self) {
        if (!--self.handleRefCount) {
            self.handle = nil;
        }
    }
    return nil;
}

#pragma mark -
- (TLMP4Atom *)findAtom:(NSArray *)searchPath;
{
    if (![searchPath count]) {
        return nil;
    }
    
    if (![self.atoms count]) {
        // TODO: bootstrap all root atoms
    }
    
    NSMutableArray *workingPath = [NSMutableArray arrayWithArray:searchPath];

    TLMP4Atom *match = [self.atoms objectForKey:[workingPath popFirstObject]];
    
    while ([workingPath count]) {
        match = [match getChild:[workingPath popFirstObject]];
    }
    
    return match;
}

#pragma mark -

// TODO: rewrite
- (NSString *)description
{
    return @"";
}

@end
