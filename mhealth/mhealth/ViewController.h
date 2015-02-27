//
//  ViewController.h
//  mhealth
//
//  Created by jiayi on 2/19/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface ViewController : UIViewController<UITextFieldDelegate, WebServiceProtocol>

@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

+ (void) replaceView:(NSString *)viewName currentView:(UIViewController *)currView;
+ (void) popUpView:(NSString *)viewName titleLabel:(NSString *)title currentView:(UIViewController *)currView;

@end