//
//  SALoginByThirdPartySubView.h
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALoginByThirdPartySubView : SAView
/// 点击回调
@property (nonatomic, copy) dispatch_block_t clickBlock;
/// 文本
@property (nonatomic, strong, readonly) UILabel *label;

+ (instancetype)viewWithText:(NSString *)text iconName:(nullable NSString *)iconName;

+ (instancetype)loginHomePageViewWithText:(NSString *)text iconName:(nullable NSString *)iconName;

- (void)resetIcon:(NSString *)icon textColor:(UIColor *)textColor text:(NSString *)text backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
