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


@implementation IngredientViewController {
    NSMutableArray *ingredients;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize table data
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:@"Ingredients"];
    self.navigationItem.titleView = titleText;
    self.navigationItem.hidesBackButton = YES;
    
    ingredients = [[NSMutableArray alloc] init];
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
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
        [ingredients removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pullIngredients:(UIRefreshControl*)refreshControl {
    [refreshControl beginRefreshing];
    
    // pull data from server
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
    [ingredients removeAllObjects];
    if ([errorMessage length] == 0) {
        for (NSDictionary *jsonIngredient in queryIngredients) {
            [ingredients addObject:[Ingredient dictToIngredient:jsonIngredient]];
        }
        NSSortDescriptor *dsc = [[NSSortDescriptor alloc] initWithKey:@"leftDays" ascending:YES];
        ingredients = [NSMutableArray arrayWithArray:[ingredients sortedArrayUsingDescriptors:[NSArray arrayWithObjects:dsc, nil]]];
        [self.tableView reloadData];
    }
    [self.refreshControl endRefreshing];
}

@end