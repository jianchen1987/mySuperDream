//
//  WMShoppingCartSelecedAllView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartSelectedAllView : SAView

/// 是否全选
@property (nonatomic, assign, readonly, getter=isSelectedAll) BOOL selectedAll;
/// 展示失效数量
@property (nonatomic, assign) NSInteger failGoodCount;
/// 全选回调
@property (nonatomic, copy) void (^selectedAllClickCallBack)(BOOL isSelecedAll);
/// 删除回调
@property (nonatomic, copy) void (^deleteClickCallBack)(void);
/// 删除回调
@property (nonatomic, copy) void (^deleteFailClickCallBack)(void);
//设置全选
- (void)setSelectedBtnStatus:(BOOL)isSelectedAll;
//设置删除按钮的是否可用
- (void)setDeleteBtnEnabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
