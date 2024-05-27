//
//  TNBargainSelectBottomView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNBargainViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainSelectBottomView : TNView
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 关闭事件回调
@property (nonatomic, copy) void (^bargainCloseCallBack)(void);
/// 确认事件回调
@property (nonatomic, copy) void (^bargainConfirmCallBack)(void);
//布局计算自己及子控件的高度
- (void)layoutyImmediately;
@end

NS_ASSUME_NONNULL_END
