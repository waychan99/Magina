//
//  MGLoginFactory.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLoginFactory : NSObject

+ (void)saveAccountInfo:(NSDictionary *)accountInfo;

+ (void)removeAccountInfo;

+ (NSDictionary *)getAccountInfo;

@end

NS_ASSUME_NONNULL_END
