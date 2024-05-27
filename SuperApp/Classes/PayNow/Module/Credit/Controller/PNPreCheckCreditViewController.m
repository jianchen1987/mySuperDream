//
//  PNPreCheckCreditViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPreCheckCreditViewController.h"
#import "PNInfoView.h"
#import "PNOperationButton.h"
#import "PNCreditRspModel.h"
#import "PNCreditDTO.h"
#import "PNCreditManager.h"


@interface PNPreCheckCreditViewController ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) PNInfoView *oneInfoView;
@property (nonatomic, strong) PNInfoView *twoInfoView;
@property (nonatomic, strong) PNInfoView *thirdInfoView;
@property (nonatomic, strong) HDUIButton *agreementBtn;
@property (nonatomic, strong) YYLabel *agreementLabel;
@property (nonatomic, strong) PNOperationButton *goBtn;
@property (nonatomic, strong) PNCreditRspModel *model;
@property (nonatomic, strong) PNCreditDTO *creditDTO;
@end


@implementation PNPreCheckCreditViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.model = [PNCreditRspModel yy_modelWithJSON:[parameters objectForKey:@"data"]];
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = [NSString stringWithFormat:PNLocalizedString(@"MVMB35xp", @"使用%@借款服务"), self.model.corporateName];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.titleLabel];
    [self.scrollViewContainer addSubview:self.oneInfoView];
    [self.scrollViewContainer addSubview:self.twoInfoView];
    [self.scrollViewContainer addSubview:self.thirdInfoView];

    [self.view addSubview:self.goBtn];
    [self.view addSubview:self.agreementBtn];
    [self.view addSubview:self.agreementLabel];

    [self ruleLimit];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(20));
    }];

    [self.oneInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
    }];

    [self.twoInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.oneInfoView.mas_bottom);
    }];

    [self.thirdInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.mas_equalTo(self.twoInfoView.mas_bottom);

        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.goBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(kRealWidth(20) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.agreementBtn.imageView.image.size);
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.agreementLabel.mas_top).offset(-kRealWidth(3));
    }];

    [self.agreementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementBtn.mas_right).offset(kRealWidth(4));
        make.bottom.mas_equalTo(self.goBtn.mas_top).offset(-kRealWidth(16));
        make.right.mas_equalTo(self.view.mas_right).offset(-kRealWidth(12));
    }];


    [super updateViewConstraints];
}

#pragma mark
- (void)ruleLimit {
    if (self.agreementBtn.selected) {
        self.goBtn.enabled = YES;
    } else {
        self.goBtn.enabled = NO;
    }
}

- (void)updateCreditStatus {
    [self showloading];

    @HDWeakify(self);
    [self.creditDTO creditAuthorization:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        @HDWeakify(self);
        [PNCreditManager.sharedInstance checkCreditAuthorizationCompletion:^(BOOL needAuth, NSDictionary *_Nonnull rspData) {
            @HDStrongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromParentViewController];
            });
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:PNLocalizedString(@"uIq2D3g0", @"%@与CoolCash共同打造的一款借贷产品，如您需在WOWNOW上借款"), self.model.corporateName];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNInfoView *)oneInfoView {
    if (!_oneInfoView) {
        PNInfoView *infoView = [[PNInfoView alloc] init];
        PNInfoViewModel *model = [[PNInfoViewModel alloc] init];
        model.keyText = PNLocalizedString(@"jpFBAZa6", @"请先注册WOWNOW ，开通CoolCash钱包");
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_1"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        model.lineWidth = 0;
        infoView.model = model;
        _oneInfoView = infoView;
    }
    return _oneInfoView;
}

- (PNInfoView *)twoInfoView {
    if (!_twoInfoView) {
        PNInfoView *infoView = [[PNInfoView alloc] init];
        PNInfoViewModel *model = [[PNInfoViewModel alloc] init];
        model.keyText = PNLocalizedString(@"vFmKjzYC", @"2.CoolCash的钱包账户等级升级到尊享");
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_2"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        model.lineWidth = 0;
        infoView.model = model;
        _twoInfoView = infoView;
    }
    return _twoInfoView;
}

- (PNInfoView *)thirdInfoView {
    if (!_thirdInfoView) {
        PNInfoView *infoView = [[PNInfoView alloc] init];
        PNInfoViewModel *model = [[PNInfoViewModel alloc] init];
        model.keyText = [NSString stringWithFormat:PNLocalizedString(@"C95wB9gi", @"同意WOWNOW用户信息与%@分享"), self.model.corporateName];
        model.keyColor = HDAppTheme.PayNowColor.c999999;
        model.keyFont = HDAppTheme.PayNowFont.standard14;
        model.keyNumbersOfLines = 0;
        model.leftImage = [UIImage imageNamed:@"pn_ms_opne_3"];
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        model.lineWidth = 0;
        infoView.model = model;
        _thirdInfoView = infoView;
    }
    return _thirdInfoView;
}

- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[HDUIButton alloc] init];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_selected"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [_agreementBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            [self ruleLimit];
        }];
    }
    return _agreementBtn;
}

- (YYLabel *)agreementLabel {
    if (!_agreementLabel) {
        _agreementLabel = [[YYLabel alloc] init];
        _agreementLabel.font = [HDAppTheme.PayNowFont fontMedium:12];
        _agreementLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(12) - kRealWidth(12) - kRealWidth(5) - kRealWidth(self.agreementBtn.imageView.image.size.width);
        [self setProtocolText];
    }
    return _agreementLabel;
}

//设置协议文本
- (void)setProtocolText {
    NSString *h1 = PNLocalizedString(@"sfFb8ECv", @"《个人信息保护政策》");
    NSString *postStr = [NSString stringWithFormat:@"%@", PNLocalizedString(@"L6ddPIex", @"本人已阅读并同意")];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:h1];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:[UIColor hd_colorWithHexString:@"#0A84FF"] backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
                                      vc.url = [PNCommonUtils urlWithTime:self.model.agreementH5];
                                      [SAWindowManager navigateToViewController:vc parameters:@{}];
                                  }];

    [text appendAttributedString:highlightText];

    self.agreementLabel.attributedText = text;
    [self.agreementLabel sizeToFit];
}

- (PNOperationButton *)goBtn {
    if (!_goBtn) {
        _goBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_goBtn setTitle:[NSString stringWithFormat:PNLocalizedString(@"DbCXkKGq", @"前往%@借款平台"), self.model.corporateName] forState:0];
        [_goBtn addTarget:self action:@selector(updateCreditStatus) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBtn;
}

- (PNCreditDTO *)creditDTO {
    if (!_creditDTO) {
        _creditDTO = [[PNCreditDTO alloc] init];
    }
    return _creditDTO;
}
@end
