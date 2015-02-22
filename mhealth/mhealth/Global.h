//
//  Global.h
//  mhealth
//
//  Created by jiayi on 2/20/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_Global_h
#define mhealth_Global_h

#define APPNAME     @"SmartCook"

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 \
    alpha:1.0]

#endif
