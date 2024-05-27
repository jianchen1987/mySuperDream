//
//  SAWalletBillListViewModel.h
//  SuperApp
//
//  Created by seeu on 2021/10/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SABillType) {
    SABillTypeNormal, ///< 正常账单
    SABillTypeHistory ///< 历史账单
};


@interface SAWalletBillListViewModel : SAViewModel

/// 默认数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource;
@property (nonatomic, assign) SABillType billType; ///< 账单类型

- (void)requestNewDataCompletion:(void (^)(NSError *error, BOOL hasMore, SARspModel *rspModel))completion;
- (void)loadMoreDataCompletion:(void (^)(NSError *error, BOOL hasMore, SARspModel *rspModel))completion;

@end

NS_ASSUME_NONNULL_END
