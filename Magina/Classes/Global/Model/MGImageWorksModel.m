//
//  MGImageWorksModel.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGImageWorksModel.h"

@implementation MGImageWorksModel

- (NSMutableDictionary<NSString *, NSString *> *)downloadedImagePathInfo {
    if (!_downloadedImagePathInfo) {
        _downloadedImagePathInfo = [NSMutableDictionary  dictionary];
    }
    return _downloadedImagePathInfo;
}

- (NSMutableArray<NSString *> *)generatedImageWorksList {
    if (!_generatedImageWorksList) {
        _generatedImageWorksList = [NSMutableArray array];
    }
    return _generatedImageWorksList;
}

@end
