//
//  WMOneClickCouponAlert.h
//  SuperApp
//
//  Created by wmz on 2022/7/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMCouponActivityContentModel.h"
#import "WMTableView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOneClickCouponAlert : SAView
///是否正在显示
@property (nonatomic, assign, getter=isShow) BOOL show;
///数据源
@property (nonatomic, strong) NSArray *dataSource;
/// rspModel
@property (nonatomic, strong) WMCouponActivityContentModel *rspModel;
/// 选中回调
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMCouponActivityContentModel *rspModel);
///下次不再展示按钮
@property (nonatomic, strong, readonly) HDUIButton *showAgainBTN;
///关闭按钮
@property (nonatomic, strong, readonly) HDUIButton *closeBTN;
/// title
@property (nonatomic, strong, readonly) YYLabel *titleLB;
/// tableView
@property (nonatomic, strong, readonly) WMTableView *tableView;
///券区域的内容
@property (nonatomic, strong, readonly) UIView *containView;
///阴影
@property (nonatomic, strong, readonly) UIView *shadomView;
///整体内容
@property (nonatomic, strong, readonly) UIView *contenView;
///背景图片
@property (nonatomic, strong, readonly) UIImageView *bgIV;
///前置背景图片
@property (nonatomic, strong, readonly) UIImageView *frontIV;
///领取按钮
@property (nonatomic, strong, readonly) HDUIButton *confirmBTN;
///描边
@property (nonatomic, strong, readonly) UIView *borderView;
///填充
@property (nonatomic, strong, readonly) UIView *fillView;

- (void)show;

- (void)dissmiss;

@end

NS_ASSUME_NONNULL_END
