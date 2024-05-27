//
//  TNSellerOrderCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
@class TNSellerOrderProductsModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderCell : SATableViewCell
///  海外购渠道  有值就是海外购  订单级别的  在model之前赋值
@property (nonatomic, copy) NSString *overseaChannel;
@property (strong, nonatomic) TNSellerOrderProductsModel *model;
@end

NS_ASSUME_NONNULL_END
