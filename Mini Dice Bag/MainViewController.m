//
//  ViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

- (void)roll;

@end

@implementation MainViewController
@synthesize detailResultLabel, mainResultLabel;

int amount = 1;
int die = 20;

- (void)roll
{
    NSString *detailText = [NSString stringWithFormat:@"%dd%d", amount, die];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:amount];
    int total = 0;
    int result;

    for (int i = 0; i < amount; i++) {
        result = arc4random_uniform(die) + 1;
        results[i] = [NSNumber numberWithInt:result];
        total += result;
    }

    if (amount <= 8) {
        NSArray *sortedArray = [results sortedArrayUsingSelector:@selector(compare:)];
        NSNumber *num;
        detailText = @"";
        for (int i = 0; i < amount; i++) {
            num = (NSNumber *)sortedArray[i];
            detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@" %d ", [num intValue]]];
        }
    }

    detailResultLabel.text = detailText;
    mainResultLabel.text = [NSString stringWithFormat:@"%d", total];
}

#pragma mark IBAction

- (IBAction)dieTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    die = [[button titleForState:UIControlStateNormal] intValue];
    [self roll];
}

- (IBAction)numberTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = [button titleForState:UIControlStateNormal];

    if ([title isEqualToString:@"+"]) {
        amount = amount <= 5 ? 6 : amount + 1;
    } else {
        amount = [title intValue];
    }

    [self roll];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self roll];
}

@end
