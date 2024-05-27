//
//  WMSimilarStoresView.h
//  SuperApp
//
//  Created by wmz on 2022/7/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMStoreListItemModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSimilarStoresView : SAView <HDCustomViewActionViewProtocol>
/// 门店号
@property (nonatomic, strong) NSString *storeNo;
/// 选中回调
@property (nonatomic, copy) void (^clickedConfirmBlock)(WMStoreListItemModel *model);

@end

NS_ASSUME_NONNULL_END
