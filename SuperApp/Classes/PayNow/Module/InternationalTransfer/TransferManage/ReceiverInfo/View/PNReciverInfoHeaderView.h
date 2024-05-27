//
//  PNReciverInfoHeaderView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNReciverInfoHeaderView : PNView
@property (nonatomic, strong) HDUIButton *agreementBtn;

- (instancetype)initWithChannel:(PNInterTransferThunesChannel)channel;

- (void)setBgViewLabyer;
@end

NS_ASSUME_NONNULL_END
