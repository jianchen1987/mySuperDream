//
//  WMGoodFailView.h
//  SuperApp
//
//  Created by wmz on 2023/5/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMShoppingCartStoreProduct.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMGoodFailView : SAView <HDCustomViewActionViewProtocol>
@property (nonatomic, strong) NSArray *dataSource;
/// 选中回调
@property (nonatomic, copy) void (^clickedConfirmBlock)(void);
@end


@interface WMGoodFailItemView : SAView
@property (nonatomic, strong) WMShoppingCartStoreProduct *product;
@end

NS_ASSUME_NONNULL_END
