//
//  SACMSNewUserMarketingViewConfig.h
//  SuperApp
//
//  Created by seeu on 2022/7/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACMSNewUserMarketingViewConfig : SACodingModel
///< icon
@property (nonatomic, copy) NSString *icon;
///< icon link
@property (nonatomic, copy) NSString *iconJumpLink;
///< title
@property (nonatomic, copy) NSString *title;
///< titleColor
@property (nonatomic, copy) NSString *titleColor;
///< titleFont
@property (nonatomic, assign) CGFloat titleFont;
///< buttonTitle
@property (nonatomic, copy) NSString *buttonTitle;
///< buttonTitleColor
@property (nonatomic, copy) NSString *buttonTitleColor;
///< buttonTitleFont
@property (nonatomic, assign) CGFloat buttonTitleFont;
///< buttonColor
@property (nonatomic, copy) NSString *buttonColor;
///< buttonJumpLink
@property (nonatomic, copy) NSString *buttonJumpLink;

@end

NS_ASSUME_NONNULL_END
