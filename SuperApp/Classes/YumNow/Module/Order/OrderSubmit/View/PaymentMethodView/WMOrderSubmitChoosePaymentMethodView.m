//
//  WMOrderSubmitChoosePaymentMethodView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitChoosePaymentMethodView.h"
#import "HDCheckstandDTO.h"
#import "HDQueryAnnoncementRspModel.h"
#import "SATableView.h"
#import "WMOrderSubmitPaymentMethodCell.h"
#import <HDUIKit/HDAnnouncementView.h>


@interface WMOrderSubmitChoosePaymentMethodView () <UITableViewDelegate, UITableViewDataSource>
/// 语言列表
@property (nonatomic, strong) SATableView *tableView;
@property (nonatomic, strong) HDAnnouncementView *announcementView; ///< 支付公告
@property (nonatomic, strong) HDCheckstandDTO *paymentDTO;          ///< dto
/// 数据源
@property (nonatomic, copy) NSArray<WMOrderSubmitPaymentMethodCellModel *> *dataSource;
@end


@implementation WMOrderSubmitChoosePaymentMethodView

- (void)hd_setupViews {
    [self addSubview:self.announcementView];
    [self addSubview:self.tableView];

    [self getAnnouncement];
}

- (void)updateConstraints {
    if (!self.announcementView.isHidden) {
        [self.announcementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(kRealHeight(42));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        if (!self.announcementView.isHidden) {
            make.top.equalTo(self.announcementView.mas_bottom);
        } else {
            make.top.equalTo(self);
        }
    }];

    [super updateConstraints];
}

#pragma mark - data
- (void)getAnnouncement {
    @HDWeakify(self);
    [self.paymentDTO queryPaymentAnnouncementSuccess:^(HDQueryAnnoncementRspModel *_Nullable announcement) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(announcement.content)) {
            HDAnnouncementViewConfig *config = HDAnnouncementViewConfig.new;
            config.text = announcement.content;
            config.backgroundColor = [UIColor hd_colorWithHexString:@"#FFEC9B"];
            config.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
            config.textColor = [UIColor hd_colorWithHexString:@"#73000000"];
            self.announcementView.config = config;
            self.announcementView.hidden = NO;
            [self setNeedsUpdateConstraints];
        }
    } failure:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    WMOrderSubmitPaymentMethodCellModel *model = self.dataSource[indexPath.row];
    model.needTopLine = indexPath.row == 0;
    model.needBottomLine = indexPath.row != self.dataSource.count - 1;
    WMOrderSubmitPaymentMethodCell *cell = [WMOrderSubmitPaymentMethodCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(SATableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

    WMOrderSubmitPaymentMethodCellModel *model = self.dataSource[indexPath.row];
    !self.selectedItemHandler ?: self.selectedItemHandler(model);
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self selectDefaultIndexPath];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height + 45);
    self.tableView.frame = self.bounds;
}

#pragma mark - public methods
- (void)configureDataSource:(NSArray<WMOrderSubmitPaymentMethodCellModel *> *)dataSource {
    self.dataSource = dataSource;
}

#pragma mark - private methods
- (void)selectDefaultIndexPath {
    for (WMOrderSubmitPaymentMethodCellModel *model in self.dataSource) {
        if ([model.paymentType isEqualToString:self.currentPaymentType]) {
            // 默认选中
            NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:model] inSection:0];
            [self.tableView selectRowAtIndexPath:defaultIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MAX) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.bounces = false;
    }
    return _tableView;
}

- (HDAnnouncementView *)announcementView {
    if (!_announcementView) {
        _announcementView = [[HDAnnouncementView alloc] init];
        _announcementView.hidden = YES;
    }
    return _announcementView;
}

- (HDCheckstandDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = HDCheckstandDTO.new;
    }
    return _paymentDTO;
}

@end
