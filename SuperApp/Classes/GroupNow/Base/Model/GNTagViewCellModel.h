//
//  GNTagViewCellModel.h
//  SuperApp
//
//  Created by wmz on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCellModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNTagViewCellModel : GNCellModel
/// 数据源
@property (nonatomic, strong) NSArray *tagArr;
/// 圆角
@property (nonatomic, assign) CGFloat cornerRadius;
/// 背景颜色
@property (nonatomic, strong) UIColor *bgColor;
/// 选中背景颜色
@property (nonatomic, strong) UIColor *bgSelectColor;
/// 文本
@property (nonatomic, strong) UIColor *textColor;
/// 选中文本颜色
@property (nonatomic, strong) UIColor *textSelectColor;
/// 可交互
@property (nonatomic, assign) BOOL userEnable;
/// 间距
@property (nonatomic, assign) CGFloat space;
/// collectionView背景颜色
@property (nonatomic, strong) UIColor *collectionViewBgColor;
/// 内边距
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 高度
@property (nonatomic, assign) CGFloat height;
/// 暂无设置
@property (nonatomic, copy) NSString *showEmpty;
/// 携带的model
@property (nonatomic, strong) id model;
/// minimumInteritemSpacing
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/// minimumLineSpacing
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/// itemSizeH
@property (nonatomic, assign) CGFloat itemSizeH;
/// textAligment
@property (nonatomic, assign) UIControlContentHorizontalAlignment textAligment;
/// hideBorder
@property (nonatomic, assign) BOOL hideBorder;

@end

NS_ASSUME_NONNULL_END
