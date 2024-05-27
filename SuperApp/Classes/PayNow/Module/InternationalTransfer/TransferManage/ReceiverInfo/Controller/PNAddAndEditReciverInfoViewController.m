//
//  PNAddAndEditReciverInfoViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAddAndEditReciverInfoViewController.h"
#import "PNAddAndEditReciverInfoViewModel.h"
#import "PNReciverInfoHeaderView.h"
#import "PNTableView.h"
#import "PNTransferFormCell.h"
#import "PNTransferSectionHeaderView.h"
#import "UIView+KeyboardMoveRespond.h"


@interface PNAddAndEditReciverInfoViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) PNAddAndEditReciverInfoViewModel *viewModel;
/// 底部按钮容器
@property (strong, nonatomic) UIView *bottomContainer;
///
@property (strong, nonatomic) UIStackView *stackView;
///
@property (strong, nonatomic) PNOperationButton *deleteBtn;
///
@property (strong, nonatomic) PNOperationButton *saveBtn;
///
@property (nonatomic, strong) PNReciverInfoHeaderView *headerView;

@end


@implementation PNAddAndEditReciverInfoViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        PNInterTransferReciverModel *model = [parameters objectForKey:@"reciverModel"];
        self.viewModel.callBack = [parameters objectForKey:@"callBack"];
        self.viewModel.uploadModel = model;
        self.viewModel.isEditStyle = !HDIsObjectNil(model);
        self.viewModel.channel = [[parameters objectForKey:@"channel"] integerValue];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];

    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    !self.viewModel.callBack ?: self.viewModel.callBack();
    [super hd_backItemClick:sender];
}

- (void)hd_setupNavigation {
    if (self.viewModel.isEditStyle) {
        self.boldTitle = PNLocalizedString(@"2VdVAFAY", @"编辑收款人信息");
    } else {
        self.boldTitle = PNLocalizedString(@"epWpMMBj", @"新增收款人信息");
    }
}

- (void)hd_setupViews {
    [self registerForKeyboardNotifications];
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.stackView];

    if (self.viewModel.isEditStyle) { //编辑模式加上删除按钮
        [self.stackView addArrangedSubview:self.deleteBtn];
    }

    [self.stackView addArrangedSubview:self.saveBtn];

    //    [self.tableView setFollowKeyBoardConfigEnable:YES margin:10 refView:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"saveBtnEnabled" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.saveBtn.enabled = self.viewModel.saveBtnEnabled;
    }];

    [self.viewModel initDataArr];
    [self.viewModel queryRelationList];
}

#pragma mark -点击保存
- (void)clickSave {
    //只需要校验手机号码位数
    if (HDIsStringNotEmpty(self.viewModel.uploadModel.msisdn) && self.viewModel.uploadModel.msisdn.length < 11) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"adress_tips_phone_format_error", @"手机号码不正确") type:HDTopToastTypeWarning];
        return;
    }

    //    if (HDIsStringNotEmpty(self.viewModel.uploadModel.email) && !self.viewModel.uploadModel.email.hd_isValidEmail) {
    //        [NAT showToastWithTitle:nil content:SALocalizedString(@"invalid_email_format", @"邮箱格式不正确") type:HDTopToastTypeWarning];
    //        return;
    //    }

    // 手机号码拼接 86上传
    if (HDIsStringNotEmpty(self.viewModel.uploadModel.msisdn) && ![self.viewModel.uploadModel.msisdn hasPrefix:@"86"]) {
        self.viewModel.uploadModel.msisdn = [@"86" stringByAppendingString:self.viewModel.uploadModel.msisdn];
    }

    if (!self.headerView.agreementBtn.selected) {
        NSString *msg = @"";
        if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
            msg = PNLocalizedString(@"pn_wechat_setting_tips", @"请确认在微信小程序“微汇款”已创建收款名片");
        } else {
            msg = PNLocalizedString(@"pn_alipay_setting_tips", @"请确认收款人信息在支付宝完成设置");
        }
        [NAT showAlertWithMessage:msg buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];

        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.headerView setBgViewLabyer];

        return;
    }

    NSString *title = @"";
    NSString *msg = @"";
    if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
        title = PNLocalizedString(@"pn_wechat_tips1", @"请确认收款人在微信设置收款账号");
        msg = PNLocalizedString(@"pn_wechat_tips2", @"请确认在微信小程序“微汇款”已创建收款名片，如未创建，请先创建“微汇款”的收款名片。");
    } else {
        title = PNLocalizedString(@"pn_alipay_tips1", @"请确认收款人在支付宝设置收款账号");
        msg = PNLocalizedString(@"pn_alipay_tips2", @"如未设置，支付宝将通过短信和电话方式通知收款人设置\n收款人必须在72小时内完成设置，未按时设置将转账失败，资金退回转出人");
    }
    [NAT showAlertWithTitle:title message:msg confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
        confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];

            @HDWeakify(self);
            [self.viewModel saveOrUpdateReciverInfoToServiceCompletion:^{
                @HDStrongify(self);
                !self.viewModel.callBack ?: self.viewModel.callBack();
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];
}

