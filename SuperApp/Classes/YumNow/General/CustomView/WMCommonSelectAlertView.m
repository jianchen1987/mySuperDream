//
//  WMCommonSelectAlertView.m
//  SuperApp
//
//  Created by wmz on 2022/11/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCommonSelectAlertView.h"
#import "WMTableView.h"


@interface WMCommonSelectAlertView () <UITableViewDelegate, UITableViewDataSource>
/// tableview
@property (nonatomic, strong) WMTableView *tableView;
/// 提交
@property (nonatomic, strong) HDUIButton *confirmBTN;

@end


@implementation WMCommonSelectAlertView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    [self addSubview:self.confirmBTN];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(44) * MIN(8, self.dataSource.count));
        make.top.mas_equalTo(kRealWidth(4));
    }];

    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
        make.top.equalTo(self.tableView.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setDataSource:(NSArray<WMSelectRspModel *> *)dataSource {
    _dataSource = dataSource;
    for (WMSelectRspModel *rspModel in dataSource) {
        if (rspModel.isSelect) {
            self.selectModel = rspModel;
            break;
            ;
        }
    }
    self.tableView.scrollEnabled = dataSource.count > 8;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)layoutyImmediately {
    [self.tableView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.confirmBTN.frame) + kRealWidth(8));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMSelectRspModel *model = self.dataSource[indexPath.row];
    WMCommonSelectAlertCell *cell = [WMCommonSelectAlertCell cellWithTableView:tableView];
    [cell setGNModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource enumerateObjectsUsingBlock:^(WMSelectRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = (idx == indexPath.row);
    }];
    self.selectModel = self.dataSource[indexPath.row];
    [self.tableView reloadData];
}

- (void)setSelectModel:(WMSelectRspModel *)selectModel {
    _selectModel = selectModel;
    if (selectModel) {
        self.confirmBTN.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        self.confirmBTN.userInteractionEnabled = YES;
    } else {
        self.confirmBTN.layer.backgroundColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.3].CGColor;
        self.confirmBTN.userInteractionEnabled = NO;
    }
}

- (WMTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WMTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = kRealWidth(44);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (HDUIButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN setTitle:WMLocalizedString(@"wm_cancel_submit", @"提交") forState:UIControlStateNormal];
        _confirmBTN.layer.backgroundColor = [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.3].CGColor;
        _confirmBTN.userInteractionEnabled = NO;
        _confirmBTN.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        [_confirmBTN setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBTN.layer.cornerRadius = kRealWidth(22);
        @HDWeakify(self)[_confirmBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.clickedConfirmBlock) {
                [self.dataSource enumerateObjectsUsingBlock:^(WMSelectRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
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


@interface WMCommonSelectAlertCell ()
/// 标题
@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) HDUIButton *confirmBTN;

@end


@implementation WMCommonSelectAlertCell

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

- (void)setGNModel:(WMSelectRspModel *)data {
    self.titleLB.text = WMFillEmpty(data.showName);
    [self.confirmBTN setImage:data.isSelect ? [UIImage imageNamed:@"yn_order_select_sel"] : [UIImage imageNamed:@"yn_order_select_nor"] forState:UIControlStateNormal];
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
