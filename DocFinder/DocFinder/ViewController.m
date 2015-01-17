//
//  ViewController.m
//  DocFinder
//
//  Created by Mason Wolters on 1/17/15.
//  Copyright (c) 2015 Big Head Applications. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [PFCloud callFunctionInBackground:@"twilioTest" withParameters:@{@"phoneNumber": @"+16165027765", @"message": @"Testing"} block:^(id object, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
