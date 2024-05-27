//
//  SAChangeCountryEntryView.h
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACountryModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

/** 切换国家代码的控件 */
@interface SAChangeCountryEntryView : SAView
/// 当前国家码模型
@property (nonatomic, strong, readonly) SACountryModel *currentCountryModel;
@property (nonatomic, copy) void (^choosedCountryBlock)(SACountryModel *model);

/// 根据国家代码设置国家
- (void)setCountryWithCountryCode:(NSString *)countryCode;

/// getter
- (UILabel *)titleLabel;
@end

NS_ASSUME_NONNULL_END
