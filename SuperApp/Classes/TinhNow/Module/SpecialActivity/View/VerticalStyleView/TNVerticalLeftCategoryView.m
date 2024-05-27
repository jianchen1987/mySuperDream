//
//  TNVerticalLeftCategoryView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNVerticalLeftCategoryView.h"
#import "SATableHeaderFooterView.h"
#import "SATableView.h"
#import "SATableViewCell.h"
#import "TNNotificationConst.h"
#import "TNSpeciaActivityViewModel.h"
#import "TNSpecialActivityGuidePopView.h"
/// 头部
@interface TNVerticalLeftHeaderView : SATableHeaderFooterView
/// 点击回调
@property (nonatomic, copy) void (^itemClickCallBack)(TNCategoryModel *model);
/// 分类按钮
//@property (strong, nonatomic) HDUIButton *categoryBtn;
///
@property (strong, nonatomic) TNCategoryModel *model;
///
@property (strong, nonatomic) UIImageView *arrowImageView;

/// 背景点击视图
@property (strong, nonatomic) UIControl *backControl;
///
@property (strong, nonatomic) UIStackView *stackView;
///
@property (strong, nonatomic) UIImageView *leftImageView;
///
@property (strong, nonatomic) UILabel *nameLabel;
@end


@implementation TNVerticalLeftHeaderView
- (void)hd_setupViews {
    [self.contentView addSubview:self.backControl];
    [self.backControl addSubview:self.leftImageView];
    [self.backControl addSubview:self.nameLabel];
    [self.backControl addSubview:self.arrowImageView];
}
- (void)clickItem {
    !self.itemClickCallBack ?: self.itemClickCallBack(self.model);
}
- (void)setModel:(TNCategoryModel *)model {
    _model = model;
    NSString *name;
    if (HDIsStringNotEmpty(model.menuName.desc)) {
        name = model.menuName.desc;
    } else {
        name = model.name;
    }
    self.nameLabel.text = name;
    if (model.isSelected) {
        if (model.hasSelectedSecondCategory) {
            self.backControl.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
            self.nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
            self.nameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
            self.arrowImageView.hidden = YES;
        } else {
            self.backControl.backgroundColor = [UIColor whiteColor];
            self.nameLabel.textColor = HDAppTheme.TinhNowColor.C1;
            self.nameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
            self.arrowImageView.hidden = HDIsArrayEmpty(model.children) ? YES : NO;
        }
    } else {
        self.backControl.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        self.nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        self.nameLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        self.arrowImageView.hidden = YES;
    }
    if (model.selectLogoImage != nil) {
        self.leftImageView.hidden = NO;
        self.leftImageView.image = model.selectLogoImage;
    } else {
        self.leftImageView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.backControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    if (!self.leftImageView.isHidden) {
        [self.leftImageView sizeToFit];
        [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.backControl);
        }];
    }
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(8));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(8));
    }];
    if (self.arrowImageView.isHidden) {
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nameLabel.mas_centerX);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        }];
    }

    [super updateConstraints];
}

/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}
/** @lazy backControl */
- (UIControl *)backControl {
    if (!_backControl) {
        _backControl = [[UIControl alloc] init];
        _backControl.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        [_backControl addTarget:self action:@selector(clickItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backControl;
}
/** @lazy leftImageView */
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard12;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
@end

/// cell
@interface TNVerticalLeftCell : SATableViewCell
///
@property (strong, nonatomic) UIImageView *leftImageView;
///
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIView *bottomLineView;
///
@property (strong, nonatomic) TNCategoryModel *model;
@end


@implementation TNVerticalLeftCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
}
- (void)setModel:(TNCategoryModel *)model {
    _model = model;
    NSString *name;
    if (HDIsStringNotEmpty(model.menuName.desc)) {
        name = model.menuName.desc;
    } else {
        name = model.name;
    }
    self.nameLabel.text = name;
    self.leftImageView.hidden = !model.isSelected;
    self.nameLabel.textColor = model.isSelected ? HDAppTheme.TinhNowColor.C1 : HDAppTheme.TinhNowColor.c5d667f;
    self.contentView.backgroundColor = model.isSelected ? [UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:26 / 255.0 alpha:0.05] : [UIColor whiteColor];
}
- (void)updateConstraints {
    [self.leftImageView sizeToFit];
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView);
    }];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.height.mas_equalTo(0.5);
    }];
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.height.mas_equalTo(0.5);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.leading.trailing.equalTo(self.topLineView);
    }];
    [super updateConstraints];
}
///** @lazy leftImageView */
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_card_rectangle"]];
    }
    return _leftImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _nameLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
