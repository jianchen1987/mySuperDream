//
//  WMOrderSubmitProductView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMShoppingCartStoreProduct;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitProductView : SAView
/// 模型
@property (nonatomic, strong) WMShoppingCartStoreProduct *model;

@property (nonatomic, assign) BOOL fromOrderDetail;
@end

NS_ASSUME_NONNULL_END
