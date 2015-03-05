//
//  NewFamilyVewController.m
//  mhealth
//
//  Created by jiayi on 3/4/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFamilyViewController.h"
#import "ViewController.h"
#import "User.h"
#import "Global.h"

extern User *ME;

@implementation NewFamilyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.familyName.delegate = self;
    self.password.delegate = self;
    self.rePassword.delegate = self;
    self.familyName.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyNext;
    self.rePassword.returnKeyType = UIReturnKeyDefault;
    [self.familyName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.rePassword addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    /*
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:@"New Family"];
    */
    self.navigationItem.title = @"New Faimly";
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 120 units
    CGRect rect=CGRectMake(0.0f, -150, width, height);
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

- (IBAction)nextOnKeyboard:(id)sender
{
    if (sender == self.familyName) {
        [self.password becomeFirstResponder];
    } else if (sender == self.password) {
        [self.rePassword becomeFirstResponder];
    } else if (sender == self.rePassword || sender == self.createBtn) {
        self.errorLabel.text = @"";
        [self.view endEditing:YES];
        [self resumeView];
        if ([self inputIsOK]) {
            WebService *ws = [[WebService alloc] initWithPHPFile:@"new_family.php"];
            ws.delegate = self;
            NSArray *valueArray = [NSArray arrayWithObjects:self.familyName.text, self.password.text, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:FAMILYNAME_KEY, FAMILYPASSWORD_KEY, nil];
            NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
            [ws setPostData:postDict];
            [ws sendRequest];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        [self resumeView];
    }
    [super touchesBegan:touches withEvent:event];
}

- (Boolean)inputIsOK {
    if ([self.familyName.text length] == 0) {
        self.errorLabel.text = @"Family Name is empry";
        return NO;
    }
    
    if ([self.password.text length] == 0) {
        self.errorLabel.text = @"Password is empry";
        return NO;
    }
    
    if ([self.rePassword.text length] == 0) {
        self.errorLabel.text = @"Re-password is empry";
        return NO;
    }
    
    if (![self.password.text isEqualToString:self.rePassword.text]) {
        self.errorLabel.text = @"Please confirm password";
        return NO;
    }
    
    return YES;
}

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *myID;
    NSString *errorMessage = [WebService jsonParse:data retData:&myID];
    NSLog(@"error message: %@", errorMessage);
    if ([errorMessage length] == 0) {
        ME.FID = [myID intValue];
        [self.navigationController popViewControllerAnimated:YES];
    } else
        self.errorLabel.text = errorMessage;
}

@end