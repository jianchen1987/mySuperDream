//
//  PNInternationalTransferViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferIndexViewController.h"
#import "HDBaseHtmlVC.h"
#import "HDTableViewSectionModel.h"
#import "HDWebViewHostViewController.h"
#import "NSObject+HDKitCore.h"
#import "PNInterTransferAmountViewController.h"
#import "PNInterTransferIndexDTO.h"
#import "PNInterTransferReciverDTO.h"
#import "PNInterTransferReciverInfoCell.h"
#import "PNInterTransferReciverModel.h"
#import "PNInterTransferRecordRspModel.h"
#import "PNInterTransferViewModel.h"
#import "PNNotifyView.h"
#import "PNTableView.h"
#import "SAInfoTableViewCell.h"
#import "UIColor+Extend.h"

static NSString *kTag = @"pn_tag";
static NSString *kHelp = @"pn_help";
static NSString *kRecent = @"pn_recent";


@interface PNInterTransferIndexViewController () <UITableViewDelegate, UITableViewDataSource>
/// 转账容器视图
@property (strong, nonatomic) UIView *transferContainer;
/// 背景图片
@property (nonatomic, strong) UIImageView *topBgView;
/// 文案
@property (nonatomic, strong) SALabel *transferTitleLabel;
/// 转账
@property (nonatomic, strong) HDUIButton *transferBtn;
/// 转账管理按钮
@property (strong, nonatomic) HDUIButton *transferManageBtn;
/// 转账记录
@property (strong, nonatomic) HDUIButton *transferRecordsBtn;
/// 最近汇款列表
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) PNInterTransferIndexDTO *recordDTO;
///
@property (strong, nonatomic) NSMutableArray *dataArr;
///
@property (strong, nonatomic) PNInterTransferReciverDTO *reciveDTO;

@property (nonatomic, strong) PNNotifyView *notifyView;

@end


@implementation PNInterTransferIndexViewController

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.transferContainer];
    [self.transferContainer addSubview:self.topBgView];
    //    [self.transferContainer addSubview:self.transferTitleLabel];
    [self.transferContainer addSubview:self.transferBtn];
    [self.transferContainer addSubview:self.transferManageBtn];
    [self.transferContainer addSubview:self.transferRecordsBtn];
    [self.view addSubview:self.tableView];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeInternationalTransfer];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (void)hd_getNewData {
    [self handleData:@[]];
    [self getRecordsData];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"unSuGzr5", @"国际转账");
    self.hd_navTitleColor = HDAppTheme.PayNowColor.c333333;
    self.hd_backButtonImage = [UIImage imageNamed:@"pn_icon_back_black"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark
- (void)getRecordsData {
    @HDWeakify(self);
    [self.recordDTO queryInterTransferRecentRecordListWithPageNum:1 pageSize:5 success:^(PNInterTransferRecordRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self handleData:rspModel.list];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [self handleData:@[]];
    }];
}

- (void)handleData:(NSArray *)dataList {
    [self.dataArr removeAllObjects];

    HDTableViewSectionModel *sectionModel;
    HDTableHeaderFootViewModel *headerModel;

    if (!HDIsArrayEmpty(dataList)) {
        NSMutableArray *arr = [NSMutableArray array];
        for (PNInterTransRecordModel *model in dataList) {
            NSDictionary *dict = [model yy_modelToJSONObject];
            PNInterTransferReciverModel *reciveModel = [PNInterTransferReciverModel yy_modelWithJSON:dict];
            reciveModel.reciverId = model.beneficiaryId;
            [arr addObject:reciveModel];
        }

        sectionModel = [[HDTableViewSectionModel alloc] init];
        [sectionModel hd_bindObject:kRecent forKey:kTag];
        headerModel = [[HDTableHeaderFootViewModel alloc] init];
        headerModel.titleFont = HDAppTheme.PayNowFont.standard16B;
        headerModel.titleColor = HDAppTheme.PayNowColor.c333333;
        headerModel.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        headerModel.title = PNLocalizedString(@"5O6zhbTH", @"最近记录");
        sectionModel.headerModel = headerModel;
        sectionModel.list = arr;
        [self.dataArr addObject:sectionModel];
    }

    sectionModel = [[HDTableViewSectionModel alloc] init];
    [sectionModel hd_bindObject:kHelp forKey:kTag];
    headerModel = [[HDTableHeaderFootViewModel alloc] init];

    headerModel.titleFont = HDAppTheme.PayNowFont.standard16B;
    headerModel.titleColor = HDAppTheme.PayNowColor.c333333;
    headerModel.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
    headerModel.edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    headerModel.title = PNLocalizedString(@"pn_Care_center", @"帮助中心");

    NSMutableArray *arr = [NSMutableArray array];
    SAInfoViewModel *model = [SAInfoViewModel new];
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    //    model.leftImage = [UIImage imageNamed:@"pn_icon_ir_introduction"];
    model.keyText = PNLocalizedString(@"pn_IR_introduction", @"国际转账产品介绍");
    model.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));

    model.eventHandler = ^{
        /// url 带# 会被转义，导致加载不到
        HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
        vc.url = kIR_Introduction;
        [SAWindowManager navigateToViewController:vc parameters:@{}];
    };
    [arr addObject:model];

    model = [SAInfoViewModel new];
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    //    model.leftImage = [UIImage imageNamed:@"pn_icon_ir_qa"];
    model.keyText = PNLocalizedString(@"pn_IR_Q&A", @"国际转账问题解答");
    model.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
    model.eventHandler = ^{
        /// url 带# 会被转义，导致加载不到
        HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
        vc.url = kIR_Help;
        [SAWindowManager navigateToViewController:vc parameters:@{}];
    };
    [arr addObject:model];

    model = [SAInfoViewModel new];
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.keyText = PNLocalizedString(@"pn_inter_qualifications", @"国际转账业务资质");
    model.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
    model.eventHandler = ^{
        /// url 带# 会被转义，导致加载不到
        HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
        vc.url = kIR_Materials;
        [SAWindowManager navigateToViewController:vc parameters:@{}];
    };
    [arr addObject:model];

    model = [SAInfoViewModel new];
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.keyText = PNLocalizedString(@"pn_contact_us", @"联系我们");
    model.rightButtonImage = [UIImage imageNamed:@"arrow_gray_small"];
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
    model.eventHandler = ^{
        [HDMediator.sharedInstance navigaveToPayNowContacUSVC:@{}];
    };
    [arr addObject:model];

    sectionModel.headerModel = headerModel;
    sectionModel.list = arr;

    [self.dataArr addObject:sectionModel];

    self.tableView.hidden = NO;
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

