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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGoButton:(id)sender {
    self.helloLabel.text = @"hello guys";
}

@end
