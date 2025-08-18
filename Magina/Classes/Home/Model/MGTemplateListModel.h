//
//  MGTemplateListModel.h
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGTemplateListModel : MGBaseModel

@property (nonatomic, copy) NSString *change_face_gender;

@property (nonatomic, copy) NSString *change_face_thumbnai;

@property (nonatomic, strong) NSArray *fatImgs;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger points;

@property (nonatomic, copy) NSString *prompt_word;

@property (nonatomic, strong) NSArray *standardImgs;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
