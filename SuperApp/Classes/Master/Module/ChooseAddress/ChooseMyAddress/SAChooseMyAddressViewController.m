
//
//  SAChooseMyAddressViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseMyAddressViewController.h"
#import "SAAddressModel.h"
#import "SAImageTitleTableViewCell.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressTableViewCell.h"
#import "SATableView.h"


@interface SAChooseMyAddressViewController () <UITableViewDelegate, UITableViewDataSource>
/// 选择地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAShoppingAddressModel *, SAAddressModelFromType);
/// 当前选择的地址模型
@property (nonatomic, weak) SAAddressModel *currentAddressModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 列表数据
@property (nonatomic, strong) HDTableViewSectionModel *addressListSectionModel;
/// DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 是否不需要主动pop
@property (nonatomic, assign) BOOL notNeedPop;
/// 是否需要校验地址是否完善
@property (nonatomic, assign) BOOL isNeedCompleteAddress;
/// 返回 回调
@property (nonatomic, copy) void (^cancelBlock)(void);
/// 选中的地址模型
@property (nonatomic, weak) SAShoppingAddressModel *selectedAddressModel;
@end


@implementation SAChooseMyAddressViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(SAShoppingAddressModel *_Nullable, SAAddressModelFromType) = parameters[@"callback"];
    void (^cancelCallBack)(void) = parameters[@"cancelCallBack"];
    self.choosedAddressBlock = callback;
    self.cancelBlock = cancelCallBack;
    self.currentAddressModel = parameters[@"currentAddressModel"];
    self.notNeedPop = [parameters[@"notNeedPop"] boolValue];
    self.isNeedCompleteAddress = [parameters[@"isNeedCompleteAddress"] boolValue];

    return self;
}

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
    self.boldTitle = SALocalizedString(@"choose_address", @"选择地址");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController == nil && HDIsObjectNil(self.selectedAddressModel)) {
        //没有选择地址回调   因为还要监听手势返回  在这里处理了
        !self.cancelBlock ?: self.cancelBlock();
    }
}
- (void)hd_getNewData {
    [self showloading];
    @HDWeakify(self);
    [self.addressDTO getShoppingAddressListSuccess:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];

        self.addressListSectionModel.list = list;
        [self.tableView successGetNewDataWithNoMoreData:true];

        for (SAShoppingAddressModel *model in list) {
            if (self.currentAddressModel && [self.currentAddressModel.addressNo isEqualToString:model.addressNo]) {
                model.isSelected = SABoolValueTrue;
                // 默认选中
                NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:[list indexOfObject:model] inSection:[self.dataSource indexOfObject:self.addressListSectionModel]];
                [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];

        [self.tableView failGetNewData];
    }];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
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
        trueModel.cellType = SAShoppingAddressCellTypeChoose;
        cell.isNeedCompleteAddress = self.isNeedCompleteAddress;
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
    id model = self.dataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
            if (self.choosedAddressBlock) {
                self.choosedAddressBlock(addressModel, SAAddressModelFromTypeAdd);
            }
        };
        [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"callback": callback, @"notNeedPop": @(self.notNeedPop), @"currentAddressModel": self.currentAddressModel}];
    } else if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;

        if (!self.choosedAddressBlock || (self.isNeedCompleteAddress && [trueModel isNeedCompleteAddressInClientType:nil])) {
            [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"model": trueModel, @"currentAddressModel": self.currentAddressModel}];
        } else if (self.choosedAddressBlock) {
            self.selectedAddressModel = trueModel;
            self.choosedAddressBlock(trueModel, SAAddressModelFromTypeAddressList);
            if (!self.notNeedPop) {
                [self.navigationController popViewControllerAnimated:YES];
            }
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
