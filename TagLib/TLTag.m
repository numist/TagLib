//
//  TLTag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLTag.h"

@implementation TLTag

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
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

- (NSString *) title
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSString *) artist
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSString *) album
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSString *) comment
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSString *) genre
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSNumber *) year
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (NSNumber *) track
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (void) setTitle: (NSString *) title
{
    #pragma unused(title)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setArtist: (NSString *) artist
{
    #pragma unused(artist)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setAlbum: (NSString *) album
{
    #pragma unused(album)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setComment: (NSString *) comment
{
    #pragma unused(comment)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setGenre: (NSString *) genre
{
    #pragma unused(genre)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setYear: (NSNumber *) year
{
    #pragma unused(year)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

- (void) setTrack: (NSNumber *) track
{
    #pragma unused(track)
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
}

@end
