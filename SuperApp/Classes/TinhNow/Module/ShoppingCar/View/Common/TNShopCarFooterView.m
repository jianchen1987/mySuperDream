//
//  TNShopCarFooterView.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNShopCarFooterView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"


@interface TNShopCarFooterView ()
/// 金额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 操作按钮
@property (nonatomic, strong) SAOperationButton *operationBtn;
@end


@implementation TNShopCarFooterView
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.operationBtn];

    self.contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:10];
    };
}
- (void)setCalculateAmount:(NSString *)calculateAmount {
    _calculateAmount = calculateAmount;
    if (HDIsStringNotEmpty(calculateAmount)) {
        self.moneyLabel.hidden = NO;
        self.operationBtn.userInteractionEnabled = YES;
        [self.operationBtn applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:1]];
        NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:TNLocalizedString(@"sub_total", @"总计")
                                                                       attributes:@{NSFontAttributeName: self.moneyLabel.font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1}];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

        NSAttributedString *moneyStr = [[NSAttributedString alloc] initWithString:calculateAmount
                                                                       attributes:@{NSFontAttributeName: self.moneyLabel.font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.cFF2323}];
        [text appendAttributedString:moneyStr];

        self.moneyLabel.attributedText = text;
    } else {
        self.moneyLabel.hidden = YES;
        [self.operationBtn applyPropertiesWithBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:0.30]];
        self.operationBtn.userInteractionEnabled = NO;
    }
}
- (void)updateConstraints {
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.operationBtn.mas_left).offset(-kRealWidth(10));
    }];
    [self.operationBtn sizeToFit];
    [self.operationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        UILabel *label = UILabel.new;
        label.font = [HDAppTheme.TinhNowFont fontSemibold:17];
        label.textColor = HDAppTheme.TinhNowColor.G1;
        label.numberOfLines = 2;
        label.adjustsFontSizeToFitWidth = YES;
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (SAOperationButton *)operationBtn {
    if (!_operationBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(6, 23, 6, 23);
        [button setTitle:TNLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickToSubmitOrderCallback ?: self.clickToSubmitOrderCallback();
        }];
        _operationBtn = button;
    }
    return _operationBtn;
}
@end
