//
//  SASearchRankItemCell.m
//  SuperApp
//
//  Created by Tia on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchRankItemCell.h"
#import "LKDataRecord.h"
#import "SASearchRankItemTableViewCell.h"
#import "SAShadowBackgroundView.h"
#import "SATableView.h"


@interface SASearchRankItemTopView : UIView

@end


@implementation SASearchRankItemTopView

- (instancetype)init {
    if (self = [super init]) {
        CAGradientLayer *gl = (CAGradientLayer *)self.layer;
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:0.5].CGColor,
            (__bridge id)[UIColor colorWithRed:252 / 255.0 green:32 / 255.0 blue:64 / 255.0 alpha:1.0].CGColor
        ];
        gl.locations = @[@(0), @(1.0f)];
    }
    return self;
}

+ (Class)layerClass {
    return CAGradientLayer.class;
}

@end


@interface SASearchRankItemCell () <UITableViewDelegate, UITableViewDataSource>

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 头部view
@property (nonatomic, strong) SASearchRankItemTopView *topView;
/// 头部icon
@property (nonatomic, strong) UIImageView *topIconView;
/// 头部标题
@property (nonatomic, strong) UILabel *topLabel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// bottomview
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation SASearchRankItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.topView];
    [self.topView addSubview:self.topIconView];
    [self.topView addSubview:self.topLabel];
    [self.bgView addSubview:self.tableView];
    [self.bgView addSubview:self.bottomView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.top.left.right.equalTo(self.bgView);
    }];

    [self.topIconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.mas_equalTo(8);
        make.centerY.equalTo(self.topView);
    }];

    [self.topLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topIconView.mas_right).offset(4);
        make.centerY.equalTo(self.topView);
        make.right.mas_equalTo(-8);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.topView);
        //        make.height.mas_equalTo(52 * 8);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(12);
    }];

    [super updateConstraints];
}

- (void)setModel:(SASearchThematicModel *)model {
    _model = model;

    self.topLabel.text = model.thematicName;
    [self.topIconView sd_setImageWithURL:[NSURL URLWithString:model.thematicIcon] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(16, 16)]];
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.thematicContentList.count >= 8 ? 8 : MIN(self.model.thematicContentList.count, 8);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASearchRankItemTableViewCell *cell = [SASearchRankItemTableViewCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.model = self.model.thematicContentList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLog(@"%@", indexPath);
    SASearchThematicListModel *model = self.model.thematicContentList[indexPath.row];
    if (HDIsStringNotEmpty(model.url)) {
        [SAWindowManager openUrl:model.url withParameters:nil];

        [LKDataRecord.shared traceEvent:@"AggregateSearchKeyWordStat" name:@"首页专题搜索" parameters:@{
            @"content": model.content,
            @"thematicName": self.model.thematicName,
        }];
    }
}

#pragma mark - lazy
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = UIView.new;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
        _bgView = view;
    }
    return _bgView;
}

- (SASearchRankItemTopView *)topView {
    if (!_topView) {
        _topView = SASearchRankItemTopView.new;
    }
    return _topView;
}

- (UIImageView *)topIconView {
    if (!_topIconView) {
        _topIconView = UIImageView.new;
        _topIconView.layer.cornerRadius = 4;
        _topIconView.layer.masksToBounds = true;
        //        _topIconView.image = [UIImage imageNamed:@"search_rank_icon"];
    }
    return _topIconView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = UILabel.new;
        _topLabel.font = HDAppTheme.font.sa_standard14B;
        _topLabel.textColor = UIColor.whiteColor;
        //        _topLabel.text = @"Everyone is searchin";
    }
    return _topLabel;
}

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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

@end
