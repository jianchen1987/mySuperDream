//
//  WMKingKongTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMKingKongAreaModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMKingKongTableViewCell : WMCardTableViewCell
@property (nonatomic, copy) NSArray<WMKingKongAreaModel *> *model;
@end


@interface WMKingKongItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
