//
//  SACMSCardView.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardViewConfig.h"
#import "SACMSDefine.h"
#import "SACMSTitleView.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSNode;
@class SACMSPageView;
@class SACMSCardView;

@protocol SACMSCardProtocol <NSObject>

@required
- (CGFloat)heightOfCardView;

/// 是否需要请求数据源
/// @param config 配置
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config;

/// 返回数据源地址
/// @param config 配置
- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config;

/// 根据数据源装载自定义参数
/// @param dataSource 数据源
- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(SACMSCardViewConfig *)config;

/// 解析返回结果
/// @param responseData 请求结果
/// @param config 配置
- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config;

@end


@interface SACMSCardView : SAView <SACMSCardProtocol>

- (instancetype)initWithConfig:(SACMSCardViewConfig *)config;
///< 页面引用
@property (nonatomic, strong) SACMSPageView *page;
/// 配置
@property (nonatomic, strong, nullable) SACMSCardViewConfig *config;

/// bgView
@property (nonatomic, strong, readonly) UIView *bgView;
/// 背景图
@property (nonatomic, strong, readonly) UIImageView *bgIV;
/// 标题
@property (nonatomic, strong, readonly) SACMSTitleView *titleView;
/// 容器
@property (nonatomic, strong, readonly) UIView *containerView;
/// 卡片获取完数据，重新刷新UI回调（page需要根据最新展示的UI重新计算高度）
@property (nonatomic, copy) void (^refreshCard)(SACMSCardView *card);
/// 点击回调
@property (nonatomic, copy) void (^clickNode)(SACMSCardView *card, SACMSNode *_Nullable node, NSString *_Nullable link, NSString *_Nullable spm);

- (void)updateTitleViewWithConfig:(SACMSTitleViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
