//
//  Roll.m
//  Mini Dice Bag
//
//  Created by Michael Enger on 17/06/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "DiceRoll.h"
#import "AppDelegate.h"

@implementation DiceRoll

@dynamic amount;
@dynamic die;
@dynamic results;
@dynamic total;
@dynamic created;

#pragma mark Class methods

+ (NSArray *)all
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DiceRoll"
                                              inManagedObjectContext:context];
    NSError *error;

    fetchRequest.entity = entity;
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    fetchRequest.fetchLimit = 100;

    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (DiceRoll *roll in fetchedObjects) {
        NSLog(@"%dd%d=%d", roll.amount.intValue, roll.die.intValue, roll.total.intValue);
    }

    return fetchedObjects;
}

+ (DiceRoll *)diceRoll
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    DiceRoll *object = [NSEntityDescription insertNewObjectForEntityForName:@"DiceRoll"
                                                     inManagedObjectContext:context];
    object.created = [NSDate date];

    return object;
}

+ (DiceRoll *)first
{
    NSArray *all = [DiceRoll all];
    return [all count] > 0 ? (DiceRoll *)[all firstObject] : nil;
}

#pragma mark Instance methods

- (void)save
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unable to save DiceRoll: %@", [error localizedDescription]);
    }
}

@end
