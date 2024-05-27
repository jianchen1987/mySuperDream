//
//  PNContactUSViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNContactUSViewController.h"
#import "NSMutableAttributedString+Highlight.h"
#import "NSObject+HDKitCore.h"
#import "PNContactUSModel.h"
#import "PNTableView.h"
#import "PNTransferSectionHeaderView.h"
#import "PNUserDTO.h"
#import "SAInfoTableViewCell.h"

static NSString *kType = @"pn_type";
static NSString *kPhone = @"pn_phone";
static NSString *kEmail = @"pn_email";


@interface PNContactUSViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNUserDTO *userDTO;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation PNContactUSViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_contact_us", @"联系我们");
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
    headerModel.title = PNLocalizedString(@"pn_care_center", @"客服中心");
    headerModel.titleFont = HDAppTheme.PayNowFont.standard16B;
    headerModel.titleColor = HDAppTheme.PayNowColor.c333333;
    headerModel.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
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

    for (NSString *itemStr in model.emails) {
        if (WJIsStringNotEmpty(itemStr)) {
            SAInfoViewModel *model = [self getDefaultModel];
            [model hd_bindObjectWeakly:kEmail forKey:kType];
            model.rightButtonImage = [UIImage imageNamed:@"pn_contact_us_email"];
            model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"pn_email", @"邮箱")];
            model.valueText = itemStr;

            [arr addObject:model];
        }
    }

    sectionModel.list = arr;
    [self.dataSource addObject:sectionModel];

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

        if ([typeStr isEqualToString:kEmail]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = infoModel.valueText;
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_email_success", @"已复制邮箱") type:HDTopToastTypeInfo];
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
@end
