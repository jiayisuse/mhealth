//
//  NewAccountViewController.h
//  mhealth
//
//  Created by jiayi on 2/21/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_NewAccountViewController_h
#define mhealth_NewAccountViewController_h

#import <UIKit/UIKit.h>

@interface NewAccountViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@end

#endif
