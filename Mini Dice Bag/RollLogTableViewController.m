//
//  RollLogTableViewController.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 17/06/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "RollLogTableViewController.h"
#import "DiceRoll.h"

@interface RollLogTableViewController ()

@property (strong, nonatomic) NSArray *objects;

@end

@implementation RollLogTableViewController
@synthesize objects = _objects;

#pragma mark UITableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objects = [DiceRoll all];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diceRollCell" forIndexPath:indexPath];
    DiceRoll *roll = (DiceRoll *)[self.objects objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%d", roll.total.intValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%dd%d", roll.amount.intValue, roll.die.intValue];
    
    return cell;
}

@end
