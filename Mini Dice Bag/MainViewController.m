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

@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSTimer *rollTimer;

- (NSArray *)roll;
- (void)rollAnimated:(BOOL)animated;
- (void)rollThreaded;
- (void)selectButton:(UIButton *)targetButton inRow:(UIView *)rowView;
- (void)setupButtonRow:(UIView *)rowView withNumber:(int)number;
- (void)showResults:(NSArray *)results detailed:(BOOL)detailed;

@end

@implementation MainViewController
@synthesize colors, detailResultLabel, diceButtonContainerView, mainResultLabel, numberButtonContainerView, rollTimer;

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

- (void)selectButton:(UIButton *)targetButton inRow:(UIView *)rowView
{
    UIButton *button;
    UIColor *color = (UIColor *)[self.colors objectForKey:@"buttonBackground"];

    for (int i = 0; i < [rowView.subviews count]; i++) {
        button = (UIButton *)[rowView.subviews objectAtIndex:i];

        if (button == targetButton) {
            button.layer.backgroundColor = color.CGColor;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)setupButtonRow:(UIView *)rowView withNumber:(int)number
{
    UIButton *button;
    int value;
    UIColor *color = (UIColor *)[self.colors objectForKey:@"buttonBackground"];
    BOOL found = NO;

    for (int i = 0; i < [rowView.subviews count]; i++) {
        button = (UIButton *)[rowView.subviews objectAtIndex:i];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        value = [[button titleForState:UIControlStateNormal] intValue];

        if ((value == number)
            || (!found && i == [rowView.subviews count] - 1)) {
            button.layer.backgroundColor = color.CGColor;
            found = YES;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    die = [[button titleForState:UIControlStateNormal] intValue];

    [self selectButton:button inRow:self.diceButtonContainerView];
    [self rollAnimated:YES];

    [userDefaults setInteger:die forKey:@"die"];
    [userDefaults synchronize];
}

- (IBAction)numberTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *title = [button titleForState:UIControlStateNormal];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if ([title isEqualToString:@"+"]) {
        amount = amount <= 5 ? 6 : amount + 1;
    } else {
        amount = [title intValue];
    }

    [self selectButton:button inRow:self.numberButtonContainerView];
    [self rollAnimated:YES];

    [userDefaults setInteger:amount forKey:@"amount"];
    [userDefaults synchronize];
}

- (IBAction)viewTapped:(id)sender
{
    [self rollAnimated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    int temp;

    [super viewDidLoad];

    self.colors = [NSDictionary dictionaryWithObjectsAndKeys:
                   [UIColor whiteColor], @"background",
                   [UIColor darkTextColor], @"text",
                   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05f], @"buttonBackground",
                   [UIColor blueColor], @"buttonText", nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    temp = (int)[userDefaults integerForKey:@"amount"];
    amount = temp > 0 ? temp : 1;
    temp = (int)[userDefaults integerForKey:@"die"];
    die = temp > 0 ? temp : 20;

    [self setupButtonRow:self.numberButtonContainerView withNumber:amount];
    [self setupButtonRow:self.diceButtonContainerView withNumber:die];
    [self rollAnimated:NO];
}

@end
