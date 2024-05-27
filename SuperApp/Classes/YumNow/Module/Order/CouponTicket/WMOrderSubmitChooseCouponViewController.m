

//
//  WMOrderSubmitChooseCouponViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitChooseCouponViewController.h"
#import "SASelectableCouponTicketTableViewCell.h"
#import "SATableView.h"
#import "WMOrderSubmitCouponDTO.h"
#import "WMOrderSubmitCouponRspModel.h"


@interface WMOrderSubmitChooseCouponViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 可用数据
@property (nonatomic, strong) HDTableViewSectionModel *usableCpuponListSectionModel;
/// 不可用数据
@property (nonatomic, strong) HDTableViewSectionModel *unusableCpuponListSectionModel;
/// DTO
@property (nonatomic, strong) WMOrderSubmitCouponDTO *couponTicketDTO;
/// 不使用优惠券按钮
@property (nonatomic, strong) HDUIButton *notUseBTN;
/// 当前页码
@property (nonatomic, assign) NSUInteger currentPageNo;
/// 选择回调，不使用优惠券就是 传 nil
@property (nonatomic, copy) void (^callback)(WMOrderSubmitCouponModel *_Nullable couponModel, NSUInteger usableCouponCount);
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 金额
@property (nonatomic, copy) NSString *amount;
/// 配送费金额
@property (nonatomic, copy) NSString *deliveryAmt;
/// 打包费
@property (nonatomic, copy) NSString *packingAmt;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 优惠券号
@property (nonatomic, copy) NSString *couponNo;
/// 币种
@property (nonatomic, copy) SACurrencyType currencyType;
/// 收货地址编号
@property (nonatomic, copy) NSString *addressNo;
/// 响应数据
@property (nonatomic, strong) WMOrderSubmitCouponRspModel *rspModel;
/// 类型
@property (nonatomic, strong) NSArray<NSNumber *> *couponType;
@end


@implementation WMOrderSubmitChooseCouponViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.storeNo = parameters[@"storeNo"];
    self.currencyType = parameters[@"currencyType"];
    self.merchantNo = parameters[@"merchantNo"];
    self.amount = parameters[@"amount"];
    self.couponNo = parameters[@"couponNo"];
    self.deliveryAmt = parameters[@"deliveryAmt"];
    self.packingAmt = parameters[@"packingAmt"];
    self.addressNo = parameters[@"addressNo"];
    self.couponType = parameters[@"couponType"];
    void (^callback)(WMOrderSubmitCouponModel *_Nullable, NSUInteger) = parameters[@"callback"];
    self.callback = callback;

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_submit_choose_coupon", @"选择优惠券");
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.notUseBTN];
}

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self.tableView getNewData];
}

