//
//  WMToStoreContactView.m
//  SuperApp
//
//  Created by Tia on 2023/8/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMToStoreContactView.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "SATableView.h"
#import "SAMultiLanguageManager.h"
#import "SAAppTheme.h"
#import "WMToStoreContactViewCell.h"
#import "SAShoppingAddressModel.h"


@interface WMToStoreContactView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBTN;

@property (nonatomic, strong) SATableView *tableView;

@property (nonatomic, copy) void (^completion)(SAShoppingAddressModel *);

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) SAShoppingAddressModel *selectData;

@end


@implementation WMToStoreContactView

- (instancetype)initWithDataSource:(NSArray *)dataSource selectData:(SAShoppingAddressModel *)selectData completion:(void (^)(SAShoppingAddressModel *))completion {
    if (self = [super init]) {
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        self.dataSource = dataSource;
        self.selectData = selectData;
        self.completion = completion;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tableView];
}

- (void)layoutContainerViewSubViews {
    CGFloat margin = kRealWidth(12);
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(16));
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(self.closeBTN.mas_left).offset(-margin);
    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB);
        make.right.mas_equalTo(-margin);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(kRealWidth(8));
        make.height.mas_equalTo(self.dataSource.count > 8 ? kScreenHeight * 0.7 : self.dataSource.count * (46 + 12));
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight - 20);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return nil;
    WMToStoreContactViewCell *cell = [WMToStoreContactViewCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.section];
    cell.btn.selected = [self.selectData isEqual:self.dataSource[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.completion) {
        self.completion(self.dataSource[indexPath.section]);
        [self dismiss];
    }
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = UILabel.new;
        _titleLB.font = HDAppTheme.font.sa_standard20H;
        _titleLB.textColor = HDAppTheme.color.sa_C333;
        _titleLB.text = WMLocalizedString(@"wm_pickup_Select contact phone number", @"选择联系电话");
    }
    return _titleLB;
}

- (UIButton *)closeBTN {
    if (!_closeBTN) {
        @HDWeakify(self);
        _closeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"recoder_del_hei"] forState:UIControlStateNormal];
        [_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBTN;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = 46;
    }
    return _tableView;
}

@end
