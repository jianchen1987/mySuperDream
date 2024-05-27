//
//  PNMSStoreOperatoreInfoCell.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTableViewCell.h"

@class PNMSStoreOperatorInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickQrCodeBlock)(PNMSStoreOperatorInfoModel *model);
typedef void (^ClickUnBindBlock)(PNMSStoreOperatorInfoModel *model);


@interface PNMSStoreOperatoreInfoCell : PNTableViewCell
@property (nonatomic, strong) PNMSStoreOperatorInfoModel *model;

@property (nonatomic, strong) ClickQrCodeBlock qrCodeBlock;
@property (nonatomic, strong) ClickUnBindBlock unBindBlock;
@end

NS_ASSUME_NONNULL_END
