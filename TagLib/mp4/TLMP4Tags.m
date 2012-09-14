//
//  MP4Tag.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//  This file is based on LGPL/MPL code written by Lukáš Lalinský.
//

#import "debugger.h"
#import "NSData+Endian.h"
#import "TLID3v1Genres.h"
#import "TLMP4AtomInfo.h"
#import "TLMP4Tags_Private.h"
#import "TLMP4FileParser.h"
#import "NSMutableArray+StackOps.h"
#import "TLMP4Atom.h"

@interface TLMP4Tags ()
@end

@implementation TLMP4Tags
@synthesize path = _path;
@synthesize atoms = _atoms;
@synthesize ready = _ready;
@synthesize encoder = _encoder;
@synthesize artwork = _artwork;
@synthesize TVShowName = _TVShowName;
@synthesize TVEpisodeID = _TVEpisodeID;
@synthesize TVSeason = _TVSeason;
@synthesize TVEpisode = _TVEpisode;
@synthesize albumArtist = _albumArtist;
@synthesize totalTracks = _totalTracks;
@synthesize totalDisks = _totalDisks;
@synthesize copyright = _copyright;
@synthesize compilation = _compilation;
@synthesize gaplessPlayback = _gaplessPlayback;
@synthesize stik = _stik;
@synthesize rating = _rating;
@synthesize purchaseDate = _purchaseDate;
@synthesize purchaserID = _purchaserID;
@synthesize composer = _composer;
@synthesize BPM = _BPM;
@synthesize grouping = _grouping;
@synthesize mediaDescription = _description;
@synthesize lyrics = _lyrics;
@synthesize podcast = _podcast;

// Properties
@synthesize channels = _channels;
@synthesize bitsPerSample = _bitsPerSample;
@synthesize sampleRate = _sampleRate;
@synthesize bitRate = _bitRate;

#pragma mark Initializers

- (TLMP4Tags *)initWithPath:(NSString *)pathArg;
{
    self = [super initWithPath:pathArg];
    if (!self || !pathArg) return nil;

    _path = pathArg;
    _ready = NO;

    // Begin loading common tags in the background
    [[TLTags loadingQueue] addOperation:[[TLMP4FileParser alloc] initTag:self]];

    return self;
}

- (id)init;
{
    return [self initWithPath:nil];
}

#pragma mark -
#pragma mark File access methods
@synthesize handle = _handle;
@synthesize handleRefCount = _handleRefCount;
- (NSFileHandle *)beginReadingFile;
{
//    @synchronized(self) {
//        if (!self.handle) {
//            TLAssert(!self.handleRefCount);
//            self.handle = [NSFileHandle fileHandleForReadingAtPath:self.path];
//        }
//        if (!self.handle) {
//            TLAssert(!self.handleRefCount);
//            return nil;
//        }
//        self.handleRefCount++;
//    }
//
//    return self.handle;
    return [NSFileHandle fileHandleForReadingAtPath:self.path];
}

- (id)endReadingFile;
{
//    @synchronized(self) {
//        if (!--self.handleRefCount) {
//            self.handle = nil;
//        }
//    }
    return nil;
}

#pragma mark - Atom methods

- (NSDictionary *)atoms;
{
    if (!_atoms) {
        NSMutableDictionary *atoms = [[NSMutableDictionary alloc] init];
        
        NSFileHandle *handle = [self beginReadingFile];
        unsigned long long end = [handle seekToEndOfFile];
        unsigned long long offset = 0;
        
        while (offset + 8 < end) {
            TLMP4Atom *atom = [[TLMP4Atom alloc] initWithOffset:offset parent:self];
            // NOTE: in the C++ impl, returns incomplete atom set
            if (!atom) {
                _atoms = [[NSDictionary alloc] init];
                return nil;
            }
            [atoms setValue:atom forKey:[atom name]];
            offset += [atom length];
        }
        
        handle = [self endReadingFile];
        _atoms = atoms;
    }
    
    return _atoms;
}

- (TLMP4Atom *)findAtom:(NSArray *)searchPath;
{
    if (![searchPath count]) {
        return nil;
    }
    
    NSMutableArray *workingPath = [NSMutableArray arrayWithArray:searchPath];

    TLMP4Atom *match = [self.atoms objectForKey:[workingPath popFirstObject]];
    
    while ([workingPath count]) {
        match = [match getChild:[workingPath popFirstObject]];
    }
    
    return match;
}

- (NSArray *)getAtom:(NSString *)name recursive:(BOOL)recursive;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSString *n in self.atoms) {
        TLMP4Atom *atom = [self.atoms objectForKey:n];
        
        if ([name isEqualToString:n]) [result addObject:atom];
        
        if (recursive) [result addObjectsFromArray:[atom getChild:name recursive:YES]];
    }
    
    return result;
}

- (id)getILSTData:(TLMP4AtomInfo *)atomInfo;
{
    TLMP4Atom *atom = [self findAtom:@[@"moov", @"udta", @"meta", @"ilst", [atomInfo name]]];
    if (!atom) return nil;
    
    // Could use stricter flags later, but this is what TagLib(C++) used…
    return [atom getDataWithType:[atomInfo type]];
}

#pragma mark - Superclass overloads

// TODO: overload isEmpty, refactor class structure so this makes more sense

// TODO: make this output more and more useful information
- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"TLMP4Tags"];
    
    if ([self.atoms count]) {
        [result appendString:@": {\n"];
        [result appendString:[self.atoms description]];
        [result appendString:@"\n} End of atoms"];
    }
    return result;
}

@end
