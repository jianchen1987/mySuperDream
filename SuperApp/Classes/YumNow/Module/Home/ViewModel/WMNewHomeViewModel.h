//
//  WMNewHomeViewModel.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMViewModel.h"
#import "WMHomeTipView.h"
#import "WMThemeModel.h"
#import "WMViewModel.h"
#import "WMHomeColumnModel.h"
#import <HDUIKit/HDTableViewSectionModel.h>
#import "WMHomeLayoutModel.h"

@class WMCategoryItem, WMNearbyFilterModel;


NS_ASSUME_NONNULL_BEGIN


@interface WMNewHomeViewModel : WMViewModel
/// 默认数据源
@property (nonatomic, strong, readonly) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;
/// 是否刚换了语言
@property (nonatomic, assign) BOOL isChangeLanguage;
/// 提示层枚举
@property (nonatomic, assign) WMHomeTipViewStyle tipViewStyle;
/// 定位失败提示
@property (nonatomic, assign) BOOL locationFailFlag;
/// 定位改变提示
@property (nonatomic, assign) BOOL locationChangeFlag;
/// 栏目请求到数据
@property (nonatomic, assign) BOOL columnFlag;

@property (nonatomic, assign) BOOL hideBackButton; ///< 隐藏返回按钮
///请求渲染数据状态
@property (nonatomic, assign) NSInteger finishRequestType;
///阿波罗配置和个配置数据源
@property (nonatomic, strong) NSArray<WMHomeLayoutModel *> *resultInfo;
///栏目配置
@property (nonatomic, strong) NSArray<WMHomeColumnModel *> *columnArray;
/// 附近门店栏目 固定
@property (nonatomic, strong) WMHomeColumnModel *nearColumnModel;
/// 门店广告
@property (nonatomic, strong, nullable) WMHomeLayoutModel *insertModel;
/// 主题列表
@property (nonatomic, strong, nullable) NSMutableArray *themeList;
/// 加载离线数据
- (void)loadOfflineData;

- (void)hd_getNewData;

/// 刷新某个model数据
- (void)reloadDataWithLayoutModel:(WMHomeLayoutModel *)model completion:(void (^)(id rspModel, BOOL result))completion;

@end

NS_ASSUME_NONNULL_END
