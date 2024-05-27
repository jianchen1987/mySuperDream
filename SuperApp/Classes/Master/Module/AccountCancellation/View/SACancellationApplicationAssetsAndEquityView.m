//
//  SACancellationApplicationAssetsAndEquityView.m
//  SuperApp
//
//  Created by Tia on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationAssetsAndEquityView.h"
#import "SACancellationApplicationAssetsAndEquityTableViewCell.h"
#import "SACancellationApplicationAssetsAndEquityViewModel.h"
#import "SACancellationApplicationVerifyIdentityViewModel.h"
#import "SATableView.h"
#import <YYText/YYText.h>


@interface SACancellationApplicationAssetsAndEquityView () <UITableViewDelegate, UITableViewDataSource>
/// icon
@property (nonatomic, strong) UIImageView *bgIV;
/// 头部提示文言
@property (nonatomic, strong) SALabel *tipsLB;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 同意按钮
@property (nonatomic, strong) HDUIButton *agreementBtn;
/// 底部容器
@property (nonatomic, strong) UIView *bottomView;
/// 协议文本
@property (nonatomic, strong) YYLabel *agreementLB;
/// 下一步
@property (nonatomic, strong) SAOperationButton *nextBtn;
/// 取消
@property (nonatomic, strong) SAOperationButton *cancelBtn;
/// vm
@property (nonatomic, strong) SACancellationApplicationAssetsAndEquityViewModel *viewModel;
/// 数据源
@property (nonatomic, copy) NSArray *dataSource;
/// 空数据容器
@property (nonatomic, strong) UIViewPlaceholderViewModel *noDatePlaceHolder;
/// 网络错误容器
@property (nonatomic, strong) UIViewPlaceholderViewModel *errorPlaceHolder;
/// identityVM
@property (nonatomic, strong) SACancellationApplicationVerifyIdentityViewModel *identityViewModel;

@end


@implementation SACancellationApplicationAssetsAndEquityView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.bgIV];
    [self addSubview:self.tipsLB];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];

    [self.bottomView addSubview:self.agreementBtn];
    [self.bottomView addSubview:self.agreementLB];
    [self.bottomView addSubview:self.nextBtn];
    [self.bottomView addSubview:self.cancelBtn];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    void (^reloadTableViewBlock)(void) = ^(void) {
        @HDStrongify(self);
        self.nextBtn.enabled = NO;
        if (!self.viewModel.isNetworkError) {
            self.tableView.placeholderViewModel = self.noDatePlaceHolder;
            self.dataSource = self.viewModel.dataSource;
            [self.tableView successGetNewDataWithNoMoreData:true];
            if (self.agreementBtn.isSelected) {
                [self checkNextBtnEnabled];
            }
        }
    };

    void (^failedGetNewDataBlock)(void) = ^(void) {
        @HDStrongify(self);
        self.nextBtn.enabled = NO;
        if (self.viewModel.isNetworkError) {
            self.tableView.placeholderViewModel = self.errorPlaceHolder;
            [self.tableView failGetNewData];
        }
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        reloadTableViewBlock();
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isNetworkError" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        failedGetNewDataBlock();
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"isLoading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            [self showloading];
        } else {
            [self dismissLoading];
        }
    }];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
    }];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-kRealWidth(105));
        make.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(94));
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bottomView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(4)));
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bottomView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-kRealWidth(8));
    }];

    [self.agreementLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(32));
        make.right.mas_equalTo(-margin);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-kRealWidth(8));
        make.top.equalTo(self.bottomView).offset(kRealWidth(8));
    }];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.equalTo(self.agreementLB.mas_top);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.tipsLB.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-margin);
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedBTNHandler:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self checkNextBtnEnabled];
    } else {
        self.nextBtn.enabled = NO;
    }
}

- (void)clickedNextBtnHandler {
    [self showloading];
    [self.identityViewModel submitCanncellationApplicationWithApiTicket:@"" success:^{
        [self dismissLoading];
        !self.nextBlock ?: self.nextBlock();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [self dismissLoading];
    }];
}

- (void)clickedCancelBtnHandler {
    !self.cancelBlock ?: self.cancelBlock();
}

#pragma mark - private methods
/// 校验下一步按钮能否点击
- (void)checkNextBtnEnabled {
    self.nextBtn.enabled = YES;
    if (self.viewModel.isNetworkError) {
        self.nextBtn.enabled = NO;
    } else if (self.dataSource.count) {
        BOOL canNext = YES;
        for (SACancellationAssetModel *model in self.dataSource) {
            if (!model.canCancellation) {
                canNext = NO;
                break;
            }
        }
        self.nextBtn.enabled = canNext;
    }
}

