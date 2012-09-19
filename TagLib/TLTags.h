//
//  TLTags.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import <Foundation/Foundation.h>

#import "debugger.h"

@class TLMP4Tags;

@interface TLTags : NSObject
@property (copy,nonatomic,readwrite) NSString *title;
@property (copy,nonatomic,readwrite) NSString *artist;
@property (copy,nonatomic,readwrite) NSString *album;
@property (copy,nonatomic,readwrite) NSString *comment;
@property (copy,nonatomic,readwrite) NSString *genre;
@property (copy,nonatomic,readwrite) NSDate *year;
@property (nonatomic,readwrite) NSNumber *trackNumber;
@property (nonatomic,readwrite) NSNumber *diskNumber;

+ (void)tagsForPath:(NSString *)path do:(void(^)(TLTags *, NSError *))completionBlock;

- (TLMP4Tags *)MP4Tags;

- (BOOL) isEmpty;
@end
