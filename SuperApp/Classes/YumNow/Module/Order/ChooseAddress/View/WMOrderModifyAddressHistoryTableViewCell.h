//
//  WMOrderModifyAddressHistoryTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTableViewCell.h"
#import "WMModifyAddressListModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderModifyAddressHistoryTableViewCell : GNTableViewCell
@property (nonatomic, strong) WMModifyAddressListModel *model;
@end

NS_ASSUME_NONNULL_END
