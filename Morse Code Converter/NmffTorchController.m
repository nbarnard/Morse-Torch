//
//  NmffTorchController.m
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/21/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "NmffTorchController.h"
#import "NSString+Morse.h"
#import <AVFoundation/AVFoundation.h>

@interface NmffTorchController ()

@property (nonatomic) AVCaptureDevice *torch;
@property (nonatomic) NSOperationQueue *torchQueue;
@property (nonatomic) NSOperationQueue *mainQueue;

@end

@implementation NmffTorchController

+ (NmffTorchController *) shared {

    static dispatch_once_t pred;
    static NmffTorchController *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[NmffTorchController alloc] init];
    });

    return shared;
}

- (NmffTorchController *) init {

    self = [super init];

    if (self != nil) {
        // identify the torch and set the torch property
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device hasTorch] && [device isTorchModeSupported:AVCaptureTorchModeOn]) {
                _torch = device;
                _torchQueue = [NSOperationQueue new];
                [_torchQueue setMaxConcurrentOperationCount:1];
                _mainQueue = [NSOperationQueue mainQueue];

            }
        }
    }
    return self;

}

- (void) sendString: (NSString *)stringToSend withLabel: (UILabel *)currentlySendingLabel {
    [_torchQueue addOperationWithBlock:^{
        NSString *morseEncodedString = [NSString new];
        morseEncodedString = [stringToSend convertToMorseCode];

        [_mainQueue addOperationWithBlock:^ {
            currentlySendingLabel.enabled = TRUE;
        }];

        NSUInteger length = stringToSend.length;
        NSString *dotDashToSend = [NSString new];
        NSString *charToSend = [NSString new];

        for (NSUInteger i=0; i < length; i++) {
            dotDashToSend = [morseEncodedString substringWithRange:NSMakeRange(i, 1)];
            charToSend = [stringToSend substringWithRange:NSMakeRange(i, 1)];

            [_mainQueue addOperationWithBlock:^ {
                currentlySendingLabel.text = [@"Currently Sending: " stringByAppendingString:charToSend];
            }];
            [self sendChar:dotDashToSend];
        }

        [_mainQueue addOperationWithBlock:^ {
            currentlySendingLabel.text = @"";
        }];

    }];
}

- (void) sendChar: (NSString *) character {
    if ([character isEqualToString:@"-"]) {
        [self sendDash];
    } else if ([character isEqualToString:@"."]) {
        [self sendDot];
    } else if ([character isEqualToString:@" "]) {
        [self sleepForSeconds:0.1]; // a space turns the torch on for 0.1 seconds as is the delimiter between alphanumeric characters. Space is encoded as five spaces by Morse Category.
    }

}

- (void) sendDot {
    // Dot is 0.1 of light on, followed by 0.1 of light off.
    [self torchOnForSeconds:0.1];
    [self sleepForSeconds:0.2];
}

- (void) sendDash {
    // Dash is 0.3 of light on, followed by 0.1 of light off.
    [self torchOnForSeconds:0.3];
    [self sleepForSeconds:0.2];
}

- (void) torchOnForSeconds: (float) secondsToLight {
    BOOL torchLocked = [_torch lockForConfiguration:nil];
    if (torchLocked) {
        _torch.torchMode = AVCaptureFlashModeOn;
        [self sleepForSeconds:secondsToLight];
        _torch.TorchMode = AVCaptureFlashModeOff;
        [_torch unlockForConfiguration];
    }

}

- (void) sleepForSeconds: (float) secondsToSleep {
    // usleep takes microseconds, which are equal to one millionth (1/1,000,000) of a second.
    usleep(secondsToSleep * 1000000);
}

@end
