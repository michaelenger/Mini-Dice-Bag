//
//  SettingsTableViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/06/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "SettingsTableViewController.h"

@implementation SettingsTableViewController
@synthesize biasControl, shakeSwitch;

#pragma mark UITableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *biasString = [userDefaults stringForKey:@"bias"];
NSLog(@"BIAS: %@", biasString);
    if ([biasString isEqualToString:@"low"]) {
        self.biasControl.selectedSegmentIndex = 1;
    } else if ([biasString isEqualToString:@"high"]) {
        self.biasControl.selectedSegmentIndex = 2;
    } else {
        self.biasControl.selectedSegmentIndex = 0;
    }

    self.shakeSwitch.on = [userDefaults boolForKey:@"shake"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    switch (self.biasControl.selectedSegmentIndex) {
        case 1:
            [userDefaults setObject:@"low" forKey:@"bias"];
            break;
        case 2:
            [userDefaults setObject:@"high" forKey:@"bias"];
            break;
        default:
            [userDefaults setObject:@"none" forKey:@"bias"];
            break;
    }

    [userDefaults setBool:self.shakeSwitch.on forKey:@"shake"];
    [userDefaults synchronize];
}

@end
