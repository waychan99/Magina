//
//  NSLayoutConstraint+BSIBDesignable.h
//  LongPartner
//
//  Created by mac on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (BSIBDesignable)

@property(nonatomic, assign) IBInspectable BOOL adapterScreen;

@property (nonatomic, assign) IBInspectable BOOL adapterVerticalConstraint;

@end

NS_ASSUME_NONNULL_END
