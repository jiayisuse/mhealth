//
//  JoinFamilyViewController.h
//  mhealth
//
//  Created by jiayi on 3/5/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_JoinFamilyViewController_h
#define mhealth_JoinFamilyViewController_h

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface JoinFamilyViewController : UIViewController<UITextFieldDelegate, WebServiceProtocol>

@property (weak, nonatomic) IBOutlet UITextField *familyName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

#endif
