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
#import "Ingredient.h"
#import "WebService.h"
#import "Global.h"

enum MODE {
    EDIT_MODE,
    SHOPPING_MODE,
};

extern User *ME;

@implementation ShoppingViewController {
    NSMutableArray *ingredients;
    NSMutableArray *selectedItems;
    NSIndexPath *removeIndex;
    NSTimeInterval expInterval;
    enum MODE mode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _siderbarBtn.target = self.revealViewController;
    _siderbarBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = REAR_VIEW_WIDTH;
    self.revealViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.navigationItem.title = @"Editing";
    self.navigationItem.hidesBackButton = YES;
    [self setDefaultButtons];
    
    ingredients = [NSMutableArray array];
    selectedItems = [[NSMutableArray alloc] init];
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // defaultBorderColor = UIColorFromRGB(0xe1e1e1).CGColor;
    self.tableView.separatorColor = UIColorFromRGB(0xe1e1e1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newRow)
                                                 name:@"newRow"
                                               object:nil];
    
    mode = EDIT_MODE;
    self.datePicker.hidden = YES;
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
    
    Ingredient *ingredient = [ingredients objectAtIndex:indexPath.row];
    cell.textLabel.text = ingredient.name;
    [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 160, cell.textLabel.frame.size.height)];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", ingredient.amount, ingredient.unit];
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
    if (mode == EDIT_MODE) {
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
    } else {
        self.datePicker.hidden = NO;
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        removeIndex = indexPath;
        self.navigationItem.title = @"Pick Exp. Date";
        self.navigationItem.rightBarButtonItem = self.doneBtn;
    }
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
    if ([ingredients count] == 0)
        self.saveButton.hidden = YES;
}

- (IBAction)onAddButton:(id)sender {
    [ViewController popUpView:@"PopUpView" titleLabel:@"New Ingredient" currentView:self];
}

- (IBAction)onEditButton:(id)sender {
    mode = EDIT_MODE;
    self.navigationItem.rightBarButtonItem = self.addBtn;
    if ([ingredients count])
        self.saveButton.hidden = NO;
    self.navigationItem.title = @"Editing";
    if (!self.datePicker.hidden)
        self.datePicker.hidden = YES;
    [self.tableView deselectRowAtIndexPath:removeIndex animated:NO];
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
    [ingredients addObject:(Ingredient *)data];
}

- (void)newRow {
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:([ingredients count] - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    if (self.saveButton.hidden)
        self.saveButton.hidden = NO;
}

- (IBAction)onSaveButtononSaveButton:(id)sender {
    [self onCancelButton:sender];
    mode = SHOPPING_MODE;
    self.navigationItem.rightBarButtonItem = self.editBtn;
    self.saveButton.hidden = YES;
    self.navigationItem.title = @"Shopping >>>";
}

- (IBAction)datePickerChanged:(id)sender {
    /*
    UIDatePicker *expDatePicker = sender;
    expInterval = [expDatePicker.date timeIntervalSince1970];
    */
}

- (IBAction)onDoneButton:(id)sender {
    WebService *ws = [[WebService alloc] initWithPHPFile:@"new_ingredient.php"];
    ws.delegate = self;
    Ingredient *ingredient = ingredients[removeIndex.row];
    NSLog(@"email = %@, fid = %ld", ME.email, ME.FID);
    NSArray *valueArray = [NSArray arrayWithObjects:ingredient.name, ingredient.amount, ingredient.unit,  @([self.datePicker.date timeIntervalSince1970]).stringValue, @(ME.FID).stringValue, ME.username, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:@"NAME", @"AMOUNT", @"UNIT", @"EXP_DATE", @"FID", USERNAME_KEY, nil];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [ws setPostData:postDict];
    [ws sendRequest];
}

- (void)dataReturned:(NSData *)data {
    NSLog(@"json:\n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *myID;
    NSString *errorMessage = [WebService jsonParse:data retData:&myID];
    NSLog(@"error message: %@", errorMessage);
    if ([errorMessage length] == 0) {
        self.navigationItem.rightBarButtonItem = self.editBtn;
        self.datePicker.hidden = YES;
        [ingredients removeObjectAtIndex:removeIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[removeIndex] withRowAnimation:UITableViewRowAnimationFade];
        if ([ingredients count] == 0)
            self.saveButton.hidden = YES;
    }
}

@end