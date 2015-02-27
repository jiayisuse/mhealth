//
//  ShoppingViewController.m
//  mhealth
//
//  Created by jiayi on 2/23/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "Global.h"

@implementation ShoppingViewController {
    NSMutableArray *ingredients;
    NSMutableArray *selectedItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
    self.revealViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50,50)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setAdjustsFontSizeToFitWidth:YES];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [titleText setText:@"Shopping List"];
    self.navigationItem.titleView = titleText;
    self.navigationItem.hidesBackButton = YES;
    [self setDefaultButtons];
    
    ingredients = [NSMutableArray arrayWithObjects:@"Eggplant", @"Mushroom", @"Potato", @"Banana", @"Chicken Wing", @"Onion", @"Cucumber", @"Apple", @"Magon", @"Pork", @"Beans", @"Daikon", @"Tofu", nil];
    selectedItems = [[NSMutableArray alloc] init];
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // defaultBorderColor = UIColorFromRGB(0xe1e1e1).CGColor;
    self.tableView.separatorColor = UIColorFromRGB(0xe1e1e1);
    // self.deleteBtn.title = @"Delete";
    // self.cancelBtn.title = @"Cancel";
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:INGREDIENT_TABLE_NAME];
        //[cell.contentView.layer setBorderWidth:0.5f];
    }
    
    cell.textLabel.text = [ingredients objectAtIndex:indexPath.row];
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 160, cell.textLabel.frame.size.height)];
    cell.detailTextLabel.text = @"x3";
    if ([selectedItems containsObject:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"checkbox_check.png"];
        cell.contentView.backgroundColor = UIColorFromRGB(0xe6f0fb);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.contentView.layer setBorderColor:UIColorFromRGB(0x7dbaff).CGColor];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"checkbox_uncheck.png"];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //[cell.contentView.layer setBorderColor:defaultBorderColor];
    }
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxTap:)];
    [cell.imageView addGestureRecognizer:imageTap];
    cell.imageView.userInteractionEnabled = YES;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)checkboxTap:(UIGestureRecognizer *)recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    if ([selectedItems containsObject:indexPath]) {
        [selectedItems removeObject:indexPath];
        if ([selectedItems count] == 0) {
            [self setDefaultButtons];
        }
    } else {
        [selectedItems addObject:indexPath];
        if ([selectedItems count] == 1) {
            [self setEditButtons];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)onCancelButton:(id)sender {
    NSMutableArray *tempIndexPathes = [NSMutableArray arrayWithArray:selectedItems];
    [selectedItems removeAllObjects];
    [self.tableView reloadRowsAtIndexPaths:tempIndexPathes withRowAnimation:UITableViewRowAnimationNone];
    [self setDefaultButtons];
}

- (IBAction)onDeleteButton:(id)sender {
    for (NSIndexPath *indexPath in selectedItems)
        [ingredients removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:selectedItems withRowAnimation:UITableViewRowAnimationNone];
    [selectedItems removeAllObjects];
    [self setDefaultButtons];
}

- (IBAction)onAddButton:(id)sender {
    [ViewController popUpView:@"PopUpView" titleLabel:@"New Ingredient" currentView:self];
}

- (void)setEditButtons {
    self.navigationItem.rightBarButtonItem = self.deleteBtn;
    self.navigationItem.leftBarButtonItem = self.cancelBtn;
}

- (void)setDefaultButtons {
    self.navigationItem.leftBarButtonItem = self.siderbarBtn;
    self.navigationItem.rightBarButtonItem = self.addBtn;
}

- (void)fetchPopUpData:(id)data {
    NSLog(@"got your! %@", data);
}

@end