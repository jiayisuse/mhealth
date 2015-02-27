//
//  ShoppingViewController.h
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_ShoppingViewController_h
#define mhealth_ShoppingViewController_h

#import <UIKit/UIKit.h>
#import "PopUpViewController.h"

@interface ShoppingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, popUpViewControllerProtocol>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *siderbarBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#endif
