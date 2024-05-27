//
//  TNSingleSelectedAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSingleSelectedAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "SATableViewCell.h"


@interface TNSingleSelectedCell : SATableViewCell
/// 文本
@property (strong, nonatomic) UILabel *titleLabel;
/// 选中按钮
@property (strong, nonatomic) HDUIButton *selectedBtn;
///
@property (strong, nonatomic) UIView *lineView;
///
@property (strong, nonatomic) TNSingleSelectedItem *item;
@end


@implementation TNSingleSelectedCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.lineView];
}
- (void)setItem:(TNSingleSelectedItem *)item {
    _item = item;
    self.titleLabel.text = item.name;
    self.selectedBtn.selected = item.selected;
}
- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(80));
    }];
    [self.selectedBtn sizeToFit];
    [self.selectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
/** @lazy selectedBtn */
- (HDUIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _selectedBtn.userInteractionEnabled = NO;
    }
    return _selectedBtn;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _lineView;
}
@end


@interface TNSingleSelectedAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 确定按钮
@property (strong, nonatomic) SAOperationButton *confirmBtn;
/// 配置项
@property (strong, nonatomic) TNSingleSelectedAlertConfig *config;
/// 选中的模型
@property (strong, nonatomic) TNSingleSelectedItem *selectedItem;
@end


@implementation TNSingleSelectedAlertView
- (instancetype)initWithConfig:(TNSingleSelectedAlertConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
- (void)checkConfirmBtnEnable {
    if (HDIsObjectNil(self.selectedItem)) {
        __block BOOL enable = NO;
        [self.config.dataArr enumerateObjectsUsingBlock:^(TNSingleSelectedItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.selected) {
                enable = YES;
                self.selectedItem = obj;
                *stop = YES;
            }
        }];
        self.confirmBtn.enabled = enable;
    } else {
        self.confirmBtn.enabled = YES;
    }
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
    [self.containerView addSubview:self.confirmBtn];
    self.titleLabel.text = self.config.title;
    [self checkConfirmBtnEnable];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(15));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(50));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(50));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];

    CGFloat height = 0;
    if (self.config.dataArr.count > 7) {
        height += kRealWidth(50) * 7;
    } else {
        height += kRealWidth(50) * self.config.dataArr.count;
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(height);
    }];
    [self.confirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(8));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.config.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNSingleSelectedItem *item = self.config.dataArr[indexPath.row];
    TNSingleSelectedCell *cell = [TNSingleSelectedCell cellWithTableView:tableView];
    cell.item = item;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TNSingleSelectedItem *item = self.config.dataArr[indexPath.row];
    if (item.selected) {
        return;
    }
    [self.config.dataArr enumerateObjectsUsingBlock:^(TNSingleSelectedItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.selected = NO;
    }];
    item.selected = YES;
    self.selectedItem = item;
    [self.tableView reloadData];
    [self checkConfirmBtnEnable];
}
#pragma mark - lazy load
/** @lazy tableview */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + kRealHeight(10), CGRectGetWidth(self.frame), CGFLOAT_MIN) style:UITableViewStylePlain];
        _tableView.rowHeight = kRealWidth(50);
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (SAOperationButton *)confirmBtn {
    if (!_confirmBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        button.disableBackgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
        [button setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:20];
        };
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.selectedItemCallBack ?: self.selectedItemCallBack(self.selectedItem);
            [self dismiss];
        }];
        _confirmBtn = button;
    }
    return _confirmBtn;
}
@end
