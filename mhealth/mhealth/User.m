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
    [userDefaults setObject:self.familyName forKey:USERFNAME_KEY];
    [userDefaults setFloat:self.height forKey:USERHEIGHT_KEY];
    [userDefaults setFloat:self.weight forKey:USERWEIGHT_KEY];
    [userDefaults setObject:self.gender forKey:USERGENDER_KEY];
}

+ (void)clearDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USERNAME_KEY];
    [userDefaults removeObjectForKey:USEREMAIL_KEY];
    [userDefaults removeObjectForKey:USERID_KEY];
    [userDefaults removeObjectForKey:USERFID_KEY];
    [userDefaults removeObjectForKey:USERFNAME_KEY];
    [userDefaults removeObjectForKey:USERHEIGHT_KEY];
    [userDefaults removeObjectForKey:USERWEIGHT_KEY];
    [userDefaults removeObjectForKey:USERGENDER_KEY];
}

@end