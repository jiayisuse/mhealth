//
//  Global.h
//  mhealth
//
//  Created by jiayi on 2/20/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_Global_h
#define mhealth_Global_h

#import "User.h"

#define USERNAME_KEY            @"USERNAME"
#define USEREMAIL_KEY           @"USEREMAIL"
#define USERID_KEY              @"USERID"
#define USERFID_KEY             @"USERFID"
#define USERPASSWORD_KEY        @"USERPASSWORD"
#define NOTIFICATION_BOOL_KEY   @"NOTIFICATION_BOOL"

#define APPNAME                 @"SmartCook"
#define INGREDIENT_TABLE_NAME   @"INGREDIENT_TABLE"
#define REAR_TABLE_NAME         @"REAR_TABLE"

#define BLUE_COLOR              UIColorFromRGB(0x268fff)
#define BLUE_HIGHLIGHT_COLOR    UIColorFromRGB(0x5ba6f6)
#define DARK_COLOR              [UIColor colorWithWhite:0.3 alpha:1.0]
#define DARK_HIGHLIGHT_COLOR    [UIColor colorWithWhite:0.4 alpha:1.0]

#define INGREDIENT_NOTIFICATION_KEY             @"IID"
#define NOTIFICATION_DEFAULT_KEY(ingredient)    [NSString stringWithFormat:@"%ld", (long)ingredient.IID]

static const NSString *DOMAIN_URL = @"http://jiayi.net/smart_cook";
static const int REAR_VIEW_WIDTH = 250;
static const int NotifyBeforeDays = 3;

User *ME;
NSArray *ingredientDict;

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 \
    alpha:1.0]

#endif
