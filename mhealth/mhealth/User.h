//
//  User.h
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_User_h
#define mhealth_User_h

@interface User : NSObject {
    NSString *username;
    NSString *email;
    long int UID;
}

@property (copy) NSString *username;
@property (copy) NSString *email;
@property long int UID;
@property long int FID;

- (void)saveDefaults;

@end

#endif
