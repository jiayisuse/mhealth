//
//  Ingredient.m
//  mhealth
//
//  Created by jiayi on 2/28/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ingredient.h"

@implementation Ingredient

- (Ingredient *)initWithName:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit iid:(NSInteger)aIid {
    Ingredient *ingredient = [[Ingredient alloc] init];
    ingredient.IID = aIid;
    ingredient.name = aName;
    ingredient.amount = aAmount;
    ingredient.unit = aUnit;
    return ingredient;
}

- (Ingredient *)initWithName:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit iid:(NSInteger)aIid expData:(NSInteger)aExpData {
    Ingredient *ingredient = [[Ingredient alloc] initWithName:aName amount:aAmount unit:aUnit iid:aIid];
    ingredient.leftDays = (aExpData + (23 * 60 * 60 + 59 * 60 + 59) - [[NSDate date] timeIntervalSince1970]) / (24 * 60 * 60);
    return ingredient;
}

+ (NSInteger)daysDiff:(NSDate *)dateOne anotherDate:(NSDate *)dateTwo {
    NSTimeInterval diff = [dateTwo timeIntervalSinceDate:dateOne];
    return (int)diff / (24 * 60 * 60);
}

+ (Ingredient *)dictToIngredient:(NSDictionary *)jsonDict {
    return [[Ingredient alloc] initWithName:jsonDict[DB_INGREDIENT_NAME_KEY] amount:jsonDict[DB_INGREDIENT_AMOUNT_KEY] unit:jsonDict[DB_INGREDIENT_UNIT_KEY] iid:[jsonDict[DB_INGREDIENT_ID_KEY] intValue] expData:[jsonDict[DB_INGREDIENT_EXP_KEY] intValue]];
}

@end