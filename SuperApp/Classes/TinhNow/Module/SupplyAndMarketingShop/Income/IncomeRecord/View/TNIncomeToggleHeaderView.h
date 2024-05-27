//
//  TNIncomeToggleHeaderView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableHeaderFooterView.h"
#import "TNEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNIncomeToggleHeaderView : SATableHeaderFooterView
///
@property (nonatomic, copy) void (^itemClickCallBack)(TNSellerIdentityType type);
@end

NS_ASSUME_NONNULL_END
