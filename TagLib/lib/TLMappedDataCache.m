//
//  TLMappedDataCache.m
//  TagLib
//
//  Created by Scott Perry on 09/14/12.
//
//

#import "TLMappedDataCache.h"

static NSCache *cache;

@implementation TLMappedDataCache

- (id)init;
{
    return nil;
}

+ (void)initialize;
{
    cache = [[NSCache alloc] init];
}

+ (NSData *)mappedDataForPath:(NSString *)path;
{
    if ([cache objectForKey:path]) {
        return [cache objectForKey:path];
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:&error];
    
    if (error || !data) {
        return nil;
    }
    
    NSUInteger cost = [data length];
    /* Note: This is not strictly true. 
     * The mapped data's impact on memory isn't really measurable (and changes as the object is used), so record the worst case as the cost.
     * Because of this, there is no totalCostLimit set on the cache—it will empty when it needs to.
     */
    [cache setObject:data forKey:path cost:cost];
    
    return data;
}

@end
