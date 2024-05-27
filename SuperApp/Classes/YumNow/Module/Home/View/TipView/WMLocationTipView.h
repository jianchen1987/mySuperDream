//
//  WMLocationTipView.h
//  SuperApp
//
//  Created by wmz on 2021/12/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAShoppingAddressModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMLocationTipView : SAView
///关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
///文本
@property (nonatomic, strong) HDLabel *titleLB;
///是否正在显示
@property (nonatomic, assign, getter=isShow) BOOL show;
///透明度 default 1
@property (nonatomic, assign) CGFloat alpa;

- (void)hd_changeUI;

- (void)show;

- (void)dissmiss;

@end

NS_ASSUME_NONNULL_END
