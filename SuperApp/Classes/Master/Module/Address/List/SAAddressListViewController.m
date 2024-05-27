//
//  SAAddressListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressListViewController.h"
#import "SAImageTitleTableViewCell.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressTableViewCell.h"
#import "SATableView.h"


@interface SAAddressListViewController () <UITableViewDelegate, UITableViewDataSource>
/// 选择地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAShoppingAddressModel *);
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 列表数据
@property (nonatomic, strong) HDTableViewSectionModel *addressListSectionModel;
/// DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
@end


@implementation SAAddressListViewController

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;
    [self.view addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    SAImageTitleTableViewCellModel *addModel = SAImageTitleTableViewCellModel.new;
    addModel.image = [UIImage imageNamed:@"add_address"];
    addModel.title = SALocalizedString(@"add_new_address", @"添加新地址");
    sectionModel.list = @[addModel];

    self.dataSource = @[sectionModel, self.addressListSectionModel];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"shopping_address", @"收货地址");
}

- (void)hd_getNewData {
    [self showloading];
    @HDWeakify(self);
    [self.addressDTO getShoppingAddressListSuccess:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];

        self.addressListSectionModel.list = list;
        [self.tableView successGetNewDataWithNoMoreData:true];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];

        [self.tableView failGetNewData];
    }];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
    [super updateViewConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return UITableViewCell.new;

    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];

    if (indexPath.row >= sectionModel.list.count)
        return UITableViewCell.new;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        SAImageTitleTableViewCell *cell = [SAImageTitleTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        SAShoppingAddressTableViewCell *cell = [SAShoppingAddressTableViewCell cellWithTableView:tableView];
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;
        if (self.choosedAddressBlock) {
            trueModel.cellType = SAShoppingAddressCellTypeChoose;
        } else {
            trueModel.cellType = SAShoppingAddressCellTypeEdit;
        }

        cell.model = trueModel;
        cell.bottomLine.hidden = indexPath.row == sectionModel.list.count - 1;

        return cell;
    }
    return UITableViewCell.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return nil;

    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
    model.titleFont = HDAppTheme.font.standard2Bold;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return section <= 0 ? CGFLOAT_MIN : 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:nil];
    } else if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        if (self.choosedAddressBlock) {
            self.choosedAddressBlock((SAShoppingAddressModel *)model);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"model": model}];
        }
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}

- (SAShoppingAddressDTO *)addressDTO {
    if (!_addressDTO) {
        _addressDTO = SAShoppingAddressDTO.new;
    }
    return _addressDTO;
}

- (HDTableViewSectionModel *)addressListSectionModel {
    if (!_addressListSectionModel) {
        _addressListSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.image = [UIImage imageNamed:@"my_address"];
        headerModel.title = SALocalizedString(@"my_address", @"我的地址");
        headerModel.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, HDAppTheme.value.padding.right);
        headerModel.titleToImageMarin = kRealWidth(10);
        headerModel.marginToBottom = kRealWidth(1);
        _addressListSectionModel.headerModel = headerModel;
    }
    return _addressListSectionModel;
}
@end
