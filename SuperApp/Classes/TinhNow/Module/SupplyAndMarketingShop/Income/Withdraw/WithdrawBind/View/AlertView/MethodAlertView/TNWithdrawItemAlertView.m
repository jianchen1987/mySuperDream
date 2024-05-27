//
//  TNWithdrawItemAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawItemAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SATableView.h"
#import "SATableViewCell.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore.h>
#import <Masonry.h>


@interface TNWithdrawItemCell : SATableViewCell
@property (strong, nonatomic) UIImageView *leftImageView; ///< 左边图片
@property (strong, nonatomic) UILabel *titleLabel;        ///< 文本
@property (strong, nonatomic) HDUIButton *selectedButton; ///< 选择
@property (strong, nonatomic) UIView *lineView;           ///< 分割线
@property (strong, nonatomic) TNWithdrawItemModel *model; ///<
@end


@implementation TNWithdrawItemCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectedButton];
    [self.contentView addSubview:self.lineView];
}
- (void)setModel:(TNWithdrawItemModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    if (HDIsStringNotEmpty(model.localImageName)) {
        self.leftImageView.hidden = NO;
        self.leftImageView.image = [UIImage imageNamed:model.localImageName];
    } else {
        self.leftImageView.hidden = YES;
    }
    self.selectedButton.selected = model.isSelected;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (!self.leftImageView.isHidden) {
        [self.leftImageView sizeToFit];
        [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        }];
    }
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        if (self.leftImageView.isHidden) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        } else {
            make.left.equalTo(self.leftImageView.mas_right).offset(kRealWidth(10));
        }
        make.right.lessThanOrEqualTo(self.selectedButton.mas_left).offset(-kRealWidth(15));
    }];
    [self.selectedButton sizeToFit];
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}
/** @lazy leftImageView */
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
/** @lazy selectedButton */
- (HDUIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [[HDUIButton alloc] init];
        [_selectedButton setImage:[UIImage imageNamed:@"tn_gray_unselect"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"tn_gray_select"] forState:UIControlStateSelected];
        _selectedButton.userInteractionEnabled = NO;
    }
    return _selectedButton;
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


@interface TNWithdrawItemAlertView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) HDLabel *titleLabel;          /// 标题
@property (nonatomic, strong) HDUIButton *closeBTN;         /// 关闭按钮
@property (strong, nonatomic) SATableView *tableView;       ///<
@property (strong, nonatomic) HDUIButton *confirBtn;        ///<
@property (strong, nonatomic) TNWithdrawItemConfig *config; ///<
@end


@implementation TNWithdrawItemAlertView
- (instancetype)initAlertViewWithConfig:(TNWithdrawItemConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
//验证确认按钮是否可以点击
- (void)checkConfirmBtnEnable {
    BOOL enable = NO;
    for (TNWithdrawItemModel *model in self.config.dataArr) {
        if (model.isSelected == YES) {
            enable = YES;
            break;
        }
    }
    self.confirBtn.enabled = enable;
    if (enable) {
        self.confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
    } else {
        self.confirBtn.backgroundColor = HexColor(0xD6DBE8);
    }
}
- (TNWithdrawItemModel *)getCurrentSelectedModel {
    for (TNWithdrawItemModel *model in self.config.dataArr) {
        if (model.isSelected == YES) {
            return model;
        }
    }
    return nil;
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
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.confirBtn];
    [self checkConfirmBtnEnable];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(kRealWidth(45));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(11));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.confirBtn.mas_top).offset(-kRealWidth(8));
        if (self.config.type == TNWithdrawItemAlertTypeMethed) {
            make.height.mas_equalTo(kRealWidth(80 * 2));
        } else {
            make.height.mas_equalTo(kRealWidth(50 * 8));
        }
    }];
    [self.confirBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(8) - kiPhoneXSeriesSafeBottomHeight);
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(35));
    }];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.config.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNWithdrawItemCell *cell = [TNWithdrawItemCell cellWithTableView:tableView];
    cell.model = self.config.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TNWithdrawItemModel *model = self.config.dataArr[indexPath.row];
    [self.config.dataArr enumerateObjectsUsingBlock:^(TNWithdrawItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.isSelected = NO;
    }];
    model.isSelected = YES;
    [self checkConfirmBtnEnable];
    [tableView reloadData];
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = self.config.title;
    }
    return _titleLabel;
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
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        if (self.config.type == TNWithdrawItemAlertTypeMethed) {
            _tableView.rowHeight = 80;
        } else {
            _tableView.rowHeight = 50;
        }
    }
    return _tableView;
}
/** @lazy confirBtn */
- (HDUIButton *)confirBtn {
    if (!_confirBtn) {
        _confirBtn = [[HDUIButton alloc] init];
        _confirBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _confirBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_confirBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        [_confirBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:20];
        };
        @HDWeakify(self);
        [_confirBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            TNWithdrawItemModel *model = [self getCurrentSelectedModel];
            !self.confirmClickCallBack ?: self.confirmClickCallBack(model);
            [self dismiss];
        }];
    }
    return _confirBtn;
}
@end
