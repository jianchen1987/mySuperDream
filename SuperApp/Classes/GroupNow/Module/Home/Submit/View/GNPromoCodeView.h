//
//  GNPromoCodeView.h
//  SuperApp
//
//  Created by wmz on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNPromoCodeView : GNView <UITextFieldDelegate>
/// titleLB
@property (nonatomic, strong) UILabel *titleLB;
/// textField
@property (nonatomic, strong) UITextField *textField;
@end

NS_ASSUME_NONNULL_END
