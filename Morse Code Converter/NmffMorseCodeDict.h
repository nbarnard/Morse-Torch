//
//  NmffMorseCodeDict.h
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/20/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NmffMorseCodeDict : NSObject

@property (atomic) NSDictionary *morseCodeDict;

+ (NmffMorseCodeDict *)shared;

@end
