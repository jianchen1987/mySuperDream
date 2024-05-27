//
//  TNBargainRecordAndStrtegyCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRecordAndStrtegyCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SATableView.h"
#import "TNBargainDTO.h"
#import "TNBargainFriendRecordCell.h"
#import "TNBargainStrategyCell.h"
#import "TNNoDataCell.h"
#import "TNAdaptImageModel.h"


@interface TNBargainRecordAndStrtegyCell () <UITableViewDelegate, UITableViewDataSource>
/// 背景视图
@property (strong, nonatomic) UIView *bgView;
/// 头部背景视图
@property (strong, nonatomic) UIView *headerView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 助力记录按钮
@property (strong, nonatomic) UIButton *recordBtn;
/// 助力角标
@property (strong, nonatomic) UIImageView *recordMarkImageView;
/// 邀人攻略按钮
@property (strong, nonatomic) UIButton *strategyBtn;
/// 邀人攻略角标
@property (strong, nonatomic) UIImageView *strategyMarkImageView;
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// 数据源
@property (strong, nonatomic) NSArray *dataArr;
/// 无数据视图
@property (strong, nonatomic) TNNoDataCellModel *noDataModel;
/// 高度
@property (nonatomic, assign) CGFloat tableHeight;
/// DTO
@property (strong, nonatomic) TNBargainDTO *bargainDTO;
@end


@implementation TNBargainRecordAndStrtegyCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.tableView];
    [self.headerView addSubview:self.recordBtn];
    [self.headerView addSubview:self.lineView];
    [self.headerView addSubview:self.strategyBtn];
    [self.recordBtn addSubview:self.recordMarkImageView];
    [self.strategyBtn addSubview:self.strategyMarkImageView];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_centerX);
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(kRealWidth(16));
    }];
    [self.recordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerView);
        make.right.equalTo(self.lineView.mas_left).offset(-1);
        make.width.equalTo(self.strategyBtn.mas_width);
    }];
    [self.strategyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.headerView);
        make.left.equalTo(self.lineView.mas_right).offset(1);
        ;
        //        make.width.equalTo(self.strategyBtn.mas_width);
    }];
    [self.recordMarkImageView sizeToFit];
    [self.recordMarkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordBtn.mas_centerX);
        make.bottom.equalTo(self.recordBtn).offset(kRealWidth(9));
    }];
    [self.strategyMarkImageView sizeToFit];
    [self.strategyMarkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.strategyBtn.mas_centerX);
        make.bottom.equalTo(self.strategyBtn).offset(kRealWidth(9));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(self.tableHeight);
    }];
    [super updateConstraints];
}
- (void)setModel:(TNBargainRecordAndStrtegyCellModel *)model {
    _model = model;
    [self prepareDataArr];
}
- (void)prepareDataArr {
    if (self.model.isShowStrategy) {
        self.recordBtn.selected = false;
        self.strategyBtn.selected = true;
        self.recordMarkImageView.hidden = true;
        self.strategyMarkImageView.hidden = false;
        self.strategyBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        self.recordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (self.model.strategyList.count > 0) {
            self.dataArr = [NSArray arrayWithArray:self.model.strategyList];
            if (HDIsArrayEmpty(self.model.strategyImagesHeightArr)) {
                //计算默认的高度数据
                CGFloat defaultHeight = kScreenWidth - kRealWidth(60);
                for (int i = 0; i < self.model.strategyList.count; i++) {
                    [self.model.strategyImagesHeightArr addObject:@(defaultHeight)];
                }
            }
            CGFloat totolHeight = 0;
            for (NSNumber *height in self.model.strategyImagesHeightArr) {
                totolHeight += height.floatValue;
            }
            self.model.strategyTableHeight = totolHeight + kRealWidth(30);
        } else {
            self.noDataModel.noDataText = TNLocalizedString(@"tn_bargain_no_strategy_teaching", @"暂无攻略教学流程图");
            self.dataArr = @[self.noDataModel];
            self.model.strategyTableHeight = kRealWidth(250);
        }
        self.tableHeight = self.model.strategyTableHeight;
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } else {
        self.recordBtn.selected = true;
        self.strategyBtn.selected = false;
        self.recordMarkImageView.hidden = false;
        self.strategyMarkImageView.hidden = true;
        self.recordBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        self.strategyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.tableHeight = self.model.recordTableHeight;
        if (self.model.recordList.count > 0) {
            self.dataArr = [NSArray arrayWithArray:self.model.recordList];
            if (self.model.currentPage == 1) {
                [self.tableView successGetNewDataWithNoMoreData:!self.model.hasNextPage];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:!self.model.hasNextPage];
            }
        } else {
            self.noDataModel.noDataText = TNLocalizedString(@"tn_bargain_no_record_k", @"暂无邀请助力记录");
            self.noDataModel.imageName = @"tinhnow_Bargain_no_data";
            self.dataArr = @[self.noDataModel];
            [self.tableView successGetNewDataWithNoMoreData:YES];
        }
    }
    [self setNeedsUpdateConstraints];
}
#pragma mark - 获取更多助力记录数据
- (void)loadMoreRecordData {
    self.model.currentPage += 1;
    @HDWeakify(self);
    [self.bargainDTO queryHelpPeopleRecordByTaskId:self.model.taskId page:self.model.currentPage size:10 success:^(TNBargainPeopleRecordRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.model.hasNextPage = self.model.currentPage < rspModel.pages;
        [self.model.recordList addObjectsFromArray:rspModel.items];
        [self prepareDataArr];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.tableView failLoadMoreData];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.isShowStrategy) {
        return 1;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id tModel = self.dataArr[indexPath.row];
    if ([tModel isKindOfClass:[TNAdaptImageModel class]]) {
        TNBargainStrategyCell *cell = [TNBargainStrategyCell cellWithTableView:tableView];
        cell.rulePics = self.dataArr;
        @HDWeakify(self);
        cell.getRealImageSizeCallBack = ^(NSInteger index, CGFloat imageHeight) {
            @HDStrongify(self);
            if (!HDIsArrayEmpty(self.model.strategyImagesHeightArr) && index < self.model.strategyImagesHeightArr.count) {
                [self.model.strategyImagesHeightArr replaceObjectAtIndex:index withObject:@(imageHeight)];
            }
            //            重新刷新cell
            if (self.recordAndStrtegyChangeCallBack) {
                self.recordAndStrtegyChangeCallBack();
            }
        };
        return cell;
    } else if ([tModel isKindOfClass:[TNHelpPeolpleRecordeModel class]]) {
        TNBargainFriendRecordCell *cell = [TNBargainFriendRecordCell cellWithTableView:tableView];
        TNHelpPeolpleRecordeModel *pModel = (TNHelpPeolpleRecordeModel *)tModel;
        cell.bargainType = self.model.bargainType;
        cell.model = pModel;
        return cell;
    } else if ([tModel isKindOfClass:[TNNoDataCellModel class]]) {
        TNNoDataCell *cell = [TNNoDataCell cellWithTableView:tableView];
        cell.model = (TNNoDataCellModel *)tModel;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id tModel = self.dataArr[indexPath.row];
    if ([tModel isKindOfClass:[TNNoDataCellModel class]]) {
        return self.tableHeight;
    }
    return UITableViewAutomaticDimension;
}
#pragma mark - method
///助力记录点击
- (void)recordClick {
    if (self.recordBtn.isSelected) {
        return;
    }
    self.model.isShowStrategy = false;
    if (self.recordAndStrtegyChangeCallBack) {
        self.recordAndStrtegyChangeCallBack();
    }
}
///邀人攻略点击
- (void)strategyClick {
    if (self.strategyBtn.isSelected) {
        return;
    }
    self.model.isShowStrategy = true;
    if (self.recordAndStrtegyChangeCallBack) {
        self.recordAndStrtegyChangeCallBack();
    }
}

/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _bgView;
}
/** @lazy headerView */
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFDFBA"];
    }
    return _headerView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor blackColor];
        //        [UIColor hd_colorWithHexString:@"#000000"];
    }
    return _lineView;
}
/** @lazy recordBtn */
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] init];
        [_recordBtn setTitle:TNLocalizedString(@"tn_bargain_record", @"助力记录") forState:UIControlStateNormal];
        [_recordBtn setTitleColor:HDAppTheme.TinhNowColor.R1 forState:UIControlStateSelected];
        [_recordBtn setTitleColor:[UIColor hd_colorWithHexString:@"#454545"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.selected = true;
    }
    return _recordBtn;
}
/** @lazy strategyBtn */
- (UIButton *)strategyBtn {
    if (!_strategyBtn) {
        _strategyBtn = [[UIButton alloc] init];
        [_strategyBtn setTitle:TNLocalizedString(@"tn_bargain_invite_strategy", @"邀人攻略") forState:UIControlStateNormal];
        [_strategyBtn setTitleColor:HDAppTheme.TinhNowColor.R1 forState:UIControlStateSelected];
        [_strategyBtn setTitleColor:[UIColor hd_colorWithHexString:@"#454545"] forState:UIControlStateNormal];
        [_strategyBtn addTarget:self action:@selector(strategyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _strategyBtn;
}
/** @lazy tableView */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
        //        _tableView.scrollEnabled = false;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        @HDWeakify(self);
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadMoreRecordData];
        };
    }
    return _tableView;
}
/** @lazy recordMarkImageView */
- (UIImageView *)recordMarkImageView {
    if (!_recordMarkImageView) {
        _recordMarkImageView = [[UIImageView alloc] init];
        _recordMarkImageView.image = [UIImage imageNamed:@"tinhnow_square_white"];
    }
    return _recordMarkImageView;
}
/** @lazy strategyMarkImageView */
- (UIImageView *)strategyMarkImageView {
    if (!_strategyMarkImageView) {
        _strategyMarkImageView = [[UIImageView alloc] init];
        _strategyMarkImageView.image = [UIImage imageNamed:@"tinhnow_square_white"];
        _strategyMarkImageView.hidden = true;
    }
    return _strategyMarkImageView;
}
/** @lazy noDataModel */
- (TNNoDataCellModel *)noDataModel {
    if (!_noDataModel) {
        TNNoDataCellModel *model = [[TNNoDataCellModel alloc] init];
        model.noDataText = TNLocalizedString(@"tn_bargain_no_strategy_teaching", @"暂无攻略教学流程图");
        model.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        model.textColor = [UIColor hd_colorWithHexString:@"#3B3B3B"];
        _noDataModel = model;
    }
    return _noDataModel;
}
/** @lazy bargainDTO */
- (TNBargainDTO *)bargainDTO {
    if (!_bargainDTO) {
        _bargainDTO = [[TNBargainDTO alloc] init];
    }
    return _bargainDTO;
}
@end


@implementation TNBargainRecordAndStrtegyCellModel
- (CGFloat)recordTableHeight {
    if (HDIsArrayEmpty(self.recordList)) {
        return kRealWidth(250); //没有数据展示无数据占位
    }
    if (self.recordList.count > 10) { //大于10条后  就是上拉获取更多
        return 10 * kRealWidth(60);
    }
    return self.recordList.count * kRealWidth(60);
}
- (NSMutableArray *)strategyImagesHeightArr {
    if (!_strategyImagesHeightArr) {
        _strategyImagesHeightArr = [NSMutableArray array];
    }
    return _strategyImagesHeightArr;
}
- (NSMutableArray<TNHelpPeolpleRecordeModel *> *)recordList {
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}
@end
