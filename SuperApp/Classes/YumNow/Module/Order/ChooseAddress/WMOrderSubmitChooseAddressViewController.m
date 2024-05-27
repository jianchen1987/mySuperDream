//
//  WMOrderSubmitChooseAddressViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitChooseAddressViewController.h"
#import "SAImageTitleTableViewCell.h"
#import "SAShoppingAddressDTO.h"
#import "SAShoppingAddressModel.h"
#import "SATableView.h"
#import "WMCheckIsStoreCanDeliveryRspModel.h"
#import "WMShoppingAddressTableViewCell.h"
#import "WMStoreDTO.h"


@interface WMOrderSubmitChooseAddressViewController () <UITableViewDelegate, UITableViewDataSource>
/// 选择地址回调
@property (nonatomic, copy) void (^choosedAddressBlock)(SAShoppingAddressModel *);
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 可用地址列表数据
@property (nonatomic, strong) HDTableViewSectionModel *availableAddressListSectionModel;
/// 可用地址列表数据
@property (nonatomic, strong) HDTableViewSectionModel *unavailableAddressListSectionModel;
/// DTO
@property (nonatomic, strong) SAShoppingAddressDTO *addressDTO;
/// 门店 DTO
@property (nonatomic, strong) WMStoreDTO *storeDTO;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 已选地址编号
@property (nonatomic, copy) NSString *chooseAddressNo;
/// 是否需要校验地址是否完善
@property (nonatomic, assign) BOOL isNeedCompleteAddress;
@end


@implementation WMOrderSubmitChooseAddressViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(SAShoppingAddressModel *) = parameters[@"callback"];
    self.choosedAddressBlock = callback;

    self.storeNo = parameters[@"storeNo"];
    self.chooseAddressNo = parameters[@"addressNo"];
    self.isNeedCompleteAddress = [parameters[@"isNeedCompleteAddress"] boolValue];

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_sumit_choose_address_title", @"选择地址");
}

- (void)hd_setupViews {
    self.miniumGetNewDataDuration = 0;
    [self.view addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    SAImageTitleTableViewCellModel *addModel = SAImageTitleTableViewCellModel.new;
    addModel.image = [UIImage imageNamed:@"add_address"];
    addModel.title = WMLocalizedString(@"add_new_address", @"添加地址");
    sectionModel.list = @[addModel];

    self.dataSource = @[sectionModel, self.availableAddressListSectionModel, self.unavailableAddressListSectionModel];
}

- (void)hd_getNewData {
    [self showloading];
    @HDWeakify(self);
    [self.addressDTO getUserAccessableShoppingAddressWithStoreNo:self.storeNo success:^(NSArray<SAShoppingAddressModel *> *_Nonnull list) {
        @HDStrongify(self);
        [self dismissLoading];

//        self.availableAddressListSectionModel.list = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
//            return [item.inRange isEqualToString:SABoolValueTrue];
//        }];
        
        //处理地址排序，默认第一位，然后地址位置与用户最近的前排
        
        NSArray *availableAddressListSectionModel = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
            return [item.inRange isEqualToString:SABoolValueTrue];
        }];
        NSMutableArray *mArr1 = @[].mutableCopy;
        NSMutableArray *mArr2 = @[].mutableCopy;
        
        //获取当前经纬度
        CLLocationCoordinate2D coordinate2D = HDLocationManager.shared.coordinate2D;
        //最新位置
        CLLocation *toL = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
        
        for (SAShoppingAddressModel *addressModel in availableAddressListSectionModel) {
            //移除默认地址优先 2.72.0
//            if([addressModel.isDefault isEqualToString:SABoolValueTrue]) {
//                [mArr1 addObject:addressModel];
//            }else{
                //比较当前位置和店铺距离大小，取最小的
                double distance = [HDLocationUtils distanceFromLocation:toL toLocation:[[CLLocation alloc] initWithLatitude:addressModel.latitude.doubleValue longitude:addressModel.longitude.doubleValue]];
                addressModel.distance = distance;
                [mArr2 addObject:addressModel];
//            }
        }
        //重排非默认地址
        [mArr2 sortUsingComparator:^NSComparisonResult(SAShoppingAddressModel *obj1, SAShoppingAddressModel *obj2) {
            return obj1.distance > obj2.distance;
        }];
        
        [mArr1 addObjectsFromArray:mArr2];

        self.availableAddressListSectionModel.list = mArr1;
        
        self.unavailableAddressListSectionModel.list = [list hd_filterWithBlock:^BOOL(SAShoppingAddressModel *_Nonnull item) {
            return [item.inRange isEqualToString:SABoolValueFalse];
        }];
        [self.tableView successGetNewDataWithNoMoreData:true];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];

        [self.tableView failGetNewData];
    }];
}

