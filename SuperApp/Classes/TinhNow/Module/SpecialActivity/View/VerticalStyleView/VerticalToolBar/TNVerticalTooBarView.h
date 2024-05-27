//
//  TNVerticalTooBarView.h
//  SuperApp
//
//  Created by 张杰 on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNVerticalTooBarView : TNView
/// 热卖点击回调
@property (nonatomic, copy) void (^hotSaleClickCallBack)(void);
/// 推荐点击回调
@property (nonatomic, copy) void (^recommendClickCallBack)(void);
/// 更改商品展示回调
@property (nonatomic, copy) void (^changeProductDisplayStyleCallBack)(void);
///滑动到推荐列表
- (void)scrollerToRecommdProducts:(BOOL)isRecommd;
@end

NS_ASSUME_NONNULL_END