/** @lazy topLineView */
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _topLineView;
}
/** @lazy bottomLineView */
- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _bottomLineView;
}
@end


@interface TNVerticalLeftCategoryView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TNSpeciaActivityViewModel *viewModel;
///
@property (strong, nonatomic) SATableView *tableView;
/// 样式切换
@property (strong, nonatomic) UIControl *changeStyleControl;
///
@property (strong, nonatomic) UIImageView *changeStyleImageView;
///
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 当前一级分类
@property (nonatomic, assign) NSInteger currentIndex;
/// 暂存选中的二级分类数据
@property (strong, nonatomic) NSArray<TNCategoryModel *> *currentSecondCategoryList;
@end


@implementation TNVerticalLeftCategoryView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"adsAndCategoryRefrehFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self prepareCategoryData];
        [self showNewFutureGuide];
    }];
}
#pragma mark -处理一级分类数据
- (void)prepareCategoryData {
    [self.dataSource removeAllObjects];
    if (self.viewModel.categoryArr.count == 1) {
        //只有推荐分类数据
        HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];
        section.commonHeaderModel = self.viewModel.categoryArr.firstObject;
        [self.dataSource addObject:section];
    } else {
        //创建分类数据
        for (TNCategoryModel *model in self.viewModel.categoryArr) {
            HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];
            section.commonHeaderModel = model;
            [self.dataSource addObject:section];
        }

        //有广告数据  放到最前面
        if (!HDIsObjectNil(self.viewModel.activityCardRspModel) && !HDIsArrayEmpty(self.viewModel.activityCardRspModel.list)) {
            TNCategoryModel *model = [[TNCategoryModel alloc] init];
            model.name = TNLocalizedString(@"5qCmA9vN", @"主题会场");
            model.selectLogoImage = [UIImage imageNamed:@"tn_special_theme_k"];
            model.menuId = kCategotyThemeVenueItemName;
            HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];
            section.commonHeaderModel = model;
            [self.dataSource insertObject:section atIndex:0];
        }
    }

    //默认选中第一个
    if (!HDIsArrayEmpty(self.dataSource)) {
        HDTableViewSectionModel *section = self.dataSource.firstObject;
        TNCategoryModel *model = section.commonHeaderModel;
        model.isSelected = YES;
        self.currentIndex = 0;
    }
    [self.tableView successGetNewDataWithNoMoreData:YES];
}
#pragma mark -处理二级级分类数据
- (void)processSecondCategoryDataBySection:(NSInteger)section {
    if (section >= self.dataSource.count) {
        return;
    }
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    TNCategoryModel *currentFirstCategoryModel = sectionModel.commonHeaderModel;
    if (currentFirstCategoryModel.isSelected) { //已选择的情况
        // 如果没有二级分类 不处理
        if (HDIsArrayEmpty(currentFirstCategoryModel.children)) {
            return;
        }
        //如果已经有选中的二级目录 直接重新刷新回一级目录
        if (currentFirstCategoryModel.hasSelectedSecondCategory) {
            [sectionModel.list enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isSelected = NO;
            }];
            !self.categoryClickCallBack ?: self.categoryClickCallBack(currentFirstCategoryModel.menuId, self.currentIndex, YES);
            [UIView performWithoutAnimation:^{
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }];
        } else {
            if (!HDIsArrayEmpty(sectionModel.list)) {
                sectionModel.list = @[];
                [UIView performWithoutAnimation:^{
                    [self.tableView successLoadMoreDataWithNoMoreData:YES];
                }];

            } else {
                sectionModel.list = self.currentSecondCategoryList;
                [UIView performWithoutAnimation:^{
                    [self.tableView successLoadMoreDataWithNoMoreData:YES];
                }];
            }
        }
        return;
    }
    currentFirstCategoryModel.isSelected = !currentFirstCategoryModel.isSelected;
    if (!HDIsArrayEmpty(currentFirstCategoryModel.children)) {
        sectionModel.list = [NSArray arrayWithArray:currentFirstCategoryModel.children];
    }
    self.currentSecondCategoryList = currentFirstCategoryModel.children; //存储当前选中的二级分类数据
    for (HDTableViewSectionModel *tempSecitonModel in self.dataSource) {
        TNCategoryModel *tempModel = tempSecitonModel.commonHeaderModel;
        if (tempModel != currentFirstCategoryModel) {
            tempModel.isSelected = NO;
            tempSecitonModel.list = @[];
        }
    }
    self.currentIndex = section;
    !self.categoryClickCallBack ?: self.categoryClickCallBack(currentFirstCategoryModel.menuId, self.currentIndex, NO);
    [UIView performWithoutAnimation:^{
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
    }];
}
- (void)hd_setupViews {
    [self addSubview:self.changeStyleControl];
    [self.changeStyleControl addSubview:self.changeStyleImageView];
    [self addSubview:self.tableView];
    [self prepareCategoryData];
}
#pragma mark -新手指导
- (void)showNewFutureGuide {
    BOOL hasShowed = [[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsKeySpecialNewFutureShowed];
    if (!hasShowed) {
        TNSpecialActivityGuidePopView *popView = [[TNSpecialActivityGuidePopView alloc] initWithSpecialType:TNSpecialStyleTypeVertical];
        [popView showFromSourceView:self.changeStyleControl];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSUserDefaultsKeySpecialNewFutureShowed];
    }
}
#pragma mark -点击了样式更换
- (void)clickChangeStyle {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTNNotificationNameChangedSpecialStyle object:nil userInfo:@{@"type": @(TNSpecialStyleTypeHorizontal)}];
    [SATalkingData trackEvent:[self.viewModel.speciaTrackPrefixName stringByAppendingString:@"商品专题_点击导航样式切换按钮"]];
}

