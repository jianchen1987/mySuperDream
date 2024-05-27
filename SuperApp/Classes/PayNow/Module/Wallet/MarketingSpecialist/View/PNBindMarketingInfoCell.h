//
//  PNBindMarketingInfoCell.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMarketingListItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNBindMarketingInfoCell : PNTableViewCell
@property (nonatomic, strong) PNMarketingListItemModel *model;
@end

NS_ASSUME_NONNULL_END
