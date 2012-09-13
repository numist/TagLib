//
//  TLMP4Tag.h
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import <Foundation/Foundation.h>

#import "TLMP4Atom.h"
#import "TLTag.h"

@interface TLMP4Tag : TLTag
@property (copy, nonatomic, readonly) NSString *path;
@property (getter=isReady, assign, nonatomic, readonly) BOOL ready;

// Public class methods
#include "TLMP4Tag_Common.h"

@end
