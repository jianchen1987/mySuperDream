//
//  PNMSWithdrawListItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickBtnBlock)(void);


@interface PNMSWithdrawListItemView : PNView
@property (nonatomic, copy) ClickBtnBlock clickBtnBlock;

- (void)setTitlel:(NSString *)title icon:(NSString *)icon;
@end

NS_ASSUME_NONNULL_END
