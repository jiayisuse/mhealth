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
#import "Global.h"

extern User *ME;
#define BUTTON_BACKGROUND_COLOR     [UIColor colorWithWhite:0.3 alpha:1.0]
#define BUTTON_HIGHLIGHTED_COLOR    [UIColor colorWithWhite:0.4 alpha:1.0]

@interface DarkButton : UIButton

@end

@implementation DarkButton

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = BUTTON_HIGHLIGHTED_COLOR;
    }
    else {
        self.backgroundColor = BUTTON_BACKGROUND_COLOR;
    }
}

@end

@implementation RearViewController {
    NSMutableArray *userItems;
}

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.25 alpha:0.9];
    
    userItems = [NSMutableArray arrayWithObjects:ME.username, ME.email, nil];
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
    
    /*
    DarkButton *logoutBtn = [DarkButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn addTarget:self
                  action:@selector(logout:)
        forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"logout" forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    logoutBtn.titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    logoutBtn.layer.cornerRadius = 5.0;
    logoutBtn.frame = CGRectMake(REAR_VIEW_WIDTH - 70.0, 10.0, 60.0, 30.0);
    [view addSubview:logoutBtn];
     */
    
    UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 60, 60)];
    profileImage.image = [UIImage imageNamed:@"carrot.png"];
    [profileImage.layer setBorderColor: [[UIColor colorWithWhite:0.3 alpha:1.0] CGColor]];
    [profileImage.layer setBorderWidth: 1.0];
    profileImage.layer.cornerRadius = 1.0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    singleTap.numberOfTapsRequired = 1;
    [profileImage setUserInteractionEnabled:YES];
    [profileImage addGestureRecognizer:singleTap];
    [view addSubview:profileImage];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 150, 30)];
    [usernameLabel setFont:[UIFont systemFontOfSize:15.0]];
    usernameLabel.text = ME.username;
    usernameLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.adjustsFontSizeToFitWidth = YES;
    usernameLabel.adjustsLetterSpacingToFitWidth = YES;
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [usernameLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapDup = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    [usernameLabel addGestureRecognizer:singleTapDup];
    [view addSubview:usernameLabel];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                    message:@"You going to logout"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
    case 0:
        break;
    case 1:
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:USERNAME_KEY];
            [userDefaults removeObjectForKey:USEREMAIL_KEY];
            [userDefaults removeObjectForKey:USERID_KEY];
            [ViewController replaceView:@"initialView" currentView:self];
        }
        break;
    }
}

@end