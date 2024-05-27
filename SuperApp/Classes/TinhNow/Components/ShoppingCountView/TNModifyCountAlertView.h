//
//  TNModifyCountAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNModifyCountAlertView : HDActionAlertView
/// 输入 数量后的回调
@property (nonatomic, copy) void (^enterCountCallBack)(NSString *count);
/// 初始化一个购买数量弹窗
/// @param count 当前购买数量
/// @param maxCount 最大可购买数量
/// @param minCount 最小可购买数量
- (instancetype)initAlertWithCurrentCount:(NSString *)count maxCount:(NSInteger)maxCount minCount:(NSInteger)minCount;

@end

NS_ASSUME_NONNULL_END
