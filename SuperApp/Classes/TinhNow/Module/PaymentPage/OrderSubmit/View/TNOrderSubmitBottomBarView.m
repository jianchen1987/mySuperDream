//
//  TNOrderSubmitBottomBarView.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitBottomBarView.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "TNCalcTotalPayFeeTrialRspModel.h"
#import "TNDecimalTool.h"
#import "TNOrderSubmitViewModel.h"


@interface TNOrderSubmitBottomBarView ()

/// total
@property (nonatomic, strong) UILabel *totalLabel;
/// submitButton
@property (nonatomic, strong) SAOperationButton *confirmButton;
/// 瑞尔价格
@property (strong, nonatomic) UILabel *khrPriceLabel;
/// viewmodel
@property (nonatomic, strong) TNOrderSubmitViewModel *viewModel;

@end


@implementation TNOrderSubmitBottomBarView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.totalLabel];
    [self addSubview:self.confirmButton];
    [self addSubview:self.khrPriceLabel];
}
- (void)hd_bindViewModel {
    [self updateInfo];
    @HDWeakify(self);
    self.viewModel.calcPayFeeFailBlock = ^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        //试算失败就不能点击
        [self.confirmButton setEnabled:NO];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"dataSource" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateInfo];
    }];
}

- (void)updateConstraints {
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(16);
        if (self.khrPriceLabel.isHidden) {
            make.bottom.equalTo(self.mas_bottom).offset(-16);
        }
        make.right.lessThanOrEqualTo(self.confirmButton.mas_left).offset(-10);
    }];
    if (!self.khrPriceLabel.isHidden) {
        [self.khrPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalLabel.mas_left);
            make.top.equalTo(self.totalLabel.mas_bottom).offset(2);
            make.bottom.equalTo(self.mas_bottom).offset(-16);
        }];
    }

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(kRealWidth(36));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
- (void)updateInfo {
    NSString *str1 = TNLocalizedString(@"tn_page_totalcount_text", @"Total:");
    NSString *str2 = self.viewModel.calcResult ? self.viewModel.calcResult.amountPayable.thousandSeparatorAmount : @"$0.00";
    NSString *str3;
    //计算在线支付优惠展示
    NSString *showStr;
    if (!HDIsObjectNil(self.viewModel.calcResult.amountPayable) && self.viewModel.calcResult.amountPayable.cent.integerValue > 0 && !HDIsObjectNil(self.viewModel.paydiscountAmount)
        && self.viewModel.paydiscountAmount.cent.integerValue > 0) {
        SAMoneyModel *showMoney = [self.viewModel.calcResult.amountPayable minus:self.viewModel.paydiscountAmount];
        str2 = [showMoney.thousandSeparatorAmount stringByAppendingString:@" "]; //增加空格展示
        str3 = self.viewModel.calcResult.amountPayable.thousandSeparatorAmount;
        showStr = [str1 stringByAppendingString:str2];
        showStr = [showStr stringByAppendingString:str3];
        if (HDIsStringNotEmpty(self.viewModel.calcResult.khrExchangeRate) && HDIsStringNotEmpty(self.viewModel.calcResult.khrAmount)) {
            //计算支付优惠之后的瑞尔金额
            NSDecimalNumber *num = [TNDecimalTool decimalDividingBy:[TNDecimalTool stringDecimalMultiplyingBy:showMoney.amount num2:self.viewModel.calcResult.khrExchangeRate]
                                                               num2:[TNDecimalTool toDecimalNumber:@"100"]];
            self.viewModel.calcResult.khrAmount = [[TNDecimalTool decimalMultiplyingBy:[TNDecimalTool roundingNumber:num afterPoint:0] num2:[TNDecimalTool toDecimalNumber:@"100"]] stringValue];
        }

    } else {
        showStr = [str1 stringByAppendingString:str2];
    }

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:showStr];
    [attributeStr addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, str1.length)];
    [attributeStr addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard17B, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.C3} range:NSMakeRange(str1.length, str2.length)];
    if (HDIsStringNotEmpty(str3)) {
        [attributeStr addAttributes:@{
            NSFontAttributeName: HDAppTheme.TinhNowFont.standard15,
            NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G3,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSBaselineOffsetAttributeName: @(0), // iOS13 不添加这个属性可能显示不出删除线
            NSStrikethroughColorAttributeName: HDAppTheme.TinhNowColor.G3
        }
                              range:NSMakeRange(str1.length + str2.length, str3.length)];
    }

    self.totalLabel.attributedText = attributeStr;

    self.khrPriceLabel.hidden = HDIsStringEmpty(self.viewModel.calcResult.khrAmount);
    if (!self.khrPriceLabel.isHidden) {
        self.khrPriceLabel.text = [SAMoneyTools thousandSeparatorAmountYuan:self.viewModel.calcResult.khrAmount currencyCode:@"KHR"];
    }

    if (self.viewModel.calcResult.amountPayable) { //没有试算结果出来  也不要让按钮可点击
        [self.confirmButton setEnabled:YES];
    } else {
        [self.confirmButton setEnabled:NO];
    }
    [self setNeedsUpdateConstraints];
}
- (void)submitOrder {
    //点击后先禁用点击
    [self.confirmButton setEnabled:NO];
    if (self.confirmButtonClickedHandler) {
        self.confirmButtonClickedHandler();
    }
}
- (void)setSubmitBtnEnable:(BOOL)enable {
    self.confirmButton.enabled = enable;
}
#pragma mark - lazy load
/** @lazy totalLabel */
- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
    }
    return _totalLabel;
}
/** @lazy confirmButton */
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _confirmButton.cornerRadius = kRealWidth(36) / 2.0f;
        _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(3, 15, 3, 15);
        [_confirmButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        [_confirmButton setTitle:TNLocalizedString(@"tn_button_submitorder_title", @"提交订单") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = HDAppTheme.TinhNowFont.standard15;
        [_confirmButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
/** @lazy khrPriceLabel */
- (UILabel *)khrPriceLabel {
    if (!_khrPriceLabel) {
        _khrPriceLabel = [[UILabel alloc] init];
        _khrPriceLabel.font = HDAppTheme.TinhNowFont.standard12;
        _khrPriceLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _khrPriceLabel.hidden = YES;
    }
    return _khrPriceLabel;
}
@end
