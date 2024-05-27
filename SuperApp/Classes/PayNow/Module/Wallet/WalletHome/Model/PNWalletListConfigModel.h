//
//  PNWalletListConfigModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletListConfigModel : PNModel
@property (nonatomic, assign) PNWalletListItemType bizType;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *logoPath;
/// 名字
@property (nonatomic, copy) NSString *businessName;

///< 排序
@property (nonatomic, assign) NSUInteger sort;

@property (nonatomic, strong) NSArray<PNWalletListConfigModel *> *children;


@end

NS_ASSUME_NONNULL_END
