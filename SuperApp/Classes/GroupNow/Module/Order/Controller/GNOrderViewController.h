//
//  GNOrderViewController.h
//  SuperApp
//
//  Created by wmz on 2021/5/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderBaseViewController.h"
#import "GNOrderViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderViewController : GNOrderBaseViewController
/// 状态
@property (nonatomic, assign) GNOrderStatus orderStatus;
/// viewModel
@property (nonatomic, strong) GNOrderViewModel *viewModel;
/// 获取列表数据
- (void)requestData:(NSInteger)pageNum;

@end

NS_ASSUME_NONNULL_END
