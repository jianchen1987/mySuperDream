//
//  GNStoreProductHomeController.h
//  SuperApp
//
//  Created by wmz on 2021/6/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailModel.h"
#import "WMZPageController.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreProductHomeController : GNViewController
///传过来的门店model 如果有则不请求
@property (nonatomic, strong) GNStoreDetailModel *storeModel;
///门店编号
@property (nonatomic, strong) NSString *storeNo;
///选中的产品编号
@property (nonatomic, strong) NSString *productCode;

@end

NS_ASSUME_NONNULL_END
