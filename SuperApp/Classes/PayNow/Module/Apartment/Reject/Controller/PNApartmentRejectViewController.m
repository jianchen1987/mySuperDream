//
//  PNApartmentRejectViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentRejectViewController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNApartmentDTO.h"


@interface PNApartmentRejectViewController () <HDTextViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDTextView *textView;
@property (nonatomic, strong) PNOperationButton *comfirmBtn;
@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, copy) NSString *paymentId;
@property (nonatomic, strong) SALabel *textLengthLabel;
@property (nonatomic, assign) CGFloat textViewHeight;
@end


@implementation PNApartmentRejectViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.paymentId = [parameters objectForKey:@"paymentId"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Rent_bill", @"公寓缴费");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.textView];
    [self.bgView addSubview:self.textLengthLabel];

    [self.view addSubview:self.comfirmBtn];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.left.width.equalTo(self.view);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(12));
        make.bottom.left.right.mas_equalTo(self.scrollViewContainer);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(self.textViewHeight > 0 ? self.textViewHeight : kRealWidth(100));
    }];

    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.mas_right);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.comfirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(kRealWidth(20) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)ruleLimit {
    if (WJIsStringEmpty(self.textView.text)) {
        self.comfirmBtn.enabled = NO;
    } else {
        self.comfirmBtn.enabled = YES;
    }
}


#pragma mark
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    if (height <= kRealWidth(100))
        return;

    [UIView animateWithDuration:0.25 animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)textViewDidChange:(HDTextView *)textView {
    self.textLengthLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, textView.maximumTextLength];
    [self ruleLimit];
}

#pragma mark
- (void)comfirmAction {
    [self.view showloading];

    @HDWeakify(self);
    [self.apartmentDTO refuseApartment:self.paymentId remark:self.textView.text success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [HDMediator.sharedInstance navigaveToPayNowApartmentResultVC:@{
            @"type": @(0),
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}


#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"pn_Reason_to_refuse", @"拒绝原因")];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B
                                                           highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                  norFont:HDAppTheme.PayNowFont.standard14B
                                                                 norColor:HDAppTheme.PayNowColor.c333333];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDTextView *)textView {
    if (!_textView) {
        HDTextView *textView = HDTextView.new;
        textView.maximumTextLength = 500;
        textView.delegate = self;
        textView.placeholder = PNLocalizedString(@"pn_input", @"请输入");
        textView.placeholderColor = HDAppTheme.color.G3;
        textView.bounces = false;
        textView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textView.font = HDAppTheme.PayNowFont.standard14;
        textView.textColor = HDAppTheme.PayNowColor.c333333;
        textView.showsVerticalScrollIndicator = false;
        textView.layer.cornerRadius = kRealWidth(4);
        textView.tintColor = HDAppTheme.PayNowColor.mainThemeColor;
        _textView = textView;
    }
    return _textView;
}

- (SALabel *)textLengthLabel {
    if (!_textLengthLabel) {
        SALabel *label = SALabel.new;
        label.text = @"0/500";
        label.textAlignment = NSTextAlignmentRight;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        _textLengthLabel = label;
    }
    return _textLengthLabel;
}

- (PNOperationButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _comfirmBtn.enabled = NO;
        [_comfirmBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定") forState:UIControlStateNormal];
        [_comfirmBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}
@end
