//
//  ViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 28/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "MainViewController.h"
#import "D20.h"
#import "DiceRoll.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@property (strong, nonatomic) NSDictionary *colors;
@property (strong, nonatomic) NSTimer *rollTimer;

- (NSString *)diceNotation;
- (NSArray *)roll;
- (void)rollAnimated:(BOOL)animated;
- (void)rollThreaded;
- (void)selectButton:(UIButton *)targetButton inRow:(UIView *)rowView;
- (void)setupButtonRow:(UIView *)rowView withNumber:(int)number;
- (void)showResults:(NSArray *)results detailed:(BOOL)detailed;
- (void)showResults:(NSString *)results total:(int)total;
- (void)showTotal:(int)total;
- (void)storeResults:(NSArray *)results;
- (NSString *)stringFromResults:(NSArray *)results;

@end

@implementation MainViewController
@synthesize colors, detailResultLabel, diceButtonContainerView, mainResultLabel, numberButtonContainerView, rollTimer;

int amount = 1;
int die = 20;
int modifier = 0;
int rollCounter;

- (NSString *)diceNotation
{
    NSString *notation = [NSString stringWithFormat:@"%dd%d", amount, die];

    if (modifier != 0) {
        notation = modifier > 0
            ? [notation stringByAppendingString:[NSString stringWithFormat:@"+%d", modifier]]
            : [notation stringByAppendingString:[NSString stringWithFormat:@"%d", modifier]];
    }

    return notation;
}

- (NSArray *)roll
{
    return [D20 detailedRoll:amount ofDie:die];
}

- (void)rollAnimated:(BOOL)animated
{
    NSArray *results;
    self.navigationItem.title = [self diceNotation];

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
        results = [self roll];
        [self showResults:results detailed:YES];
        [self storeResults:results];
    }
}

- (void)rollThreaded
{
    NSArray *results = [self roll];

    if (--rollCounter <= 0) {
        [self showResults:results detailed:YES];
        [self storeResults:results];
        [self.rollTimer invalidate];
    } else {
        [self showResults:results detailed:NO];
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
            button.layer.cornerRadius = 5;
        } else {
            button.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)setupButtonRow:(UIView *)rowView withNumber:(int)number
{
    UIButton *button;
    int value;
    BOOL found = NO;

    for (int i = 0; i < [rowView.subviews count]; i++) {
        button = (UIButton *)[rowView.subviews objectAtIndex:i];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        value = [[button titleForState:UIControlStateNormal] intValue];

        if ((value == number)
            || (!found && i == [rowView.subviews count] - 1)) {
            found = YES;
            break;
        }
    }

    if (found) {
        [self selectButton:button inRow:rowView];
    }
}

- (void)showResults:(NSArray *)results detailed:(BOOL)detailed
{
    int num;
    int total = 0;

    for (int i = 0; i < amount; i++) {
        num = [(NSNumber *)results[i] intValue];
        total += num;
    }

    total += modifier;

    if (detailed) {
        [self showResults:[self stringFromResults:results] total:total];
    } else {
        [self showTotal:total];
    }
}

- (void)showResults:(NSString *)results total:(int)total
{
    self.detailResultLabel.text = results;
    [self showTotal:total];
}

- (void)showTotal:(int)total
{
    self.mainResultLabel.text = [NSString stringWithFormat:@"%d", total];
}

- (void)storeResults:(NSArray *)results
{
    NSString *resultText = [self stringFromResults:results];
    int num;
    int total = 0;

    for (int i = 0; i < amount; i++) {
        num = [(NSNumber *)results[i] intValue];
        total += num;
    }

    total += modifier;

    DiceRoll *roll = [DiceRoll diceRoll];
    roll.amount = [NSNumber numberWithInt:amount];
    roll.die = [NSNumber numberWithInt:die];
    roll.modifier = [NSNumber numberWithInt:modifier];
    roll.total = [NSNumber numberWithInt:total];
    roll.results = resultText;
    [roll save];
}

- (NSString *)stringFromResults:(NSArray *)results
{
    NSArray* sortedResults = [results sortedArrayUsingSelector:@selector(compare:)];
    NSString *string = @"";
    int num;

    for (int i = 0; i < amount; i++) {
        num = [(NSNumber *)sortedResults[i] intValue];
        string = [string stringByAppendingString:[NSString stringWithFormat:@" %d ", num]];
    }

    if (modifier != 0) {
        string = modifier > 0
            ? [string stringByAppendingString:[NSString stringWithFormat:@" +%d ", modifier]]
            : [string stringByAppendingString:[NSString stringWithFormat:@" %d ", modifier]];
    }

    return string;
}

#pragma mark IBAction

- (IBAction)dieTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    die = [[button titleForState:UIControlStateNormal] intValue];

    [self selectButton:button inRow:self.diceButtonContainerView];
    [self rollAnimated:YES];
}

- (IBAction)modifierTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = [button titleForState:UIControlStateNormal];

    modifier += [buttonTitle isEqualToString:@"+"] ? 1 : -1;

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

    [self selectButton:button inRow:self.numberButtonContainerView];
    [self rollAnimated:YES];
}

- (IBAction)viewTapped:(id)sender
{
    [self rollAnimated:YES];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    DiceRoll *first;

    [super viewDidLoad];

    self.colors = [NSDictionary dictionaryWithObjectsAndKeys:
                   [UIColor whiteColor], @"background",
                   [UIColor darkTextColor], @"text",
                   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05f], @"buttonBackground",
                   [UIColor blueColor], @"buttonText", nil];

    first = [DiceRoll first];
    if (first) {
        amount = first.amount.intValue;
        die = first.die.intValue;
        modifier = first.modifier.intValue;
        self.navigationItem.title = [self diceNotation];
        [self showResults:first.results total:first.total.intValue];
    } else {
        [self rollAnimated:NO];
    }

    [self setupButtonRow:self.numberButtonContainerView withNumber:amount];
    [self setupButtonRow:self.diceButtonContainerView withNumber:die];
}

@end
