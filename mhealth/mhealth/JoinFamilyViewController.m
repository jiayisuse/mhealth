//
//  JoinFamilyViewController.m
//  mhealth
//
//  Created by jiayi on 3/5/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JoinFamilyViewController.h"
#import "ViewController.h"
#import "Global.h"

extern User *ME;

@implementation JoinFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.familyName.delegate = self;
    self.password.delegate = self;
    self.familyName.returnKeyType = UIReturnKeyNext;
    self.password.returnKeyType = UIReturnKeyDefault;
    [self.familyName addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.password addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.navigationItem.title = @"Join Family";
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 30 units
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
    if (sender == self.familyName) {
        [self.password becomeFirstResponder];
    } else if (sender == self.password || sender == self.joinBtn) {
        self.errorLabel.text = @"";
        [self.view endEditing:YES];
        [self resumeView];
        
        if ([self.familyName.text length] == 0) {
            self.errorLabel.text = @"Email is empty";
            return;
        }
        if ([self.password.text length] == 0) {
            self.errorLabel.text = @"Password is empty";
            return;
        }
        
        WebService *ws = [[WebService alloc] initWithPHPFile:@"join_family.php"];
        ws.delegate = self;
        NSArray *keyArray = [NSArray arrayWithObjects:FAMILYNAME_KEY, FAMILYPASSWORD_KEY, USERID_KEY, nil];
        NSArray *valueArray = [NSArray arrayWithObjects:self.familyName.text, self.password.text, @(ME.UID).stringValue, nil];
        NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        [ws setPostData:postDict];
        [ws sendRequest];
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

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSArray *familyData;
    NSString *errorMessage = [WebService jsonParse:data retData:&familyData];
    NSLog(@"error message: %@, id = %@", errorMessage, familyData[0]);
    if ([errorMessage length] == 0) {
        ME.FID = [familyData[0] intValue];
        ME.familyName = self.familyName.text;
        [ME saveDefaults];
        [ViewController replaceView:@"mainView" currentView:self];
    } else
        self.errorLabel.text = errorMessage;
}

@end