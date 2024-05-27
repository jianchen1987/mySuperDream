//
//  PNWalletFunctionModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/15.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "PNWalletListConfigModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNWalletFunctionModel : PNModel
/// 右上角的设置
@property (nonatomic, strong) NSArray<PNWalletListConfigModel *> *SETTING;
/// 扫一扫、付款码、收款码
@property (nonatomic, strong) NSArray<PNWalletListConfigModel *> *RIBBON;
/// 功能列表区
@property (nonatomic, strong) NSArray<PNWalletListConfigModel *> *ENTRANCE;
@end

NS_ASSUME_NONNULL_END