#pragma mark -点击删除
- (void)clickDelete {
    @HDWeakify(self);
    [NAT showAlertWithTitle:PNLocalizedString(@"pn_delete_reciver_title", @"删除收款人") message:PNLocalizedString(@"pn_delete_reciver_message", @"确认删除收款人？")
        confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            @HDStrongify(self);
            @HDWeakify(self);
            [self.viewModel deleteReciverInfoToServiceCompletion:^{
                @HDStrongify(self);
                !self.viewModel.callBack ?: self.viewModel.callBack();
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView dismiss];
        }
        cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
            [alertView dismiss];
        }];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.view.mas_bottom).offset(kiPhoneXSeriesSafeBottomHeight > 0 ? -kiPhoneXSeriesSafeBottomHeight : -kRealWidth(15));
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(48));
    }];

    [super updateViewConstraints];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        PNTransferSectionHeaderView *headerView = [PNTransferSectionHeaderView headerWithTableView:tableView];
        [headerView setTitle:sectionModel.headerModel.title rightImage:sectionModel.headerModel.rightButtonImage];

        headerView.rightBtnClickBlock = ^{
            if (self.viewModel.channel == PNInterTransferThunesChannel_Wechat) {
                [NAT showAlertWithMessage:PNLocalizedString(@"pn_check_wechat_name_some", @"收款人姓名需要与微信小程序“微汇款”的收款人姓名一致")
                              buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                              }];
            } else {
                [NAT showAlertWithTitle:PNLocalizedString(@"pn_check_alipay_name", @"查看支付宝app的收款人姓名")
                    message:PNLocalizedString(@"pn_check_alipay_name_some", @"收款人姓名需要与支付宝收款人姓名一致")
                    confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                    }
                    cancelButtonTitle:PNLocalizedString(@"pn_copy_check_link", @"复制查看链接") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                        [alertView dismiss];
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = kAlipay_url_2;
                        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeInfo];
                    }];
            }
        };
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.viewModel.dataArr[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[PNTransferFormConfig class]]) {
        PNTransferFormCell *cell = [PNTransferFormCell cellWithTableView:tableView];
        cell.config = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;

        [self setHeaderView];
    }
    return _tableView;
}

- (void)setHeaderView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    headView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [headView addSubview:self.headerView];

    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headView);
        make.bottom.mas_equalTo(headView.mas_bottom);
    }];

    CGFloat height = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headView.frame;
    frame.size.height = height;

    headView.frame = frame;

    self.tableView.tableHeaderView = headView;
}

/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = 30;
        _stackView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _stackView;
}

/** @lazy oprateBtn */
- (PNOperationButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_saveBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:PNLocalizedString(@"5nm3J7mD", @"保存") forState:UIControlStateNormal];
    }
    return _saveBtn;
}

/** @lazy deleteBtn */
- (PNOperationButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_deleteBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:PNLocalizedString(@"TITLE_DELETE", @"删除") forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

/** @lazy viewModel */
- (PNAddAndEditReciverInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNAddAndEditReciverInfoViewModel alloc] init];
    }
    return _viewModel;
}

- (PNReciverInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PNReciverInfoHeaderView alloc] initWithChannel:self.viewModel.channel];
    }
    return _headerView;
}
@end
