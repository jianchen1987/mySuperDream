//
//  PNMSVoucherListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherListViewController.h"
#import "PNMSBillFilterModel.h"
#import "PNMSFilterStoreOperatorDataModel.h"
#import "PNMSOrderDTO.h"
#import "PNMSVoucherFilterView.h"
#import "PNMSVoucherListView.h"
#import "PNMSVoucherViewModel.h"


@interface PNMSVoucherListViewController ()
@property (nonatomic, strong) PNMSVoucherListView *contentView;
@property (nonatomic, strong) PNMSVoucherViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *addBtn;
@property (nonatomic, strong) PNMSVoucherFilterView *filterView;
@property (nonatomic, strong) PNMSFilterStoreOperatorDataModel *spModel;
@property (nonatomic, strong) PNMSOrderDTO *transDTO;
@property (nonatomic, assign) BOOL isFirst;

@end


@implementation PNMSVoucherListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_voucher_records", @"凭证记录");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.isFirst = YES;
    self.viewModel.currentPage = 1;
    self.viewModel.filterModel = [PNMSFilterModel new];
    self.viewModel.filterModel.startDate = @"";
    self.viewModel.filterModel.endDate = @"";
    self.viewModel.filterModel.storeNo = @"";
    self.viewModel.filterModel.operatorValue = @"";

    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_getNewData {
    [self.contentView getData:YES];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSVoucherListView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSVoucherListView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSVoucherViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSVoucherViewModel.new);
}

- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_more", @"筛选") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            self.filterView.filterModel = self.viewModel.filterModel;

            [self.filterView showInSuperView:self.contentView];
            self.isFirst = NO;
        }];

        _addBtn = button;
    }
    return _addBtn;
}

- (PNMSVoucherFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNMSVoucherFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.hd_navigationBar.hd_height)];
        @HDWeakify(self);
        _filterView.confirmBlock = ^(PNMSFilterModel *model) {
            @HDStrongify(self);
            self.viewModel.filterModel = model;

            [self.contentView getData:NO];
        };
    }
    return _filterView;
}

- (PNMSOrderDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNMSOrderDTO alloc] init];
    }
    return _transDTO;
}
@end
