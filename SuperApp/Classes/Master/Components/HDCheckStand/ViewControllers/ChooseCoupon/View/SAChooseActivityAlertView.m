//
//  SAChooseActivityAlertView.m
//  SuperApp
//
//  Created by seeu on 2022/5/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChooseActivityAlertView.h"
#import "SAPaymentActivityModel.h"
#import "SAPaymentActivityNoUseTableViewCell.h"
#import "SAPaymentActivityTableViewCell.h"
#import "SATableView.h"


@interface SAChooseActivityAlertView () <UITableViewDelegate, UITableViewDataSource>

///< tableview
@property (nonatomic, strong) SATableView *tableView;
///< dataSource
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
///<
@property (nonatomic, strong) HDTableViewSectionModel *usableSection;
@property (nonatomic, strong) HDTableViewSectionModel *unusableSection;
@property (nonatomic, strong) HDTableViewSectionModel *noUseSection;

@end


@implementation SAChooseActivityAlertView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setData:(NSArray<SAPaymentActivityModel *> *)data {
    _data = data;

    NSArray<SAPaymentActivityModel *> *usable = [data hd_filterWithBlock:^BOOL(SAPaymentActivityModel *_Nonnull item) {
        return item.fulfill == HDPaymentActivityStateAvailable;
    }];

    NSArray<SAPaymentActivityModel *> *unusable = [data hd_filterWithBlock:^BOOL(SAPaymentActivityModel *_Nonnull item) {
        return item.fulfill == HDPaymentActivityStateUnavailable;
    }];

    self.usableSection.list = [NSArray arrayWithArray:usable];
    self.unusableSection.list = [NSArray arrayWithArray:unusable];

    if (usable.count) {
        self.dataSource = @[self.usableSection, self.noUseSection, self.unusableSection];
    } else {
        self.dataSource = @[self.unusableSection, self.noUseSection];
    }

    [self.tableView successGetNewDataWithNoMoreData:YES];

    [self setNeedsUpdateConstraints];
}

- (void)setCurrentActivity:(SAPaymentActivityModel *)currentActivity {
    _currentActivity = currentActivity;
    if (currentActivity) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:[self.usableSection.list indexOfObject:currentActivity] inSection:[self.dataSource indexOfObject:self.usableSection]];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        return;
    }

    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self.dataSource indexOfObject:self.noUseSection]];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAPaymentActivityModel.class]) {
        SAPaymentActivityTableViewCell *cell = [SAPaymentActivityTableViewCell cellWithTableView:tableView];
        SAPaymentActivityModel *trueModel = model;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAPaymentActivityNoUseModel.class]) {
        SAPaymentActivityNoUseTableViewCell *cell = [SAPaymentActivityNoUseTableViewCell cellWithTableView:tableView];
        return cell;
    }

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAPaymentActivityModel.class]) {
        SAPaymentActivityModel *trueModel = model;
        if (trueModel.fulfill == HDPaymentActivityStateUnavailable) {
            return NO;
        }
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAPaymentActivityModel.class]) {
        !self.clickedActivity ?: self.clickedActivity(model);
    } else {
        !self.clickedActivity ?: self.clickedActivity(nil);
    }
}

#pragma mark - HDCustomViewActionViewProtocol
- (void)layoutyImmediately {
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    CGFloat defaultHeight = kScreenHeight * 0.5;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height < defaultHeight ? defaultHeight : self.tableView.contentSize.height);
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.tableView.contentSize.height < defaultHeight ? defaultHeight : self.tableView.contentSize.height);
}

#pragma mark - lazy load
/** @lazy tableview */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
    }
    return _tableView;
}

- (HDTableViewSectionModel *)usableSection {
    if (!_usableSection) {
        _usableSection = HDTableViewSectionModel.new;
    }
    return _usableSection;
}
- (HDTableViewSectionModel *)unusableSection {
    if (!_unusableSection) {
        _unusableSection = HDTableViewSectionModel.new;
    }
    return _unusableSection;
}
- (HDTableViewSectionModel *)noUseSection {
    if (!_noUseSection) {
        _noUseSection = HDTableViewSectionModel.new;
        _noUseSection.list = @[SAPaymentActivityNoUseModel.new];
    }
    return _noUseSection;
}
@end
