//
//  RecipeWebViewController.m
//  mhealth
//
//  Created by jiayi on 3/8/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeWebViewController.h"

@implementation RecipeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.recipeURL];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end