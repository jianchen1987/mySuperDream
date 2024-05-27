//
//  PNInterTransferPayerInfoViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferPayerInfoViewController.h"
#import "PNInterTransferConfirmViewController.h"
#import "PNInterTransferViewModel.h"
#import "PNTransferFormCell.h"
#import "PNTransferSectionHeaderView.h"
#import <YYText.h>


@interface PNInterTransferPayerInfoViewController ()
///
@property (strong, nonatomic) PNInterTransferViewModel *viewModel;
/// 同意协议按钮
@property (strong, nonatomic) HDUIButton *agreementBtn;
@property (nonatomic, strong) YYLabel *agreementLabel;

@end


@implementation PNInterTransferPayerInfoViewController
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupNavigation {
    if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_wechat", @"转账到微信");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_alipay", @"转账到支付宝");
    }
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.stepView setCurrentStep:1];
    [self setProtocolText];
    self.agreementBtn.selected = self.viewModel.agreementCoolcashTerms;
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"payerInfoVcRefrehData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"payerContinueBtnEnabled" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.oprateBtn.enabled = self.viewModel.payerContinueBtnEnabled;
    }];

    [self.viewModel initPayerInfoData];
    if (HDIsObjectNil(self.viewModel.payerInfoModel)) {
        [self.viewModel queryPayerInfoCompletion:^(BOOL isSuccess) {
            if (isSuccess) {
                [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
            } else {
                [self.viewModel.payerInfoDataArr removeAllObjects];
                [self.tableView failGetNewData];
            }
        }];
    } else {
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }
}

#pragma mark -下一步
- (void)clickOprateBtn {
    @HDWeakify(self);
    [self.viewModel amlAnalyzeVerificationAndCreateOrderCompletion:^(BOOL isSuccess) {
        @HDStrongify(self);
        if (isSuccess) {
            PNInterTransferConfirmViewController *confirmVC = [[PNInterTransferConfirmViewController alloc] initWithViewModel:self.viewModel];
            [SAWindowManager navigateToViewController:confirmVC];
        }
    }];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.payerInfoDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.payerInfoDataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.payerInfoDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        PNTransferSectionHeaderView *headerView = [PNTransferSectionHeaderView headerWithTableView:tableView];
        //        headerView.title = sectionModel.headerModel.title;
        [headerView setTitle:sectionModel.headerModel.title rightImage:sectionModel.headerModel.rightButtonImage];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.payerInfoDataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[PNTransferFormConfig class]]) {
        PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
        cell.config = model;
        return cell;
    }
    return UITableViewCell.new;
}

/** @lazy viewModel */
- (PNInterTransferViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNInterTransferViewModel alloc] init];
    }
    return _viewModel;
}

/** @lazy agreementBtn */
- (HDUIButton *)agreementBtn {
    if (!_agreementBtn) {
        _agreementBtn = [[HDUIButton alloc] init];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_unselect"] forState:UIControlStateNormal];
        [_agreementBtn setImage:[UIImage imageNamed:@"pn_transfer_agreement_selected"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [_agreementBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            self.viewModel.agreementCoolcashTerms = btn.isSelected;
            [self.viewModel checkPayerContinueBtnEabled];
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
    }
    return _agreementLabel;
}

//设置协议文本
- (void)setProtocolText {
    NSString *h1 = PNLocalizedString(@"Pl6Nbxfy", @"Coolcash 用户协议的条款和条件");
    NSString *postStr = [NSString stringWithFormat:@"%@", PNLocalizedString(@"ms_have_read_and_agree", @"我已阅读并同意")];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:h1];
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:HDAppTheme.PayNowColor.mainThemeColor backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"InterTransfer", @"navTitle": @"CoolCash"}];
                                  }];

    [text appendAttributedString:highlightText];

    self.agreementLabel.attributedText = text;
    [self.agreementLabel sizeToFit];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [footerView addSubview:self.agreementBtn];
    [footerView addSubview:self.agreementLabel];

    [self.agreementBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView.mas_left).offset(kRealWidth(12));
        make.size.mas_equalTo(self.agreementBtn.imageView.image.size);
        make.centerY.mas_equalTo(self.agreementLabel.mas_centerY);
    }];

    [self.agreementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(kRealWidth(12));
        make.left.mas_equalTo(self.agreementBtn.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(footerView.mas_right).offset(kRealWidth(-12));
        make.bottom.mas_equalTo(footerView.mas_bottom).offset(kRealWidth(-8));
    }];

    CGFloat height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footerView.frame;
    frame.size.height = height;

    footerView.frame = frame;

    self.tableView.tableFooterView = footerView;
}
@end
