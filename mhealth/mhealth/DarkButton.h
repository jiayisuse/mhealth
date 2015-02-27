//
//  DarkButton.h
//  mhealth
//
//  Created by jiayi on 2/26/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_DarkButton_h
#define mhealth_DarkButton_h

#import <UIKIT/UIKIT.h>

@interface DarkButton : UIButton

+ (id)newButton:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events;

@end

#endif
