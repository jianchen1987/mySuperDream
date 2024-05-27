//
//  SAWalletBillListRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "SAWalletBillModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillListRspModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<SAWalletBillModel *> *list;
@end

NS_ASSUME_NONNULL_END
