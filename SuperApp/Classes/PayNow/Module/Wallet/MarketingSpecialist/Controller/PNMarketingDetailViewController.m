//
//  PNMarketingCountViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNMarketingDetailViewController.h"
#import "PNCheckMarketingRspModel.h"
#import "PNMarketingDTO.h"
#import "PNMarketingDetailInfoModel.h"


@interface PNMarketingDetailViewController ()
/// 推广专员编号
@property (nonatomic, strong) SALabel *marketingNoLabel;
@property (nonatomic, strong) UIView *infoBgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *leftBgView;
@property (nonatomic, strong) UIView *rightBgView;
@property (nonatomic, strong) SALabel *amountTitleLabel;
@property (nonatomic, strong) SALabel *amountValueLabel;
@property (nonatomic, strong) SALabel *inviteTitleLabel;
@property (nonatomic, strong) SALabel *inviteValueLabel;
@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) UIView *hLine;
@property (nonatomic, strong) PNOperationButton *detailButton;
@property (nonatomic, strong) PNCheckMarketingRspModel *argModel;
@property (nonatomic, strong) PNMarketingDTO *marketingDTO;

@end


@implementation PNMarketingDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.argModel = [PNCheckMarketingRspModel yy_modelWithJSON:[parameters objectForKey:@"data"]];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"MaTAHBph", @"推广专员业绩");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;


    [self.scrollViewContainer addSubview:self.marketingNoLabel];
    [self.scrollViewContainer addSubview:self.infoBgView];

    [self.infoBgView addSubview:self.titleLabel];
    [self.infoBgView addSubview:self.leftBgView];
    [self.infoBgView addSubview:self.rightBgView];

    [self.leftBgView addSubview:self.amountTitleLabel];
    [self.leftBgView addSubview:self.amountValueLabel];

    [self.rightBgView addSubview:self.inviteTitleLabel];
    [self.rightBgView addSubview:self.inviteValueLabel];

    [self.infoBgView addSubview:self.hLine];
    [self.infoBgView addSubview:self.vLine];
    [self.infoBgView addSubview:self.detailButton];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.marketingNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(24));
    }];

    [self.infoBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.marketingNoLabel.mas_bottom).offset(kRealWidth(24));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoBgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.infoBgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.infoBgView.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.leftBgView.mas_top).offset(-kRealWidth(30));
    }];

    [self.leftBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.infoBgView.mas_width).multipliedBy(0.5);
        make.left.mas_equalTo(self.infoBgView.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];

    [self.amountTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBgView.mas_left).offset(kRealWidth(10));
        make.right.mas_equalTo(self.leftBgView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.leftBgView);
    }];

    [self.amountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.amountTitleLabel);
        make.top.mas_equalTo(self.amountTitleLabel.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.leftBgView.mas_bottom).offset(-kRealWidth(24));
    }];

    [self.rightBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.infoBgView.mas_right);
        make.width.bottom.top.equalTo(self.leftBgView);
    }];

    [self.inviteTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightBgView.mas_left).offset(kRealWidth(10));
        make.right.mas_equalTo(self.rightBgView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.rightBgView);
    }];

    [self.inviteValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inviteTitleLabel);
        make.top.mas_equalTo(self.inviteTitleLabel.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.rightBgView.mas_bottom).offset(-kRealWidth(24));
    }];

    /// 竖线
    [self.hLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(1));
        make.left.mas_equalTo(self.leftBgView.mas_right);
        make.top.equalTo(self.leftBgView);
        make.bottom.mas_equalTo(self.leftBgView.mas_bottom).offset(-kRealWidth(15));
    }];

    /// 横线
    [self.vLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.infoBgView);
        make.height.equalTo(@(1));
        make.top.mas_equalTo(self.leftBgView.mas_bottom);
    }];

    [self.detailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftBgView.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.infoBgView.mas_left).offset(kRealWidth(30));
        make.right.mas_equalTo(self.infoBgView.mas_right).offset(-kRealWidth(30));
        make.bottom.mas_equalTo(self.infoBgView.mas_bottom).offset(-kRealWidth(12));
    }];


    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)getData {
    [self.view showloading];

    @HDWeakify(self);
    [self.marketingDTO queryPromoterDetail:self.argModel.promoterLoginName successBlock:^(PNMarketingDetailInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.marketingNoLabel.text = [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"iADKsimo", @"您的推广专员编号："), rspModel.promoterLoginName];
        self.inviteValueLabel.text = [NSString stringWithFormat:@"%zd", rspModel.bindNum];
        if (HDIsObjectNil(rspModel.totalReward)) {
            self.amountValueLabel.text = @"$0.00";
        } else {
            self.amountValueLabel.text = rspModel.totalReward.thousandSeparatorAmount;
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (SALabel *)marketingNoLabel {
    if (!_marketingNoLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard17B;
        label.numberOfLines = 0;
        _marketingNoLabel = label;
    }
    return _marketingNoLabel;
}

- (UIView *)infoBgView {
    if (!_infoBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _infoBgView = view;
    }
    return _infoBgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"18Av6MwR", @"您的好友绑定信息");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)leftBgView {
    if (!_leftBgView) {
        _leftBgView = [[UIView alloc] init];
    }
    return _leftBgView;
}

- (SALabel *)amountTitleLabel {
    if (!_amountTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"a2JXqqGT", @"累计获取奖励数");
        label.textAlignment = NSTextAlignmentCenter;
        _amountTitleLabel = label;
    }
    return _amountTitleLabel;
}

- (SALabel *)amountValueLabel {
    if (!_amountValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"$0.00";
        _amountValueLabel = label;
    }
    return _amountValueLabel;
}

- (UIView *)rightBgView {
    if (!_rightBgView) {
        _rightBgView = [[UIView alloc] init];
    }
    return _rightBgView;
}

- (SALabel *)inviteTitleLabel {
    if (!_inviteTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"success_invite", @"成功邀请好友数");
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _inviteTitleLabel = label;
    }
    return _inviteTitleLabel;
}

- (SALabel *)inviteValueLabel {
    if (!_inviteValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        _inviteValueLabel = label;
    }
    return _inviteValueLabel;
}

- (UIView *)hLine {
    if (!_hLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _hLine = view;
    }
    return _hLine;
}

- (UIView *)vLine {
    if (!_vLine) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _vLine = view;
    }
    return _vLine;
}

- (PNOperationButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_detailButton setTitle:PNLocalizedString(@"LcQapHR3", @"查看详情") forState:UIControlStateNormal];

        @HDWeakify(self);
        [_detailButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToPayNowBindMarketingListInfoVC:@{
                @"promoterLoginName": self.argModel.promoterLoginName,
            }];
        }];
    }
    return _detailButton;
}

- (PNMarketingDTO *)marketingDTO {
    if (!_marketingDTO) {
        _marketingDTO = [[PNMarketingDTO alloc] init];
    }
    return _marketingDTO;
}
@end
