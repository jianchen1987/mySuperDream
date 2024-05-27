//
//  TNFreightDetailAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SAMoneyModel;


@interface TNFreightDetailAlertView : HDActionAlertView
- (instancetype)initWithBaseFreight:(SAMoneyModel *)baseFreight additionalFreight:(SAMoneyModel *)additionalFreight;
@end

NS_ASSUME_NONNULL_END
