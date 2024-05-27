//
//  TNOrderDetailsExpressView.h
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNOrderDetailExpressOrderModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsExpressView : TNView
///
@property (nonatomic, strong) UIView *line;
///
@property (nonatomic, strong) UIImageView *iconImgView;
/// 订单号
@property (nonatomic, strong) UILabel *expressNoLabel;
/// 状态时间
@property (nonatomic, strong) UILabel *timeLabel;
/// 暂无物流信息/已揽件
@property (nonatomic, strong) UILabel *expressStatusLabel;
/// 刷新按钮
@property (nonatomic, strong) UIButton *refreshBtn;
/// 箭头
@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) TNOrderDetailExpressOrderModel *expressOrderModel;

@end

NS_ASSUME_NONNULL_END
