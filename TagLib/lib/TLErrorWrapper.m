//
//  TLErrorWrapper.m
//  TagLib
//
//  Created by Scott Perry on 09/18/12.
//
//

#import "TLErrorWrapper.h"

#import "debugger.h"

NSString * const kTLErrorDomain = @"net.numist.taglib";

@interface TLErrorWrapper () {
    NSUInteger theCount;
}
@end

@implementation TLErrorWrapper
@synthesize error = _error;

- (id)init;
{
    self = [super init];
    if (!self) return nil;
    
    theCount = 0;
    
    return self;
}

- (void)setError:(NSError *)error;
{
    theCount++;
    
    if (theCount > 1) {
        DebugBreak();
    }
    TLAssert(theCount == 1);
    
    _error = error;
}

+ (NSError *)errorWithCode:(NSUInteger)code path:(NSString *)path detail:(NSString *)detail file:(char *)file line:(unsigned int)line;
{
    NSString *errorString;
    switch (code) {
        case kTLErrorFileNotFound:
            errorString = @"File not found";
            break;
        case kTLErrorCorruptFile:
            errorString = @"File is corrupt";
            break;
        case kTLErrorFileNotRecognized:
            errorString = @"File is corrupt or of unknown type";
            break;
        default:
            errorString = [NSString stringWithFormat:@"An unknown error of type %lu has occurred", code];
            break;
    }
    
    NSMutableDictionary *dict = [@{
                                 @"file" : [NSString stringWithCString:file encoding:NSUTF8StringEncoding],
                                 @"line" : [NSNumber numberWithUnsignedInt:line],
                                 NSLocalizedDescriptionKey : errorString
                                 } mutableCopy];
    if (path) {
        [dict setObject:path forKey:@"path"];
    }
    if (detail) {
        [dict setObject:detail forKey:@"detail"];
    }
    return [NSError errorWithDomain:kTLErrorDomain code:code userInfo:dict];
}

+ (NSError *)errorWithCode:(NSUInteger)code path:(NSString *)path file:(char *)file line:(unsigned)line;
{
    return [TLErrorWrapper errorWithCode:code path:path detail:nil file:file line:line];
}

+ (NSError *)errorWithCode:(NSUInteger)code detail:(NSString *)detail file:(char *)file line:(unsigned)line;
{
    return [TLErrorWrapper errorWithCode:code path:nil detail:detail file:file line:line];
}

@end
