//
//  WMFoucsAdvertiseTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//
#import "WMAdadvertisingModel.h"
#import "WMCardTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFoucsAdvertiseTableViewCell : WMCardTableViewCell
@property (nonatomic, copy) NSArray<WMAdadvertisingModel *> *model;
@end


@interface WMAdvertiseItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
