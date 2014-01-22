//
//  NmffTorchController.h
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/21/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NmffTorchController : NSObject

+ (NmffTorchController *) shared;

- (void) sendString: (NSString *)stringToSend withLabel: (UILabel *)currentlySendingLabel;
- (void) cancelSending;

@end
