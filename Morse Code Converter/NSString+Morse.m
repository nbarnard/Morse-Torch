//
//  NSString+Morse.m
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/20/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "NSString+Morse.h"
#import "NmffMorseCodeDict.h"

@implementation NSString (Morse)


- (NSString *) convertToMorseCode {

    int length = self.length;

    NSMutableString *convertedString = [NSMutableString new];
    NSString *convertedChar = [NSString new];

    for (int i=0; i < length; i++) {
        convertedChar = [self convertCharToMorseCode:[self substringWithRange:NSMakeRange(i, 1)]];
        [convertedString appendString: convertedChar];

    }
    return [[NSString alloc] initWithString:convertedString];
}

- (NSString *) convertCharToMorseCode: (NSString *) singleCharacter {

    NmffMorseCodeDict *dict = [NmffMorseCodeDict shared];

    NSString *convertedChar = [dict.morseCodeDict objectForKey:[singleCharacter uppercaseString]];

    return convertedChar;
}


@end
