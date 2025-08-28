//
//  MGPointsDetailsModel.h
//  Magina
//
//  Created by mac on 2025/8/22.
//

#import "MGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGPointsDetailsModel : MGBaseModel

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger points;

/** 0 加分 1 减分 */
@property (nonatomic, assign) NSInteger symbol;

@end

NS_ASSUME_NONNULL_END
