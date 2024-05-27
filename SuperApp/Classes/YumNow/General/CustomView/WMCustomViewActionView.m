//
//  WMCustomViewActionView.m
//  SuperApp
//
//  Created by wmz on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCustomViewActionView.h"
#import "HDAppTheme+YumNow.h"
#import "Masonry.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIImage+HDKitCore.h>
#import <HDKitCore/UIView+HD_Extension.h>


@implementation WMCustomViewActionView

+ (instancetype)actionViewWithContentView:(UIView<HDCustomViewActionViewProtocol> *)contentView block:(WMCustomConfigBlock)block {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerMinHeight = kRealWidth(100);
    config.marginTitleToContentView = kRealWidth(16);
    config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
    config.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
    config.titleColor = HDAppTheme.WMColor.B3;
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.contentHorizontalEdgeMargin = 0;
    if (block)
        block(config);
    return [self actionViewWithContentView:contentView config:config];
}

- (void)setupContainerSubViews {
    [super setupContainerSubViews];
    UIButton *btn = [self valueForKey:@"button"];
    [btn setImage:[UIImage imageNamed:@"yn_bottom_del"] forState:UIControlStateNormal];
}

+ (HDAlertView *)showTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
                   confirm:(nullable NSString *)confirm
                   handler:(HDAlertViewButtonHandler)handler
                    config:(nullable WMAlertConfigBlock)block {
    HDAlertViewConfig *config = HDAlertViewConfig.new;
    config.titleFont = [HDAppTheme.WMFont wm_boldForSize:18];
    config.containerCorner = kRealWidth(14);
    config.titleColor = HDAppTheme.WMColor.B3;
    config.marginMessageToButton = kRealWidth(40);
    config.buttonHeight = kRealWidth(48);
    config.messageFont = [HDAppTheme.WMFont wm_ForSize:13];
    config.messageColor = HDAppTheme.WMColor.B6;
    config.marginTitle2Message = title ? kRealWidth(28) : kRealWidth(0);
    if (block)
        block(config);
    HDAlertView *alert = [HDAlertView alertViewWithTitle:title message:message config:config];
    if (confirm) {
        HDAlertViewButton *button = [HDAlertViewButton buttonWithTitle:confirm type:HDAlertViewButtonTypeDefault handler:handler];
        UIView *lineView = UIView.new;
        lineView.backgroundColor = HDAppTheme.WMColor.lineColor;
        [button addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(0.8);
        }];
        [button addSubview:lineView];
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.backgroundColor = HDAppTheme.WMColor.bg3;
        [alert addButton:button];
    }
    return alert;
}

+ (WMNormalAlertView *)WMAlertWithConfig:(WMNormalAlertConfig *)config {
    WMNormalAlertView *alert = [[WMNormalAlertView alloc] initWithConfig:config];
    [alert show];
    return alert;
}

+ (WMNormalAlertView *)WMAlertWithContent:(NSString *)content {
    WMNormalAlertConfig *config = WMNormalAlertConfig.new;
    config.content = content;
    return [WMCustomViewActionView WMAlertWithContent:content handle:nil];
}

+ (WMNormalAlertView *)WMAlertWithContent:(NSString *)content handle:(nullable WMAlertViewButtonHandler)handle {
    WMNormalAlertConfig *config = WMNormalAlertConfig.new;
    config.content = content;
    config.confirmHandle = handle;
    WMNormalAlertView *alert = [[WMNormalAlertView alloc] initWithConfig:config];
    [alert show];
    return alert;
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
