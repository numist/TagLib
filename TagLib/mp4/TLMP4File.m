//
//  TLMP4File.m
//  TagLib
//
//  Created by Scott Perry on 8/13/11.
//  Copyright 2011 Scott Perry. All rights reserved.
//

#import "TLMP4File.h"

@interface TLMP4File () {
@private
    NSURL *filePath;
}
@end

@implementation TLMP4File
@synthesize atoms;
@synthesize properties;
@synthesize tag;

- (id)init
{
    [NSException raise:@"UnimplementedException" format:@"%@",
     @"Selector is not implemented in this class"];
    return nil;
}

- (TLMP4File *) initWithPath:(NSString *)path
{
    return [self initWithPath:path readProperties:YES];
}

- (TLMP4File *) initWithURL:(NSURL *)url
{
    return [self initWithURL:url readProperties:YES];
}

- (TLMP4File *) initWithPath:(NSString *)path readProperties:(BOOL)props
{
    return [self initWithURL:[NSURL fileURLWithPath:path] readProperties:props];
}

- (TLMP4File *) initWithURL:(NSURL *)url readProperties:(BOOL)props
{
    self = [super init];
    if (self) {
        self->filePath = url;
        NSFileHandle * file = [NSFileHandle fileHandleForReadingFromURL:url error:NULL];
        if (!file) {
            return nil;
        }
        self->atoms = [(TLMP4Atoms *)[TLMP4Atoms alloc] initWithFile:file];
        if (!self->atoms) {
            return nil;
        }
        self->tag = [(TLMP4Tag *)[TLMP4Tag alloc] initWithFile:file atoms:self->atoms];
        if (!self->tag) {
            return nil;
        }
        if (props) {
            self->properties = [(TLMP4Properties *)[TLMP4Properties alloc] initWithFile:file atoms:self->atoms];
            if (!self->properties) {
                return nil;
            }
        } else {
            self->properties = nil;
        }
    }
    
    return self;

}

- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"TLMP4File {\n"];
    if (self->properties) {
        [result appendFormat:@"properties: %@\n", self->properties];
    } else {
        [result appendString:@"(properties not read)\n"];
    }
    [result appendFormat:@"atoms: %@\n", self->atoms];
    [result appendFormat:@"tags: %@\n}", self->tag];
    return result;

}

@end
