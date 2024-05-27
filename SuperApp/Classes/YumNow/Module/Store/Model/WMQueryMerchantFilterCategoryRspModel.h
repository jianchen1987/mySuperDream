//
//  WMQueryMerchantFilterCategoryRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMCategoryItem;


@interface WMQueryMerchantFilterCategoryRspModel : WMRspModel
/// itemslist
@property (nonatomic, strong) NSArray<WMCategoryItem *> *list;
@end

NS_ASSUME_NONNULL_END
