//
//  IngredientViewController.m
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngredientViewController.h"
#import "Ingredient.h"
#import "WebService.h"
#import "SWRevealViewController.h"
#import "Global.h"

@interface myTableViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *leftDaysLabel;

@end

@implementation myTableViewCell

@end

enum WEBSERVICE_OP {
    OP_QUERY,
    OP_DELETE,
};

@implementation IngredientViewController {
    NSMutableArray *ingredients;
    NSIndexPath *removeIndex;
    enum WEBSERVICE_OP webserviceOp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize table data
    
    /*
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:@"Ingredients"];
     */
    self.navigationItem.title = @"Ingredients";
    self.navigationItem.hidesBackButton = YES;
    
    ingredients = [[NSMutableArray alloc] init];
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.tableView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
    self.revealViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullIngredients:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    [self pullIngredients:refreshControl];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ingredients count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = 20.0f;
    if ([tableView isEqual:self.tableView]) {
        result = 60.0f;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myTableViewCell *cell = (myTableViewCell *)[tableView dequeueReusableCellWithIdentifier:INGREDIENT_TABLE_NAME];
    if (cell == nil) {
        cell = [[myTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:INGREDIENT_TABLE_NAME];
        UILabel *leftDaysLable = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 140, 10, 100, 40)];
        leftDaysLable.backgroundColor = [UIColor clearColor];
        leftDaysLable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:leftDaysLable];
        cell.leftDaysLabel = leftDaysLable;
    }
    Ingredient *ingredient = ingredients[indexPath.row];
    cell.textLabel.text = ingredient.name;
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 160, cell.textLabel.frame.size.height)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", ingredient.amount, ingredient.unit];
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ingredient.name]];
    cell.imageView.image = icon != nil ? icon : [UIImage imageNamed:@"Empty.png"];
    //cell.imageView.image = [UIImage imageNamed:@"Banana.png"];
    cell.leftDaysLabel.text = [NSString stringWithFormat:@"%ld days", (long)ingredient.leftDays];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        removeIndex = indexPath;
        Ingredient *ingredient = ingredients[indexPath.row];
        webserviceOp = OP_DELETE;
        WebService *ws = [[WebService alloc] initWithPHPFile:@"delete.php"];
        ws.delegate = self;
        NSArray *valueArray = [NSArray arrayWithObjects:@(ingredient.IID).stringValue, nil];
        NSArray *keyArray = [NSArray arrayWithObjects:DB_INGREDIENT_ID_KEY, nil];
        NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
        [ws setPostData:postDict];
        [ws sendRequest];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pullIngredients:(UIRefreshControl*)refreshControl {
    [refreshControl beginRefreshing];
    
    // pull data from server
    webserviceOp = OP_QUERY;
    WebService *ws = [[WebService alloc] initWithPHPFile:@"query.php"];
    ws.delegate = self;
    NSArray *valueArray = [NSArray arrayWithObjects:@(ME.FID).stringValue, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:@"FID", nil];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [ws setPostData:postDict];
    [ws sendRequest];
    
    [self.tableView reloadData];
}

- (void)dataReturned:(NSData *)data {
    NSMutableArray *queryIngredients = [[NSMutableArray alloc] init];
    NSString *errorMessage = [WebService jsonParse:data retData:&queryIngredients];
    if ([errorMessage length] == 0) {
        switch (webserviceOp) {
            case OP_QUERY: {
                [ingredients removeAllObjects];
                for (NSDictionary *jsonIngredient in queryIngredients) {
                    [ingredients addObject:[Ingredient dictToIngredient:jsonIngredient]];
                }
                NSSortDescriptor *dsc = [[NSSortDescriptor alloc] initWithKey:@"leftDays" ascending:YES];
                ingredients = [NSMutableArray arrayWithArray:[ingredients sortedArrayUsingDescriptors:[NSArray arrayWithObjects:dsc, nil]]];
                [self.tableView reloadData];
                [self reloadNotification];
                break;
            }
            case OP_DELETE: {
                Ingredient *ingredient = ingredients[removeIndex.row];
                if ([self hasNotificationFor:ingredient])
                    [self deleteNotificationFor:ingredient];
                
                [ingredients removeObjectAtIndex:removeIndex.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:removeIndex, nil] withRowAnimation:UITableViewRowAnimationLeft];
                [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
                [self.tableView addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
                break;
            }
            default:
                break;
        }
    }
    [self.refreshControl endRefreshing];
}

- (void)reloadNotification {
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (Ingredient *ingredient in ingredients) {
        int nNotifications = 0;
        if (ingredient.leftDays > 3)
            nNotifications = NotifyBeforeDays + 1;
        else if (ingredient.leftDays <= 3 && ingredient.leftDays >= 0)
            nNotifications = ingredient.leftDays + 1;
        if (64 - [[[UIApplication sharedApplication] scheduledLocalNotifications] count] < nNotifications)
            break;
        
        if (![self hasNotificationFor:ingredient]) {
            for (int daysBefore = -1; daysBefore <= NotifyBeforeDays && daysBefore < ingredient.leftDays; daysBefore++) {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.fireDate = [self expNotifyDateAdv:(ingredient.leftDays - daysBefore)];
                notification.alertBody = [self expNotifyBody:daysBefore ingredient:ingredient];
                notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                notification.userInfo = [NSDictionary dictionaryWithObject:NOTIFICATION_DEFAULT_KEY(ingredient) forKey:INGREDIENT_NOTIFICATION_KEY];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [self storeNotificationFor:ingredient];
                NSLog(@"body: %@", notification.alertBody);
                NSLog(@"date: %@\n", [notification.fireDate description]);
            }
        }
    }
}

- (BOOL)hasNotificationFor:(Ingredient *)ingredient {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *notificationKey = NOTIFICATION_DEFAULT_KEY(ingredient);
    return (BOOL)[userDefaults valueForKey:notificationKey];
}

- (void)storeNotificationFor:(Ingredient *)ingredient {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *notificationKey = NOTIFICATION_DEFAULT_KEY(ingredient);
    [userDefaults setBool:YES forKey:notificationKey];
}

- (void)deleteNotificationFor:(Ingredient *)ingredient {
    NSString *notificationKey = NOTIFICATION_DEFAULT_KEY(ingredient);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:notificationKey];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSString *notificationID = notification.userInfo[INGREDIENT_NOTIFICATION_KEY];
        if ([notificationID isEqualToString:notificationKey]) {
            NSLog(@"Delete %@", ingredient.name);
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (NSDate *)expNotifyDateAdv:(NSInteger)advDays {
    if (advDays == 0)
        return [[NSDate date] dateByAddingTimeInterval:5];
    else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone systemTimeZone]];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [comps setHour:2];
        [comps setMinute:0];
        [comps setSecond:0];
        NSDate *triggerDate = [cal dateFromComponents:comps];
        return [triggerDate dateByAddingTimeInterval:advDays * 24 * 60 * 60];
    }
}

- (NSString *)expNotifyBody:(NSInteger)leftDays ingredient:(Ingredient *)ingredient {
    NSLog(@"left day = %ld", (long)ingredient.leftDays);
    if (leftDays < 0)
        return [NSString stringWithFormat:@"%@ expired!", ingredient.name];
    if (leftDays == 0)
        return [NSString stringWithFormat:@"%@ TODAY", ingredient.name];
    if (leftDays == 1)
        return [NSString stringWithFormat:@"%@ 1 day left", ingredient.name];
    return [NSString stringWithFormat:@"%@ %ld days left", ingredient.name, (long)leftDays];
}

@end