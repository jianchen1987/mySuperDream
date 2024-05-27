//
//  SAOrderProductInfoTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAGoodsModel.h"
#import "SAModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SAOrderProductInfoTableViewCellModel;


@interface SAOrderProductInfoTableViewCell : SATableViewCell
///< model
@property (nonatomic, strong) SAOrderProductInfoTableViewCellModel *model;
@end


@interface SAOrderProductInfoTableViewCellModel : SAModel
///< storelogo
@property (nonatomic, copy, nullable) NSString *storeLogo;
///< storeName
@property (nonatomic, copy, nullable) NSString *storeName;
///< storeNo
@property (nonatomic, copy, nullable) NSString *storeNo;
///< 一级商户号
@property (nonatomic, copy) NSString *firstMerchantNo;
///< 二级商户号
@property (nonatomic, copy) NSString *secondMerchantNo;

///< 商品
@property (nonatomic, strong) NSArray<SAGoodsModel *> *productList;

@end

NS_ASSUME_NONNULL_END
