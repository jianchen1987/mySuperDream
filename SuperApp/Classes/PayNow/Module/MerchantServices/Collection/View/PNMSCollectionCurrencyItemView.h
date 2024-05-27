//
//  PNMSCollectionCurrencyItemView.h
//  SuperApp
//
//  Created by xixi on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSCollectionCurrencyItemModel : PNModel
/// 金额
@property (nonatomic, strong) NSString *money;
/// 总笔数
@property (nonatomic, strong) NSString *count;

@property (nonatomic, strong) PNCurrencyType currency;
@end


@interface PNMSCollectionCurrencyItemView : PNView
@property (nonatomic, strong) PNMSCollectionCurrencyItemModel *model;
@end

NS_ASSUME_NONNULL_END
