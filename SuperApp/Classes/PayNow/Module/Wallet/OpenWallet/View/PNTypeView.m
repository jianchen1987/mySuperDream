//
//  TypeView.m
//  SuperApp
//
//  Created by Quin on 2021/11/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNTypeView.h"


@implementation PNTypeView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    _gridView = HDGridView.new;
    _gridView.columnCount = 4;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.shouldShowSeparator = false;
    //    _gridView.separatorWidth = PixelOne * 2;
    _gridView.separatorDashed = false;
    //    _gridView.separatorLineDashPattern = @[@3, @2];
    _gridView.separatorColor = UIColor.whiteColor;
    //    _gridView.separatorEdgeInsets = UIEdgeInsetsMake(15, 0, 12, 0);
    _gridView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:10];
    };
    [self addSubview:self.bgView];
    [self.bgView addSubview:_gridView];

    void (^addSubViewToGridView)(NSString *, NSString *, ButtonBlock) = ^void(NSString *title, NSString *img, ButtonBlock handler) {
        UIButton *button = UIButton.new;
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateHighlighted];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button addTouchUpInsideHandler:handler];
        //        [HDCommonButton btnExchangeTextAndImg:button Margin:40 Type:HDCommonButtonImageULabelD];
        UILabel *label = UILabel.new;
        label.text = title;
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = [HDAppTheme.font forSize:13];

        UIView *view = UIView.new;
        [view addSubview:button];
        [view addSubview:label];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view.mas_top).offset(kRealHeight(25));
        }];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.bottom.equalTo(view.mas_bottom).offset(-kRealHeight(25));
        }];

        [self.gridView addSubview:view];
    };

    addSubViewToGridView(PNLocalizedString(@"wallet_pay", @"钱包支付"),
                         @"pay_pay",
                         ^(UIButton *button){
                         });

    addSubViewToGridView(PNLocalizedString(@"TRANS_TYPE_TRANSFER", @"转账"),
                         @"pay_trans",
                         ^(UIButton *button){

                         });

    addSubViewToGridView(PNLocalizedString(@"exchange", @"兑换"),
                         @"pay_exchange",
                         ^(UIButton *button){
                         });
    addSubViewToGridView(PNLocalizedString(@"more", @"更多"),
                         @"pay_more",
                         ^(UIButton *button){
                         });
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
#pragma mark - layout
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10 shadowRadius:10 shadowOpacity:1 shadowColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.04].CGColor
                          fillColor:UIColor.whiteColor.CGColor
                       shadowOffset:CGSizeMake(0, 5)];
        };
    }
    return _bgView;
}

@end
