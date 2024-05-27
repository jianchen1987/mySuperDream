//
//  HDDealCommonView.h
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDDealCommonInfoRowViewModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDDealCommonViewModel : NSObject
@property (nonatomic, copy) NSString *imageName;                           ///< 图片名
@property (nonatomic, copy) NSString *title;                               ///< 标题
@property (nonatomic, strong) UIFont *titleFont;                           ///< 标题文字字体
@property (nonatomic, strong) UIColor *titleColor;                         ///< 标题文字颜色
@property (nonatomic, copy) NSString *subTitle;                            ///< 子标题
@property (nonatomic, strong) UIFont *subTitleFont;                        ///< 子标题文字字体
@property (nonatomic, strong) UIColor *subTitleColor;                      ///< 子标题文字颜色
@property (nonatomic, copy) NSString *desc;                                ///< 描述
@property (nonatomic, strong) UIFont *descFont;                            ///< 描述文字字体
@property (nonatomic, strong) UIColor *descColor;                          ///< 描述文字颜色
@property (nonatomic, assign) BOOL needDividingLine;                       ///< 是否需要分割线，默认开启
@property (nonatomic, assign) NSInteger dividingLineIndex;                 ///< 分割线位置，默认 0，即第一行上面
@property (nonatomic, assign) CGFloat dividingLineHMargin;                 ///< 分割线水平方向外边距
@property (nonatomic, strong) UIColor *dividingLineColor;                  ///< 分割线颜色
@property (nonatomic, assign) CGFloat dividingLineWidth;                   ///< 分割线高度，默认 0.5
@property (nonatomic, copy) NSArray<HDDealCommonInfoRowViewModel *> *list; ///< 列表
@property (nonatomic, copy) NSString *remarkText;                          ///< 底部备注
@property (nonatomic, strong) UIFont *remarkTextFont;                      ///< 底部备注文字字体
@property (nonatomic, strong) UIColor *remarkTextColor;                    ///< 底部备注文字颜色
@property (nonatomic, assign) NSTextAlignment remarkTextAlignment;         ///< 底部备注文字对齐方式
@end


@interface HDDealCommonView : UIView

+ (instancetype)dealCommonViewWithModel:(HDDealCommonViewModel *)model;
- (instancetype)initWithModel:(HDDealCommonViewModel *)model;

@property (nonatomic, strong) HDDealCommonViewModel *model; ///< 模型
@end

NS_ASSUME_NONNULL_END
