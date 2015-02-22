//
//  NewAccountViewController.m
//  mhealth
//
//  Created by jiayi on 2/21/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewAccountViewController.h"
#import "Global.h"

@implementation NewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.email.delegate = self;
    self.password.delegate = self;
    self.rePassword.delegate = self;
    self.email.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyNext;
    self.rePassword.returnKeyType = UIReturnKeyDefault;
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.rePassword addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:APPNAME];
    self.navigationItem.titleView = titleText;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 30 units
    CGRect rect=CGRectMake(0.0f, -80, width, height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

- (void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f, Y, width, height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.email) {
        [self.password becomeFirstResponder];
    } else if (sender == self.password) {
        [self.rePassword becomeFirstResponder];
    } else if (sender == self.rePassword){
        [self.view endEditing:YES];
        [self resumeView];
        if ([self inputIsOK])
            ;
    }
}

- (Boolean)inputIsOK {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        [self resumeView];
    }
    [super touchesBegan:touches withEvent:event];
}

@end