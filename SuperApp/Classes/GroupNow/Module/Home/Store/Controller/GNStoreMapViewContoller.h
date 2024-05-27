//
//  GNStoreMapViewContoller.h
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailModel.h"
#import "GNViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNStoreMapViewContoller : GNViewController
@property (nonatomic, strong) GNStoreDetailModel *storeModel; ///传过来的门店model
@property (nonatomic, copy) NSString *storeNo;                ///门店编号
@end

NS_ASSUME_NONNULL_END
