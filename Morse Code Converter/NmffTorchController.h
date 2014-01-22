//
//  NmffTorchController.h
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/21/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NmffTorchDelegate

-(void) updateCurrentlySendingLabelWithChar: (NSString *) label;
-(void) toggleCancelButton: (BOOL) status;
-(void) toggleSendButton: (BOOL) status;

@end

@interface NmffTorchController : NSObject

+ (NmffTorchController *) shared;

- (void) sendString: (NSString *)stringToSend;
- (void) cancelSending;

@property (unsafe_unretained) id <NmffTorchDelegate> delegate;

@end
