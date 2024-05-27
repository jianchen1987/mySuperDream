//
//  PNInfoSwitchModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SwitchBlock)(BOOL switchValue);


@interface PNInfoSwitchModel : PNModel
/// 背景颜色
@property (nonatomic, strong) UIColor *backgroundColor;

/// title的值
@property (nonatomic, copy) NSString *title;
/// title颜色
@property (nonatomic, strong) UIColor *titleColor;
/// title的字体
@property (nonatomic, strong) UIFont *titleFont;
/// title的UIEdgeInsets
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

/// subTitle的值
@property (nonatomic, copy) NSString *subTitle;
/// subTitle颜色
@property (nonatomic, strong) UIColor *subTitleColor;
/// subTitle的字体
@property (nonatomic, strong) UIFont *subTitleFont;
/// subTitle的UIEdgeInsets
@property (nonatomic, assign) UIEdgeInsets subTitleEdgeInsets;

/// 底部线条颜色
@property (nonatomic, strong) UIColor *bottomLineColor;
/// 底部线条高度
@property (nonatomic, assign) CGFloat bottomLineHeight;
/// 底部线条 开始缩进 [距离左边间距]
@property (nonatomic, assign) CGFloat bottomLineSpaceToLeft;
/// 底部线条 结束缩进 [距离右边间距]
@property (nonatomic, assign) CGFloat bottomLineSpaceToRight;

/// 选择器的UIEdgeInsets
@property (nonatomic, assign) UIEdgeInsets switchEdgeInsets;
/// 选择器选中的 颜色
@property (nonatomic, strong) UIColor *onTintColor;
/// 选择器状态
@property (nonatomic, assign) BOOL switchValue;

/// 是否相对于父view 来居中【否则是相对于title 来居中】
@property (nonatomic, assign) BOOL isCenterToView;

/// 是否可以操作
@property (nonatomic, assign) BOOL enable;

/// 值变化
@property (nonatomic, copy) SwitchBlock valueBlock;
@end

NS_ASSUME_NONNULL_END
