//
//  TLTags.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import "TLTags.h"

#import "TLMP4Tags_Private.h"

NSString *TLErrorDomain = @"net.numist.taglib";

@implementation TLTags
@synthesize title = _title;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize comment = _comment;
@synthesize genre = _genre;
@synthesize year = _year;
@synthesize trackNumber = _trackNumber;
@synthesize diskNumber = _diskNumber;

- (id)init;
{
    @throw [NSException exceptionWithName: @"TLTagInitializerException"
                                  reason: @"TLTag objects are created using +tagsForPath:do:"
                                userInfo: nil];
    return nil;
}

+ (void)tagsForPath:(NSString *)path do:(void(^)(TLTags *, NSError *))completionBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        TLTags *result;
        NSError *error;
        NSDictionary *userInfo = @{@"path":path};

        // Does the file even exist?
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            error = [NSError errorWithDomain:TLErrorDomain code:kTagLibFileNotFound userInfo:userInfo];
            return;
        }

        // Maybe it's an MP4?
        result = [[TLMP4Tags alloc] initWithPath:path error:&error];
        if (result) {
            completionBlock(result, nil);
            return;
        }

        // Well, anyone else have any ideas?
        error = [NSError errorWithDomain:TLErrorDomain code:kTagLibFileNotFound userInfo:userInfo];
        completionBlock(nil, error);
        return;
    });
}

- (TLMP4Tags *)MP4Tags;
{
    if (![self isKindOfClass:[TLMP4Tags class]]) {
        return nil;
    }
    return (TLMP4Tags *)self;
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

- (NSString *)description;
{
    if ([self artist] && [self album] && [self title]) {
        return [NSString stringWithFormat:@"%@ from %@ by %@", [self title], [self album], [self artist]];
    } else {
        return [NSString stringWithFormat:@"Tags object for a file with very few (if any) tags"];
    }
}

@end
