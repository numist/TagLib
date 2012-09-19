//
//  TLMP4Tags.m
//  TagLib
//
//  Created by Scott Perry on 8/8/11.
//

#import "TLMP4Tags_Private.h"

#import "debugger.h"
#import "NSData+Endian.h"
#import "NSMutableArray+StackOps.h"
#import "TLID3v1Genres.h"
#import "TLMP4Atom.h"
#import "TLMP4AtomInfo.h"
#import "TLMP4Tags+Parser.h"
#import "TLErrorWrapper.h"
#import "TLMappedDataCache.h"

@implementation TLMP4Tags
@synthesize path = _path;
@synthesize atoms = _atoms;
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
@synthesize length = _length;

#pragma mark Initializers

- (id)initWithPath:(NSString *)pathArg error:(NSError **)terror;
{
    self = [super initPrivate];
    if (!self || !pathArg) return nil;
    // Clear terror, in case we succeed.
    if (terror) *terror = nil;

    _path = pathArg;

    //
    // Drop the parser into a GCD queue so it's easier to pass errors back up
    //
    TLErrorWrapper *wrapper = [[TLErrorWrapper alloc] init];
    dispatch_queue_t q = dispatch_queue_create("TLMP4ParserQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(q, kTLWrappedError, (__bridge void *)wrapper, NULL);
    
    dispatch_sync(q, ^{
        [self load];
    });
    
    NSError *error = [wrapper error];
    dispatch_release(q);
    
    if (error) {
        if (terror) *terror = error;
        return nil;
    }

    return self;
}

- (id)init;
{
    return [self initWithPath:nil error:nil];
}

#pragma mark -
#pragma mark File access methods
- (NSData *)getData;
{
    return [TLMappedDataCache mappedDataForPath:self.path];
}

#pragma mark - Atom methods

- (NSDictionary *)atoms;
{
    if (!_atoms) {
        NSMutableDictionary *atoms = [[NSMutableDictionary alloc] init];
        
        NSData *data = [self getData];
        unsigned long long end = [data length];
        unsigned long long offset = 0;
        
        while (offset + 8 < end) {
            TLMP4Atom *atom = [[TLMP4Atom alloc] initWithOffset:offset parent:self];
            // NOTE: in the C++ impl, returns incomplete atom set
            if (!atom) {
                TLAssert(pendingError);
                return nil;
            }
            [atoms setValue:atom forKey:[atom name]];
            offset += [atom length];
        }
        
        data = nil;
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

- (BOOL)isEmpty;
{
    if (![super isEmpty]) return NO;
    
    if ([self encoder]) return NO;
    if ([self artwork]) return NO;
    if ([self TVShowName]) return NO;
    if ([self TVEpisodeID]) return NO;
    if ([self TVSeason]) return NO;
    if ([self TVEpisode]) return NO;
    if ([self albumArtist]) return NO;
    if ([self totalTracks]) return NO;
    if ([self totalDisks]) return NO;
    if ([self copyright]) return NO;
    if ([self compilation]) return NO;
    if ([self gaplessPlayback]) return NO;
    if ([self stik]) return NO;
    if ([self rating]) return NO;
    if ([self purchaseDate]) return NO;
    if ([self purchaserID]) return NO;
    if ([self composer]) return NO;
    if ([self BPM]) return NO;
    if ([self grouping]) return NO;
    if ([self mediaDescription]) return NO;
    if ([self lyrics]) return NO;
    if ([self podcast]) return NO;

    return YES;
}

@end
