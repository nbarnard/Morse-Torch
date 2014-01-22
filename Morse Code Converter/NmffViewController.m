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

@interface NmffViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textToEncode;
@property (weak, nonatomic) IBOutlet UIButton *sendMorseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSendButton;
@property (weak, nonatomic) IBOutlet UILabel *currentlySendingLabel;

@end

@implementation NmffViewController

#pragma mark - UIView
- (void)viewDidLoad {
    [super viewDidLoad];
    _textToEncode.delegate = self;
    _sendMorseButton.enabled = FALSE;
    _cancelSendButton.enabled = FALSE;
}

#pragma mark - UIButton

- (IBAction) sendMorseButton:(id)sender {
    if ([_textToEncode.text canEncodeToMorseCode]) {
        _sendMorseButton.enabled = FALSE;
        NmffTorchController *torchController = [NmffTorchController shared];
        [torchController sendString: _textToEncode.text
                          withLabel: _currentlySendingLabel
                    andCancelButton: _cancelSendButton];
        _textToEncode.text = @""; // set the text field to blank so the user knows we'll process it

    } else {
        NSLog(@"Cannot Be Converted to Morse Code"); // This should not be reached as the button should be deactivated.
    }
}

- (IBAction) cancelSendingButton:(id) sender {
    NmffTorchController *torchController = [NmffTorchController shared];
    [torchController cancelSending];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([newString canEncodeToMorseCode] && newString.length !=0) {
        _sendMorseButton.enabled = TRUE;
    } else {
        _sendMorseButton.enabled = FALSE;
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
