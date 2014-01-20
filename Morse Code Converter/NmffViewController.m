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

@end



@implementation NmffViewController

#pragma mark - UIButton
- (IBAction)tappedGenerateMorseCodeButton:(id)sender {
    NSLog(@"%@", _textToEncode.text);
    NSLog(@"%@",[_textToEncode.text convertToMorseCode]);


}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
