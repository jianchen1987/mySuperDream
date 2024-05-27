//
//  SAChangeAreaCodeView.h
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACountryModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALoginAreaCodeView : SAView
/// 当前国家码模型
@property (nonatomic, strong, readonly) SACountryModel *currentCountryModel;
@property (nonatomic, copy) void (^choosedCountryBlock)(SACountryModel *model);

/// 根据国家代码设置国家
- (void)setCountryWithCountryCode:(NSString *)countryCode;

/// getter
- (UILabel *)titleLabel;

@end

NS_ASSUME_NONNULL_END
