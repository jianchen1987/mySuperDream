//
//  SAWalletViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SAWalletItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletViewModel : SAViewModel
/// 数据源
@property (nonatomic, copy, readonly) NSArray<SAWalletItemModel *> *dataSource;
/// 成功刷新
@property (nonatomic, copy) void (^successGetNewDataBlock)(NSArray<SAWalletItemModel *> *dataSource);
/// 刷新失败
@property (nonatomic, copy) void (^failedGetNewDataBlock)(NSArray<SAWalletItemModel *> *dataSource);

/// 刷新
- (void)getNewData;
- (void)queryAvaliableChannelFinish:(void (^)(NSUInteger count))finish;
@end

NS_ASSUME_NONNULL_END
