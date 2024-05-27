//
//  PNApartmentRecordListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentRecordListViewController.h"
#import "PNApartmentRecordListView.h"
#import "PNAPFilterView.h"


@interface PNApartmentRecordListViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PNApartmentRecordListView *contentView;
@property (nonatomic, strong) HDUIButton *addBtn;
@property (nonatomic, strong) PNAPFilterView *filterView;

@end


@implementation PNApartmentRecordListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.contentView.startDate = @"";
        self.contentView.endDate = @"";
        self.contentView.statusArray = [NSMutableArray arrayWithObject:@(PNApartmentPaymentStatus_ALL)];
    }
    return self;
}

- (void)hd_getNewData {
    [self.contentView getNewData];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Record", @"缴费记录");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.contentView];
}

- (void)updateViewConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
}

- (PNApartmentRecordListView *)contentView {
    if (!_contentView) {
        _contentView = [[PNApartmentRecordListView alloc] init];
    }
    return _contentView;
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

            self.filterView.startDate = self.contentView.startDate;
            self.filterView.endDate = self.contentView.endDate;
            self.filterView.statusArray = self.contentView.statusArray;
            [self.filterView showInSuperView:self.bgView];
        }];

        _addBtn = button;
    }
    return _addBtn;
}

- (PNAPFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNAPFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

        @HDWeakify(self);
        _filterView.confirmBlock = ^(NSString *_Nonnull startDate, NSString *_Nonnull endDate, NSArray *_Nonnull status) {
            @HDStrongify(self);

            HDLog(@"11");
            self.contentView.startDate = startDate;
            self.contentView.endDate = endDate;
            self.contentView.statusArray = [NSMutableArray arrayWithArray:status];

            [self.contentView getNewData];
        };
    }
    return _filterView;
}
@end
