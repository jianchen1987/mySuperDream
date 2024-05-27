//
//  PNInterTransferBaseViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferBaseViewController.h"


@interface PNInterTransferBaseViewController ()

@end


@implementation PNInterTransferBaseViewController

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.stepView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.oprateBtn];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"unSuGzr5", @"国际转账");
}

//子类重写
- (void)clickOprateBtn {
}

- (void)updateViewConstraints {
    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(kRealWidth(108));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.stepView.mas_bottom).offset(kRealWidth(10));
    }];

    [self.oprateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(20));
        make.bottom.equalTo(self.view.mas_bottom).offset(kiPhoneXSeriesSafeBottomHeight > 0 ? -kiPhoneXSeriesSafeBottomHeight : -kRealWidth(15));
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(48));
    }];

    [super updateViewConstraints];
}

// 子类重写
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCell.new;
}
/** @lazy stepView */
- (PNTransferStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNTransferStepView alloc] init];
    }
    return _stepView;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.needShowErrorView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

/** @lazy oprateBtn */
- (PNOperationButton *)oprateBtn {
    if (!_oprateBtn) {
        _oprateBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_oprateBtn addTarget:self action:@selector(clickOprateBtn) forControlEvents:UIControlEventTouchUpInside];
        [_oprateBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_NEXT", @"下一步") forState:UIControlStateNormal];
    }
    return _oprateBtn;
}
@end
