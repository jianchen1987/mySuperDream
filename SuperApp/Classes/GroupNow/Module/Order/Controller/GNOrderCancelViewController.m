//
//  GNOrderCancelViewController.m
//  SuperApp
//
//  Created by wmz on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderCancelViewController.h"
#import "GNCanceHeadView.h"
#import "GNCancelViewModel.h"


@interface GNOrderCancelViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
///确定按钮
@property (nonatomic, strong) HDUIButton *confirmBTN;
/// viewModel
@property (nonatomic, strong) GNCancelViewModel *viewModel;
/// headView
@property (nonatomic, strong) GNCanceHeadView *headView;
///回调
@property (nonatomic, copy) void (^callback)(BOOL result);
@end


@implementation GNOrderCancelViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.viewModel.orderNo = parameters[@"orderNo"];
    self.callback = parameters[@"callback"];
    return self;
}

- (void)hd_setupViews {
    self.boldTitle = GNLocalizedString(@"gn_order_cancel", @"Order Cancellation");
    self.view.backgroundColor = self.tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    [self.view addSubview:self.headView];
    [self.view addSubview:self.confirmBTN];
    [self.view addSubview:self.tableView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self.viewModel getCancelList];
    @HDWeakify(self)[self.KVOController hd_observe:self.viewModel keyPath:@"refreshType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.GNdelegate = self;
        if (self.viewModel.refreshType == GNRequestTypeSuccess) {
            [self.tableView reloadData:YES];
            self.confirmBTN.hidden = self.headView.hidden = NO;
        } else {
            [self.tableView reloadFail];
            self.confirmBTN.hidden = self.headView.hidden = YES;
        }
        [self.view setNeedsUpdateConstraints];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"changeBTNState" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        NSArray *selectArr = [self.viewModel.cancelDataSource hd_filterWithBlock:^BOOL(GNOrderCancelRspModel *_Nonnull item) {
            return item.isSelect;
        }];
        self.confirmBTN.enabled = !HDIsArrayEmpty(selectArr);
    }];
}

- (void)updateViewConstraints {
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.confirmBTN.isHidden) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kRealWidth(20));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(44));
        }
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.headView.isHidden) {
            make.top.mas_equalTo(kNavigationBarH);
            make.left.right.mas_equalTo(0);
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.headView.isHidden) {
            make.top.mas_equalTo(kNavigationBarH);
        } else {
            make.top.equalTo(self.headView.mas_bottom);
        }
        make.left.right.mas_equalTo(0);
        if (self.confirmBTN.isHidden) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.confirmBTN.mas_top).offset(-kRealWidth(20));
        }
    }];

    [super updateViewConstraints];
}

- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id<GNRowModelProtocol>)rowData {
    if ([rowData.businessData isKindOfClass:GNOrderCancelRspModel.class]) {
        GNOrderCancelRspModel *model = (id)rowData.businessData;
        [self.viewModel.cancelDataSource enumerateObjectsUsingBlock:^(GNOrderCancelRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.selected = (obj == model);
        }];
        ///其他
        if ([model.type isEqualToString:@"40"]) {
            if (self.viewModel.reasonModel && [self.viewModel.dataSource indexOfObject:self.viewModel.reasonModel] != NSNotFound) {
                [self.viewModel.dataSource removeObject:self.viewModel.reasonModel];
            }
            self.viewModel.reasonModel = [GNCellModel createClass:@"GNCancelReasonOtherCell"];
            [self.viewModel.dataSource addObject:self.viewModel.reasonModel];
            [self.tableView reloadData:YES];
            [self.tableView layoutIfNeeded];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.viewModel.dataSource.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
            if ([self.viewModel.dataSource indexOfObject:self.viewModel.reasonModel] != NSNotFound) {
                [self.viewModel.dataSource removeObject:self.viewModel.reasonModel];
            }
            [self.tableView reloadData:YES];
        }
        self.viewModel.changeBTNState = !self.viewModel.changeBTNState;
    }
}

///提交
- (void)confirmAction {
    @HDWeakify(self) NSArray *selectArr = [self.viewModel.cancelDataSource hd_filterWithBlock:^BOOL(GNOrderCancelRspModel *_Nonnull item) {
        return item.isSelect;
    }];
    if (!HDIsArrayEmpty(selectArr)) {
        GNOrderCancelRspModel *rspModel = selectArr.firstObject;
        NSString *remark = nil;
        if ([rspModel.type isEqualToString:@"40"]) {
            remark = self.viewModel.reasonModel.title;
        }
        [self showloading];
        [self.viewModel orderCanceledWithState:rspModel.type remark:remark completion:^(BOOL success) {
            [self dismissLoading];
            @HDStrongify(self) if (self.callback) {
                self.callback(success);
            }
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (GNTableView *)tableView {
    if (!_tableView) {
        ///使用UITableViewController解决输入框键盘遮挡问题
        UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self addChildViewController:tableViewController];
        [tableViewController.view setFrame:self.view.frame];
        GNTableView *tableView = [[GNTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.needShowErrorView = YES;
        tableView.needShowNoDataView = YES;
        tableView.delegate = tableView.provider;
        tableView.dataSource = tableView.provider;
        ///自动偏移解决键盘遮挡问题
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        tableViewController.tableView = tableView;
        _tableView = (id)tableViewController.tableView;
    }
    return _tableView;
}

- (GNCancelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNCancelViewModel.new;
    }
    return _viewModel;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        _confirmBTN.layer.cornerRadius = kRealWidth(22);
        _confirmBTN.hidden = YES;
        _confirmBTN.enabled = NO;
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self confirmAction];
        }];
    }
    return _confirmBTN;
}

- (GNCanceHeadView *)headView {
    if (!_headView) {
        _headView = GNCanceHeadView.new;
        _headView.hidden = YES;
    }
    return _headView;
}

@end