/// 快速转账点击
- (void)fastTransferClick:(NSString *)reciveId {
    [self.view showloading];
    @HDWeakify(self);
    [self.reciveDTO queryReciverByReciverIds:@[reciveId] success:^(NSArray<PNInterTransferReciverModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self.view dismissLoading];
        if (!HDIsArrayEmpty(list)) {
            PNInterTransferViewModel *viewModel = [[PNInterTransferViewModel alloc] init];
            PNInterTransferReciverModel *reciverModel = list.firstObject;
            viewModel.reciverModel = reciverModel;
            viewModel.channel = reciverModel.channel;
            PNInterTransferAmountViewController *amountVC = [[PNInterTransferAmountViewController alloc] initWithViewModel:viewModel];
            [SAWindowManager navigateToViewController:amountVC];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark -methods
/// 点击国际转账
- (void)clickInternationalTransfer {
    [HDMediator.sharedInstance navigaveToInternationalTransferChannelVC:@{}];
}

/// 点击转账管理
- (void)clickTransferManage {
    [HDMediator.sharedInstance navigaveToInternationalTransferManagerVC:@{}];
}

/// 点击转账记录
- (void)clickTransferRecords {
    [HDMediator.sharedInstance navigaveToInternationalTransferRecordsListVC:@{}];
}

#pragma mark
#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:indexPath.section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kTag];
    if ([tag isEqualToString:kRecent]) {
        PNInterTransferReciverInfoCell *cell = [PNInterTransferReciverInfoCell cellWithTableView:tableView];
        [cell setRightImage:[UIImage imageNamed:@"arrow_gray_small"]];
        [cell setHiddenLeftImage:NO];
        PNInterTransferReciverModel *model = sectionModel.list[indexPath.row];
        cell.model = model;
        return cell;
    } else {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = sectionModel.list[indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self.class)];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:NSStringFromClass(self.class)];
        headerView.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        HDLabel *label = [[HDLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(50))];
        label.tag = 100;
        label.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.hd_edgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        [headerView addSubview:label];
    }

    HDLabel *label = [headerView viewWithTag:100];

    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:section];
    if (WJIsStringNotEmpty(sectionModel.headerModel.title)) {
        label.text = sectionModel.headerModel.title;
    } else {
        label.text = @"";
    }

    NSString *tag = [sectionModel hd_getBoundObjectForKey:kTag];
    if ([tag isEqualToString:kHelp] && self.dataArr.count > 1) {
        label.hd_top = kRealWidth(12);
    } else {
        label.hd_top = 0;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (HDIsArrayEmpty(self.dataArr)) {
        return 0;
    }

    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:section];
    NSString *tag = [sectionModel hd_getBoundObjectForKey:kTag];
    if ([tag isEqualToString:kHelp] && self.dataArr.count > 1) {
        return kRealWidth(62);
    } else {
        return kRealWidth(50);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDTableViewSectionModel *sectionModel = [self.dataArr objectAtIndex:indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:PNInterTransferReciverModel.class]) {
        PNInterTransferReciverModel *reciverModel = model;
        if (reciverModel.beneficiaryIsUsable) {
            [self fastTransferClick:reciverModel.reciverId];
        } else {
            [NAT showAlertWithMessage:reciverModel.beneficiaryIsUsableMsg buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
                              handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                  [alertView dismiss];
                              }];
        }
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        if (trueModel.eventHandler) {
            trueModel.eventHandler();
        }
    }
}

