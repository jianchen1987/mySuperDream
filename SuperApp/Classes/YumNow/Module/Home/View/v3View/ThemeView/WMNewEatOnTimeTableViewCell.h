//
//  WMEatOnTimeTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMThemeModel.h"
#import "WMeatOnTimeThemeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewEatOnTimeTableViewCell : WMCardTableViewCell

@property (nonatomic, strong) WMThemeModel *model;

@end


@interface WMNewEatOnTimeItemCardCell : WMItemCardCell

@end


NS_ASSUME_NONNULL_END
