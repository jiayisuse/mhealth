//
//  AppDelegate.m
//  mhealth
//
//  Created by jiayi on 2/19/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"

extern NSArray *ingredientDict;
extern User *ME;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ME = [[User alloc] init];
    NSString *username = [userDefaults stringForKey:USERNAME_KEY];
    if (username != nil) {
        ME.username = username;
        ME.email = [userDefaults stringForKey:USEREMAIL_KEY];
        ME.UID = [userDefaults integerForKey:USERID_KEY];
        ME.FID = [userDefaults integerForKey:USERFID_KEY];
        ME.familyName = [userDefaults stringForKey:USERFNAME_KEY];
        ME.height = [userDefaults floatForKey:USERHEIGHT_KEY];
        ME.weight = [userDefaults floatForKey:USERWEIGHT_KEY];
        ME.gender = [userDefaults stringForKey:USERGENDER_KEY];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *mainView = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        self.window.rootViewController = mainView;
        [self.window makeKeyAndVisible];
    }
    
    ingredientDict = [NSArray arrayWithObjects:@"Apple", @"Banana", @"Beans", @"Beef", @"Blueberry", @"Bread", @"Broccoli", @"Burger", @"Butter", @"Cake", @"Carrot", @"Cheese", @"Cherry", @"Chicken", @"Chicken Leg", @"Chicken Wing", @"Chips", @"Chocolate", @"Cola", @"Corn", @"Cucumber", @"Daikon", @"Donut", @"Egg", @"Eggplant", @"Fish", @"French Fries", @"Garlic", @"Grape", @"Green Onion", @"Green Pepper", @"Hotdog", @"Icecream", @"Lemon", @"Lettuce", @"Lime", @"Milk", @"Mushroom", @"Noodle", @"Orange Juice", @"Pear", @"Pineapple", @"Pinto Beans", @"Pizza", @"Potato", @"Red Onion", @"Red Pepper", @"Sandwitch", @"Sausage", @"Shrimp", @"Soda", @"Strawberry", @"Tofu", @"Tomato", @"Turkey", @"Watermelon", @"White Rice", @"Wine", @"Yogurt", nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
