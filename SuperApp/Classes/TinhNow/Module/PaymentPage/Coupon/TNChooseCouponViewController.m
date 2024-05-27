//
//  TNChooseCouponViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNChooseCouponViewController.h"
#import "SASelectableCouponTicketTableViewCell.h"
#import "SATableView.h"


@interface TNChooseCouponViewController () <UITableViewDelegate, UITableViewDataSource>
/// tableView
@property (strong, nonatomic) SATableView *tableView;
///
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 不使用按钮
@property (strong, nonatomic) HDUIButton *unUseBTN;
/// 选中回调
@property (nonatomic, copy) void (^chooseCouponCallBack)(WMOrderSubmitCouponModel *model);

@end


@implementation TNChooseCouponViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.dataSource = parameters[@"coupons"];
    self.chooseCouponCallBack = parameters[@"callBack"];
    return self;
}
- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor hd_colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.tableView];
}
- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_submit_choose_coupon", @"选择优惠券");
    ;
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.unUseBTN];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)hd_bindViewModel {
    [self.tableView successGetNewDataWithNoMoreData:YES];
    if (!HDIsArrayEmpty(self.dataSource)) {
        @HDWeakify(self);
        [self.dataSource.firstObject.list enumerateObjectsUsingBlock:^(SACouponTicketModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            @HDStrongify(self);
            if (obj.isSelected == YES) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                *stop = YES;
            }
        }];
    }
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
        SACouponTicketModel *truemodel = (SACouponTicketModel *)model;
        SASelectableCouponTicketTableViewCell *cell = [SASelectableCouponTicketTableViewCell cellWithTableView:tableView];
        truemodel.isFirstCell = indexPath.row == 0;
        truemodel.isLastCell = indexPath.row == sectionModel.list.count - 1;
        truemodel.cellType = SACouponTicketCellTypeSelect;
        cell.model = truemodel;
        //        @HDWeakify(self);
        //        cell.clickedViewDetailBlock = ^{
        //            @HDStrongify(self);
        //            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
        //        };
        return cell;
    }
    return nil;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:SACouponTicketModel.class]) {
        SACouponTicketModel *truemodel = (SACouponTicketModel *)model;
        if ([truemodel.couponState isEqualToString:SACouponTicketStateUnused]) {
            // 取出模型
            WMOrderSubmitCouponModel *needModel = truemodel.orderSubmitCouponModel;
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            !self.chooseCouponCallBack ?: self.chooseCouponCallBack(needModel);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}

- (HDUIButton *)unUseBTN {
    if (!_unUseBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:SALocalizedString(@"not_use", @"不使用") forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (!HDIsArrayEmpty(self.dataSource)) {
                [self.dataSource.firstObject.list enumerateObjectsUsingBlock:^(SACouponTicketModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    obj.isSelected = NO;
                }];
            }
            !self.chooseCouponCallBack ?: self.chooseCouponCallBack(WMOrderSubmitCouponModel.new);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _unUseBTN = button;
    }
    return _unUseBTN;
}
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
