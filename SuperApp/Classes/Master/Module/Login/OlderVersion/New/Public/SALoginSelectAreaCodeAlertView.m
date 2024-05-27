//
//  SASlectAreaCodeAlertView.m
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginSelectAreaCodeAlertView.h"
#import "SAAppTheme.h"
#import "SAChangeCountryViewProvider.h"
#import "SAMultiLanguageManager.h"
#import "SAOperationButton.h"
#import "SATableView.h"
#import "SATableViewCell.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface SASlectAreaCodeCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SACountryModel *model;
/// 图片
@property (nonatomic, strong) UIImageView *imgView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 子标题
@property (nonatomic, strong) UILabel *subLabel;
/// 分割线
@property (nonatomic, strong) UIView *line;

@end


@implementation SASlectAreaCodeCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subLabel];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.centerY.equalTo(self.contentView);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(48));
        make.centerY.equalTo(self.contentView);
    }];

    [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.equalTo(self.contentView);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.left.right.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SACountryModel *)model {
    _model = model;
    self.imgView.image = [model.countryCode isEqualToString:@"86"] ? [UIImage imageNamed:@"icon_flag_cn"] : [UIImage imageNamed:@"icon_flag_km"];
    self.titleLabel.text = model.displayText;
    self.subLabel.text = model.fullCountryCode;
}

#pragma mark - lazy load
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.new;
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = HDAppTheme.color.sa_C333;
        _titleLabel.font = HDAppTheme.font.sa_standard16;
    }
    return _titleLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = UILabel.new;
        _subLabel.textColor = HDAppTheme.color.sa_C999;
        _subLabel.font = HDAppTheme.font.sa_standard14;
    }
    return _subLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _line;
}

@end


@interface SALoginSelectAreaCodeAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 国家列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray *dataSource;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 取消按钮
@property (nonatomic, strong) SAOperationButton *cancelBTN;
/// 标题分割线
@property (nonatomic, strong) UIView *line1;
/// 按钮分割线
@property (nonatomic, strong) UIView *line2;

@end


@implementation SALoginSelectAreaCodeAlertView

- (instancetype)init {
    if (self = [super init]) {
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
    [self.containerView addSubview:self.line1];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.cancelBTN];
    [self.containerView addSubview:self.line2];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(15));
        make.centerX.equalTo(self.containerView);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.line1.mas_bottom);
        make.height.mas_equalTo(self.dataSource.count * kRealWidth(55));
    }];

    [self.cancelBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(48));
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(12)));
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    SACountryModel *model = self.dataSource[indexPath.row];
    SASlectAreaCodeCell *cell = [SASlectAreaCodeCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    SACountryModel *model = self.dataSource[indexPath.row];
    !self.selectedItemHandler ?: self.selectedItemHandler(model);
    [self dismiss];
}

#pragma mark - lazy load
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = SALocalizedString(@"login_new_SelectCountryCode", @"选择国家区号");
        label.textColor = HDAppTheme.color.sa_C333;
        label.font = HDAppTheme.font.sa_standard16B;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = kRealWidth(55);
        _tableView.bounces = false;
    }
    return _tableView;
}

- (SAOperationButton *)cancelBTN {
    if (!_cancelBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard16H;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _cancelBTN = button;
    }
    return _cancelBTN;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = UIView.new;
        _line1.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = UIView.new;
        _line2.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _line2;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = SAChangeCountryViewProvider.areaCodedataSource;
    }
    return _dataSource;
}

@end
