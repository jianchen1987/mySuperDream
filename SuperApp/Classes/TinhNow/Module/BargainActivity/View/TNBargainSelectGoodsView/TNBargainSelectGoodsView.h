//
//  TNBargainSelectGoodsView.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNBargainViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainSelectGoodsView : TNView
/// viewModel
@property (strong, nonatomic) TNBargainViewModel *viewModel;
/// 创建助力任务回调
@property (nonatomic, copy) void (^createTaskClickCallBack)(TNBargainSelectGoodsView *showView);
- (void)show:(UIView *)inView;
- (void)dissmiss;
@end

NS_ASSUME_NONNULL_END
