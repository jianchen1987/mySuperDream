//
//  SACountryModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACountryModel : SACodingModel
/// 长显示文字
@property (nonatomic, copy) NSString *displayText;
/// 国家代码
@property (nonatomic, copy) NSString *countryCode;
/// 完整国家代码（拼接 + 号）
@property (nonatomic, copy, readonly) NSString *fullCountryCode;
/// 手机号格式，如中国：xxx-xxxx-xxxx
@property (nonatomic, copy) NSString *phoneNumberFormat;
/// 0开头的手机号格式，如中国：xx-xxxx-xxxx，会在第一次设置 phoneNumberFormat 自动将此值设置为一次
@property (nonatomic, copy) NSString *zeroPrefixPhoneNumberFormat;
/// 手机号有效最短为位数
@property (nonatomic, assign) NSUInteger minimumDigits;
/// 手机号有效最长为位数
@property (nonatomic, assign) NSUInteger maximumDigits;
/// 判断当前号码是否有效的 block
@property (nonatomic, copy) BOOL (^isPhoneNumberValidBlock)(NSString *phoneNumber);

+ (instancetype)modelWithDisplayText:(NSString *)displayText countryCode:(NSString *)countryCode;
- (void)updatePhoneNumberFormat:(NSString *)phoneNumberFormat minimumDigits:(NSUInteger)minimumDigits maximumDigits:(NSUInteger)maximumDigits;
@end

NS_ASSUME_NONNULL_END
