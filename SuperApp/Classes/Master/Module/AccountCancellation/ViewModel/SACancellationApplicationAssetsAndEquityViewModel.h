//
//  SACancellationApplicationAssetsAndEquityViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationReasonModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationAssetsAndEquityViewModel : SAViewModel
/// 是否正在加载
@property (nonatomic, assign, readonly) BOOL isLoading;
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 数据源
@property (nonatomic, copy, readonly) NSArray *dataSource;
/// 注销原因模型数据
@property (nonatomic, strong, readonly) SACancellationReasonModel *reasonModel;
/// 查询用户的资产与权益
- (void)queryOrdeDetailInfo;

@end

NS_ASSUME_NONNULL_END
