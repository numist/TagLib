//
//  ID3v1Genres.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//  This file is based on LGPL/MPL code written by Scott Wheeler.
//

#import <Foundation/Foundation.h>

@interface ID3v1Genres : NSObject

+ (NSArray *) genreList;
+ (NSDictionary *) genreMap;
+ (NSString *) genreForIndex: (uint16) i;
+ (uint16) indexForGenre: (NSString *)genre;

@end
