//
//  TNRedZoneSaleAreaAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/2/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNRedZoneSaleAreaAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "SATableViewCell.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNRedZoneSaleAreaCell : SATableViewCell
/// 卡片
@property (strong, nonatomic) UIView *cardView;
/// 标题
@property (strong, nonatomic) UILabel *nameLabel;
/// 不在区域
@property (strong, nonatomic) UILabel *notAreaLabel;
/// go 右边图片
@property (strong, nonatomic) UIImageView *rightImageView;
///  查看配送专题按钮
@property (strong, nonatomic) HDUIButton *watchBtn;
///
@property (strong, nonatomic) TNRedZoneAdressForActivityModel *model;
///
@property (nonatomic, assign) BOOL hasSetCardViewRadius;
@end


@implementation TNRedZoneSaleAreaCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.nameLabel];
    [self.cardView addSubview:self.notAreaLabel];
    [self.cardView addSubview:self.rightImageView];
    [self.cardView addSubview:self.watchBtn];
}
- (void)setModel:(TNRedZoneAdressForActivityModel *)model {
    _model = model;
    self.nameLabel.text = model.address;
    if (model.deliveryValid) {
        self.cardView.backgroundColor = HexColor(0xECF1F8);
        self.rightImageView.hidden = NO;
        self.watchBtn.hidden = NO;
        self.notAreaLabel.hidden = YES;
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
    } else {
        self.cardView.backgroundColor = [UIColor whiteColor];
        self.rightImageView.hidden = YES;
        self.watchBtn.hidden = YES;
        self.notAreaLabel.hidden = NO;
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    if (self.model.deliveryValid) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView.mas_left).offset(kRealWidth(10));
            make.right.lessThanOrEqualTo(self.rightImageView.mas_left).offset(-kRealWidth(15));
            make.top.equalTo(self.cardView.mas_top).offset(kRealWidth(10));
        }];
        [self.rightImageView sizeToFit];
        [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cardView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.cardView.mas_top).offset(kRealWidth(10));
        }];
        [self.watchBtn sizeToFit];
        [self.watchBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.cardView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
            make.bottom.equalTo(self.cardView.mas_bottom).offset(-kRealWidth(7));
        }];
        [self.rightImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardView.mas_left).offset(kRealWidth(10));
            make.right.lessThanOrEqualTo(self.cardView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.cardView.mas_top).offset(kRealWidth(10));
        }];
        [self.notAreaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.cardView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(15));
            make.bottom.equalTo(self.cardView.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    [super updateConstraints];
}
/** @lazy cardView */
- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [[UIView alloc] init];
        _cardView.layer.masksToBounds = YES;
        _cardView.layer.cornerRadius = 4;
        _cardView.layer.borderColor = HDAppTheme.TinhNowColor.cD6DBE8.CGColor;
        _cardView.layer.borderWidth = 0.5;
    }
    return _cardView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
/** @lazy notAreaLabel */
- (UILabel *)notAreaLabel {
    if (!_notAreaLabel) {
        _notAreaLabel = [[UILabel alloc] init];
        _notAreaLabel.font = [HDAppTheme.TinhNowFont fontLight:10];
        _notAreaLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _notAreaLabel.text = TNLocalizedString(@"PvDt6VBS", @"不在配送范围");
    }
    return _notAreaLabel;
}
/** @lazy rightImageView */
- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_go_orange_k"]];
    }
    return _rightImageView;
}

/** @lazy watchBtn */
- (HDUIButton *)watchBtn {
    if (!_watchBtn) {
        _watchBtn = [[HDUIButton alloc] init];
        [_watchBtn setTitle:TNLocalizedString(@"83pOtE7w", @"查看配送专题") forState:UIControlStateNormal];
        [_watchBtn setTitleColor:HDAppTheme.TinhNowColor.cFF2323 forState:UIControlStateNormal];
        _watchBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:10];
        _watchBtn.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        _watchBtn.backgroundColor = [UIColor whiteColor];
        _watchBtn.userInteractionEnabled = NO;
        _watchBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:11];
        };
    }
    return _watchBtn;
}
@end