- (void)updateAgreementText {
    NSString *stringGray = SALocalizedString(@"ac_tips32", @"我已阅读并知晓%@，且同意注销后各类资产与权益的处理结果");
    NSString *stringBlack = SALocalizedString(@"ac_tips33", @"《账号注销须知》");
    NSString *txt = [NSString stringWithFormat:stringGray, stringBlack];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:txt];

    text.yy_font = HDAppTheme.font.standard4;
    text.yy_color = HDAppTheme.color.G1;

    [text yy_setTextHighlightRange:[txt rangeOfString:stringBlack] color:UIColor.redColor backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/logout-notice"}];
                         }];
    self.agreementLB.attributedText = text;
    self.agreementLB.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SACancellationApplicationAssetsAndEquityTableViewCell *cell = [SACancellationApplicationAssetsAndEquityTableViewCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SACancellationAssetModel *model = self.dataSource[indexPath.row];
    NSString *url = model.iosLink;
    if (HDIsStringNotEmpty(url)) {
        if ([SAWindowManager canOpenURL:url]) {
            [SAWindowManager openUrl:url withParameters:nil];
        }
    }
}

#pragma mark - lazy load
- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ac_bg"]];
    }
    return _bgIV;
}

- (SALabel *)tipsLB {
    if (!_tipsLB) {
        SALabel *l = SALabel.new;
        l.hd_lineSpace = 5;
        l.font = [HDAppTheme.font boldForSize:14];
        l.textColor = UIColor.whiteColor;
        l.text = SALocalizedString(@"ac_tips31", @"注销后，您各类资产与权益处理如下");
        l.numberOfLines = 0;

        _tipsLB = l;
    }
    return _tipsLB;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.placeholderViewModel = self.noDatePlaceHolder;
        @HDWeakify(self);
        _tableView.hd_tappedRefreshBtnHandler = ^{
            @HDStrongify(self);
            [self.viewModel queryOrdeDetailInfo];
        };
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchDown];
        [button setImage:[UIImage imageNamed:@"ac_icon_pro_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ac_icon_pro_sel"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = NO;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button sizeToFit];
        _agreementBtn = button;
    }
    return _agreementBtn;
}

- (YYLabel *)agreementLB {
    if (!_agreementLB) {
        _agreementLB = [[YYLabel alloc] init];
        _agreementLB.preferredMaxLayoutWidth = SCREEN_WIDTH - kRealWidth(40 + 15); //自适应高度
        _agreementLB.numberOfLines = 0;
        [self updateAgreementText];
    }
    return _agreementLB;
}

- (SAOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(clickedNextBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitle:SALocalizedStringFromTable(@"confirm_deactivate", @"确定注销", @"Buttons") forState:UIControlStateNormal];
        [_nextBtn applyPropertiesWithBackgroundColor:HDAppTheme.color.sa_C1];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}

- (SAOperationButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_cancelBtn addTarget:self action:@selector(clickedCancelBtnHandler) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        _cancelBtn.borderColor = HDAppTheme.color.sa_C1;
        [_cancelBtn applyPropertiesWithBackgroundColor:UIColor.whiteColor];
    }
    return _cancelBtn;
}

- (UIViewPlaceholderViewModel *)noDatePlaceHolder {
    if (!_noDatePlaceHolder) {
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"ac_placehold";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = HDAppTheme.font.standard4;
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#999999"];
        placeHolder.needRefreshBtn = NO;
        placeHolder.title = SALocalizedString(@"ac_no_assets", @"暂无资产与权益");
        _noDatePlaceHolder = placeHolder;
    }
    return _noDatePlaceHolder;
}

- (UIViewPlaceholderViewModel *)errorPlaceHolder {
    if (!_errorPlaceHolder) {
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.image = @"ac_placehold";
        placeHolder.imageSize = CGSizeMake(kRealWidth(200), kRealWidth(200));
        placeHolder.titleFont = HDAppTheme.font.standard4;
        placeHolder.titleColor = [UIColor hd_colorWithHexString:@"#999999"];
        placeHolder.needRefreshBtn = YES;
        placeHolder.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        placeHolder.title = TNLocalizedString(@"tn_page_networkerror_title", @"网络不给力，点击重新加载");
        _errorPlaceHolder = placeHolder;
    }
    return _errorPlaceHolder;
}

- (SACancellationApplicationVerifyIdentityViewModel *)identityViewModel {
    if (!_identityViewModel) {
        _identityViewModel = [[SACancellationApplicationVerifyIdentityViewModel alloc] initWithModel:self.viewModel.reasonModel];
        // 获取上次登录成功的账号
        _identityViewModel.lastLoginFullAccount = SAUser.lastLoginFullAccount;
    }
    return _identityViewModel;
}

@end
