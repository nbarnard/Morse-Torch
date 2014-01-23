//
//  NmffViewController.m
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/20/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "NmffViewController.h"
#import "NSString+Morse.h"
#import "NmffTorchController.h"
#import <ProgressHUD.h>

@interface NmffViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textToEncode;
@property (weak, nonatomic) IBOutlet UIButton *sendMorseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSendButton;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation NmffViewController

#pragma mark - UIView
- (void)viewDidLoad {
    [super viewDidLoad];
    _textToEncode.delegate = self;

    // Init the torch. If we receive nil, we're unable to utilize it and should stop.
    if ([NmffTorchController shared] == nil) {
        [self noTorch];
    }
}

#pragma mark - UIButton

- (IBAction) sendMorseButton:(id)sender {
    if ([_textToEncode.text canEncodeToMorseCode]) {
        [self toggleSendButton:FALSE];
        NmffTorchController *torchController = [NmffTorchController shared];
        torchController.delegate = self;
        [torchController sendString: _textToEncode.text];
        _textToEncode.text = @""; // set the text field to blank so the user knows we'll process it

    } else {
        NSLog(@"Cannot Be Converted to Morse Code"); // This should not be reached as the button should be deactivated.
    }
}

- (IBAction) cancelSendingButton:(id) sender {
    NmffTorchController *torchController = [NmffTorchController shared];
    [torchController cancelSending];
}

#pragma mark - NmffTorchDelegate
#pragma mark UIButton

- (void) toggleCancelButton:(BOOL)status {
    _cancelSendButton.enabled = status;
}

- (void) toggleSendButton:(BOOL) status{
    _sendMorseButton.enabled = status;
}

#pragma mark HUD Control

- (void) updateCurrentlySendingHUDWithChar:(NSString *)label {
    if([label isEqualToString:@" "]) {
        [ProgressHUD show:@"Sending Space"];
    } else {
        [ProgressHUD show:[@"Sending: " stringByAppendingString:label]];
    }
}

- (void) dismissHUD {
    [ProgressHUD dismiss];
}

#pragma mark - NoTorch Handling

// No torch, disable our user interface and present
- (void) noTorch {
    _textToEncode.enabled = FALSE;
    _mainView.backgroundColor = [UIColor lightGrayColor];
    _textToEncode.backgroundColor = [UIColor lightGrayColor];

    NSMutableAttributedString *noLED = [[NSMutableAttributedString alloc] initWithString:@"Disabled: No LED found on Device"];

    [noLED addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, noLED.length)];
    _textToEncode.attributedPlaceholder = noLED;

    UIAlertView *noTorch = [[UIAlertView alloc] initWithTitle: @"No LED Found"
                                                      message: @"Morse Code Convert was unable to find an LED to send Morse Code"
                                                     delegate: nil
                                            cancelButtonTitle: @"Close"
                                            otherButtonTitles: nil];
    [noTorch show];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([newString canEncodeToMorseCode] && newString.length !=0) {
        [self toggleSendButton:TRUE];
    } else {
        [self toggleSendButton:FALSE];
    }
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *)textField {
    [textField endEditing:YES];
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Boilerplate
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
