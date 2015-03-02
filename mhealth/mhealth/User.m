//
//  User.m
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Global.h"

@implementation User

@synthesize email;
@synthesize username;
@synthesize UID;

- (void)saveDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.username forKey:USERNAME_KEY];
    [userDefaults setObject:self.email forKey:USEREMAIL_KEY];
    [userDefaults setInteger:self.UID forKey:USERID_KEY];
    [userDefaults setInteger:self.FID forKey:USERFID_KEY];
}

@end