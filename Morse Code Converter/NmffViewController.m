//
//  NmffViewController.m
//  Morse Code Converter
//
//  Created by Nicholas Barnard on 1/20/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "NmffViewController.h"
#import "NSString+Morse.h"

@interface NmffViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textToEncode;

@end



@implementation NmffViewController

#pragma mark - UIView
- (void)viewDidLoad {
    [super viewDidLoad];
    _textToEncode.delegate = self;
}

#pragma mark - UIButton

- (IBAction)tappedGenerateMorseCodeButton:(id)sender {
    NSLog(@"Input Text: %@", _textToEncode.text);
    if ([_textToEncode.text canEncodeToMorseCode]) {
        NSLog(@"Equivelent Morse Code: %@",[_textToEncode.text convertToMorseCode]);
    } else {
        NSLog(@"Cannot Be Converted to Morse Code");
    }

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing: (UITextField *)textField {
    [textField endEditing:YES];
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Boilerplate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
