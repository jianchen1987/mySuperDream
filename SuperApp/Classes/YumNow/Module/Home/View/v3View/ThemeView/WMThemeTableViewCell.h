//
//  WMThemeTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMThemeModel.h"
#import "WMeatOnTimeThemeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMThemeTableViewCell : WMCardTableViewCell
@property (nonatomic, strong) WMThemeModel *model;
@end


@interface WMThemeItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
