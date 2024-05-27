//
//  TNActivityRuleView.h
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNActivityRuleView : TNView <HDCustomViewActionViewProtocol>
- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
