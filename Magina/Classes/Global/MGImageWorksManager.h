//
//  MGImageWorksManager.h
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import <Foundation/Foundation.h>
#import "MGImageWorksModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGImageWorksManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSString *dataFilePath;

@property (nonatomic, strong) NSMutableArray<MGImageWorksModel *> *imageWorks;

- (void)loadImageWorksCompletion:(void (^ __nullable)(NSMutableArray<MGImageWorksModel *> *imageWorks))completion;

- (void)saveImageWorksCompletion:(void (^ __nullable)(NSMutableArray<MGImageWorksModel *> *imageWorks))completion;

- (void)productionImageWorksWithName:(NSString * __nullable)name generatedTag:(NSString *)generatedTag worksCount:(NSInteger)worksCount completion:(void (^ __nullable)(MGImageWorksModel *imageWorksModel))completion;

- (void)downloadImageWorks;

- (void)downloadImageWorksModel:(MGImageWorksModel *)worksModel completion:(void (^ __nullable)(MGImageWorksModel *imageWorksModel))completion;

- (void)testSourceEvent;

@end

NS_ASSUME_NONNULL_END
