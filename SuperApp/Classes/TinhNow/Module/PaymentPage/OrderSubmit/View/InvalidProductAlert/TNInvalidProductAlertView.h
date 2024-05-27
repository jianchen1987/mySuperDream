//
//  TNInvalidProductAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  提交订单页  失效 下架等商品提示弹窗

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TNShoppingCarItemModel;

typedef NS_ENUM(NSUInteger, TNSubmitInvalidType) {
    ///全部失效
    TNSubmitInvalidTypeAllInvalid = 0,
    ///部分可以购买
    TNSubmitInvalidTypeCanBuy = 1,
};

@interface TNInvalidProductAlertView : HDAlertView
/// 返回修改回调
@property (nonatomic, copy) void (^backChangeBlock)(void);
/// 继续下单回调
@property (nonatomic, copy) void (^continueSubmitOrderBlock)(NSArray<TNShoppingCarItemModel *> *list);

/// 关闭弹窗回调
@property (nonatomic, copy) void (^closeBlock)(void);

- (instancetype)initWithTitle:(NSString *)title invalidType:(TNSubmitInvalidType)invalidType DataArr:(NSArray<TNShoppingCarItemModel *> *)dataArr;

@end

NS_ASSUME_NONNULL_END
