//
//  WMKingKongNewTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMKingKongAreaModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewKingKongTableViewCell : WMCardTableViewCell
@property (nonatomic, copy) NSArray<WMKingKongAreaModel *> *model;
@end


@interface WMNewKingKongItemCardCell : WMItemCardCell

@end


NS_ASSUME_NONNULL_END
