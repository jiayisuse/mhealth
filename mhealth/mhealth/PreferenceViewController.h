//
//  PreferenceViewController.h
//  mhealth
//
//  Created by jiayi on 3/8/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_PreferenceViewController_h
#define mhealth_PreferenceViewController_h

#import <UIKIT/UIKIT.h>
#import "PopUpViewController.h"
#import "WebService.h"

@interface PreferenceViewController : UIViewController<WebServiceProtocol, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITextField *heightText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;
@property (weak, nonatomic) IBOutlet UILabel *heightAsterisk;
@property (weak, nonatomic) IBOutlet UILabel *weightAsterisk;
@property (weak, nonatomic) IBOutlet UILabel *genderAsterisk;

@end

#endif
