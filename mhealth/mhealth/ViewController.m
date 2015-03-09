//
//  ViewController.m
//  mhealth
//
//  Created by jiayi on 2/19/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import "ViewController.h"
#import "NewAccountViewController.h"
#import "PopUpViewController.h"
#import "PreferenceViewController.h"
#import "WebService.h"
#import "Global.h"

extern User *ME;

@interface ViewController () {
    WebService *ws;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.emailLogin.delegate = self;
    self.passwordLogin.delegate = self;
    self.emailLogin.returnKeyType = UIReturnKeyNext;
    self.passwordLogin.returnKeyType = UIReturnKeyDefault;
    [self.emailLogin addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordLogin addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.emailLogin setKeyboardType:UIKeyboardTypeEmailAddress];
    
    // set title
    /*
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:APPNAME];
     */
    self.navigationItem.title = APPNAME;
    //self.navigationItem.hidesBackButton = YES;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createLabelTapped:)];
    labelTap.numberOfTapsRequired = 1;
    [self.createLabel addGestureRecognizer:labelTap];
    self.createLabel.userInteractionEnabled = YES;
    
    ws = [[WebService alloc] initWithPHPFile:@"login.php"];
    ws.delegate = self;

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
    if (sender == self.emailLogin) {
        [self.passwordLogin becomeFirstResponder];
    } else if (sender == self.passwordLogin || sender == self.loginBtn) {
        self.errorLabel.text = @"";
        [self.view endEditing:YES];
        [self resumeView];
        
        if ([self.emailLogin.text length] == 0) {
            self.errorLabel.text = @"Email is empty";
            return;
        }
        if ([self.passwordLogin.text length] == 0) {
            self.errorLabel.text = @"Password is empty";
            return;
        }
                
        NSArray *keyArray = [NSArray arrayWithObjects:USEREMAIL_KEY, USERPASSWORD_KEY, nil];
        NSArray *valueArray = [NSArray arrayWithObjects:self.emailLogin.text, self.passwordLogin.text, nil];
        NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        [ws setPostData:postDict];
        [ws sendRequest];
    }
}

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSArray *retData;
    NSString *errorMessage = [WebService jsonParse:data retData:&retData];
    NSLog(@"error message: %@", errorMessage);
    if ([errorMessage length] == 0) {
        ME.email = self.emailLogin.text;
        ME.username = retData[2];
        ME.UID = [retData[0] intValue];
        ME.FID = [retData[1] intValue];
        ME.familyName = retData[3];
        ME.height = [retData[4] floatValue];
        ME.weight = [retData[5] floatValue];
        ME.gender = retData[6];
        NSLog(@"email = %@, username = %@, id = %ld, fid = %ld, height = %f, weight = %f, gender = %@", ME.email, ME.username, ME.UID, ME.FID, ME.height, ME.weight, ME.gender);
        [ME saveDefaults];
        [ViewController replaceView:@"mainView" currentView:self];
    } else
        self.errorLabel.text = errorMessage;
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewAccountViewController *newAccountView = (NewAccountViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NewFamilyView"];
    [self.navigationController pushViewController:newAccountView animated:YES];
    NSLog(@"haha %p", newAccountView);
    //[self presentViewController:newAccountView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)navigateToView:(NSString *)viewName currentView:(UIViewController *)currView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *newView = [storyboard instantiateViewControllerWithIdentifier:viewName];
    [currView.navigationController pushViewController:newView animated:YES];
}

+ (void)replaceView:(NSString *)viewName currentView:(UIViewController *)currView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *newView = [storyboard instantiateViewControllerWithIdentifier:viewName];
    [currView presentViewController:newView animated:YES completion:nil];
}

+ (void)popUpView:(NSString *)viewName titleLabel:(NSString *)title currentView:(UIViewController *)currView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopUpViewController *newView = (PopUpViewController *)[storyboard instantiateViewControllerWithIdentifier:viewName];
    newView.delegate = (id)currView;
    newView.title = title;
    newView.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    newView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    currView.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (currView.navigationController)
        currView.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (currView.tabBarController)
        currView.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [currView presentViewController:newView animated:YES completion:nil];
}

+ (void)popUpPreferenceView:(NSString *)viewName currentView:(UIViewController *)currView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreferenceViewController *newView = (PreferenceViewController *)[storyboard instantiateViewControllerWithIdentifier:viewName];
    newView.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    newView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    currView.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (currView.navigationController)
        currView.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (currView.tabBarController)
        currView.tabBarController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [currView presentViewController:newView animated:YES completion:nil];
}

@end
