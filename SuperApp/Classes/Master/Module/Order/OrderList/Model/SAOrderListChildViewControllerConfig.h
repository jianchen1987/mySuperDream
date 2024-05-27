//
//  SAOrderListChildViewControllerConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAModel.h"

@class SAOrderListViewController;


@interface SAOrderListChildViewControllerConfig : SAModel
/// 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 控制器
@property (nonatomic, strong) SAOrderListViewController *vc;

+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAOrderListViewController *)vc;

@end

@class SAOrderCenterListViewController;


@interface SAOrderCenterListChildViewControllerConfig : SAModel
/// 标题
@property (nonatomic, strong) SAInternationalizationModel *title;
/// 控制器
@property (nonatomic, strong) SAOrderCenterListViewController *vc;

+ (instancetype)configWithTitle:(SAInternationalizationModel *)title vc:(SAOrderCenterListViewController *)vc;

@end
