//
//  WMOrderModifyAddressTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/10/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTableViewCell.h"
#import "SAShoppingAddressModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderModifyAddressTableViewCell : GNTableViewCell
/// 模型
@property (nonatomic, strong) SAShoppingAddressModel *model;
/// cellModel
@property (nonatomic, strong) GNCellModel *cellModel;
@end

NS_ASSUME_NONNULL_END
