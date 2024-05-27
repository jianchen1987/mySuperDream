//
//  SAWalletBillTableHeaderViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillTableHeaderViewModel : SAModel
/// 按钮标题
@property (nonatomic, copy) NSString *btnTitle;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 描述颜色
@property (nonatomic, strong) UIColor *descColor;
/// 属性文字描述，优先级高于 desc
@property (nonatomic, copy) NSAttributedString *attrDesc;
@end

NS_ASSUME_NONNULL_END
