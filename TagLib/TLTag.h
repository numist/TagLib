//
//  TLTag.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "debugger.h"

@interface TLTag : NSObject
@property (copy,nonatomic,readwrite) NSString *title;
@property (copy,nonatomic,readwrite) NSString *artist;
@property (copy,nonatomic,readwrite) NSString *album;
@property (copy,nonatomic,readwrite) NSString *comment;
@property (copy,nonatomic,readwrite) NSString *genre;
@property (copy,nonatomic,readwrite) NSDate *year;
@property (copy,nonatomic,readwrite) NSNumber *track;

// TODO: Initializer(s)

- (BOOL) isEmpty;
+ (void) copy: (TLTag *)source to: (TLTag *) target overwrite: (BOOL)overwrite;
@end
