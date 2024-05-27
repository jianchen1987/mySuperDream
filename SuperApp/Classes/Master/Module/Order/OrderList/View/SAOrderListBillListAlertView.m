//
//  SAOrderListBillListAlertView.m
//  SuperApp
//
//  Created by Tia on 2023/2/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListBillListAlertView.h"
#import "SAAppTheme.h"
#import "SALabel.h"
#import "SAMultiLanguageManager.h"
#import "SATableHeaderFooterView.h"
#import "SATableView.h"
#import "SATableViewCell.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface SAOrderListBillListTableHeaderFootView : SATableHeaderFooterView
/// 描述
@property (nonatomic, strong) SALabel *descLB;

@end


@implementation SAOrderListBillListTableHeaderFootView

- (void)hd_setupViews {
    [self.contentView addSubview:self.descLB];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(20);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard14M;
        label.textColor = HDAppTheme.color.sa_C333;
        _descLB = label;
    }
    return _descLB;
}

@end


@interface SAOrderListBillListTableCell : SATableViewCell

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *pointView;

@property (nonatomic, strong) SALabel *dateLabel;

@property (nonatomic, strong) SALabel *priceLabel;

@property (nonatomic, strong) UIImageView *arrowView;
/// 是否显示退款数据
@property (nonatomic, assign) BOOL isRefund;

@property (nonatomic, strong) SAOrderBillListItemModel *model;

@end


@implementation SAOrderListBillListTableCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.pointView];
    [self.bottomView addSubview:self.dateLabel];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.arrowView];
}

- (void)updateConstraints {
    CGFloat margin = 12;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(margin * 3);
    }];

    [self.pointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2, 2));
        make.left.mas_equalTo(margin);
        make.centerY.equalTo(self.bottomView);
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.height.mas_equalTo(margin * 1.5);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
        make.left.equalTo(self.pointView.mas_right).offset(4);
    }];

    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.bottomView);
    }];

    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.arrowView.mas_left).offset(-4);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAOrderBillListItemModel *)model {
    _model = model;
    if (self.isRefund) {
        self.priceLabel.text = [NSString stringWithFormat:@"+%@", model.refundAmount.thousandSeparatorAmount];
        _priceLabel.textColor = [UIColor hd_colorWithHexString:@"#2077FC"];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"-%@", model.actualPayAmount.thousandSeparatorAmount];
        _priceLabel.textColor = HDAppTheme.color.sa_C1;
    }
    _dateLabel.text = self.isRefund ? model.finishTimeStr : model.createTimeStr;
}

#pragma mark - lazy load

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = HDAppTheme.color.sa_backgroundColor;
        _bottomView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _bottomView;
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = UIView.new;
        _pointView.backgroundColor = HDAppTheme.color.sa_C999;
        _pointView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:1];
        };
    }
    return _pointView;
}

- (SALabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = SALabel.new;
        _dateLabel.textColor = HDAppTheme.color.sa_C333;
        _dateLabel.font = HDAppTheme.font.sa_standard14;
        _dateLabel.text = @"09/01/2023 09:30";
    }
    return _dateLabel;
}

- (SALabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = SALabel.new;
        _priceLabel.font = HDAppTheme.font.sa_standard14B;
        _priceLabel.textColor = HDAppTheme.color.sa_C1;
    }
    return _priceLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = UIImageView.new;
        _arrowView.image = [UIImage imageNamed:@"icon_oc_arrow"];
    }
    return _arrowView;
}
@end


@interface SAOrderListBillListAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;

@end


@implementation SAOrderListBillListAlertView

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
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.tableView];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.tableView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.titleLabel);
                make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight - 20);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.height.mas_equalTo(self.tableView.contentSize.height);
            }];
        });
    }];
}

- (void)layoutContainerViewSubViews {
    CGFloat margin = 12;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(20);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight - 20);
        make.height.mas_equalTo(100);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (void)setModel:(SAOrderBillListModel *)model {
    _model = model;
    NSString *preStr = [NSString stringWithFormat:@"%@:", SALocalizedString(@"orderDetails_orderNo", @"订单号")];
    NSString *orderStr = [NSString stringWithFormat:@"%@%@", preStr, model.aggregateOrderNo];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orderStr];
    [attributedString addAttribute:NSFontAttributeName value:HDAppTheme.font.sa_standard14 range:[orderStr rangeOfString:model.aggregateOrderNo]];

    self.titleLabel.attributedText = attributedString;
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.payList.count;
    } else {
        return self.model.refundList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAOrderListBillListTableCell *cell = [SAOrderListBillListTableCell cellWithTableView:tableView];
    NSArray *arr = indexPath.section ? self.model.refundList : self.model.payList;
    cell.isRefund = indexPath.section;
    cell.model = arr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SAOrderListBillListTableHeaderFootView *header = [SAOrderListBillListTableHeaderFootView headerWithTableView:tableView];
    header.descLB.text = section ? [NSString stringWithFormat:SALocalizedString(@"oc_refund_completed", @"退款完成 %ld 笔"), self.model.refundList.count] :
                                   [NSString stringWithFormat:SALocalizedString(@"oc_pay_completed", @"支付完成 %ld 笔"), self.model.payList.count];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0 && self.model.payList.count == 0) || (section == 1 && self.model.refundList.count == 0)) {
        return 0;
    }
    return 12 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @HDWeakify(self);
    [self dismissCompletion:^{
        @HDStrongify(self);
        if (self.didSelectedBlock) {
            BOOL isRefund = indexPath.section;
            NSArray *arr = indexPath.section ? self.model.refundList : self.model.payList;
            self.didSelectedBlock(isRefund, arr[indexPath.row]);
        }
    }];
}

#pragma mark - lazy load
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *l = SALabel.new;
        l.textColor = HDAppTheme.color.sa_C333;
        l.font = HDAppTheme.font.sa_standard14SB;
        _titleLabel = l;
    }
    return _titleLabel;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.bounces = NO;
    }
    return _tableView;
}

@end
