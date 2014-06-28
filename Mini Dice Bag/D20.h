//
//  D20.h
//  D20
//
//  Created by Michael Enger on 31/05/14.
//  Copyright (c) 2014 Michael Enger. All rights reserved.
//

@interface D20 : NSObject

+ (int)roll:(int)die;
+ (int)roll:(int)amount ofDie:(int)die;
+ (int)roll:(int)amount ofDie:(int)die withModifier:(int)modifier;

+ (NSArray *)detailedRoll:(int)die;
+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die;
+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die withMin:(int)min;
+ (NSArray *)detailedRoll:(int)amount ofDie:(int)die withModifier:(int)modifier;

@end
