//
//  PayHDCheckstandPaymentDetailTitleModel.h
//  ViPay
//
//  Created by VanJay on 2019/6/10.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandPaymentDetailTitleModel : NSObject

@property (nonatomic, assign) CGFloat sideFontSize;   ///< 两边字体
@property (nonatomic, assign) CGFloat middleFontSize; ///< 中间字体
@property (nonatomic, strong) UIColor *sideColor;     ///< 两边颜色
@property (nonatomic, strong) UIColor *middleColor;   ///< 中间颜色
@property (nonatomic, copy) NSString *leftStr;        ///< 左边文字
@property (nonatomic, copy) NSString *middleStr;      ///< 中间文字
@property (nonatomic, copy) NSString *rightStr;       ///< 右边文字
@end

NS_ASSUME_NONNULL_END
