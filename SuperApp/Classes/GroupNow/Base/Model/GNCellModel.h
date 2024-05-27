//
//  GNCellModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "GNRowModelProtocol.h"

typedef void (^GNCommonBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN


@interface GNCellModel : GNModel <GNRowModelProtocol>
/// titile
@property (nonatomic, copy) NSString *title;
/// titleColor
@property (nonatomic, strong) UIColor *titleColor;
/// titleFont
@property (nonatomic, strong) UIFont *titleFont;
/// 图片文字
@property (nonatomic, copy) NSString *imageTitle;
/// detail
@property (nonatomic, copy, nullable) NSString *detail;
/// detailColor
@property (nonatomic, strong) UIColor *detailColor;
/// detailFont
@property (nonatomic, strong) UIFont *detailFont;
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 图片在左侧
@property (nonatomic, assign) BOOL imageLeft;
/// 图片隐藏
@property (nonatomic, assign) BOOL imageHide;
/// offset
@property (nonatomic, assign) CGFloat offset;
/// bottomOffset
@property (nonatomic, assign) CGFloat bottomOffset;
/// 图片size
@property (nonatomic, assign) CGSize imageSize;
/// itemSize
@property (nonatomic, assign) CGSize itemSize;
/// width
@property (nonatomic, assign) CGFloat width;
/// 隐藏线条
@property (nonatomic, assign) BOOL lineHidden;

@property (nonatomic, assign) BOOL history;
/// 行
@property (nonatomic, assign) NSInteger numOfLines;
/// num
@property (nonatomic, assign) NSInteger num;
/// index
@property (nonatomic, assign) NSInteger index;
/// 对应标志
@property (nonatomic, copy) NSString *tag;
/// nameColor
@property (nonatomic, strong) UIColor *nameColor;

@property (nonatomic, copy, nullable) GNCommonBlock block;

@property (nonatomic, assign) BOOL leftHigh;

@property (nonatomic, assign) BOOL rightHigh;

@property (nonatomic, strong, nullable) id object;
///最后一个
@property (nonatomic, assign) BOOL last;
///第一个
@property (nonatomic, assign) BOOL first;
/// cellClickEnable
@property (nonatomic, assign) BOOL cellClickEnable;
/// rightClickEnable
@property (nonatomic, assign) BOOL rightClickEnable;
/// rightBTN 热区
@property (nonatomic, assign) BOOL rightHotArea;
/// btn外边距
@property (nonatomic, assign) UIEdgeInsets outInsets;
/// btn内边距
@property (nonatomic, assign) UIEdgeInsets innerInsets;
/// 快速创建class
+ (GNCellModel *)createClass:(nullable NSString *)classStr;

- (instancetype)initTitle:(nullable NSString *)title image:(nullable UIImage *)image;

- (instancetype)initTitle:(nullable NSString *)title detail:(nullable NSString *)detail;

- (instancetype)initTitle:(nullable NSString *)title image:(nullable UIImage *)image detail:(nullable NSString *)detail;

@end

NS_ASSUME_NONNULL_END
