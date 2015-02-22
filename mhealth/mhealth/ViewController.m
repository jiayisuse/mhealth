//
//  ViewController.m
//  mhealth
//
//  Created by jiayi on 2/19/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import "ViewController.h"
#import "Global.h"
#import "NewAccountViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"jiayisuse" forKey:USERNAME_KEY];
    [userDefaults setObject:@"jiayisuse@gmail.com" forKey:USEREMAIL_KEY];
    [userDefaults setInteger:1 forKey:USERID_KEY];
    
    userName = [userDefaults stringForKey:USERNAME_KEY];
    if (userName != nil) {
        userEmail = [userDefaults stringForKey:USEREMAIL_KEY];
        userID = [userDefaults integerForKey:USERID_KEY];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabView = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"tabView"];
        [self presentViewController:tabView animated:YES completion:nil];
    }
     */
    
    self.username_login.delegate = self;
    self.password_login.delegate = self;
    self.username_login.returnKeyType = UIReturnKeyNext;
    self.password_login.returnKeyType = UIReturnKeyDefault;
    [self.username_login addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password_login addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // set title
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:APPNAME];
    self.navigationItem.titleView = titleText;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createLabelTapped:)];
    labelTap.numberOfTapsRequired = 1;
    [self.createLabel addGestureRecognizer:labelTap];
    self.createLabel.userInteractionEnabled = YES;
    
    /*
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:UIColorFromRGB(0x4FB54F)];
     */
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 30 units
    CGRect rect=CGRectMake(0.0f, -30, width, height);
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
    if (sender == self.username_login) {
        [self.password_login becomeFirstResponder];
    } else if (sender == self.password_login) {
        [self.view endEditing:YES];
        [self resumeView];
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

- (void) createLabelTapped: (UITapGestureRecognizer *)recognizer {
    //Code to handle the gesture
    NSLog(@"I am in handleTapFrom method");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewAccountViewController *newAccountView = (NewAccountViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NewAccountView"];
    [self.navigationController pushViewController:newAccountView animated:YES];
    NSLog(@"haha %p", newAccountView);
    //[self presentViewController:newAccountView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGoButton:(id)sender {
    
}

@end
