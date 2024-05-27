//
//  PNApartmentListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentListViewController.h"
#import "PNApartmentListView.h"


@interface PNApartmentListViewController ()
@property (nonatomic, strong) PNApartmentListView *contentView;
@property (nonatomic, strong) HDUIButton *addBtn;
@end


@implementation PNApartmentListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contentView getNewData];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Rent_bill", @"公寓缴费");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNApartmentListView *)contentView {
    if (!_contentView) {
        _contentView = [[PNApartmentListView alloc] init];
    }
    return _contentView;
}

- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_record_2", @"记录") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;

        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowApartmentRecordListVC:@{}];
        }];

        _addBtn = button;
    }
    return _addBtn;
}

@end
