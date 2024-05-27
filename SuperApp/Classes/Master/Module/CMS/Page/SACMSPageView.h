//
//  SACMSPageView.h
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSPluginView.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class SACMSPageViewConfig;
@class SACMSCardView;
@class SACMSNode;
@class SACMSPageView;

@protocol SACMSPageViewDelegate <NSObject>

@optional

- (void)didClickedOnPageView:(SACMSPageView *)pageView cardView:(SACMSCardView *)cardView node:(SACMSNode *)node link:(NSString *)link spm:(NSString *)spm;

// 页面重新刷新了，外部根据需要重新通过getViewHeight获取高度
- (void)pageViewDidRefresh:(SACMSPageView *)pageView cardView:(SACMSCardView *)cardView;

@end


@interface SACMSPageView : SAView

@property (nonatomic, copy) NSString *backgroundImage; ///< 背景图片地址

@property (nonatomic, strong, readonly) NSArray<SACMSCardView *> *cardViews; ///< 卡片数组
@property (nonatomic, weak) id<SACMSPageViewDelegate> delegate;              ///< 代理
@property (nonatomic, copy, readonly) NSString *pageName;                    ///< 页面名称
@property (nonatomic, assign, readonly) CGFloat pageWidth;                   ///< 页面宽度

- (instancetype)initWithWidth:(CGFloat)width config:(SACMSPageViewConfig *)config;
- (CGFloat)getViewHeight;

@end

NS_ASSUME_NONNULL_END
