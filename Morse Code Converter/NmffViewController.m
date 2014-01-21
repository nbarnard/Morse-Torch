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
@property (weak, nonatomic) IBOutlet UIButton *generateMorseButton;

@end

@implementation NmffViewController

#pragma mark - UIView
- (void)viewDidLoad {
    [super viewDidLoad];
    _textToEncode.delegate = self;
    _generateMorseButton.enabled = FALSE;
}

#pragma mark - UIButton

- (IBAction) tappedGenerateMorseCodeButton:(id)sender {
    if ([_textToEncode.text canEncodeToMorseCode]) {
        NSString *morseEncodedString = [NSString new];
        morseEncodedString = [_textToEncode.text convertToMorseCode];
        NmffTorchController *torchController = [NmffTorchController shared];
        [torchController sendString:morseEncodedString];
    } else {
        NSLog(@"Cannot Be Converted to Morse Code");
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    _generateMorseButton.enabled = !_generateMorseButton.enabled;

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([newString canEncodeToMorseCode] && newString.length !=0) {
        _generateMorseButton.enabled = TRUE;
    } else {
        _generateMorseButton.enabled = FALSE;
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
