//
//  TLMP4File.h
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLMP4Properties.h"
#import "TLMP4Atoms.h"
#import "TLMP4Tag.h"

@interface TLMP4File : NSObject {
    @private
    TLMP4Atoms *atoms;
    TLMP4Properties *properties;
    TLMP4Tag *tag;
}
@property(nonatomic, readonly) TLMP4Atoms *atoms;
@property(nonatomic, readonly) TLMP4Properties *properties;
@property(nonatomic, readonly) TLMP4Tag *tag;

- (TLMP4File *) initWithPath:(NSString *)path;
- (TLMP4File *) initWithURL:(NSURL *)url;
- (TLMP4File *) initWithPath:(NSString *)path readProperties:(BOOL)props;
- (TLMP4File *) initWithURL:(NSURL *)url readProperties:(BOOL)props;

@end
