//
//  WMTopShortcutOptionsTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMCardTableViewCell.h"
#import "WMAdadvertisingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMTopShortcutOptionsTableViewCell : WMCardTableViewCell
@property (nonatomic, copy) NSArray<WMAdadvertisingModel *> *model;

@end


@interface WMTopShortcutOptionsItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
