//
//  TLMP4Tags+Parser.h
//  TagLib
//
//  Created by Scott Perry on 09/16/12.
//
//

#import "TLMP4Tags_Private.h"

@interface TLMP4Tags (Parser)
- (void)loadWithError:(NSError **)error;
- (void)getPropertiesWithError:(NSError **)error;
@end
