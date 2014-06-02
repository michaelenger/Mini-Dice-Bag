//
//  ViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "MainViewController.h"
#import "D20.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@property (strong, nonatomic) NSTimer *rollTimer;
@property (strong, nonatomic) UIColor *selectedButtonBackgroundColor;

- (NSArray *)roll;
- (void)rollAnimated:(BOOL)animated;
- (void)rollThreaded;
- (void)showResults:(NSArray *)results detailed:(BOOL)detailed;

@end

@implementation MainViewController
@synthesize detailResultLabel, diceButtonContainerView, mainResultLabel, numberButtonContainerView, rollTimer, selectedButtonBackgroundColor;

int amount = 1;
int die = 20;
int rollCounter;

- (NSArray *)roll
{
    NSArray *results = [D20 detailedRoll:amount ofDie:die];
    return [results sortedArrayUsingSelector:@selector(compare:)];
}

- (void)rollAnimated:(BOOL)animated
{
    if (animated) {
        if (self.rollTimer && [self.rollTimer isValid]) {
            [self.rollTimer invalidate];
        }

        rollCounter = 5; // @todo: randomize this?
        [self showResults:[self roll] detailed:NO]; // prevents the delay effect when starting the timer
        self.rollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                          target:self
                                                        selector:@selector(rollThreaded)
                                                        userInfo:nil
                                                         repeats:YES];
    } else {
        [self showResults:[self roll] detailed:YES];
    }
}

- (void)rollThreaded
{
    if (--rollCounter <= 0) {
        [self showResults:[self roll] detailed:YES];
        [self.rollTimer invalidate];
    } else {
        [self showResults:[self roll] detailed:NO];
    }
}

- (void)showResults:(NSArray *)results detailed:(BOOL)detailed
{
    NSString *detailText = @"";
    int num;
    int total = 0;

    for (int i = 0; i < amount; i++) {
        num = [(NSNumber *)results[i] intValue];
        detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@" %d ", num]];
        total += num;
    }

    if (detailed) {
        detailResultLabel.text = amount <= 20 ? detailText : [NSString stringWithFormat:@"%dd%d", amount, die];
    }

    mainResultLabel.text = [NSString stringWithFormat:@"%d", total];
}

#pragma mark IBAction

- (IBAction)dieTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    die = [[button titleForState:UIControlStateNormal] intValue];

    for (int i = 0; i < [diceButtonContainerView.subviews count]; i++) {
        button = (UIButton *)[diceButtonContainerView.subviews objectAtIndex:i];

        if ([[button titleForState:UIControlStateNormal] intValue] == die) {
            button.layer.backgroundColor = self.selectedButtonBackgroundColor.CGColor;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }

    [self rollAnimated:YES];
}

- (IBAction)numberTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = [button titleForState:UIControlStateNormal];

    for (int i = 0; i < [numberButtonContainerView.subviews count]; i++) {
        button = (UIButton *)[numberButtonContainerView.subviews objectAtIndex:i];

        if ([[button titleForState:UIControlStateNormal] isEqualToString:title]) {
            button.layer.backgroundColor = self.selectedButtonBackgroundColor.CGColor;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }

    if ([title isEqualToString:@"+"]) {
        amount = amount <= 5 ? 6 : amount + 1;
    } else {
        amount = [title intValue];
    }

    [self rollAnimated:YES];
}

- (IBAction)viewTapped:(id)sender
{
    [self rollAnimated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    UIButton *button;

    [super viewDidLoad];

    self.selectedButtonBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05f];

    // Setup buttons
    for (int i = 0; i < [numberButtonContainerView.subviews count]; i++) {
        button = (UIButton *)[numberButtonContainerView.subviews objectAtIndex:i];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;

        if (([[button titleForState:UIControlStateNormal] intValue] == amount)
            || (amount > 5 && [[button titleForState:UIControlStateNormal] isEqualToString:@"+"])) {
            button.layer.backgroundColor = self.selectedButtonBackgroundColor.CGColor;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }

    for (int i = 0; i < [diceButtonContainerView.subviews count]; i++) {
        button = (UIButton *)[diceButtonContainerView.subviews objectAtIndex:i];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;

        if ([[button titleForState:UIControlStateNormal] intValue] == die) {
            button.layer.backgroundColor = self.selectedButtonBackgroundColor.CGColor;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }

    [self rollAnimated:NO];
}

@end
