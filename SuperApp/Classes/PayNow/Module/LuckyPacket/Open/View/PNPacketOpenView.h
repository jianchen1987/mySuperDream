//
//  PNPacketOpenView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "PNPacketDetailModel.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CloseBtnBlock)(void);


@interface PNPacketOpenView : HDActionAlertView

@property (nonatomic, copy) CloseBtnBlock closeBtnBlock;

- (instancetype)initWithModel:(PNPacketDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
