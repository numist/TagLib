//
//  TLMappedDataCache.h
//  TagLib
//
//  Created by Scott Perry on 09/14/12.
//
//

#import <Foundation/Foundation.h>

@interface TLMappedDataCache : NSObject
+ (NSData *)mappedDataForPath:(NSString *)path;
@end
