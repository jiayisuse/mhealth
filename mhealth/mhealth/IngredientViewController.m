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
    
    ingredients = [NSMutableArray arrayWithObjects:@"Eggplant", @"Mushroom", @"Potato", @"Banana", @"Chicken Wing", @"Onion", @"Cucumber", @"Apple", @"Magon", @"Pork", @"Beans", @"Daikon", @"Tofu", nil];
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
    self.revealViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
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
    cell.textLabel.text = [ingredients objectAtIndex:indexPath.row];
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 160, cell.textLabel.frame.size.height)];
    cell.detailTextLabel.text = @"x3";
    cell.imageView.image = [UIImage imageNamed:@"banana.png"];
    cell.leftDaysLabel.text = [NSString stringWithFormat:@"%ld days", (long)indexPath.row];
    
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

@end