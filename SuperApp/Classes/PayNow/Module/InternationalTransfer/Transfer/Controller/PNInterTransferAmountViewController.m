//
//  PNInterTransferAmountViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferAmountViewController.h"
#import "PNInterTransferAmountCell.h"
#import "PNInterTransferPayerInfoViewController.h"
#import "PNInterTransferReciverInfoCell.h"
#import "PNInterTransferViewModel.h"
#import "PNTransferFormCell.h"
#import "PNTransferSectionHeaderView.h"


@interface PNInterTransferAmountViewController ()
///
@property (strong, nonatomic) PNInterTransferViewModel *viewModel;
@property (nonatomic, strong) SALabel *agreementLabel;
@end


@implementation PNInterTransferAmountViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_wechat", @"转账到微信");
    } else {
        self.boldTitle = PNLocalizedString(@"pn_transfer_to_alipay", @"转账到支付宝");
    }
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [super hd_setupViews];

    self.tableView.sectionHeaderHeight = kRealWidth(10);

    [self.stepView setCurrentStep:0];

    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        [self getQuotaData:NO completion:nil];
    };
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    @HDWeakify(self);

    [self.KVOController hd_observe:self.viewModel keyPath:@"getExchangeRateRefreshData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self setAgreements];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"transExchangeAmountRrfreshData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"chargeRrfreshData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"transAmountVcRefrehData" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"amountContinueBtnEnabled" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.oprateBtn.enabled = self.viewModel.amountContinueBtnEnabled;
    }];

    [self.viewModel initTransferAmountData];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t _sema = dispatch_semaphore_create(1);
        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        __block BOOL isNeedShow = YES;
        [self.viewModel checkNeedInviateCode:^(BOOL isSuccess) {
            if (isSuccess) {
                isNeedShow = NO;
            }
            dispatch_semaphore_signal(_sema);
        }];

        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        [self getQuotaData:isNeedShow completion:^{
            dispatch_semaphore_signal(_sema);

            [self.viewModel checkIsBind];
        }];
    });
}

- (void)getQuotaData:(BOOL)needShowKeyBoard completion:(void (^)(void))completion {
    if (HDIsObjectNil(self.viewModel.quotaAndRateModel) || HDIsObjectNil(self.viewModel.quotaAndRateModel.rate)) {
        [self.viewModel queryQuotaAndExchangeRateNeedLoading:YES completion:^(BOOL isSuccess) {
            if (isSuccess) {
                [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
                if (needShowKeyBoard) {
                    [self amountTextFieldBecomeFirstResponder:0.25];
                }
                !completion ?: completion();
            } else {
                [self.viewModel.transferAmountDataArr removeAllObjects];
                [self.tableView failGetNewData];
                !completion ?: completion();
            }
        }];
    } else {
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        if (needShowKeyBoard) {
            [self amountTextFieldBecomeFirstResponder:0.8];
        }
        !completion ?: completion();
    }
}

///金额键盘响应
- (void)amountTextFieldBecomeFirstResponder:(float)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *visbleCells = [self.tableView visibleCells];
        for (UITableViewCell *cell in visbleCells) {
            if ([cell isKindOfClass:[PNInterTransferAmountCell class]]) {
                PNInterTransferAmountCell *amountCell = (PNInterTransferAmountCell *)cell;
                if (amountCell.model.isBecomeFirstResponder && HDIsStringEmpty(amountCell.model.valueText)) { //金额框没有值 就弹起
                    [amountCell becomeFirstResponder];
                    break;
                }
            }
        }
    });
}

#pragma mark -下一步
- (void)clickOprateBtn {
    @HDWeakify(self);
    [self.viewModel openInterTransferAccountCompletion:^{
        @HDStrongify(self);
        @HDWeakify(self);
        [self.viewModel queryPayerInfoCompletion:^(BOOL isSuccess) {
            @HDStrongify(self);
            if (isSuccess) {
                PNInterTransferPayerInfoViewController *infoVC = [[PNInterTransferPayerInfoViewController alloc] initWithViewModel:self.viewModel];
                [SAWindowManager navigateToViewController:infoVC];
            }
        }];
    }];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.transferAmountDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel.title)) {
        PNTransferSectionHeaderView *headerView = [PNTransferSectionHeaderView headerWithTableView:tableView];
        //        headerView.title = sectionModel.headerModel.title;
        [headerView setTitle:sectionModel.headerModel.title rightImage:sectionModel.headerModel.rightButtonImage];
        return headerView;
    }

    UIView *headerView = UIView.new;
    headerView.frame = CGRectMake(0, 0, kScreenWidth, kRealWidth(10));
    headerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel.title)) {
        return kRealWidth(45);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel.title)) {
        return kRealWidth(45);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[PNInterTransferAmountCellModel class]]) {
        PNInterTransferAmountCell *cell = [PNInterTransferAmountCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:[PNTransferFormConfig class]]) {
        PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
        cell.config = model;
        return cell;
    } else if ([model isKindOfClass:[PNInterTransferReciverModel class]]) {
        PNInterTransferReciverInfoCell *cell = [PNInterTransferReciverInfoCell cellWithTableView:tableView];
        cell.hiddenEditBtn = NO;
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.transferAmountDataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[PNInterTransferReciverModel class]]) {
        [self.viewModel chooseReciverInfo];
    }
}

/** @lazy viewModel */
- (PNInterTransferViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNInterTransferViewModel alloc] init];
    }
    return _viewModel;
}

- (SALabel *)agreementLabel {
    if (!_agreementLabel) {
        _agreementLabel = [[SALabel alloc] init];
        _agreementLabel.font = [HDAppTheme.PayNowFont fontMedium:12];
        _agreementLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(40);
    }
    return _agreementLabel;
}

- (void)setAgreements {
    NSString *str = [self.viewModel.quotaAndRateModel.agreementsStr componentsJoinedByString:@"\n"];
    self.agreementLabel.text = str;
    [self.agreementLabel sizeToFit];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [footerView addSubview:self.agreementLabel];

    [self.agreementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(kRealWidth(12));
        make.left.mas_equalTo(footerView.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(footerView.mas_right).offset(kRealWidth(-20));
        make.bottom.mas_equalTo(footerView.mas_bottom).offset(kRealWidth(-20));
    }];

    CGFloat height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footerView.frame;
    frame.size.height = height;

    footerView.frame = frame;

    self.tableView.tableFooterView = footerView;
}

@end
