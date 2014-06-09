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
@property (strong, nonatomic) IBOutlet UIView *diceButtonContainerView;
@property (strong, nonatomic) IBOutlet UILabel *mainResultLabel;
@property (strong, nonatomic) IBOutlet UIView *numberButtonContainerView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;

- (IBAction)dieTapped:(id)sender;
- (IBAction)numberTapped:(id)sender;
- (IBAction)overlayTapped:(id)sender;
- (IBAction)viewTapped:(id)sender;

@end
