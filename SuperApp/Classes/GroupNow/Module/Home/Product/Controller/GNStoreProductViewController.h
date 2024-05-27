//
//  GNStoreProductViewController.h
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductViewModel.h"
#import "GNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNStoreProductViewController : GNViewController
///门店编号
@property (nonatomic, copy) NSString *storeNo;
///商品详情id
@property (nonatomic, copy) NSString *productNo;
///所属下标
@property (nonatomic, assign) NSInteger index;
/// viewModel
@property (nonatomic, strong) GNStoreProductViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
