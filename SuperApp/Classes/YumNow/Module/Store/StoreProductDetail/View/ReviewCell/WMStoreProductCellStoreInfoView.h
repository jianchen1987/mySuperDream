//
//  WMStoreProductCellStoreInfoView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

/// 评论 cell 上门店信息
@interface WMStoreProductCellStoreInfoView : SAView
/// 更新信息
- (void)updateStoreImageWithImageURL:(NSString *)imageURL storeName:(NSString *)storeName storeDesc:(NSString *)storeDesc;
@end

NS_ASSUME_NONNULL_END
