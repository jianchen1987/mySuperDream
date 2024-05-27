//
//  TNPhoneActionAlertView.h
//  SuperApp
//
//  Created by xixi on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TNPhoneActionAlertView : HDActionAlertView

/// 初始化
- (instancetype)initWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView;
@end

NS_ASSUME_NONNULL_END
