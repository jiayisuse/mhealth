//
//  NewFamilyViewController.h
//  mhealth
//
//  Created by jiayi on 3/4/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_NewFamilyViewController_h
#define mhealth_NewFamilyViewController_h

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface NewFamilyController : UIViewController<UITextFieldDelegate, WebServiceProtocol>

@property (weak, nonatomic) IBOutlet UITextField *familyName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UILabel * errorLabel;

@end

#endif
