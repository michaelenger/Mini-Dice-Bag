//
//  ViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) NSTimer *rollTimer;

- (NSArray *)roll;
- (void)rollAnimated:(BOOL)animated;
- (void)rollThreaded;
- (void)showResults:(NSArray *)results detailed:(BOOL)detailed;

@end

@implementation MainViewController
@synthesize detailResultLabel, mainResultLabel, rollTimer;

int amount = 1;
int die = 20;
int rollCounter;

- (NSArray *)roll
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:amount];
    int result;

    for (int i = 0; i < amount; i++) {
        result = arc4random_uniform(die) + 1;
        results[i] = [NSNumber numberWithInt:result];
    }

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
        detailResultLabel.text = amount <= 8 ? detailText : [NSString stringWithFormat:@"%dd%d", amount, die];
    } else {
        detailResultLabel.text = @"";
    }

    mainResultLabel.text = [NSString stringWithFormat:@"%d", total];
}

#pragma mark IBAction

- (IBAction)dieTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    die = [[button titleForState:UIControlStateNormal] intValue];
    [self rollAnimated:YES];
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

    [self rollAnimated:YES];
}

- (IBAction)viewTapped:(id)sender
{
    [self rollAnimated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rollAnimated:NO];
}

@end
