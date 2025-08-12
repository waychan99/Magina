//
//  MopKeyChainStore.h
//  MopSDK
//
//  Created by 朱盛雄 on 17/2/9.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWKeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
