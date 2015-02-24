//
//  ShoppingViewController.m
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingViewController.h"
#import "SWRevealViewController.h"
#import "Global.h"

@implementation ShoppingViewController

- (void)viewDidLoad {
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
}

@end