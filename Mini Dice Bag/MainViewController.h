//
//  ViewController.h
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *detailResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainResultLabel;

- (IBAction)dieTapped:(id)sender;
- (IBAction)numberTapped:(id)sender;

@end
