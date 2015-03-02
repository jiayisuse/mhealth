//
//  PopUpViewController.h
//  mhealth
//
//  Created by jiayi on 2/26/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_PopUpViewController_h
#define mhealth_PopUpViewController_h

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"

@protocol popUpViewControllerProtocol <NSObject>

- (void)fetchPopUpData:(id)data;

@end

@interface PopUpViewController : UIViewController<UITextFieldDelegate, AutocompletionTableViewDelegate>

@property (nonatomic, weak) id <popUpViewControllerProtocol> delegate;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITextField *ingredientText;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UILabel *asterisk;
@property (nonatomic, copy) NSString *title;

@end

#endif
