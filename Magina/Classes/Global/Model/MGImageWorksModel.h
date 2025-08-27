//
//  MGImageWorksModel.h
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGImageWorksModel : MGBaseModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *generatedTag;

@property (nonatomic, strong) NSArray<NSString *> *generatedImageWorksArr;

@property (nonatomic, assign) NSTimeInterval generatedTime;

@property (nonatomic, assign) BOOL isDownloaded;

@end

NS_ASSUME_NONNULL_END
