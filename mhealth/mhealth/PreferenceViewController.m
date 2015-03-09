//
//  PreferenceViewController.m
//  mhealth
//
//  Created by jiayi on 3/8/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreferenceViewController.h"
#import "IGLDropDownMenu.h"
#import "BlueButton.h"
#import "Global.h"

extern User *ME;

@interface PreferenceViewController () <IGLDropDownMenuDelegate>

@property (strong, nonatomic) IGLDropDownMenu *genderMenu;

@end

@implementation PreferenceViewController {
    BlueButton *saveBtn;
    CGFloat viewY;
    NSArray *genders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popUpView.layer.cornerRadius = 5.0f;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [self.closeImage addGestureRecognizer:closeTap];
    self.closeImage.userInteractionEnabled = YES;
    self.titleLabel.text = @"Preference";
    
    [self.heightText setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.weightText setKeyboardType:UIKeyboardTypeDecimalPad];
    self.heightText.delegate = self;
    self.weightText.delegate = self;
    self.heightText.text = ME.height == 0 ? @"" : @(ME.height).stringValue;
    self.weightText.text = ME.weight == 0 ? @"" : @(ME.weight).stringValue;
    [self.heightText addTarget:self
                    action:@selector(heightTextChanged:)
          forControlEvents:UIControlEventEditingChanged];
    [self.weightText addTarget:self
                        action:@selector(weightTextChanged:)
              forControlEvents:UIControlEventEditingChanged];
    
    saveBtn = [BlueButton newButton:self action:@selector(onSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 30;
    saveBtn.frame = CGRectMake((self.popUpView.frame.size.width - btnWidth) / 2, self.popUpView.frame.size.height - 20 - btnHeight, btnWidth, btnHeight);
    saveBtn.layer.cornerRadius = 5.0;
    [self.popUpView addSubview:saveBtn];
    
    viewY = self.view.frame.origin.y;
    
    genders = [NSArray arrayWithObjects:@"Female", @"Male", nil];
    NSMutableArray *unitItems = [[NSMutableArray alloc] init];
    for (NSString *unit in genders) {
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:unit];
        item.textLabel.textAlignment = NSTextAlignmentCenter;
        item.textLabel.textColor = BLUE_COLOR;
        [item.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        [unitItems addObject:item];
    }
    self.genderMenu = [[IGLDropDownMenu alloc] init];
    self.genderMenu.menuText = (ME.gender == nil || [ME.gender isEqualToString:@""]) ? @"Gender" : ME.gender;
    self.genderMenu.menuButton.textLabel.backgroundColor = BLUE_HIGHLIGHT_COLOR;
    self.genderMenu.menuButton.textLabel.textColor = [UIColor blackColor];
    self.genderMenu.menuButton.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.genderMenu.menuButton.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.genderMenu.dropDownItems = unitItems;
    CGFloat w = 80;
    CGFloat h = self.heightText.frame.size.height - 5;
    [self.genderMenu setFrame:CGRectMake(self.popUpView.frame.size.width / 2 - w / 2, 125, w, h)];
    self.genderMenu.delegate = self;
    self.genderMenu.paddingLeft = 0;
    //self.unitMenu.gutterY = 1;
    [self.genderMenu reloadView];
    [self.popUpView addSubview:self.genderMenu];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 80 units
    CGRect rect = CGRectMake(0.0f, -60, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (void)resumeView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, viewY, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        [self resumeView];
    }
    if (![[touch view] isKindOfClass:[IGLDropDownMenu class]] && self.genderMenu.expanding) {
        self.genderMenu.expanding = NO;
        [self.genderMenu foldView];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)onSaveButton:(id)sender {
    NSString *height = self.heightText.text;
    if (height.length == 0) {
        self.heightText.placeholder = @"Please enter height";
        self.heightAsterisk.hidden = NO;
        return;
    }
    
    NSString *weight = self.weightText.text;
    if (weight.length == 0) {
        self.weightText.placeholder = @"Please enter weight";
        self.weightAsterisk.hidden = NO;
        return;
    }
    
    NSInteger index = self.genderMenu.selectedIndex;
    if (index == -1 && [self.genderMenu.menuText isEqualToString:@"Gender"]) {
        self.genderAsterisk.hidden = NO;
        return;
    }
    NSString *gender = self.genderMenu.menuText;
    
    ME.height = [height floatValue];
    ME.weight = [weight floatValue];
    ME.gender = gender;
    
    WebService *ws = [[WebService alloc] initWithPHPFile:@"user_update.php"];
    ws.delegate = self;
    NSArray *valueArray = [NSArray arrayWithObjects:height, weight, gender, @(ME.UID).stringValue, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:USERHEIGHT_KEY, USERWEIGHT_KEY, USERGENDER_KEY, USERID_KEY, nil];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [ws setPostData:postDict];
    [ws sendRequest];
}

- (void)closeView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSArray *familyData;
    NSString *errorMessage = [WebService jsonParse:data retData:&familyData];
    if ([errorMessage length] == 0) {
        [ME saveDefaults];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)heightTextChanged:(UITextField *)textField {
    self.heightAsterisk.hidden = YES;
}

- (void)weightTextChanged:(UITextField *)textField {
    self.weightAsterisk.hidden = YES;
}

@end