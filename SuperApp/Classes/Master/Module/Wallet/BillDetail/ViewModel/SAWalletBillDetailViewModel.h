//
//  SAWalletBillDetailViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SAWalletBillDetailRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillDetailViewModel : SAViewModel
/// 交易订单号
@property (nonatomic, copy) NSString *tradeNo;
/// 详情
@property (nonatomic, strong, readonly) SAWalletBillDetailRspModel *detailRspModel;
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;

- (void)getNewData;
@end

NS_ASSUME_NONNULL_END