@interface TNRedZoneSaleAreaAlertView () <UITableViewDelegate, UITableViewDataSource>
///
@property (strong, nonatomic) NSArray<TNRedZoneAdressForActivityModel *> *dataArr;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (strong, nonatomic) UITableView *tableView;
/// 新建收货地址
@property (nonatomic, strong) SAOperationButton *addAdressBtn;
/// 配送区域
@property (nonatomic, strong) SAOperationButton *deliverAreBtn;
/// 返回商城
@property (nonatomic, strong) SAOperationButton *backHomeBtn;
///
@property (nonatomic, assign) CGFloat tableHeight;
@end


@implementation TNRedZoneSaleAreaAlertView
- (instancetype)initWithDataArr:(NSArray<TNRedZoneAdressForActivityModel *> *)dataArr {
    if (self = [super init]) {
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.dataArr = dataArr;
    }
    return self;
}
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.centerY.equalTo(self.mas_centerY);
    }];
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:8];
    };
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    self.tableHeight = 0;
    if (self.dataArr.count >= 3) {
        for (int i = 0; i < 2; i++) {
            TNRedZoneAdressForActivityModel *model = self.dataArr[i];
            self.tableHeight += model.cellHeight;
        }
        self.tableHeight += kRealWidth(30);
        self.tableHeight += kRealWidth(50);
    } else if (self.dataArr.count == 2) {
        for (int i = 0; i < 2; i++) {
            TNRedZoneAdressForActivityModel *model = self.dataArr[i];
            self.tableHeight += model.cellHeight;
        }
        self.tableHeight += kRealWidth(30);
    } else if (self.dataArr.count == 1) {
        TNRedZoneAdressForActivityModel *model = self.dataArr.firstObject;
        self.tableHeight += model.cellHeight;
        self.tableHeight += kRealWidth(20);
    }
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.addAdressBtn];
    [self.containerView addSubview:self.deliverAreBtn];
    [self.containerView addSubview:self.backHomeBtn];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(self.tableHeight);
    }];
    [self.addAdressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.tableView.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.deliverAreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.addAdressBtn.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(40));
    }];
    [self.backHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.deliverAreBtn.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(40));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealWidth(15));
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNRedZoneSaleAreaCell *cell = [TNRedZoneSaleAreaCell cellWithTableView:tableView];
    TNRedZoneAdressForActivityModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TNRedZoneAdressForActivityModel *model = self.dataArr[indexPath.row];
    if (model.deliveryValid) {
        [self dismiss];
        !self.clickActivityCallBack ?: self.clickActivityCallBack(model);
    }
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = TNLocalizedString(@"mtu7P3yv", @"收货地址不在销售区域范围");
    }
    return _titleLabel;
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
/** @lazy addAdressBtn */
- (SAOperationButton *)addAdressBtn {
    if (!_addAdressBtn) {
        _addAdressBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_addAdressBtn setTitle:TNLocalizedString(@"wmhDEksP", @"新建收货地址") forState:UIControlStateNormal];
        [_addAdressBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addAdressBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _addAdressBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_addAdressBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        @HDWeakify(self);
        [_addAdressBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.addNewAdressCallBack ?: self.addNewAdressCallBack();
        }];
        _addAdressBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _addAdressBtn;
}
/** @lazy deliverAreBtn */
- (SAOperationButton *)deliverAreBtn {
    if (!_deliverAreBtn) {
        _deliverAreBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_deliverAreBtn setTitle:TNLocalizedString(@"SugnLs2V", @"查看配送区域") forState:UIControlStateNormal];
        [_deliverAreBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _deliverAreBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _deliverAreBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_deliverAreBtn applyPropertiesWithBackgroundColor:HexColor(0xFFB262)];
        @HDWeakify(self);
        [_deliverAreBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.watchDeliverAreaCallBack ?: self.watchDeliverAreaCallBack();
        }];
        _deliverAreBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _deliverAreBtn;
}
/** @lazy backHomeBtn */
- (SAOperationButton *)backHomeBtn {
    if (!_backHomeBtn) {
        _backHomeBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_backHomeBtn setTitle:TNLocalizedString(@"SW1eoWUt", @"返回商城") forState:UIControlStateNormal];
        [_backHomeBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        _backHomeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:14];
        _backHomeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_backHomeBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.G5];
        @HDWeakify(self);
        [_backHomeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.backHomeCallBack ?: self.backHomeCallBack();
        }];
        _backHomeBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _backHomeBtn;
}
@end
