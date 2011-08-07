//
//  TLTag.h
//  TagLib
//
//  Created by Scott Perry on 8/7/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//
//  A simple, generic interface to common audio meta data fields

#import <Foundation/Foundation.h>

@protocol TLTag <NSObject>
-(NSString) getTitle;
-(NSString) getArtist;
-(NSString) getAlbum;
-(NSString) getComment;
-(NSString) getGenre;
-(NSNumber) getYear;
-(NSNumber) getTrack;

-(void) setTitle: (NSString) title;
-(void) setArtist: (NSString) artist;
-(void) setAlbum: (NSString) album;
-(void) setComment: (NSString) comment;
-(void) setGenre: (NSString) genre;
-(void) setYear: (NSNumber) year;
-(void) setTrack: (NSNumber) track;

-(BOOL) isEmpty;
@end
