//
//  SAWalletItemModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletItemModel : SAModel
/// logo 图
@property (nonatomic, copy) NSString *logoImageName;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 背景图
@property (nonatomic, copy) NSString *bgImageName;
/// 内容
@property (nonatomic, copy) NSString *content;
/// 不可提现余额【携带了 币种】
@property (nonatomic, copy) NSString *nonCashBalance;
/// 不可提现余额
@property (nonatomic, copy) NSString *nonCashBalanceStr;
/// 第一个
@property (nonatomic, assign) BOOL isFirst;
/// 最后一个
@property (nonatomic, assign) BOOL isLast;
@end

NS_ASSUME_NONNULL_END
