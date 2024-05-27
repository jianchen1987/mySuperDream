//
//  WMOrderDetailCancelReasonView.m
//  SuperApp
//
//  Created by wmz on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderDetailCancelReasonView.h"
#import "SATableView.h"


@interface WMOrderDetailCancelReasonView () <UITableViewDelegate, UITableViewDataSource>
/// topLabel
@property (nonatomic, strong) HDLabel *topLB;
/// tableview
@property (nonatomic, strong) SATableView *tableView;
/// 提交
@property (nonatomic, strong) HDUIButton *confirmBTN;

@property (nonatomic, assign, getter=isItemSelect) BOOL itemSelect;

@end


@implementation WMOrderDetailCancelReasonView

- (void)hd_setupViews {
    [self addSubview:self.topLB];
    [self addSubview:self.tableView];
    [self addSubview:self.confirmBTN];
}

- (void)updateConstraints {
    [self.topLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLB.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.top.mas_equalTo(kRealWidth(4));
        }
    }];

    CGFloat higeht = MIN(10, self.dataSource.count) * kRealWidth(44);
    self.tableView.scrollEnabled = self.dataSource.count > 10;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(higeht);
        if (self.topLB.isHidden) {
            make.top.mas_equalTo(kRealWidth(4));
        } else {
            make.top.equalTo(self.topLB.mas_bottom).offset(kRealWidth(12));
        }
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
        make.top.equalTo(self.tableView.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setDataSource:(NSArray<WMOrderCancelReasonModel *> *)dataSource {
    _dataSource = dataSource;
    BOOL select = NO;
    for (WMOrderCancelReasonModel *item in dataSource) {
        if (item.isSelect) {
            select = YES;
            break;
        }
    }
    self.itemSelect = select;
    if (!self.fromUnCancelView) {
        self.topLB.hidden = NO;
        self.topLB.text = [NSString stringWithFormat:@"%@\n%@",
                                                     WMLocalizedString(@"wm_cancel_reason_tip1", @"如果您使用优惠券，优惠券退回您的账号"),
                                                     WMLocalizedString(@"wm_cancel_reason_tip2", @"如果您使用优惠券，优惠券退回您的账号")];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = kRealWidth(4);
        self.topLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.topLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    }
    [self.tableView successGetNewDataWithNoMoreData:YES];
    [self.tableView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)layoutyImmediately {
    [self.tableView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.confirmBTN.frame));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMOrderDetailCancelReasonCell *cell = [WMOrderDetailCancelReasonCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource enumerateObjectsUsingBlock:^(WMOrderCancelReasonModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = (idx == indexPath.row);
    }];
    self.itemSelect = YES;
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRealWidth(44);
}

- (void)setItemSelect:(BOOL)itemSelect {
    _itemSelect = itemSelect;
    if (itemSelect) {
        [self.confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        self.confirmBTN.userInteractionEnabled = YES;
    } else {
        [self.confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.confirmBTN.layer.backgroundColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.3].CGColor;
        self.confirmBTN.userInteractionEnabled = NO;
    }
}

- (HDLabel *)topLB {
    if (!_topLB) {
        _topLB = HDLabel.new;
        _topLB.textColor = HDAppTheme.WMColor.B6;
        _topLB.font = [HDAppTheme.WMFont wm_ForSize:12];
        _topLB.numberOfLines = 0;
        _topLB.hidden = YES;
    }
    return _topLB;
}

- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.estimatedRowHeight = kRealWidth(44);
        _tableView.scrollEnabled = NO;
        _tableView.needRefreshHeader = NO;
    }
    return _tableView;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN setTitle:WMLocalizedString(@"wm_cancel_submit", @"提交") forState:UIControlStateNormal];
        _confirmBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _confirmBTN.layer.cornerRadius = kRealWidth(22);
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.clickedConfirmBlock) {
                [self.dataSource enumerateObjectsUsingBlock:^(WMOrderCancelReasonModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (obj.isSelect) {
                        self.clickedConfirmBlock(obj);
                        *stop = YES;
                        return;
                    }
                }];
            }
        }];
    }
    return _confirmBTN;
}

@end


@interface WMOrderDetailCancelReasonCell ()
/// 标题
@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) HDUIButton *confirmBTN;

@end


@implementation WMOrderDetailCancelReasonCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.confirmBTN];
}

- (void)updateConstraints {
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.equalTo(self.confirmBTN.mas_left).offset(-kRealWidth(12));
    }];

    [super updateConstraints];
}

- (void)setModel:(WMOrderCancelReasonModel *)model {
    _model = model;
    self.titleLB.text = model.name;
    [self.confirmBTN setImage:model.isSelect ? [UIImage imageNamed:@"yn_order_select_sel"] : [UIImage imageNamed:@"yn_order_select_nor"] forState:UIControlStateNormal];
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _confirmBTN.userInteractionEnabled = NO;
    }
    return _confirmBTN;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 0;
        _titleLB.textColor = HDAppTheme.WMColor.B3;
        _titleLB.font = [HDAppTheme.WMFont wm_boldForSize:14];
    }
    return _titleLB;
}

@end
