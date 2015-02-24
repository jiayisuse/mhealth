//
//  IngredientViewController.m
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "IngredientViewController.h"
#import "SWRevealViewController.h"

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
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    ingredients = [NSMutableArray arrayWithObjects:@"Eggplant", @"Mushroom", @"Potato", @"Banana", @"Chicken Wing", @"Onion", @"Cucumber", @"Apple", @"Magon", @"Pork", @"Beans", @"Daikon", @"Tofu", nil];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:INGREDIENT_TABLE_NAME];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:INGREDIENT_TABLE_NAME];
    }
    cell.textLabel.text = [ingredients objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"banana.png"];
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

@end