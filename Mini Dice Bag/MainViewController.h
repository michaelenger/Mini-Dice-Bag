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
@property (strong, nonatomic) IBOutlet UILabel *modifierLabel;
@property (strong, nonatomic) IBOutlet UIStepper *modifierStepper;
@property (strong, nonatomic) IBOutlet UIView *numberButtonContainerView;

- (IBAction)dieTapped:(id)sender;
- (IBAction)modifierChanged:(id)sender;
- (IBAction)numberTapped:(id)sender;
- (IBAction)viewTapped:(id)sender;

@end
