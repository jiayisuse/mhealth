//
//  RearViewController.h
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_RearViewController_h
#define mhealth_RearViewController_h

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface RearViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, WebServiceProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#endif
