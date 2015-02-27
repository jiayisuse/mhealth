//
//  PopUpViewController.m
//  mhealth
//
//  Created by jiayi on 2/26/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopUpViewController.h"
#import "ViewController.h"
#import "BlueButton.h"
#import "IGLDropDownMenu.h"
#import "Global.h"

extern NSArray *ingredientDict;

@interface PopUpViewController () <IGLDropDownMenuDelegate>

@property (strong, nonatomic) IGLDropDownMenu *unitMenu;
@property (strong, nonatomic) AutocompletionTableView *autoCompleter;

@end

@implementation PopUpViewController {
    BlueButton *saveBtn;
    CGFloat viewY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popUpView.layer.cornerRadius = 5.0f;
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [self.closeImage addGestureRecognizer:closeTap];
    self.closeImage.userInteractionEnabled = YES;
    self.titleLabel.text = @"New";
    
    saveBtn = [BlueButton newButton:self action:@selector(onSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 30;
    saveBtn.frame = CGRectMake((self.popUpView.frame.size.width - btnWidth) / 2, self.popUpView.frame.size.height - 20 - btnHeight, btnWidth, btnHeight);
    saveBtn.layer.cornerRadius = 5.0;
    [self.popUpView addSubview:saveBtn];
    
    // init auto completer
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
    [options setValue:[NSNumber numberWithBool:NO] forKey:ACOCaseSensitive];
    [options setValue:nil forKey:ACOUseSourceFont];
    [options setValue:[NSNumber numberWithBool:NO] forKey:ACOHighlightSubstrWithBold];
    self.autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.ingredientText
                                                                   position:CGPointMake(self.ingredientText.frame.origin.x + self.popUpView.frame.origin.x, self.ingredientText.frame.origin.y + self.popUpView.frame.origin.y)
                                                           inViewController:self
                                                                withOptions:options];
    self.autoCompleter.autoCompleteDelegate = self;
    self.autoCompleter.suggestionsDictionary = ingredientDict;
    
    viewY = self.view.frame.origin.y;
    
    NSArray *units = [NSArray arrayWithObjects:@".Num", @".Lbs", nil];
    NSMutableArray *unitItems = [[NSMutableArray alloc] init];
    for (NSString *unit in units) {
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:unit];
        item.textLabel.textAlignment = NSTextAlignmentCenter;
        item.textLabel.textColor = BLUE_COLOR;
        [item.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        [unitItems addObject:item];
    }
    self.unitMenu = [[IGLDropDownMenu alloc] init];
    self.unitMenu.menuText = @"Unit";
    self.unitMenu.menuButton.textLabel.backgroundColor = BLUE_HIGHLIGHT_COLOR;
    self.unitMenu.menuButton.textLabel.textColor = [UIColor blackColor];
    self.unitMenu.menuButton.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.unitMenu.menuButton.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.unitMenu.dropDownItems = unitItems;
    [self.unitMenu setFrame:CGRectMake(self.popUpView.frame.size.width / 2 + 25, self.amountText.frame.origin.y, 50, self.amountText.frame.size.height)];
    self.unitMenu.delegate = self;
    self.unitMenu.paddingLeft = 0;
    //self.unitMenu.gutterY = 1;
    [self.unitMenu reloadView];
    [self.popUpView addSubview:self.unitMenu];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //move up by 80 units
    CGRect rect = CGRectMake(0.0f, -60, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (void)resumeView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, viewY, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        [self resumeView];
    }
    if (![[touch view] isKindOfClass:[IGLDropDownMenu class]] && self.unitMenu.expanding) {
        self.unitMenu.expanding = NO;
        [self.unitMenu foldView];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)onSaveButton:(id)sender {
    NSLog(@"button click!!!");
}

- (void)closeView:(UITapGestureRecognizer *)recognizer {
    if (self.delegate) {
        [self.delegate fetchPopUpData:@"hoho"];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

//-----------------------------------------------------

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index {
    
}

//-----------------------------------------------------
- (NSArray*) autoCompletion:(AutocompletionTableView *)completer suggestionsFor:(NSString *)string {
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return ingredientDict;
}

- (void) autoCompletion:(AutocompletionTableView *) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index {
    // invoked when an available suggestion is selected
    NSLog(@"%@ - Suggestion chosen: %d", completer, index);
}

@end