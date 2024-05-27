//
//  WMChooseGoodsSpecificationView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMStoreGoodsProductSpecification;

NS_ASSUME_NONNULL_BEGIN

/// 单个商品规格控件
@interface WMChooseGoodsSpecificationView : SAView
/// 模型
@property (nonatomic, strong) WMStoreGoodsProductSpecification *model;
/// 点击了选中按钮
@property (nonatomic, copy) void (^clickedSelectBTNBlock)(HDUIButton *button);
/// 设置按钮选中状态
- (void)setSelectBtnSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
