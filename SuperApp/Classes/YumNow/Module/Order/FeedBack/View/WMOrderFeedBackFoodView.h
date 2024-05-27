//
//  WMOrderFeedBackFoodView.h
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMEnum.h"
#import "WMFeedBackRefundAmountModel.h"
#import "WMShoppingCartStoreProduct.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackFoodView : SAView
///商品列表
@property (nonatomic, strong) NSArray<WMShoppingCartStoreProduct *> *productArr;
/// orderNo
@property (nonatomic, copy) NSString *orderNo;
///标志
@property (nonatomic, assign) BOOL flag;
/// type
@property (nonatomic, copy) WMOrderFeedBackPostShowType type;
///退款model
@property (nonatomic, strong, nullable) WMFeedBackRefundAmountModel *rspModel;

@end


@interface WMOrderFeedBackFoodItemView : SAView
/// model
@property (nonatomic, strong) WMShoppingCartStoreProduct *model;
/// 选中
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMShoppingCartStoreProduct *model);
/// 数量改变
@property (nonatomic, copy) void (^changeNumBlock)(WMShoppingCartStoreProduct *model);
///刷新内容
- (void)updateContent;
@end

NS_ASSUME_NONNULL_END
