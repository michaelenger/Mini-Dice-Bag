//
//  D20.m
//  D20
//
//  Created by Michael Enger on 31/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

#import "D20.h"

typedef struct DiceRoll {
    int amount;
    int die;
    int modifier;
} DiceRoll;

@interface D20 (Private)

+ (int)getRandomNumber:(int)limit;
+ (int)getRandomNumber:(int)limit withMin:(int)min;
+ (DiceRoll)parseNotation:(NSString *)diceNotation;

@end

@implementation D20

#pragma mark Private

+ (int)getRandomNumber:(int)limit
{
    return arc4random_uniform(limit) + 1;
}

+ (int)getRandomNumber:(int)limit withMin:(int)min
{
    return arc4random_uniform(limit - (min - 1)) + min;
}

#pragma mark Public

+ (int)roll:(int)die
{
    return [self getRandomNumber:die];
}

+ (int)roll:(int)amount ofDie:(int)die
{
    int result = 0;

    if (amount > 0) {
        for (int i = 0; i < amount; i++) {
            result += [self getRandomNumber:die];
        }
    }

    return result;
}

+ (int)roll:(int)amount ofDie:(int)die withModifier:(int)modifier
{
    return [self roll:amount ofDie:die] + modifier;
}

+ (NSArray *)detailedRoll:(int)die
{
    int result = [self getRandomNumber:die];
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:result], nil];
}

+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die
{
    return [self detailedRoll:amount ofDie:die withMin:1];
}

+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die withMin:(int)min
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:amount];
    int result;

    if (amount > 0) {
        for (int i = 0; i < amount; i++) {
            result = [self getRandomNumber:die withMin:min];
            [results addObject:[NSNumber numberWithInt:result]];
        }
    }

    return [NSArray arrayWithArray:results];
}

+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die withModifier:(int)modifier
{
    NSMutableArray *results = [NSMutableArray arrayWithArray:[self detailedRoll:amount ofDie:die]];
    [results addObject:[NSNumber numberWithInt:(int)modifier]];
    return [NSArray arrayWithArray:results];
}

@end
