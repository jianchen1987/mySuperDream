//
//  SAMarketingAlertViewCollectionCell.h
//  SuperApp
//
//  Created by seeu on 2023/10/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SAMarketingAlertView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAMarketingAlertViewCollectionCell : SACollectionViewCell
///< model
@property (nonatomic, strong) SAMarketingAlertItem *model;
@end

NS_ASSUME_NONNULL_END
