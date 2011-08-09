//
//  TLTag.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLTag : NSObject

- (BOOL) isEmpty;
+ (void) copy: (TLTag *)source to: (TLTag *) target overwrite: (BOOL)overwrite;

- (NSString *) title;
- (NSString *) artist;
- (NSString *) album;
- (NSString *) comment;
- (NSString *) genre;
- (NSNumber *) year;
- (NSNumber *) track;

- (void) setTitle: (NSString *) title;
- (void) setArtist: (NSString *) artist;
- (void) setAlbum: (NSString *) album;
- (void) setComment: (NSString *) comment;
- (void) setGenre: (NSString *) genre;
- (void) setYear: (NSNumber *) year;
- (void) setTrack: (NSNumber *) track;

@end
