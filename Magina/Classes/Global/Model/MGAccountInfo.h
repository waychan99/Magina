//
//  MGAccountInfo.h
//  Magina
//
//  Created by mac on 2025/8/22.
//

#import "MGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGAccountInfo : MGBaseModel


@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *user_registered;

@property (nonatomic, copy) NSString *display_name;

@property (nonatomic, strong) NSNumber *user_type;

@property (nonatomic, copy) NSString *descriptioN;

@property (nonatomic, copy) NSString *user_avatar;

@property (nonatomic, strong) NSNumber *gender;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *invite_code;

@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, copy) NSString *is_temu_new;

@property (nonatomic, strong) NSNumber *is_new;

@property (nonatomic, strong) NSDictionary *level;

@property (nonatomic, assign) NSInteger my_video_count;

@property (nonatomic, assign) NSInteger like_and_comment_count;

@property (nonatomic, copy) NSString *user_vip_expiration_time;

@property (nonatomic, assign) NSInteger user_vip;

@property (nonatomic, assign) NSInteger is_delete_user;

@property (nonatomic, strong) NSArray *inviteAddPointsInfo;

@end

NS_ASSUME_NONNULL_END
