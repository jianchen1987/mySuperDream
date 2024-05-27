//
//  TNProductDetailBottomView.h
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailBottomView : TNView
/// 添加购物车回调
@property (nonatomic, copy) void (^addCartButtonClickedHander)(void);
/// 立即购买回调
@property (nonatomic, copy) void (^buyNowButtonClickedHander)(void);
/// 客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(NSString *storeNo);
/// 电话的回调
@property (nonatomic, copy) void (^phoneButtonClickedHander)(void);
/// SMS的回调
@property (nonatomic, copy) void (^smsButtonClickedHander)(void);

///获取购物车在屏幕中的相对Point
- (CGPoint)getCartButtonPoint;
///购物车按钮开始抖动
- (void)cartButtonBeginShake;
@end

NS_ASSUME_NONNULL_END
