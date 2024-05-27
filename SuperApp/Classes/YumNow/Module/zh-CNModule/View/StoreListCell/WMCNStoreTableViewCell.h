//
//  WMCNStoreTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/12/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMStoreModel.h"
#import "WMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMCNStoreTableViewCell : WMTableViewCell

@property (nonatomic, strong) WMBaseStoreModel *model;

@end

NS_ASSUME_NONNULL_END
