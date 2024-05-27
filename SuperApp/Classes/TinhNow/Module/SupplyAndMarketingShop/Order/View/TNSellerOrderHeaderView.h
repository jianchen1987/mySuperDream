//
//  TNSellerOrderHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
@class TNSellerOrderModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderHeaderView : SATableHeaderFooterView
@property (strong, nonatomic) TNSellerOrderModel *model;
@end

NS_ASSUME_NONNULL_END
