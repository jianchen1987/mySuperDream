//
//  PNGesturePasswordView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

typedef NS_ENUM(NSInteger, PNGesturePasswordViewType) {
    PNGesturePasswordViewTypeSet = 0,   ///< 初始设置
    PNGesturePasswordViewTypeReset = 1, ///< 重新设置
    PNGesturePasswordViewTypeLogin = 2, ///< 校验
};


typedef NS_ENUM(NSInteger, PNGesturePasswordResultStatus) {
    PNGesturePasswordResult_SetFirst = 1,                    ///< 第一次输入密码 【初始】
    PNGesturePasswordResult_SetFirstSuccess = 2,             ///< 第二次输入 设置密码 成功 【初始】
    PNGesturePasswordResult_SetFirstFail = 3,                ///< 第二次输入 设置密码 失败 【初始】
    PNGesturePasswordResult_TwoSameTime = 4,                 ///< 现有密码 和 输入密码 一样 【校验】
    PNGesturePasswordResult_TwoDifferentTimes = 5,           ///< 现有密码 和 输入密码 不一样 【校验】
    PNGesturePasswordResult_PassVerificationOldPassword = 6, ///< 验证旧密码 通过 【修改】
    PNGesturePasswordResult_FailVerificationOldPassword = 7, ///< 验证旧密码 错误 【修改】
    PNGesturePasswordResult_LessThan = 8,                    ///< 手势密码小于四位数
};

NS_ASSUME_NONNULL_BEGIN

/// 回调
typedef void (^SuccessBlock)(PNGesturePasswordResultStatus status, NSString *currentSelectPassword);


@interface PNGesturePasswordView : PNView

@property (nonatomic, strong) UIColor *strokeColor;      ///圆弧的填充颜色
@property (nonatomic, strong) UIColor *fillColor;        ///除中心圆点外 其他部分的填充色
@property (nonatomic, strong) UIColor *centerPointColor; ///中心圆点的颜色
@property (nonatomic, strong) UIColor *lineColor;        ///线条填充颜色


- (instancetype)initWithFrame:(CGRect)frame viewType:(PNGesturePasswordViewType)viewType;

/// 结果的回调
- (void)resultCallback:(SuccessBlock)block;
@end

NS_ASSUME_NONNULL_END
