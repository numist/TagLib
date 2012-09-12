//
//  TLMP4FileParser.h
//  TagLib
//
//  Created by Scott Perry on 09/11/12.
//
//

#import <Foundation/Foundation.h>

#import "TLMP4Tag_Private.h"

@interface TLMP4FileParser : NSOperation
- (id)initTag:(TLMP4Tag *)tag;
@end
