//
//  WMNewBrandThemeTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewThemeTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewBrandThemeTableViewCell : WMNewThemeTableViewCell

@end


@interface WMNewBrandThemeItemCardCell : WMItemCardCell
@property (nonatomic, strong) WMModel *model;
@end

NS_ASSUME_NONNULL_END
