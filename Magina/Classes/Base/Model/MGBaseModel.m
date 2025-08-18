//
//  MGBaseModel.m
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGBaseModel.h"

@implementation MGBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{//id
             @"ID" : @"id",
             //description
             @"descriptioN" : @"description"};
}

@end
