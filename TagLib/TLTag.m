//
//  TLTag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLTag.h"

@implementation TLTag
@synthesize title, artist, album, comment, genre, year, track;

- (id)init
{
    return [super init];
}

- (BOOL) isEmpty
{
    return ([self title] == nil &&
        [self artist] == nil &&
        [self album] == nil &&
        [self comment] == nil &&
        [self genre] == nil &&
        [self year] == nil &&
        [self track] == nil);
}

// TODO: There's got to be a better way.
+ (void) copy: (TLTag *)source to: (TLTag *) target overwrite: (BOOL)overwrite
{
    if (overwrite) {
        [target setTitle:[source title]];
        [target setArtist:[source artist]];
        [target setAlbum:[source album]];
        [target setComment:[source comment]];
        [target setGenre:[source genre]];
        [target setYear:[source year]];
        [target setTrack:[source track]];
    } else {
        if ([target title] == nil) {
            [target setTitle:[source title]];
        }
        if ([target artist] == nil) {
            [target setArtist:[source artist]];
        }
        if ([target album] == nil) {
            [target setAlbum:[source album]];
        }
        if ([target comment] == nil) {
            [target setComment:[source comment]];
        }
        if ([target genre] == nil) {
            [target setGenre:[source genre]];
        }
        if ([target year] == nil) {
            [target setYear:[source year]];
        }
        if ([target track] == nil) {
            [target setTrack:[source track]];
        }
    }
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
