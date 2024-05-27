//
//  PNBillCategoryItemModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillCategoryItemModel : PNModel
/// id
@property (nonatomic, strong) NSString *idStr;
/// 大分类message
@property (nonatomic, strong) NSString *billerProductParent;
/// 大分类code
@property (nonatomic, strong) NSString *billerProductParentCode;
/// 小分类message
@property (nonatomic, strong) NSString *billerProduct;
/// 小分类code
@property (nonatomic, assign) NSString *billerProductCode;
/// 产品名称message
@property (nonatomic, strong) NSString *paymentCategory;
/// 产品名称code
@property (nonatomic, assign) PNPaymentCategory paymentCategoryCode;
/// 产品名称图标
@property (nonatomic, strong) NSString *paymentCategoryIcon;
///
@property (nonatomic, strong) NSString *createTime;
///
@property (nonatomic, strong) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
