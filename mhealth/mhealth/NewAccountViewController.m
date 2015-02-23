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

@interface NewAccountViewController() {
    WebService *ws;
}
@end

@implementation NewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.email.delegate = self;
    self.username.delegate = self;
    self.password.delegate = self;
    self.rePassword.delegate = self;
    self.email.returnKeyType = UIReturnKeyNext;
    self.username.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyNext;
    self.rePassword.returnKeyType = UIReturnKeyDefault;
    [self.email addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.username addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.rePassword addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:APPNAME];
    self.navigationItem.titleView = titleText;
    
    ws = [[WebService alloc] initWithPHPFile:@"new_account.php"];
    ws.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 120 units
    CGRect rect=CGRectMake(0.0f, -120, width, height);
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
    if (sender == self.email) {
        [self.username becomeFirstResponder];
    } else if (sender == self.username) {
        [self.password becomeFirstResponder];
    } else if (sender == self.password) {
        [self.rePassword becomeFirstResponder];
    } else if (sender == self.rePassword || sender == self.createBtn) {
        if (sender == self.rePassword) {
            [self.view endEditing:YES];
            [self resumeView];
        }
        if ([self inputIsOK]) {
            NSArray *valueArray = [NSArray arrayWithObjects:self.email.text, self.username.text,
                                   self.password.text, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:USEREMAIL_KEY, USERNAME_KEY, USERPASSWORD_KEY, nil];
            NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
            [ws setPostData:postDict];
            [ws sendRequest];
        }
    }
}

- (Boolean)inputIsOK {
    if ([self.email.text length] == 0) {
        self.errorLabel.text = @"Email is empry";
        return NO;
    }
    
    if (![self isValidEmail:self.email.text]) {
        self.errorLabel.text = @"Invalid email";
        return NO;
    }
    
    if ([self.username.text length] == 0) {
        self.errorLabel.text = @"Username is empry";
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

- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        [self resumeView];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)dataDownloaded:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end