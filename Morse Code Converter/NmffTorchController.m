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

#pragma mark - Initalizers / Cancellers

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


- (void) cancelSending {
    [_torchQueue cancelAllOperations];
}

#pragma mark - String Sending

// Block code inspired by http://stackoverflow.com/questions/4962673/how-to-cancel-out-of-operation-created-with-addoperationwithblock

- (void) sendString: (NSString *)stringToSend withLabel: (UILabel *)currentlySendingLabel andCancelButton: (UIButton *) cancelButton {
    cancelButton.enabled = TRUE;
    NSLog(@"Cancel Button Enabled");

    __block NSBlockOperation *sendString = [NSBlockOperation blockOperationWithBlock:^{
        NSString *morseEncodedString = [stringToSend convertToMorseCode];

        [_mainQueue addOperationWithBlock:^ {
            currentlySendingLabel.enabled = TRUE;
        }];

        NSUInteger length = morseEncodedString.length;

        // For Loop both increments and checks if this block has been canceled.
        for (NSUInteger morseStringLocation=0, textStringLocation = 0; morseStringLocation < length && ![sendString isCancelled]; morseStringLocation++) {
            NSString *dotDashToSend = [morseEncodedString substringWithRange:NSMakeRange(morseStringLocation, 1)];
            NSString *charToSend = [stringToSend substringWithRange:NSMakeRange(textStringLocation, 1)];

            [_mainQueue addOperationWithBlock:^ {
                currentlySendingLabel.text = [@"Currently Sending: " stringByAppendingString:charToSend];
            }];
            // If the Dot/Dash/Space that we're sending is a plus it means we're at the end of a character, so we need to the textStringLocation by one so the next update will give us the right letter
            if ([dotDashToSend isEqualToString:@"+"]){
                textStringLocation++;
            }
            [self sendChar:dotDashToSend];
        } // For loop end

        [_mainQueue addOperationWithBlock:^ {
            currentlySendingLabel.text = @"";
            cancelButton.enabled = FALSE;
            NSLog(@"Cancel Button Disabled");
        }];

    }]; // send string block end

    [_torchQueue addOperation:sendString];
}

- (void) sendChar: (NSString *) character {
    if ([character isEqualToString:@"-"]) {
        [self sendDash];
    } else if ([character isEqualToString:@"."]) {
        [self sendDot];
    } else if ([character isEqualToString:@"+"]) {
        [self sleepForSeconds:0.1];
    } else if ([character isEqualToString:@" "]) {
        [self sleepForSeconds:0.4]; // A space is represented by " +" as + is the terminator defining the end of a non-morse character. This'll do 0.4, and the + will handle the rest of the 0.5 delay.
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