- (void)checkIsAddressModelValid:(SAShoppingAddressModel *)addressModel {
    @HDWeakify(self);
    void (^successHandler)(BOOL) = ^(BOOL canDelivery) {
        @HDStrongify(self);
        if (canDelivery) {
            addressModel.inRange = SABoolValueTrue;
            !self.choosedAddressBlock ?: self.choosedAddressBlock(addressModel);
            [self dismissAnimated:true completion:nil];
        } else {
            [NAT showAlertWithTitle:WMLocalizedString(@"choosed_address_not_in_delivery_scope_1", @"不在配送范围")
                            message:WMLocalizedString(@"choosed_address_not_in_delivery_scope_2", @"当前地点暂未提供配送服务。")
                        buttonTitle:WMLocalizedString(@"manual_select", @"手动选择") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [alertView dismiss];
                            [self hd_getNewData];
                        }];
        }
    };

    [self.storeDTO checkIsStoreCanDeliveryWithStoreNo:self.storeNo longitude:addressModel.longitude.stringValue latitude:addressModel.latitude.stringValue
                                              success:^(WMCheckIsStoreCanDeliveryRspModel *_Nonnull rspModel) {
                                                  !successHandler ?: successHandler(rspModel.canDelivery == SABoolValueTrue);
                                              }
                                              failure:nil];
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
        WMShoppingAddressTableViewCell *cell = [WMShoppingAddressTableViewCell cellWithTableView:tableView];
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;
        trueModel.cellType = SAShoppingAddressCellTypeChoose;
        trueModel.isSelected = [trueModel.addressNo isEqualToString:self.chooseAddressNo] ? SABoolValueTrue : SABoolValueFalse;
        cell.isNeedCompleteAddress = self.isNeedCompleteAddress;
        cell.model = trueModel;
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
    model.marginToBottom = 5;
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
    [tableView deselectRowAtIndexPath:indexPath animated:false];

    id model = self.dataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:SAImageTitleTableViewCellModel.class]) {
        void (^callback)(SAShoppingAddressModel *) = ^(SAShoppingAddressModel *addressModel) {
            // 判断地址是否在配送范围
            [self checkIsAddressModelValid:addressModel];
        };
        [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"callback": callback}];
    } else if ([model isKindOfClass:SAShoppingAddressModel.class]) {
        SAShoppingAddressModel *trueModel = (SAShoppingAddressModel *)model;
        if ([trueModel.inRange isEqualToString:SABoolValueTrue]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            if (self.isNeedCompleteAddress && [trueModel isNeedCompleteAddressInClientType:nil]) {
                [HDMediator.sharedInstance navigaveToAddOrModifyAddressViewController:@{@"model": trueModel}];
            } else {
                !self.choosedAddressBlock ?: self.choosedAddressBlock(model);
                [self dismissAnimated:true completion:nil];
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

- (WMStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = WMStoreDTO.new;
    }
    return _storeDTO;
}

- (HDTableViewSectionModel *)availableAddressListSectionModel {
    if (!_availableAddressListSectionModel) {
        _availableAddressListSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.image = [UIImage imageNamed:@"my_address"];
        headerModel.title = WMLocalizedString(@"my_address", @"我的地址");
        headerModel.titleFont = HDAppTheme.font.standard2Bold;
        headerModel.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, HDAppTheme.value.padding.right);
        headerModel.titleToImageMarin = kRealWidth(10);
        _availableAddressListSectionModel.headerModel = headerModel;
    }
    return _availableAddressListSectionModel;
}

- (HDTableViewSectionModel *)unavailableAddressListSectionModel {
    if (!_unavailableAddressListSectionModel) {
        _unavailableAddressListSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"cannot_be_delivered_to", @"以下地址不在配送范围");
        headerModel.titleFont = HDAppTheme.font.standard2;
        headerModel.titleColor = HDAppTheme.color.G3;
        headerModel.edgeInsets = UIEdgeInsetsMake(15, kRealWidth(30), 0, HDAppTheme.value.padding.right);
        _unavailableAddressListSectionModel.headerModel = headerModel;
    }
    return _unavailableAddressListSectionModel;
}
@end
