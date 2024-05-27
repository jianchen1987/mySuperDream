//
//  TNProductDetailSellerBottomView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.

//  海外购3.3版本  不用这个视图了

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailSellerBottomView : TNView
/// 添加购物车回调
@property (nonatomic, copy) void (^addCartButtonClickedHander)(void);
/// 立即购买回调
@property (nonatomic, copy) void (^buyNowButtonClickedHander)(void);
/// 加入或者取消销售回调
@property (nonatomic, copy) void (^addOrCancelSellClickedHander)(void);
/// 客服的回调
@property (nonatomic, copy) void (^customerServiceButtonClickedHander)(NSString *storeNo);
/// 电话的回调
@property (nonatomic, copy) void (^phoneButtonClickedHander)(void);
/// SMS的回调
@property (nonatomic, copy) void (^smsButtonClickedHander)(void);

@end

NS_ASSUME_NONNULL_END
