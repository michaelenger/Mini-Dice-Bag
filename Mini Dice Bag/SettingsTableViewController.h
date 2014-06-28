//
//  SettingsTableViewController.h
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/06/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *biasControl;
@property (strong, nonatomic) IBOutlet UISwitch *shakeSwitch;

@end
