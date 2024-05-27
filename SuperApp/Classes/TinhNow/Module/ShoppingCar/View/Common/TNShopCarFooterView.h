//
//  TNShopCarFooterView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNShopCarFooterView : SATableHeaderFooterView
/// 点击结算回调
@property (nonatomic, copy) void (^clickToSubmitOrderCallback)(void);
/// 试算后的金额
@property (nonatomic, copy) NSString *_Nullable calculateAmount;
@end

NS_ASSUME_NONNULL_END
