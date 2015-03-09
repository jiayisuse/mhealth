//
//  IngredientViewController.m
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IngredientViewController.h"
#import "RecipeWebViewController.h"
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
    
    self.navigationItem.title = @"Ingredients";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.siderbarBtn;
    self.navigationItem.rightBarButtonItem = self.recipeBtn;
    
    ingredients = [[NSMutableArray alloc] init];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
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
        UILabel *leftDaysLabel = [[UILabel alloc] init];
        //UILabel *leftDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 140, 10, 100, 40)];
        leftDaysLabel.backgroundColor = [UIColor clearColor];
        leftDaysLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:leftDaysLabel];
        leftDaysLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewDict = @{ @"leftDaysLabel":leftDaysLabel };
        NSArray *constraintPos_H = [NSLayoutConstraint constraintsWithVisualFormat:@"|[leftDaysLabel]-15-|" options:0 metrics:nil views:viewDict];
        NSArray *constraintPos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[leftDaysLabel]-|" options:0 metrics:nil views:viewDict];
        NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"[leftDaysLabel(30)]" options:0 metrics:nil views:viewDict];
        NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftDaysLabel(30)]" options:0 metrics:nil views:viewDict];
        [cell.contentView addConstraints:constraintPos_H];
        [cell.contentView addConstraints:constraintPos_V];
        [leftDaysLabel addConstraints:constraint_H];
        [leftDaysLabel addConstraints:constraint_V];
        cell.leftDaysLabel = leftDaysLabel;
    }
    Ingredient *ingredient = ingredients[indexPath.row];
    cell.textLabel.text = ingredient.name;
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 160, cell.textLabel.frame.size.height)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", ingredient.amount, ingredient.unit];
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ingredient.name]];
    cell.imageView.image = icon != nil ? icon : [UIImage imageNamed:@"Empty.png"];
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
    if (!self.tableView.editing)
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


// -------------------------- Button Actions --------------------------

- (IBAction)onRecipeBtn:(id)sender {
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)onCancelBtn:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self updateButtonsToMatchTableState];
}

// http://allrecipes.com/search/default.aspx?qt=n&rt=r&wt=tomato%20potato%20pork&pqt=k&ms=0&fo=0&nCal=490&nCarb=75&nFat=50&nExt=0

- (IBAction)onGoBtn:(id)sender {
    NSMutableString *URL = [NSMutableString new];
    
    BOOL suggestion = [[NSUserDefaults standardUserDefaults] boolForKey:AUTORECIPE_KEY];
    if (suggestion)
        [URL setString:@"http://allrecipes.com/search/default.aspx?qt=n&rt=r&wt="];
    else
        [URL setString:@"http://m.allrecipes.com/search/results/?wt="];
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    for (int i = 0; i < [selectedRows count] - 1; i++) {
        NSIndexPath *indexPath = selectedRows[i];
        [URL appendFormat:@"%@%%20", ((Ingredient *)ingredients[indexPath.row]).name];
    }
    NSIndexPath *indexPath = [selectedRows lastObject];
    [URL appendString:((Ingredient *)ingredients[indexPath.row]).name];
    if (suggestion) {
        [URL appendString:@"&pqt=k&ms=0&fo=0&"];
        float BMI = (ME.weight * 0.45) / ME.height / ME.height;
        NSLog(@"BMI %f", BMI);
        float ratio = (60 - BMI - ([ME.gender isEqualToString:@"Male"] ? 2 : 0)) / 60;
        int calories = ratio * 1000;
        int fat = ratio * 100;
        int carbon = ratio * 150;
        [URL appendFormat:@"nCal=%d&nCarb=%d&nFat=%d&nExt=0", calories, carbon, fat];
    } else
        [URL appendString:@"&sort=re&page=1"];
    
    NSLog(@"weight %f, %@", ME.weight, URL);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecipeWebViewController *newView = [storyboard instantiateViewControllerWithIdentifier:@"recipeWebView"];
    newView.recipeURL = URL;
    [self.navigationController pushViewController:newView animated:YES];
}

- (void)updateButtonsToMatchTableState {
    if (self.tableView.editing) {
        self.navigationItem.leftBarButtonItem = self.cancelBtn;
        self.navigationItem.rightBarButtonItem = self.goBtn;
    } else {
        // Not in editing mode.
        self.navigationItem.leftBarButtonItem = self.siderbarBtn;
        self.navigationItem.rightBarButtonItem = self.recipeBtn;
        // Show the edit button, but disable the edit button if there's nothing to edit.
        if (ingredients.count > 0) {
            self.recipeBtn.enabled = YES;
        } else {
            self.recipeBtn.enabled = NO;
        }
    }
}


// -------------------------- Local Notification --------------------------

- (void)reloadNotification {
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (Ingredient *ingredient in ingredients) {
        long int nNotifications = 0;
        if (ingredient.leftDays > 3)
            nNotifications = NotifyBeforeDays + 1;
        else if (ingredient.leftDays <= 3 && ingredient.leftDays >= 0)
            nNotifications = ingredient.leftDays + 1;
        if (64 - [[[UIApplication sharedApplication] scheduledLocalNotifications] count] < nNotifications)
            break;
        
        if (![self hasNotificationFor:ingredient]) {
            for (int daysBefore = -1; daysBefore <= NotifyBeforeDays && daysBefore <= ingredient.leftDays; daysBefore++) {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.fireDate = [self expNotifyDateAdv:(ingredient.leftDays - daysBefore)];
                notification.alertBody = [self expNotifyBody:daysBefore ingredient:ingredient];
                notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                notification.userInfo = [NSDictionary dictionaryWithObject:NOTIFICATION_DEFAULT_KEY(ingredient) forKey:INGREDIENT_NOTIFICATION_KEY];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                [self storeNotificationFor:ingredient];
                NSLog(@"body: %@", notification.alertBody);
                NSLog(@"date: %@", [notification.fireDate description]);
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