- (void)hd_bindViewModel {
    self.dataSource = @[self.usableCpuponListSectionModel, self.unusableCpuponListSectionModel];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - Data
- (void)getNewData {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    @HDWeakify(self);
    [self.couponTicketDTO getCouponListWithBusinessType:SAMarketingBusinessTypeYumNow storeNo:self.storeNo currencyType:self.currencyType amount:self.amount deliveryAmt:self.deliveryAmt
        packingAmt:self.packingAmt
        pageSize:99 ///目前接口没有类型筛选 导致筛选的时候拿不到
        pageNum:pageNo
        merchantNo:self.merchantNo
        addressNo:self.addressNo success:^(WMOrderSubmitCouponRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.rspModel = rspModel;
            // 修正 number
            self.currentPageNo = rspModel.pageNum;
            NSArray<WMOrderSubmitCouponModel *> *list = @[];
            if ([self.couponType isKindOfClass:NSArray.class] && self.couponType.count) {
                list = [rspModel.list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                    return [self.couponType containsObject:@(item.couponType)];
                }];
            } else {
                list = rspModel.list;
            }
            NSArray<SACouponTicketModel *> *usableList = [[list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return [item.usable isEqualToString:SABoolValueTrue];
            }] mapObjectsUsingBlock:^id _Nonnull(WMOrderSubmitCouponModel *_Nonnull obj, NSUInteger idx) {
                return [SACouponTicketModel modelWithOrderSubmitCouponModel:obj businessLine:SAMarketingBusinessTypeYumNow];
            }];
            NSArray<SACouponTicketModel *> *unusableList = [[list hd_filterWithBlock:^BOOL(WMOrderSubmitCouponModel *_Nonnull item) {
                return ![item.usable isEqualToString:SABoolValueTrue];
            }] mapObjectsUsingBlock:^id _Nonnull(WMOrderSubmitCouponModel *_Nonnull obj, NSUInteger idx) {
                return [SACouponTicketModel modelWithOrderSubmitCouponModel:obj businessLine:SAMarketingBusinessTypeYumNow];
            }];
            if (pageNo == 1) {
                if (list.count) {
                    NSArray<SACouponTicketModel *> *copyedUsableList = self.usableCpuponListSectionModel.list.mutableCopy;
                    for (SACouponTicketModel *newModel in usableList) {
                        for (SACouponTicketModel *oldModel in copyedUsableList) {
                            if ([oldModel.couponTitle isEqualToString:newModel.couponTitle]) {
                                newModel.isSelected = oldModel.isSelected;
                                newModel.isExpanded = oldModel.isExpanded;
                            }
                        }
                    }
                    NSArray<SACouponTicketModel *> *copyedUnusableList = self.unusableCpuponListSectionModel.list.mutableCopy;
                    for (SACouponTicketModel *newModel in unusableList) {
                        for (SACouponTicketModel *oldModel in copyedUnusableList) {
                            if ([oldModel.couponTitle isEqualToString:newModel.couponTitle]) {
                                newModel.isSelected = oldModel.isSelected;
                                newModel.isExpanded = oldModel.isExpanded;
                            }
                        }
                    }
                    self.usableCpuponListSectionModel.list = usableList;
                    self.unusableCpuponListSectionModel.list = unusableList;
                }
                [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                if (rspModel.list.count) {
                    NSMutableArray<SACouponTicketModel *> *originalUsableList = [NSMutableArray arrayWithArray:self.usableCpuponListSectionModel.list];
                    [originalUsableList addObjectsFromArray:usableList];
                    self.usableCpuponListSectionModel.list = originalUsableList;

                    NSMutableArray<SACouponTicketModel *> *originalUnusableList = [NSMutableArray arrayWithArray:self.unusableCpuponListSectionModel.list];
                    [originalUnusableList addObjectsFromArray:unusableList];
                    self.unusableCpuponListSectionModel.list = originalUnusableList;
                }
                [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
            [self selectDefaultIndexPath];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            pageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
        }];
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
    if ([model isKindOfClass:SACouponTicketModel.class]) {
        SASelectableCouponTicketTableViewCell *cell = [SASelectableCouponTicketTableViewCell cellWithTableView:tableView];
        SACouponTicketModel *trueModel = (SACouponTicketModel *)model;
        trueModel.isFirstCell = indexPath.row == 0;
        trueModel.isLastCell = indexPath.row == sectionModel.list.count - 1;
        trueModel.cellType = SACouponTicketCellTypeSelect;
        cell.model = trueModel;
        //        @HDWeakify(self);
        //        cell.clickedViewDetailBlock = ^{
        //            @HDStrongify(self);
        //            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
        //        };
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
    model.marginToBottom = kRealWidth(5);
    model.backgroundColor = UIColor.clearColor;
    headView.model = model;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    if (HDIsStringEmpty(sectionModel.headerModel.title) || sectionModel.list.count <= 0)
        return CGFLOAT_MIN;

    return 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];

    id model = self.dataSource[indexPath.section].list[indexPath.row];

    if ([model isKindOfClass:SACouponTicketModel.class]) {
        SACouponTicketModel *trueModel = (SACouponTicketModel *)model;
        if ([trueModel.couponState isEqualToString:SACouponTicketStateUnused]) {
            // 取出模型
            WMOrderSubmitCouponModel *needModel = trueModel.orderSubmitCouponModel;

            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            !self.callback ?: self.callback(needModel, self.rspModel.total);
            [self dismissAnimated:true completion:nil];
        }
    }
}

#pragma mark - private methods
- (void)selectDefaultIndexPath {
    for (HDTableViewSectionModel *sectionModel in self.dataSource) {
        for (SACouponTicketModel *ticketModel in sectionModel.list) {
            // 选中已选券
            if (HDIsStringNotEmpty(self.couponNo) && [self.couponNo isEqualToString:ticketModel.couponNo]) {
                ticketModel.isSelected = true;
                // 默认选中
                NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:[sectionModel.list indexOfObject:ticketModel] inSection:[self.dataSource indexOfObject:sectionModel]];
                [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    }
}

#pragma mark - SAViewModelProtocol
- (BOOL)allowContinuousBePushed {
    return true;
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (WMOrderSubmitCouponDTO *)couponTicketDTO {
    if (!_couponTicketDTO) {
        _couponTicketDTO = WMOrderSubmitCouponDTO.new;
    }
    return _couponTicketDTO;
}

- (HDTableViewSectionModel *)usableCpuponListSectionModel {
    if (!_usableCpuponListSectionModel) {
        _usableCpuponListSectionModel = HDTableViewSectionModel.new;
    }
    return _usableCpuponListSectionModel;
}

- (HDTableViewSectionModel *)unusableCpuponListSectionModel {
    if (!_unusableCpuponListSectionModel) {
        _unusableCpuponListSectionModel = HDTableViewSectionModel.new;
        HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
        headerModel.title = WMLocalizedString(@"following_not_available", @"以下优惠券不可使用");
        headerModel.edgeInsets = UIEdgeInsetsMake(0, kRealWidth(20), 0, HDAppTheme.value.padding.right);
        _unusableCpuponListSectionModel.headerModel = headerModel;
    }
    return _unusableCpuponListSectionModel;
}

- (HDUIButton *)notUseBTN {
    if (!_notUseBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:WMLocalizedString(@"not_use", @"Not use") forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.callback ?: self.callback(nil, self.usableCpuponListSectionModel.list.count);
            [self dismissAnimated:true completion:nil];
        }];
        _notUseBTN = button;
    }
    return _notUseBTN;
}
@end
