//
//  WMBrandThemeTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMThemeTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMBrandThemeTableViewCell : WMThemeTableViewCell

@end


@interface WMBrandThemeItemCardCell : WMItemCardCell
@property (nonatomic, strong) WMModel *model;
@end

NS_ASSUME_NONNULL_END
