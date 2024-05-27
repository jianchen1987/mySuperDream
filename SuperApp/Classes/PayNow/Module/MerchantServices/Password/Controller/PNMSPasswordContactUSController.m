//
//  PNMSPasswordContactUSController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPasswordContactUSController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "NSObject+HDKitCore.h"
#import "PNContactUSModel.h"
#import "PNOperationButton.h"
#import "PNTableView.h"
#import "PNTransferSectionHeaderView.h"
#import "PNUserDTO.h"
#import "SAInfoTableViewCell.h"

static NSString *kType = @"pn_type";
static NSString *kPhone = @"pn_phone";
static NSString *kEmail = @"pn_email";


@interface PNMSPasswordContactUSController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNUserDTO *userDTO;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PNOperationButton *button;
@property (nonatomic, strong) UIView *footerView;
@end


@implementation PNMSPasswordContactUSController

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"change_pay_password", @"修改支付密码");
}

- (void)hd_getNewData {
    [self.view showloading];

    @HDWeakify(self);
    [self.userDTO getContactUSInfo:^(PNContactUSModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        /// 处理数据
        [self processData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
/// 处理数据  加工数据
- (void)processData:(PNContactUSModel *)model {
    [self.dataSource removeAllObjects];

    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    HDTableHeaderFootViewModel *headerModel = [[HDTableHeaderFootViewModel alloc] init];

    SAInfoViewModel *smodel = SAInfoViewModel.new;
    smodel.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    smodel.keyFont = HDAppTheme.PayNowFont.standard16B;
    smodel.keyColor = HDAppTheme.PayNowColor.c333333;
    smodel.keyNumbersOfLines = 0;
    smodel.lineWidth = 0;
    smodel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
    smodel.keyText = PNLocalizedString(@"pn_contact_care_center_reset_password", @"请联系客服中心重置支付密码");
    sectionModel.list = @[smodel];
    [self.dataSource addObject:sectionModel];

    sectionModel = [[HDTableViewSectionModel alloc] init];
    headerModel = [[HDTableHeaderFootViewModel alloc] init];
    headerModel.title = PNLocalizedString(@"pn_care_center", @"客服中心");
    headerModel.titleFont = HDAppTheme.PayNowFont.standard16B;
    headerModel.titleColor = HDAppTheme.PayNowColor.c333333;
    headerModel.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    headerModel.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    sectionModel.headerModel = headerModel;

    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *itemStr in model.hotlines) {
        if (WJIsStringNotEmpty(itemStr)) {
            SAInfoViewModel *model = [self getDefaultModel];
            [model hd_bindObjectWeakly:kPhone forKey:kType];
            model.rightButtonImage = [UIImage imageNamed:@"pn_contact_us_phone"];
            model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"pn_phone", @"电话")];
            model.valueText = itemStr;

            [arr addObject:model];
        }
    }

    sectionModel.list = arr;
    [self.dataSource addObject:sectionModel];

    self.tableView.tableFooterView = self.footerView;
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (SAInfoViewModel *)getDefaultModel {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyFont = HDAppTheme.PayNowFont.standard14;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c999999;
    model.valueTextAlignment = NSTextAlignmentLeft;
    model.valueAlignmentToOther = NSTextAlignmentLeft;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
    return model;
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        HDTableHeaderFootView *headerView = [HDTableHeaderFootView headerWithTableView:tableView];
        headerView.model = sectionModel.headerModel;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return kRealWidth(48);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:[SAInfoViewModel class]]) {
        SAInfoViewModel *infoModel = model;
        NSString *typeStr = [model hd_getBoundObjectForKey:kType];
        if ([typeStr isEqualToString:kPhone]) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [infoModel.valueText hd_trimAllWhiteSpace]]];
            [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    HDLog(@"拉起成功");
                } else {
                    HDLog(@"拉起失败");
                }
            }];
        }
    }
}

#pragma mark
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
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

- (PNUserDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = [[PNUserDTO alloc] init];
    }
    return _userDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _footerView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        [_footerView addSubview:self.button];
    }
    return _footerView;
}

- (PNOperationButton *)button {
    if (!_button) {
        PNOperationButton *btn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        btn.frame = CGRectMake(kRealWidth(20), kRealWidth(24), kScreenWidth - kRealWidth(40), 48);
        [btn setTitle:PNLocalizedString(@"pn_received_sms_code", @"我已收到验证码") forState:UIControlStateNormal];

        _button = btn;

        [_button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesForgotPasswordVerifySMSCodeVC:@{
                @"type": @(0),
            }];
        }];
    }
    return _button;
}

@end
