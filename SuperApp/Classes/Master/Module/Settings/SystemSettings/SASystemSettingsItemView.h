//
//  SASystemSettingsItemView.h
//  SuperApp
//
//  Created by Tia on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASystemSettingsItemView : SAView

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UISwitch *itemSwitch;

@property (nonatomic, strong) UIView *line;

@end

NS_ASSUME_NONNULL_END
