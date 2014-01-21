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
@property (weak, nonatomic) IBOutlet UITextView *textToEncode;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end



@implementation NmffViewController

#pragma mark - UIButton
- (IBAction)tappedGenerateMorseCodeButton:(id)sender {

    NSLog(@"%@", _textToEncode.text);
    if ([_textToEncode.text canEncodeToMorseCode]) {
        NSLog(@"%@",[_textToEncode.text convertToMorseCode]);
    } else {
        NSLog(@"Cannot Be Converted to Morse Code");
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)dismissKeyboard {
    [_textToEncode resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
