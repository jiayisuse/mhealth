//
//  RecipeWebViewController.h
//  mhealth
//
//  Created by jiayi on 3/8/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_RecipeWebViewController_h
#define mhealth_RecipeWebViewController_h

#import <UIKIT/UIKIT.h>

@interface RecipeWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *recipeURL;

@end

#endif
