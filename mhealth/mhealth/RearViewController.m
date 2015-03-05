//
//  RearViewController.m
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RearViewController.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "DarkButton.h"
#import "Global.h"

extern User *ME;

@implementation RearViewController {
    NSMutableArray *userItems;
    DarkButton *joinBtn;
    UIAlertView *joinAlert;
    UIAlertView *logoutAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.25 alpha:0.9];
    
    userItems = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@ @ %@", ME.username, ME.familyName], ME.email, nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 20.0f;
    if ([tableView isEqual:self.tableView]) {
        result = 40.0f;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REAR_TABLE_NAME];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REAR_TABLE_NAME];
    }
    cell.textLabel.text = [userItems objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, REAR_VIEW_WIDTH, 100.0)];
    
    joinBtn = [DarkButton buttonWithType:UIButtonTypeCustom];
    [joinBtn addTarget:self
                  action:@selector(joinFamily:)
        forControlEvents:UIControlEventTouchUpInside];
    [joinBtn setTitle:@"Join" forState:UIControlStateNormal];
    [joinBtn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    joinBtn.titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [joinBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    joinBtn.layer.cornerRadius = 5.0;
    joinBtn.frame = CGRectMake(REAR_VIEW_WIDTH - 57.0, 12.0, 45.0, 26.0);
    [view addSubview:joinBtn];
    
    UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 60, 60)];
    profileImage.image = [UIImage imageNamed:@"carrot_profile.png"];
    [profileImage.layer setBorderColor: [[UIColor colorWithWhite:0.3 alpha:1.0] CGColor]];
    [profileImage.layer setBorderWidth: 1.0];
    profileImage.layer.cornerRadius = 1.0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    singleTap.numberOfTapsRequired = 1;
    [profileImage setUserInteractionEnabled:YES];
    [profileImage addGestureRecognizer:singleTap];
    [view addSubview:profileImage];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 14, 100, 30)];
    [usernameLabel setFont:[UIFont systemFontOfSize:15.0]];
    usernameLabel.text = ME.username;
    usernameLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.adjustsFontSizeToFitWidth = YES;
    usernameLabel.adjustsLetterSpacingToFitWidth = YES;
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [usernameLabel setUserInteractionEnabled:YES];
    [usernameLabel addGestureRecognizer:singleTap];
    [view addSubview:usernameLabel];
    
    UILabel *familyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 36, 100, 30)];
    [familyNameLabel setFont:[UIFont systemFontOfSize:15.0]];
    familyNameLabel.text = ME.familyName;
    familyNameLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    familyNameLabel.backgroundColor = [UIColor clearColor];
    familyNameLabel.adjustsFontSizeToFitWidth = YES;
    familyNameLabel.adjustsLetterSpacingToFitWidth = YES;
    familyNameLabel.textAlignment = NSTextAlignmentLeft;
    [familyNameLabel setUserInteractionEnabled:YES];
    [familyNameLabel addGestureRecognizer:singleTap];
    [view addSubview:familyNameLabel];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    DarkButton *clearBtn = [DarkButton newButton:self action:@selector(clearCache:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"Clear Cache" forState:UIControlStateNormal];
    clearBtn.translatesAutoresizingMaskIntoConstraints = NO;
    clearBtn.frame = CGRectMake(10.0, 20.0, REAR_VIEW_WIDTH - 20, 40.0);
    [view addSubview:clearBtn];
    
    /*
    NSDictionary *viewDict = @{ @"clearBtn":clearBtn };
    NSArray *constraintPos_H = [NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[clearBtn]-10-|" options:0 metrics:nil views:viewDict];
    NSArray *constraintPos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[clearBtn]" options:0 metrics:nil views:viewDict];
    [view addConstraints:constraintPos_H];
    [view addConstraints:constraintPos_V];
    */
    
    return view;
}

- (void)logout:(id)sender {
    logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                             message:@"You going to logout"
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Logout", nil];
    [logoutAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"lalalala");
    switch (buttonIndex) {
    case 0:
        break;
    case 1:
        {
            if (alertView == logoutAlert) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:USERNAME_KEY];
                [userDefaults removeObjectForKey:USEREMAIL_KEY];
                [userDefaults removeObjectForKey:USERID_KEY];
                [userDefaults removeObjectForKey:USERFID_KEY];
                [userDefaults removeObjectForKey:USERFNAME_KEY];
                
                NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
                for (UILocalNotification *notification in notifications) {
                    NSString *notificationID = notification.userInfo[INGREDIENT_NOTIFICATION_KEY];
                    [userDefaults removeObjectForKey:notificationID];
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
                }
                
                [ViewController replaceView:@"initialView" currentView:self];
            } else {
                NSString *familyName = [joinAlert textFieldAtIndex:0].text;
                if (familyName.length == 0) {
                    [self alertInfo:@"Error" text:@"Please enter family name"];
                    return;
                }
                
                NSString *password = [joinAlert textFieldAtIndex:1].text;
                if (password.length == 0) {
                    [self alertInfo:@"Error" text:@"Please enter password"];
                    return;
                }
                
                WebService *ws = [[WebService alloc] initWithPHPFile:@"join_family.php"];
                ws.delegate = self;
                NSArray *keyArray = [NSArray arrayWithObjects:FAMILYNAME_KEY, FAMILYPASSWORD_KEY, USERID_KEY, nil];
                NSArray *valueArray = [NSArray arrayWithObjects:familyName, password, @(ME.UID).stringValue, nil];
                NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
                [ws setPostData:postDict];
                [ws sendRequest];
            }
        }
        break;
    }
}

- (void)alertInfo:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertInfo:(NSString *)title text:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)clearCache:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSString *notificationID = notification.userInfo[INGREDIENT_NOTIFICATION_KEY];
        [userDefaults removeObjectForKey:notificationID];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [self alertInfo:@"Clear Finished"];
}

- (void)joinFamily:(id)sender {
    joinAlert = [[UIAlertView alloc] initWithTitle:@"Join Another Family" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Join", nil];
    joinAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [joinAlert textFieldAtIndex:0].placeholder = @"Family Name";
    [joinAlert textFieldAtIndex:1].placeholder = @"Password";
    [joinAlert show];
}

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSArray *familyData;
    NSString *errorMessage = [WebService jsonParse:data retData:&familyData];
    NSLog(@"error message: %@, id = %@", errorMessage, familyData[0]);
    if ([errorMessage length] == 0) {
        ME.FID = [familyData[0] intValue];
        ME.familyName = [joinAlert textFieldAtIndex:0].text;
        [ME saveDefaults];
        [ViewController replaceView:@"mainView" currentView:self];
    } else {
        [self alertInfo:@"Error" text:errorMessage];
    }
}

@end