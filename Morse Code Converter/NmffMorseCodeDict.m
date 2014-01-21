//
//  NmffMorseCodeDict.m
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/20/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "NmffMorseCodeDict.h"

@implementation NmffMorseCodeDict

+ (NmffMorseCodeDict *) shared {

    static dispatch_once_t pred;
    static NmffMorseCodeDict *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[NmffMorseCodeDict alloc] init];
    });

    return shared;
}

- init {
    self = [super init];
    if (self != nil) {
        NSString *morseCodePlist = [[NSBundle mainBundle] pathForResource:@"Morse Code" ofType:@"plist"];
        _morseCodeDict = [[NSDictionary alloc] initWithContentsOfFile:morseCodePlist];
    }
    return self;
}

@end
