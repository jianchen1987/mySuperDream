//
//  WMChooseGoodsSkuView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMStoreGoodsProductPropertyOption;

NS_ASSUME_NONNULL_BEGIN

/// 单个商品规格控件
@interface WMChooseGoodsPropertyView : SAView
/// 模型
@property (nonatomic, strong) WMStoreGoodsProductPropertyOption *model;
/// 点击了选中按钮
@property (nonatomic, copy) BOOL (^clickedSelectBTNBlock)(HDUIButton *button);
/// 设置按钮选中状态
- (void)setSelectBtnSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
