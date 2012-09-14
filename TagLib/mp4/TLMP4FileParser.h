//
//  TLMP4FileParser.h
//  TagLib
//
//  Created by Scott Perry on 09/11/12.
//
//

#import <Foundation/Foundation.h>

@class TLMP4Tags;

@interface TLMP4FileParser : NSOperation
- (id)initTag:(TLMP4Tags *)tag;
@end