#pragma mark 是否可以滚动
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        [self scrollerToTop];
    }
}
#pragma mark 设置偏移量到顶部
- (void)scrollerToTop {
    [self.tableView setContentOffset:CGPointZero];
}
#pragma mark - CollectionDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        if (scrollView.contentOffset.y <= 0) {
            self.canScroll = NO;
            [self scrollerToTop];
            if (self.scrollerViewScrollerToTopCallBack) {
                self.scrollerViewScrollerToTopCallBack();
            }
        }
    } else {
        self.canScroll = NO;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNVerticalLeftHeaderView *headerView = [TNVerticalLeftHeaderView headerWithTableView:tableView identifier:[NSString stringWithFormat:@"TNVerticalLeftHeaderView + %ld", section]];
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    headerView.model = sectionModel.commonHeaderModel;
    @HDWeakify(self);
    headerView.itemClickCallBack = ^(TNCategoryModel *model) {
        @HDStrongify(self);
        [self processSecondCategoryDataBySection:section];
    };
    if (HDIsArrayEmpty(sectionModel.list)) {
        headerView.arrowImageView.image = [UIImage imageNamed:@"tn_category_select_down"];
    } else {
        headerView.arrowImageView.image = [UIImage imageNamed:@"tn_category_select_up"];
    }
    return headerView;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return kRealWidth(75);
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNVerticalLeftCell *cell = [TNVerticalLeftCell cellWithTableView:tableView];
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    TNCategoryModel *model = sectionModel.list[indexPath.row];
    cell.model = model;
    if (indexPath.row == 0 && sectionModel.list.count == 1) {
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = NO;
    } else if (indexPath.row == 0 && sectionModel.list.count > 1) {
        cell.topLineView.hidden = NO;
        cell.bottomLineView.hidden = YES;
    } else if (indexPath.row == sectionModel.list.count - 1) {
        cell.topLineView.hidden = YES;
        cell.bottomLineView.hidden = NO;
    } else {
        cell.topLineView.hidden = YES;
        cell.bottomLineView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    TNCategoryModel *model = sectionModel.list[indexPath.row];
    if (model.isSelected) {
        return;
    }
    for (TNCategoryModel *tempModel in sectionModel.list) {
        tempModel.isSelected = NO;
    }
    model.isSelected = !model.isSelected;

    !self.categoryClickCallBack ?: self.categoryClickCallBack(model.menuId, self.currentIndex, YES);
    [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
}
- (void)updateConstraints {
    [self.changeStyleControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kRealWidth(60));
    }];
    [self.changeStyleImageView sizeToFit];
    [self.changeStyleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.changeStyleControl);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.changeStyleControl.mas_bottom);
    }];
    [super updateConstraints];
}

/** @lazy tableviw */
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.needShowNoDataView = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = kRealWidth(34);
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = kRealWidth(50);
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, kSpecialLeftCategoryWidth, kRealWidth(80) + kiPhoneXSeriesSafeBottomHeight);
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}
/** @lazy changeStyleControl */
- (UIControl *)changeStyleControl {
    if (!_changeStyleControl) {
        _changeStyleControl = [[UIControl alloc] init];
        _changeStyleControl.backgroundColor = [UIColor whiteColor];
        [_changeStyleControl addTarget:self action:@selector(clickChangeStyle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeStyleControl;
}
/** @lazy changeStyleImageView */
- (UIImageView *)changeStyleImageView {
    if (!_changeStyleImageView) {
        _changeStyleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_horizontalStyle_topic"]];
    }
    return _changeStyleImageView;
}
/** @lazy dataSource */
- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
