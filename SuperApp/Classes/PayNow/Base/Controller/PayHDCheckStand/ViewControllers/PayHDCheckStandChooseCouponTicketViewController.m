//
//  PayHDCheckstandChooseCouponTicketViewController.m
//  ViPay
//
//  Created by VanJay on 2019/6/13.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandChooseCouponTicketViewController.h"
#import "PayHDCheckstandCouponTicketTableViewCell.h"
#import "PayHDCommonCouponTicketTableViewCell.h"
#import "PayHDDontUseCouponTicketTableViewCell.h"
#import "PayHDTradePreferentialModel.h"
#import "SATableView.h"


@interface PayHDCheckstandChooseCouponTicketViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SATableView *tableView;                                               ///< 付款方式列表
@property (nonatomic, strong) NSMutableArray<NSArray<PayHDTradePreferentialModel *> *> *dataSource; ///< 数据源

@end


@implementation PayHDCheckstandChooseCouponTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType {
    return PayHDCheckstandPaymentOverTimeEndActionTypeChoosePreferential;
}

- (void)setupUI {
    self.title = PNLocalizedString(@"check_stand_choose_coupon", @"选择优惠");

    [self.containerView addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.width.centerX.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

#pragma mark - private methods
/**
 冒泡排序实现

 @param dataArray 需要排序的数组
 @return 排序完成的数组
 */
- (NSArray<PayHDTradePreferentialModel *> *)buddleSortCouponList:(NSArray<PayHDTradePreferentialModel *> *)dataArray {
    NSMutableArray<PayHDTradePreferentialModel *> *resultArray = [NSMutableArray arrayWithArray:dataArray];
    for (NSInteger i = 0; i < dataArray.count - 1; i++) {
        for (NSInteger j = 0; j < dataArray.count - 1 - i; j++) {
            if (!resultArray[j].isCommonCoupon && resultArray[j + 1].isCommonCoupon) {
                [resultArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }

    return resultArray;
}

#pragma mark - getters and setters
- (void)configureWithCouponList:(NSArray<PayHDTradePreferentialModel *> *)couponList isSelectedDontUseCoupon:(BOOL)isSelectedDontUseCoupon {
    [self.dataSource removeAllObjects];

    // 冒泡排序，常规优惠排前面
    NSArray<PayHDTradePreferentialModel *> *sortedCouponList = [self buddleSortCouponList:couponList];

    // 添加不使用优惠
    NSMutableArray<PayHDTradePreferentialModel *> *mutableCouponList = [NSMutableArray arrayWithArray:sortedCouponList];
    PayHDTradePreferentialModel *dontUseCouponModel = [[PayHDTradePreferentialModel alloc] init];
    dontUseCouponModel.couponAmt = [SAMoneyModel modelWithAmount:@"0" currency:@"USD"];
    dontUseCouponModel.isDontUseCoupon = YES;
    dontUseCouponModel.type = PNTradePreferentialTypeDefault;
    dontUseCouponModel.selected = isSelectedDontUseCoupon;
    [mutableCouponList addObject:dontUseCouponModel];

    NSMutableArray<PayHDTradePreferentialModel *> *commonCoupon = [NSMutableArray array];
    NSMutableArray<PayHDTradePreferentialModel *> *otherCoupon = [NSMutableArray array];

    for (PayHDTradePreferentialModel *model in mutableCouponList) {
        if (model.isCommonCoupon) {
            [commonCoupon addObject:model];
        } else {
            [otherCoupon addObject:model];
        }
    }

    if (commonCoupon.count > 0) {
        [self.dataSource addObjectsFromArray:@[commonCoupon]];
    }
    if (otherCoupon.count > 0) {
        [self.dataSource addObjectsFromArray:@[otherCoupon]];
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];

    // 默认选中
    for (NSInteger sectionIndex = 0; sectionIndex < self.dataSource.count; sectionIndex++) {
        NSArray<PayHDTradePreferentialModel *> *sectionDataSource = self.dataSource[sectionIndex];
        for (PayHDTradePreferentialModel *model in sectionDataSource) {
            if (model.isSelected) {
                NSInteger index = [sectionDataSource indexOfObject:model];
                NSIndexPath *selIndex = [NSIndexPath indexPathForRow:index inSection:sectionIndex];
                [_tableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:sectionIndex];
                [self tableView:self.tableView didSelectRowAtIndexPath:path];
            }
        }
    }
}

#pragma mark - table view delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayHDTradePreferentialModel *model = self.dataSource[indexPath.section][indexPath.row];
    model.numbersOfLineOfTitle = 2;
    model.numbersOfLineOfDate = 2;
    model.isFixedHeight = YES;

    if (model.isCommonCoupon) {
        PayHDCommonCouponTicketTableViewCell *cell = [PayHDCommonCouponTicketTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else if (model.isDontUseCoupon) {
        PayHDDontUseCouponTicketTableViewCell *cell = [PayHDDontUseCouponTicketTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    PayHDCheckstandCouponTicketTableViewCell *cell = [PayHDCheckstandCouponTicketTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayHDTradePreferentialModel *model = self.dataSource[indexPath.section][indexPath.row];

    if (model.isCommonCoupon) {
        return kRealWidth(95);
    } else {
        return kRealWidth(115);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PayHDTradePreferentialModel *model = self.dataSource[indexPath.section][indexPath.row];

    !self.choosedCouponModelHandler ?: self.choosedCouponModelHandler(model);

    // 自动返回
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != self.dataSource.count - 1) {
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = HexColor(0xF5F7FA);
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != self.dataSource.count - 1) {
        return 5;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = UIColor.whiteColor;
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return kRealWidth(15);
    }
    return CGFLOAT_MIN;
}

#pragma mark - lazy load
- (NSMutableArray<NSArray<PayHDTradePreferentialModel *> *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(20))];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(20))];

        [_tableView registerClass:PayHDCheckstandCouponTicketTableViewCell.class forCellReuseIdentifier:NSStringFromClass(PayHDCheckstandCouponTicketTableViewCell.class)];
        [_tableView registerClass:PayHDDontUseCouponTicketTableViewCell.class forCellReuseIdentifier:NSStringFromClass(PayHDDontUseCouponTicketTableViewCell.class)];
        [_tableView registerClass:PayHDCommonCouponTicketTableViewCell.class forCellReuseIdentifier:NSStringFromClass(PayHDCommonCouponTicketTableViewCell.class)];
    }
    return _tableView;
}

@end
