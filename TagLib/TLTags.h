//
//  TLTags.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import <Foundation/Foundation.h>

#import "debugger.h"

@interface TLTags : NSObject
@property (copy,nonatomic,readwrite) NSString *title;
@property (copy,nonatomic,readwrite) NSString *artist;
@property (copy,nonatomic,readwrite) NSString *album;
@property (copy,nonatomic,readwrite) NSString *comment;
@property (copy,nonatomic,readwrite) NSString *genre;
@property (copy,nonatomic,readwrite) NSDate *year;
@property (nonatomic,readwrite) NSNumber *trackNumber;
@property (nonatomic,readwrite) NSNumber *diskNumber;

- (id)initWithPath:(NSString *)path;

- (BOOL) isEmpty;

+ (void)setLoadingQueue:(NSOperationQueue *)queue;
+ (NSOperationQueue *)loadingQueue;
@end
