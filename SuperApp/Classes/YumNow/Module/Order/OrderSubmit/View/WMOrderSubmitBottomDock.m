//
//  WMOrderSubmitBottomDock.m
//  SuperApp
//
//  Created by VanJay on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitBottomDock.h"
#import "SAMoneyModel.h"
#import "WMOperationButton.h"


@interface WMOrderSubmitBottomDock ()
/// 用于绘制阴影
@property (nonatomic, strong) UIView *shadowView;
/// 阴影图层
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
/// 按钮左部分容器
@property (nonatomic, strong) UIView *buttonLeftContainer;
/// 主标题
@property (nonatomic, strong) SALabel *mainTitleLB;
/// 提交按钮
@property (nonatomic, strong) WMOperationButton *submitBTN;
/// 应付
@property (nonatomic, strong, readwrite) SAMoneyModel *payablePrice;
/// 实付
@property (nonatomic, strong, readwrite) SAMoneyModel *actualPayPrice;

@end


@implementation WMOrderSubmitBottomDock
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.shadowView];
    [self addSubview:self.buttonLeftContainer];
    [self addSubview:self.mainTitleLB];
    [self addSubview:self.submitBTN];

    @HDWeakify(self);
    self.shadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
        self.shadowLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5 shadowRadius:3 shadowOpacity:1
                                       shadowColor:[UIColor colorWithRed:52 / 255.0 green:59 / 255.0 blue:77 / 255.0 alpha:0.16].CGColor
                                         fillColor:HDAppTheme.WMColor.B3.CGColor
                                      shadowOffset:CGSizeMake(0, 3)];
    };
    self.buttonLeftContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        UIRectCorner rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        if (self.submitBTN.isHidden) {
            rectCorner = UIRectCornerAllCorners;
        }
        [view setRoundedCorners:rectCorner radius:precedingFrame.size.height * 0.5];
    };
    self.submitBTN.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        if (precedingFrame.size.width > 0) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        }
    };
}

#pragma mark - event response
- (void)clickedSubmitBTNHandler {
    self.submitBTN.userInteractionEnabled = NO;
    void (^submitCompletion)(void) = ^() {
        self.submitBTN.userInteractionEnabled = YES;
    };
    !self.clickedSubmitBTNBlock ?: self.clickedSubmitBTNBlock(submitCompletion);
}

#pragma mark - public methods
- (void)setActualPayPrice:(SAMoneyModel *)actualPayPrice {
    _actualPayPrice = actualPayPrice;
    [self adjustContentRender];
}

- (void)setPayablePrice:(SAMoneyModel *_Nullable)payablePrice {
    _payablePrice = payablePrice;
    [self adjustContentRender];
}

#pragma mark - private methods
- (void)adjustContentRender {
    [self adjustStoreCartPriceInfo];
    [self adjustSubmitButtonState];
    [self setNeedsUpdateConstraints];
}

- (void)adjustStoreCartPriceInfo {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *appendingStr;
    appendingStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", WMLocalizedString(@"total", @"总计")]
                                                          attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [text appendAttributedString:appendingStr];

    if (!HDIsObjectNil(self.actualPayPrice)) {
        appendingStr =
            [[NSMutableAttributedString alloc] initWithString:self.actualPayPrice.thousandSeparatorAmount
                                                   attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:20 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: UIColor.whiteColor}];
        [appendingStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: UIColor.whiteColor}
                              range:[appendingStr.string rangeOfString:self.actualPayPrice.currencySymbol]];
        [text appendAttributedString:appendingStr];
    }

    if (!HDIsObjectNil(self.payablePrice) && self.actualPayPrice.cent.doubleValue != self.payablePrice.cent.doubleValue) {
        // 空格
        NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
        [text appendAttributedString:whiteSpace];

        appendingStr = [[NSMutableAttributedString alloc] initWithString:self.payablePrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
            NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0.6],
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0.6]
        }];
        [text appendAttributedString:appendingStr];
    }
    self.mainTitleLB.attributedText = text;
}

- (void)adjustSubmitButtonState {
    [self.submitBTN applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
    [self.submitBTN setTitle:WMLocalizedStringFromTable(@"order_submit_btn", @"提交", @"Buttons") forState:UIControlStateNormal];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.buttonLeftContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(48));
    }];

    [self.mainTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonLeftContainer).offset(kRealWidth(20));
        make.centerY.equalTo(self.buttonLeftContainer);
        if (self.submitBTN.isHidden) {
            make.right.equalTo(self.buttonLeftContainer.mas_left).offset(-kRealWidth(5));
        } else {
            make.right.equalTo(self.submitBTN.mas_left).offset(-kRealWidth(5));
        }
    }];
    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.submitBTN.isHidden) {
            make.height.centerY.equalTo(self.buttonLeftContainer);
            make.right.equalTo(self).offset(1);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(100));
        }
    }];
    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
    }
    return _shadowView;
}

- (UIView *)buttonLeftContainer {
    if (!_buttonLeftContainer) {
        _buttonLeftContainer = UIView.new;
    }
    return _buttonLeftContainer;
}

- (SALabel *)mainTitleLB {
    if (!_mainTitleLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textColor = UIColor.whiteColor;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.text = [NSString stringWithFormat:@"%@: -", WMLocalizedString(@"total", @"总计")];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _mainTitleLB = label;
    }
    return _mainTitleLB;
}

- (WMOperationButton *)submitBTN {
    if (!_submitBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightHeavy];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setTitle:WMLocalizedStringFromTable(@"order_submit_btn", @"提交", @"Buttons") forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(20), kRealWidth(12), kRealWidth(20));
        [button addTarget:self action:@selector(clickedSubmitBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _submitBTN = button;
    }
    return _submitBTN;
}
@end
