//
//  GNSubmitOrderViewController.h
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderBaseViewController.h"
#import "GNProductModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface GNSubmitOrderViewController : GNOrderBaseViewController
///门店编号
@property (nonatomic, copy, nonnull) NSString *storeNo;
/// 商品编号
@property (nonatomic, copy, nonnull) NSString *productCode;

@end

NS_ASSUME_NONNULL_END
