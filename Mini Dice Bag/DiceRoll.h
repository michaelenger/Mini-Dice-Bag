//
//  Roll.h
//  Mini Dice Bag
//
//  Created by Michael Enger on 17/06/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DiceRoll : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * die;
@property (nonatomic, retain) NSNumber * modifier;
@property (nonatomic, retain) NSString * results;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSDate * created;

+ (NSArray *)all;
+ (DiceRoll *)diceRoll;
+ (DiceRoll *)first;

- (void)save;

@end
