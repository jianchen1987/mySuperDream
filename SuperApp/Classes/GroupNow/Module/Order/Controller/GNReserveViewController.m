//
//  GNReserveViewController.m
//  SuperApp
//
//  Created by wmz on 2022/9/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReserveViewController.h"
#import "GNReserveView.h"
#import "GNReserveViewModel.h"


@interface GNReserveViewController ()
/// contentView
@property (nonatomic, strong) GNReserveView *reserveView;
/// viewModel
@property (nonatomic, strong) GNReserveViewModel *viewModel;
/// 选择回调
@property (nonatomic, copy) void (^callback)(GNReserveRspModel *_Nullable rspModel);

@end


@implementation GNReserveViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self.parameters = parameters;
    void (^callback)(GNReserveRspModel *_Nullable) = parameters[@"callback"];
    self.callback = callback;
    self.viewModel.reserveModel = parameters[@"reserveModel"];
    self.viewModel.storeNo = parameters[@"storeNo"];
    self.viewModel.orderNo = parameters[@"orderNo"];
    return [super initWithRouteParameters:parameters];
}

- (void)hd_setupViews {
    self.boldTitle = GNLocalizedString(@"gn_book", @"Reservation Details");
    [self.view addSubview:self.reserveView];
}

- (void)hd_setupNavigation {
    self.hd_navBackgroundColor = HDAppTheme.color.gn_mainBgColor;
}

- (void)updateViewConstraints {
    [self.reserveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarH);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

- (GNReserveView *)reserveView {
    if (!_reserveView) {
        _reserveView = [[GNReserveView alloc] initWithViewModel:self.viewModel];
        _reserveView.callback = self.callback;
    }
    return _reserveView;
}

- (GNReserveViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = GNReserveViewModel.new;
    }
    return _viewModel;
}

- (BOOL)needClose {
    return YES;
}

- (BOOL)needLogin {
    return YES;
}

@end
