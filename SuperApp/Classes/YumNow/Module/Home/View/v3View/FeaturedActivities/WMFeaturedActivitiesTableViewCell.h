//
//  WMFeaturedActivitiesTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/12.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMAdadvertisingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFeaturedActivitiesTableViewCell : WMCardTableViewCell

@property (nonatomic, copy) NSArray<WMAdadvertisingModel *> *model;

@end


@interface WMFeaturedActivitiesItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
