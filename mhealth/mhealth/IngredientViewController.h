//
//  IngredientViewController.h
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_IngredientViewController_h
#define mhealth_IngredientViewController_h

#import <UIKit/UIKit.h>

@interface IngredientViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#endif