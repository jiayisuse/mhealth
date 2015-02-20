//
//  ViewController.m
//  mhealth
//
//  Created by jiayi on 2/19/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createLabelTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.createLabel addGestureRecognizer:tapGestureRecognizer];
    self.createLabel.userInteractionEnabled = YES;
}

- (void) createLabelTapped: (UITapGestureRecognizer *)recognizer {
    //Code to handle the gesture
    NSLog(@"I am in handleTapFrom method");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGoButton:(id)sender {
    
}

@end
