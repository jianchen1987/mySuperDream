//
//  TNProductServiceAlertView.m
//  SuperApp
//
//  Created by seeu on 2020/8/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductServiceAlertView.h"
#import "SAInfoTableViewCell.h"
#import "SATableView.h"
#import "TNProductServiceCell.h"


@interface TNProductServiceAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 数据源
@property (nonatomic, strong) NSArray<TNProductServiceModel *> *dataSource;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 列表
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation TNProductServiceAlertView
- (instancetype)initWithDataArr:(NSArray<TNProductServiceModel *> *)dataArr {
    self = [super init];
    if (self) {
        self.dataSource = dataArr;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
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
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tableView];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat height = self.tableView.contentSize.height;
            CGFloat maxHeight = kScreenHeight * 2 / 3;
            CGFloat minHeight = 250;
            if (height > maxHeight) {
                height = maxHeight;
            }
            if (height < minHeight) {
                height = minHeight;
            }
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        });
    }];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(15));
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(250);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNProductServiceModel *model = self.dataSource[indexPath.row];
    TNProductServiceCell *cell = [TNProductServiceCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - lazy load
/** @lazy tableview */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + kRealHeight(10), CGRectGetWidth(self.frame), CGFLOAT_MIN) style:UITableViewStylePlain];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 65;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"tn_service_info", @"服务");
    }
    return _titleLabel;
}
@end
