//
//  TLErrorWrapper.h
//  TagLib
//
//  Created by Scott Perry on 09/18/12.
//
//

#import <Foundation/Foundation.h>

#define kTLWrappedError ((void *)215776529)

#define pendingError ([(__bridge TLErrorWrapper *)dispatch_get_specific(kTLWrappedError) error])

#define setError(code, reason) ([(__bridge TLErrorWrapper *)dispatch_get_specific(kTLWrappedError) setError:newErrorWithDetail((code), (reason))])

#define newErrorWithDetail(code, reason) ([TLErrorWrapper errorWithCode:(code) detail:(reason) file:__FILE__ line:__LINE__])
#define newErrorWithPath(code, thePath) ([TLErrorWrapper errorWithCode:(code) path:(thePath) file:__FILE__ line:__LINE__])

extern NSString * const kTLErrorDomain;
enum {
    kTLErrorFileNotFound = 1,
    kTLErrorCorruptFile,
    kTLErrorFileNotRecognized,
    kTLErrorUnimplemented
};

@interface TLErrorWrapper : NSObject
@property (nonatomic, strong) NSError *error;

+ (NSError *)errorWithCode:(NSUInteger)code path:(NSString *)path detail:(NSString *)detail file:(char *)file line:(unsigned int)line;
+ (NSError *)errorWithCode:(NSUInteger)code path:(NSString *)path file:(char *)file line:(unsigned)line;
+ (NSError *)errorWithCode:(NSUInteger)code detail:(NSString *)detail file:(char *)file line:(unsigned)line;
@end
