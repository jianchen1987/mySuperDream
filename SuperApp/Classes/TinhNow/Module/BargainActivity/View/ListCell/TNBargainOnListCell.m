//
//  TNBargainOnListCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainOnListCell.h"
#import "TNBargainDetailViewController.h"
#import "TNBargainRecordCell.h"
#define tableWidth (kScreenWidth - kRealWidth(30)) // table 宽度
#define cellHeight kRealWidth(135)                 // table 宽度


@interface TNBargainOnListCell () <UITableViewDelegate, UITableViewDataSource>
/// 进行中列表
@property (strong, nonatomic) UITableView *tableView;
/// 头部
@property (strong, nonatomic) UIView *tableHeaderView;
/// 头部文字
@property (strong, nonatomic) UILabel *headerLabel;
/// 尾部
@property (strong, nonatomic) UIView *tableFooterView;
/// 尾部点击按钮
@property (strong, nonatomic) HDUIButton *upDownBtn;

@end


@implementation TNBargainOnListCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.tableView];
}
- (void)setIsShowExtend:(BOOL)isShowExtend {
    _isShowExtend = isShowExtend;
}
- (void)setIsExtend:(BOOL)isExtend {
    _isExtend = isExtend;
    if (self.isExtend) {
        self.upDownBtn.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.upDownBtn.transform = CGAffineTransformIdentity;
    }
}
- (void)setDataArr:(NSArray<TNBargainRecordModel *> *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 0) {
        self.tableView.tableHeaderView = self.tableHeaderView;
        self.tableView.tableFooterView = self.tableFooterView;
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
    }
    if (self.isShowExtend) {
        self.upDownBtn.hidden = false;
    } else {
        self.upDownBtn.hidden = true;
    }
    [self setNeedsUpdateConstraints];
    [self.tableView reloadData];
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNBargainRecordCell *cell = [TNBargainRecordCell cellWithTableView:tableView];
    TNBargainRecordModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    if (indexPath.row == self.dataArr.count - 1) {
        cell.hiddeBottomLine = YES;
    } else {
        cell.hiddeBottomLine = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNBargainRecordModel *model = self.dataArr[indexPath.row];
    TNBargainDetailViewController *detailVC = [[TNBargainDetailViewController alloc] initWithRouteParameters:@{@"taskId": model.taskId}];
    [SAWindowManager navigateToViewController:detailVC];
    if (model.status == TNBargainGoodStatusOngoing) {
        !self.continueBargainClickTrackEventCallBack ?: self.continueBargainClickTrackEventCallBack();
    }
}
#pragma mark - method
- (UIImageView *)getLineView {
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_line_white"]];
    lineView.size = lineView.image.size;
    return lineView;
}
- (void)upDownClick:(HDUIButton *)btn {
    self.isExtend = !self.isExtend;
    if (self.extendClickCallBack) {
        self.extendClickCallBack(self.isExtend);
    }
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = cellHeight;
        _tableView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:16];
        };
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}
- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, tableWidth + 10, kRealWidth(40));
        [_tableHeaderView setGradualChangingColorFromColor:HDAppTheme.TinhNowColor.R4 toColor:HDAppTheme.TinhNowColor.R3];
        // 文本
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.font = HDAppTheme.TinhNowFont.standard17;
        _headerLabel.text = TNLocalizedString(@"tn_bargain_task_ongoing", @"正在进行中");
        [_tableHeaderView addSubview:_headerLabel];

        UIImageView *leftLineView = [self getLineView];
        UIImageView *rightLineView = [self getLineView];
        [_tableHeaderView addSubview:leftLineView];
        [_tableHeaderView addSubview:rightLineView];

        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_tableHeaderView);
        }];
        [leftLineView sizeToFit];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerLabel.mas_centerY);
            make.right.equalTo(_headerLabel.mas_left).offset(-kRealWidth(14));
        }];
        [rightLineView sizeToFit];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerLabel.mas_centerY);
            make.left.equalTo(_headerLabel.mas_right).offset(kRealWidth(14));
        }];
    }
    return _tableHeaderView;
}
- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] init];
        _tableFooterView.frame = CGRectMake(0, 0, tableWidth + 10, kRealWidth(40));
        [_tableFooterView setGradualChangingColorFromColor:HDAppTheme.TinhNowColor.R4 toColor:HDAppTheme.TinhNowColor.R3];
        //按钮
        _upDownBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_upDownBtn setImage:[UIImage imageNamed:@"tinhnow_down_k"] forState:UIControlStateNormal];
        [_tableFooterView addSubview:_upDownBtn];
        [_upDownBtn addTarget:self action:@selector(upDownClick:) forControlEvents:UIControlEventTouchUpInside];

        UIImageView *leftLineView = [self getLineView];
        UIImageView *rightLineView = [self getLineView];
        [_tableFooterView addSubview:leftLineView];
        [_tableFooterView addSubview:rightLineView];

        [_upDownBtn sizeToFit];
        [_upDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_tableFooterView);
        }];
        [leftLineView sizeToFit];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_upDownBtn.mas_centerY);
            make.right.equalTo(_upDownBtn.mas_left).offset(-kRealWidth(14));
        }];
        [rightLineView sizeToFit];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_upDownBtn.mas_centerY);
            make.left.equalTo(_upDownBtn.mas_right).offset(kRealWidth(14));
        }];
    }
    return _tableFooterView;
}
@end


@implementation TNBargainOnListCellModel
- (CGFloat)tableHeight {
    CGFloat headerAndFooterHeight = 0;
    if (self.list.count > 0) {
        headerAndFooterHeight = kRealWidth(110);
    }
    CGFloat height = cellHeight * self.list.count + headerAndFooterHeight;
    return height;
}
@end
