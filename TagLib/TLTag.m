//
//  TLTag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLTag.h"

@implementation TLTag
@synthesize title = _title;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize comment = _comment;
@synthesize genre = _genre;
@synthesize year = _year;
@synthesize trackNumber = _trackNumber;
@synthesize diskNumber = _diskNumber;

- (id)initWithPath:(NSString *)path;
{
    self = [super init];
    if (!self || !path) return nil;
    return self;
}

- (id)init
{
    return [self initWithPath:nil];
}

- (BOOL) isEmpty
{
    return ([self title] == nil &&
        [self artist] == nil &&
        [self album] == nil &&
        [self comment] == nil &&
        [self genre] == nil &&
        [self year] == nil &&
        [self trackNumber] == 0);
}

#pragma mark - NSOperationQueue management methods

static NSOperationQueue *currentQueue = nil;

+ (void)setLoadingQueue:(NSOperationQueue *)queue;
{
    currentQueue = queue;
}

+ (NSOperationQueue *)loadingQueue;
{
    if (!currentQueue) {
        currentQueue = [[NSOperationQueue alloc] init];
        // Disks don't really parallelize well
        [currentQueue setMaxConcurrentOperationCount:1];
    }
    return currentQueue;
}

@end
