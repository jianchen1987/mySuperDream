//
//  PNMSOperatorListCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMSOperatorInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickResetPasswordBlock)(PNMSOperatorInfoModel *model);
typedef void (^ClickUnBindBlock)(PNMSOperatorInfoModel *model);


@interface PNMSOperatorListCell : PNTableViewCell
@property (nonatomic, strong) PNMSOperatorInfoModel *model;

@property (nonatomic, strong) ClickResetPasswordBlock resetPasswordBlock;
@property (nonatomic, strong) ClickUnBindBlock unBindBlock;
@end

NS_ASSUME_NONNULL_END
