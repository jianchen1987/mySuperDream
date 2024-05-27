//
//  WMNewThemeTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMThemeModel.h"
#import "WMeatOnTimeThemeModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewThemeTableViewCell : WMCardTableViewCell

@property (nonatomic, strong) WMThemeModel *model;

@end


@interface WMNewThemeItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
