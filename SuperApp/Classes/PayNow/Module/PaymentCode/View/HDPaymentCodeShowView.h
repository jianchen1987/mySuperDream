//
//  HDPaymentCodeShowView.h
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDPaymentCodeShowViewCoverType) {
    HDPaymentCodeShowViewCoverTypeFirstTimeOpen = 0, ///< 第一次开启
    HDPaymentCodeShowViewCoverTypeReOpen,            ///< 再次开启
    HDPaymentCodeShowViewCoverTypeWarning,           ///< 截屏警告
    HDPaymentCodeShowViewCoverTypeOffline,           ///< 网络不可用
    HDPaymentCodeShowViewCoverTypeOther              ///< 其它，比如转模型错误
};

NS_ASSUME_NONNULL_BEGIN


@interface HDPaymentCodeShowView : UIView
/** 点击了协议 */
@property (nonatomic, copy) void (^clickedAgreementLabelHandler)(void);
/** 点击了蒙层按钮 */
@property (nonatomic, copy) void (^clickedCoverViewButtonHandler)(HDPaymentCodeShowViewCoverType type);

@property (nonatomic, assign, readonly) BOOL isShowingPaymentCode; ///< 是否正在展示付款码

- (void)showCoverViewForType:(HDPaymentCodeShowViewCoverType)type;
- (void)showCoverViewForOtherTypeWithTip:(NSString *)tip buttonTitle:(NSString *)buttonTitle;

- (void)hideCoverView;
- (void)updateBarCodeImage:(UIImage *)image contentStr:(NSString *)contentStr;
- (void)updateQRCodeImage:(UIImage *)image contentStr:(NSString *)contentStr;

- (void)showLoading;
- (void)dismissLoading;
@end

NS_ASSUME_NONNULL_END