#pragma mark
#pragma mark -layout
- (void)updateViewConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        }];
    }

    [self.transferContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.notifyView.hidden) {
            make.top.equalTo(self.notifyView.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(10));
        }
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(12));
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.topBgView.image.size);
        make.top.left.right.bottom.mas_equalTo(self.transferContainer);
    }];

    //    [self.transferTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.transferContainer.mas_right).offset(kRealWidth(-12));
    //        make.top.mas_equalTo(self.transferContainer.mas_top).offset(kRealWidth(10));
    //    }];

    CGFloat btnWith = (kScreenWidth - (kRealWidth(12) * 4)) / 3.f;
    [self.transferManageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(btnWith));
        make.left.equalTo(self.transferContainer.mas_left).offset(kRealWidth(12));
        make.bottom.equalTo(self.transferContainer.mas_bottom).offset(kRealWidth(-16));
    }];

    [self.transferBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.height.equalTo(self.transferManageBtn);
        make.left.mas_equalTo(self.transferManageBtn.mas_right).offset(kRealWidth(12));
    }];

    [self.transferRecordsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.height.equalTo(self.transferBtn);
        make.right.mas_equalTo(self.transferContainer.mas_right).offset(kRealWidth(12));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.transferContainer.mas_bottom).offset(kRealWidth(10));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
/** @lazy transferContainer */
- (UIView *)transferContainer {
    if (!_transferContainer) {
        _transferContainer = [[UIView alloc] init];
        _transferContainer.backgroundColor = [UIColor whiteColor];
        _transferContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _transferContainer;
}

- (UIImageView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIImageView alloc] init];
        _topBgView.image = [UIImage imageNamed:@"pn_transfer_index_top_bg"];
    }
    return _topBgView;
}

- (SALabel *)transferTitleLabel {
    if (!_transferTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        label.text = PNLocalizedString(@"pn_transfer_to_alipay_tips", @"转出至: 支付宝绑定的中国大陆银行");
        label.numberOfLines = 0;
        _transferTitleLabel = label;

        _transferTitleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(15)];
            view.backgroundColor = [UIColor tn_colorGradientChangeWithSize:precedingFrame.size direction:TNGradientChangeDirectionLevel startColor:HexColor(0xFF4141)
                                                                  endColor:[HexColor(0xF98787) colorWithAlphaComponent:0.5]];
        };
    }
    return _transferTitleLabel;
}

- (HDUIButton *)transferBtn {
    if (!_transferBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_go_to_transfer", @"去转账") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_transfer"] forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12B;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setImagePosition:HDUIButtonImagePositionTop];
        [button sizeToFit];
        [button addTarget:self action:@selector(clickInternationalTransfer) forControlEvents:UIControlEventTouchUpInside];

        _transferBtn = button;
    }
    return _transferBtn;
}

/** @lazy transferManageBtn */
- (HDUIButton *)transferManageBtn {
    if (!_transferManageBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"fdYrGIFb", @"转账管理") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_transfer_manager"] forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12B;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setImagePosition:HDUIButtonImagePositionTop];
        [button sizeToFit];
        [button addTarget:self action:@selector(clickTransferManage) forControlEvents:UIControlEventTouchUpInside];
        _transferManageBtn = button;
    }
    return _transferManageBtn;
}

/** @lazy transferManageBtn */
- (HDUIButton *)transferRecordsBtn {
    if (!_transferRecordsBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"tvy0oIAQ", @"转账记录") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_transfer_record"] forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        [button setImagePosition:HDUIButtonImagePositionTop];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12B;
        [button sizeToFit];
        [button addTarget:self action:@selector(clickTransferRecords) forControlEvents:UIControlEventTouchUpInside];
        _transferRecordsBtn = button;
    }
    return _transferRecordsBtn;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.needShowErrorView = false;
        _tableView.needShowNoDataView = false;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(12)];
        //        };
    }
    return _tableView;
}

/** @lazy recordDto */
- (PNInterTransferIndexDTO *)recordDTO {
    if (!_recordDTO) {
        _recordDTO = [[PNInterTransferIndexDTO alloc] init];
    }
    return _recordDTO;
}

/** @lazy dataArr */
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

/** @lazy reciveDto */
- (PNInterTransferReciverDTO *)reciveDTO {
    if (!_reciveDTO) {
        _reciveDTO = [[PNInterTransferReciverDTO alloc] init];
    }
    return _reciveDTO;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end
