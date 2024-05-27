//
//  TNPreIncomeRecordViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPreIncomeRecordViewController.h"
#import "SATalkingData.h"
#import "TNIncomeRecordListView.h"
#import "TNIncomeViewModel.h"


@interface TNPreIncomeRecordViewController ()
///背景图片
@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) HDLabel *totalTitleLabel;
@property (nonatomic, strong) HDLabel *totalValueLabel;
@property (nonatomic, strong) HDUIButton *helpButton;
@property (nonatomic, strong) TNIncomeRecordListView *listView;
@property (strong, nonatomic) TNIncomeViewModel *viewModel; ///<
///  预估收入金额  上层带过来  没有的就自己请求
@property (nonatomic, copy) NSString *frozenCommissionBalanceMoney;
@end


@implementation TNPreIncomeRecordViewController
- (id)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.frozenCommissionBalanceMoney = [parameters valueForKey:@"frozenCommissionBalanceMoney"];
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"oXCF17fO", @"预估收益记录");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.totalTitleLabel];
    [self.view addSubview:self.totalValueLabel];
    [self.view addSubview:self.helpButton];
    [self.view addSubview:self.listView];
}
- (void)hd_bindViewModel {
    if (HDIsStringNotEmpty(self.frozenCommissionBalanceMoney)) {
        self.totalValueLabel.text = self.frozenCommissionBalanceMoney;
    } else {
        [self.viewModel getIncomeData];
    }
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"incomeRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.totalValueLabel.text = !HDIsObjectNil(self.viewModel.incomeModel.frozenCommissionBalanceMoney) ? self.viewModel.incomeModel.frozenCommissionBalanceMoney.thousandSeparatorAmount : @"--";
    }];
    //
    //过去预估数据
    [self.viewModel preRecordGetNewData];
}
- (void)updateViewConstraints {
    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.size.mas_equalTo(self.bgImgView.image.size);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.totalTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.bgImgView.mas_top).offset(kRealWidth(55));
    }];

    [self.totalValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.totalTitleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.helpButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.size.equalTo(@(CGSizeMake(kRealWidth(45), kRealWidth(45))));
        make.top.mas_equalTo(self.bgImgView.mas_top);
    }];

    [self.listView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bgImgView.mas_bottom).offset(kRealWidth(10));
    }];

    [super updateViewConstraints];
}
#pragma mark
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"tn_income_bg"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgView;
}

- (HDLabel *)totalTitleLabel {
    if (!_totalTitleLabel) {
        _totalTitleLabel = [[HDLabel alloc] init];
        _totalTitleLabel.textColor = HDAppTheme.TinhNowColor.cFFFFFF;
        _totalTitleLabel.font = HDAppTheme.TinhNowFont.standard14;
        _totalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _totalTitleLabel.text = TNLocalizedString(@"xHpMQ6s4", @"预估收入");
    }
    return _totalTitleLabel;
}

- (HDLabel *)totalValueLabel {
    if (!_totalValueLabel) {
        _totalValueLabel = [[HDLabel alloc] init];
        _totalValueLabel.textColor = HDAppTheme.TinhNowColor.cFFFFFF;
        _totalValueLabel.font = [HDAppTheme.TinhNowFont fontSemibold:30];
        _totalValueLabel.textAlignment = NSTextAlignmentCenter;
        _totalValueLabel.text = @"--";
    }
    return _totalValueLabel;
}

- (HDUIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:[UIImage imageNamed:@"tn_income_help"] forState:UIControlStateNormal];

        [_helpButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [SAWindowManager openUrl:[[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowPreIncomeHelp] withParameters:nil];
            //            [SATalkingData trackEvent:@"[电商]预估收入记录-帮助" label:@"" parameters:@{}];
        }];
    }
    return _helpButton;
}

- (TNIncomeRecordListView *)listView {
    if (!_listView) {
        _listView = [[TNIncomeRecordListView alloc] initWithViewModel:self.viewModel];
        _listView.isPreIncomeListView = YES;
    }
    return _listView;
}
/** @lazy viewModel */
- (TNIncomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNIncomeViewModel alloc] init];
    }
    return _viewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
