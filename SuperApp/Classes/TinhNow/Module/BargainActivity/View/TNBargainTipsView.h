//
//  TNBargainTipsView.h
//  SuperApp
//
//  Created by xixi on 2021/3/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  浮层 - 您已发起该商品的砍价，请点击查看

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNTriangleView : TNView
/// 三角形的颜色
@property (nonatomic, strong) UIColor *triangleColor;
@end


@interface TNBargainTipsViewConfig : NSObject
///
@property (nonatomic, strong) NSString *logoName;
///
@property (nonatomic, assign) CGRect logoFrame;
///
@property (nonatomic, strong) NSString *contentStr;
///
@property (nonatomic, strong) UIColor *contentTitleColor;
///
@property (nonatomic, strong) UIFont *contentFont;
///
@property (nonatomic, strong) UIColor *contentBackgroundColor;
@end


@interface TNBargainTipsView : TNView

///
@property (nonatomic, strong) TNBargainTipsViewConfig *config;

- (void)show;

@end

NS_ASSUME_NONNULL_END
