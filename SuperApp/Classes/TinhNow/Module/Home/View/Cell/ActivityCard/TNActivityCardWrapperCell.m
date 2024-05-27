//
//  TNActivityCardWrapperCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardWrapperCell.h"
#import "SATableView.h"
#import "TNActivityCardBannerCell.h"
#import "TNActivityCardMultipleBannersCell.h"
#import "TNActivityCardScrollItemCell.h"
#import "TNActivityCardSixItemCell.h"
#import "TNActivityCardSquareItemCell.h"
#import "TNActivityCardTextCell.h"


@interface TNActivityCardWrapperCell () <UITableViewDelegate, UITableViewDataSource>
/// 容器
@property (strong, nonatomic) SATableView *tableView;
/// 旧模型 用于判断 是否需要刷新数据  多次reload 很卡顿
@property (strong, nonatomic) TNActivityCardRspModel *oldCellModel;
@end


@implementation TNActivityCardWrapperCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.tableView];
}
- (void)setCellModel:(TNActivityCardRspModel *)cellModel {
    _cellModel = cellModel;
    self.tableView.backgroundColor = cellModel.backGroundColor;
    if (HDIsObjectNil(self.oldCellModel) || ![self.oldCellModel.list isEqualToArray:cellModel.list]) {
        [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        [self setNeedsUpdateConstraints];
        self.oldCellModel = cellModel;
    }
}
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.cellModel.cellHeight);
    }];
    [super updateConstraints];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellModel.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNActivityCardModel *model = self.cellModel.list[indexPath.section];
    if (model.cardStyle == TNActivityCardStyleText) {
        TNActivityCardTextCell *cell = [TNActivityCardTextCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    } else if (model.cardStyle == TNActivityCardStyleBanner) {
        TNActivityCardBannerCell *cell = [TNActivityCardBannerCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    } else if (model.cardStyle == TNActivityCardStyleScorllItem) {
        TNActivityCardScrollItemCell *cell = [TNActivityCardScrollItemCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    } else if (model.cardStyle == TNActivityCardStyleSixItem) {
        TNActivityCardSixItemCell *cell = [TNActivityCardSixItemCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    } else if (model.cardStyle == TNActivityCardStyleMultipleBanners) {
        TNActivityCardMultipleBannersCell *cell = [TNActivityCardMultipleBannersCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    } else if (model.cardStyle == TNActivityCardStyleSquareScorllItem) {
        TNActivityCardSquareItemCell *cell = [TNActivityCardSquareItemCell cellWithTableView:tableView];
        cell.cardModel = model;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TNActivityCardModel *model = self.cellModel.list[indexPath.section];
    if ([cell isKindOfClass:TNActivityCardTextCell.class]) {
        TNActivityCardTextCell *textCell = (TNActivityCardTextCell *)cell;
        textCell.cardModel = model;
    } else if ([cell isKindOfClass:TNActivityCardBannerCell.class]) {
        TNActivityCardBannerCell *bannerCell = (TNActivityCardBannerCell *)cell;
        bannerCell.cardModel = model;
    } else if ([cell isKindOfClass:TNActivityCardScrollItemCell.class]) {
        TNActivityCardScrollItemCell *scrollerCell = (TNActivityCardScrollItemCell *)cell;
        scrollerCell.cardModel = model;
    } else if ([cell isKindOfClass:TNActivityCardSixItemCell.class]) {
        TNActivityCardSixItemCell *sixItemCell = (TNActivityCardSixItemCell *)cell;
        sixItemCell.cardModel = model;
    } else if ([cell isKindOfClass:TNActivityCardMultipleBannersCell.class]) {
        TNActivityCardMultipleBannersCell *multipCell = (TNActivityCardMultipleBannersCell *)cell;
        multipCell.cardModel = model;
    } else if ([cell isKindOfClass:TNActivityCardSquareItemCell.class]) {
        TNActivityCardSquareItemCell *squareCell = (TNActivityCardSquareItemCell *)cell;
        squareCell.cardModel = model;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TNActivityCardModel *model = self.cellModel.list[section];
    if (model.scene == TNActivityCardSceneIndex && model.cardStyle != TNActivityCardStyleText && section != 0) {
        return kRealWidth(10);
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNActivityCardModel *model = self.cellModel.list[indexPath.section];
    return model.cellHeight;
}
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.needRefreshHeader = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
