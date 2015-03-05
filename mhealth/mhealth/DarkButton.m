//
//  DarkButton.m
//  mhealth
//
//  Created by jiayi on 2/26/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DarkButton.h"
#import "Global.h"

@implementation DarkButton

+ (id)newButton:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events {
    DarkButton *btn = (DarkButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:DARK_COLOR];
    btn.titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btn addTarget:target action:selector forControlEvents:events];
    return btn;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = DARK_HIGHLIGHT_COLOR;
    } else {
        self.backgroundColor = DARK_COLOR;
    }
}

@end