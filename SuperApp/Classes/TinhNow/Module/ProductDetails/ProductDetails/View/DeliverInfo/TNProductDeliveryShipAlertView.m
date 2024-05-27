//
//  TNProductDeliveryShipAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDeliveryShipAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SATableViewCell.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNShipAlertCell : SATableViewCell
/// 左边文案
@property (strong, nonatomic) HDLabel *leftLB;
/// 右边文案
@property (strong, nonatomic) HDLabel *rightLB;
/// 底部线条
@property (strong, nonatomic) UIView *bottomLine;
/// 左边线条
@property (strong, nonatomic) UIView *leftLine;
/// 右边线条
@property (strong, nonatomic) UIView *rightLine;
/// 中间线条
@property (strong, nonatomic) UIView *midLine;
@end


@implementation TNShipAlertCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightLB];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.leftLine];
    [self.contentView addSubview:self.rightLine];
    [self.contentView addSubview:self.midLine];
}
- (void)updateConstraints {
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(PixelOne);
    }];
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10)).priorityHigh();
        make.width.equalTo(self.rightLB.mas_width);
    }];
    [self.midLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.leftLine.mas_bottom);
        make.width.mas_equalTo(PixelOne);
        make.left.equalTo(self.leftLB.mas_right);
    }];
    [self.rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(5));
        make.top.equalTo(self.leftLB.mas_top);
        make.bottom.equalTo(self.leftLB.mas_bottom);
        make.left.equalTo(self.leftLB.mas_right);
    }];

    [self.rightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(PixelOne);
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(PixelOne);
        make.left.equalTo(self.leftLine.mas_right);
        make.right.equalTo(self.rightLine.mas_left);
    }];
    [super updateConstraints];
}
/** @lazy leftLB */
- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[HDLabel alloc] init];
        _leftLB.font = HDAppTheme.TinhNowFont.standard12M;
        _leftLB.textColor = HDAppTheme.TinhNowColor.G1;
        _leftLB.textAlignment = NSTextAlignmentCenter;
        _leftLB.numberOfLines = 0;
    }
    return _leftLB;
}
/** @lazy rightLB */
- (HDLabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[HDLabel alloc] init];
        _rightLB.font = HDAppTheme.TinhNowFont.standard12M;
        _rightLB.textColor = HDAppTheme.TinhNowColor.G1;
        _rightLB.textAlignment = NSTextAlignmentCenter;
        _rightLB.numberOfLines = 0;
    }
    return _rightLB;
}
/** @lazy leftLine */
- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = HexColor(0xCCCCCC);
    }
    return _leftLine;
}
/** @lazy rightLine */
- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = HexColor(0xCCCCCC);
    }
    return _rightLine;
}
/** @lazy bottomLine */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HexColor(0xCCCCCC);
    }
    return _bottomLine;
}
/** @lazy midLine */
- (UIView *)midLine {
    if (!_midLine) {
        _midLine = [[UIView alloc] init];
        _midLine.backgroundColor = HexColor(0xCCCCCC);
    }
    return _midLine;
}
@end
/**
 运费说明弹窗
 */
@interface TNProductDeliveryShipAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 圆角背景
@property (strong, nonatomic) UIView *contentView;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBtn;
/// 标题
@property (strong, nonatomic) HDLabel *titleLabel;
/// 滚动视图
@property (strong, nonatomic) UITableView *tableView;
@end


@implementation TNProductDeliveryShipAlertView
#pragma mark - override
- (instancetype)initWithAnimationStyle:(HDActionAlertViewTransitionStyle)style {
    if (self = [super init]) {
        self.transitionStyle = style;
        self.allowTapBackgroundDismiss = YES;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
    }
    return self;
}
- (void)layoutContainerView {
    self.containerView.frame = [UIScreen mainScreen].bounds;
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tableView];
    [self.containerView addSubview:self.closeBtn];
    @HDWeakify(self);
    [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat tableViewHeight = self.tableView.contentSize.height;
            CGFloat maxHeight = kScreenHeight / 2;
            if (tableViewHeight > maxHeight) {
                tableViewHeight = maxHeight;
            }
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(tableViewHeight);
            }];
        });
    }];
}
/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
        make.centerY.mas_equalTo(self.containerView.mas_centerY).offset(-kRealWidth(30));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(35));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(20));
        make.height.mas_equalTo(50);
    }];
    [self.closeBtn sizeToFit];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.contentView.mas_bottom).offset(kRealWidth(20));
    }];
}
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNShipAlertCell *cell = [TNShipAlertCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.backgroundColor = HexColor(0xFFD4A7);
        cell.leftLine.hidden = cell.rightLine.hidden = cell.midLine.hidden = YES;
        cell.leftLB.text = TNLocalizedString(@"oP6mSV3r", @"可送达区域");
        cell.rightLB.text = TNLocalizedString(@"TOIFMAND", @"每单运费($)");
    } else {
        TNDeliverFreightModel *model = self.dataArr[indexPath.row - 1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.leftLine.hidden = cell.rightLine.hidden = cell.midLine.hidden = NO;
        cell.leftLB.text = model.name;
        cell.rightLB.text = model.firstPriceMoney.centFace;
    }
    return cell;
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 38;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
/** @lazy titleLabel */
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"jZfhTnwG", @"运费说明");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/** @lazy closeBtn */
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"tinhnow_bargain_close"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _closeBtn;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFFFFF"];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _contentView;
}
@end
