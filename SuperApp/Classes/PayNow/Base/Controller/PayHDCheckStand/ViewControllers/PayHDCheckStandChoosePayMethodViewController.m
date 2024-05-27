//
//  PayHDCheckstandChoosePayMethodViewController.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandChoosePayMethodViewController.h"
#import "PNMultiLanguageManager.h" //语言
#import "PayHDCommonTickTableViewCell.h"
#import "PayHDTradePaymentMethodModel.h"
#import "PayHDTradePreferentialModel.h"
#import "SATableView.h"


@interface PayHDCheckstandChoosePayMethodViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SATableView *tableView;                                          ///< 付款方式列表
@property (nonatomic, strong) NSMutableArray<PayHDCommonTickTableViewCellModel *> *dataSource; ///< 数据源

@end


@implementation PayHDCheckstandChoosePayMethodViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType {
    return PayHDCheckstandPaymentOverTimeEndActionTypeChoosePayMethod;
}

- (void)setupUI {
    self.title = PNLocalizedString(@"checkStand_choose_pay_method", @"选择付款方式");

    [self.containerView addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom).offset(kRealWidth(20));
        make.width.centerX.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

#pragma mark - getters and setters
- (void)setPayMethodList:(NSArray<PayHDTradePaymentMethodModel *> *)payMethodList {
    _payMethodList = payMethodList;

    // 刷新界面
    [self.dataSource removeAllObjects];

    // 排序
    PayHDTradePaymentMethodModel *firstPaymentMethod = payMethodList.firstObject;
    NSArray<PayHDTradePaymentMethodModel *> *filteredArr =
        [payMethodList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PayHDTradePreferentialModel *model, NSDictionary *bindings) {
                           return model.sort <= firstPaymentMethod.sort;
                       }]];
    if (filteredArr && filteredArr.count > 0) {
        firstPaymentMethod = filteredArr.firstObject;
    }

    for (PayHDTradePaymentMethodModel *payMethod in payMethodList) {
        PayHDCommonTickTableViewCellModel *model = [[PayHDCommonTickTableViewCellModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@(%@)", payMethod.desc, payMethod.number];
        model.imageName = @"check_stand_logo";

        // 默认选中
        if (payMethod == firstPaymentMethod) {
            model.selected = YES;
        } else {
            model.selected = NO;
        }

        // 判读余额
        if (payMethod.balance.cent.doubleValue < self.payAmount.cent.doubleValue) {
            model.disabled = YES;
            model.subTitle = PNLocalizedString(@"checkStand_balance_not_enough", @"余额不足");
        } else {
            model.disabled = NO;
        }

        [self.dataSource addObject:model];
    }
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - table view delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayHDCommonTickTableViewCell *cell = [PayHDCommonTickTableViewCell cellWithTableView:tableView];
    PayHDCommonTickTableViewCellModel *model = self.dataSource[indexPath.row];
    model.hideBottomLine = indexPath.row >= self.dataSource.count - 1;
    cell.model = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    PayHDCommonTickTableViewCellModel *model = self.dataSource[indexPath.row];

    if (model.disabled) {
        HDLog(@"余额不足");
    }

    if (model.selected)
        return;

    for (PayHDCommonTickTableViewCellModel *subModel in self.dataSource) {
        if (subModel == model) {
            subModel.selected = YES;
        } else {
            subModel.selected = NO;
        }
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - lazy load
- (NSMutableArray<PayHDCommonTickTableViewCellModel *> *)dataSource {
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

        _tableView.estimatedRowHeight = 60;

        [_tableView registerClass:PayHDCommonTickTableViewCell.class forCellReuseIdentifier:NSStringFromClass(PayHDCommonTickTableViewCell.class)];
    }
    return _tableView;
}
@end
