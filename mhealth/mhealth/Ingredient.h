//
//  Ingredient.h
//  mhealth
//
//  Created by jiayi on 2/28/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_Ingredient_h
#define mhealth_Ingredient_h

#define DB_INGREDIENT_NAME_KEY      @"name"
#define DB_INGREDIENT_USERNAME_KEY  @"user_name"
#define DB_INGREDIENT_FID_KEY       @"family_id"
#define DB_INGREDIENT_AMOUNT_KEY    @"amount"
#define DB_INGREDIENT_UNIT_KEY      @"unit"
#define DB_INGREDIENT_EXP_KEY       @"expiration"

@interface Ingredient : NSObject

@property (nonatomic) NSInteger IID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *unit;
@property (nonatomic) NSInteger leftDays;

- (Ingredient *)initWithName:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit;
- (Ingredient *)initWithName:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit expData:(NSInteger)aExpData;
+ (NSInteger)daysDiff:(NSDate *)dateOne anotherDate:(NSDate *)dateTwo;
+ (Ingredient *)dictToIngredient:(NSDictionary *)jsonDict;

@end

#endif
