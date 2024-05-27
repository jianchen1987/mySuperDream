//
//  TNSkuSpecView.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNSkuSpecModel;
@class TNProductSkuModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSkuSpecView : TNView
/// sku
@property (strong, nonatomic) TNSkuSpecModel *model;
/// 选中了规格后的回调  如果回调的skuModel为空  即没选完整
@property (nonatomic, copy) void (^selectedSkuCallBack)(NSSet<NSIndexPath *> *selecedIndexSet, TNProductSkuModel *skuModel);
/// collectionView高度
@property (nonatomic, assign) CGFloat collectionViewHeight;
/// 获取到最终高度的回调
@property (nonatomic, copy) void (^collectionViewHeightCallBack)(void);
/// 选择的sku数量
@property (nonatomic, assign) NSInteger selectedCount;
/// 即将弹出键盘  如果规格弹窗视图高度太低  需要拉长高度
@property (nonatomic, copy) void (^willShowKeyboardModifyCountCallBack)(CGRect keyboardRect);
/// 即将关闭键盘  还原视图
@property (nonatomic, copy) void (^willHiddenKeyboardModifyCountCallBack)(void);
@end

NS_ASSUME_NONNULL_END
