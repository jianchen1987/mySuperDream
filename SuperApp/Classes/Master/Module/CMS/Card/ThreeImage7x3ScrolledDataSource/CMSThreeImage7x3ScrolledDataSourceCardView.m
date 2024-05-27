//
//  CMSThreeImage7x3ScrolledDataSourceCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage7x3ScrolledDataSourceCardView.h"
#import "CMSThreeImage7x3ItemConfig.h"
#import "CMSThreeImage7x3ScrolledCardCell.h"
#import "CMSThreeImage7x3ScrolledCardView.h"
#import "CMSThreeImage7x3ScrolledDataSourceRspModel.h"
#import "SAAddressModel.h"

#define sideWidth 0
#define cellMargin kRealWidth(10)
#define cellWidth kRealWidth(165)
#define hasTitleCellHeight kRealWidth(102)
#define noTitleCellHeight kRealWidth(85)


@interface CMSThreeImage7x3ScrolledDataSourceCardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<CMSThreeImage7x3ItemConfig *> *dataSource; ///< 数据源
@property (nonatomic, assign) BOOL hasTitle;                                   ///< 所有数据是否有包含标题的

@end


@implementation CMSThreeImage7x3ScrolledDataSourceCardView

#pragma mark - Overwirite
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    if (HDIsStringNotEmpty(dataSource)) {
        return YES;
    }
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    NSString *dataSource = config.getCardContent[@"dataSource"];
    return dataSource;
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    NSMutableDictionary *req = NSMutableDictionary.new;
    NSDictionary *superParameters = [super setupRequestParamtersWithDataSource:dataSource cardConfig:config];
    [req addEntriesFromDictionary:superParameters];
    if (config.addressModel) {
        [req addEntriesFromDictionary:@{@"location": @{@"lat": config.addressModel.lat.stringValue, @"lon": config.addressModel.lon.stringValue}}];
    }

    return req;
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [super parsingDataSourceResponse:responseData withCardConfig:config];

    CMSThreeImage7x3ScrolledDataSourceRspModel *rspModel = [CMSThreeImage7x3ScrolledDataSourceRspModel yy_modelWithDictionary:responseData[@"data"]];
    if (HDIsArrayEmpty(rspModel.nodes)) {
        return;
    }
    config.titleConfig.title = rspModel.title;
    config.titleConfig.subTitle = rspModel.subTitle;
    config.titleConfig.subTitleLink = rspModel.subTitleLink;
    config.nodes = [rspModel.nodes mapObjectsUsingBlock:^id _Nonnull(CMSThreeImage7x3ItemConfig *_Nonnull obj, NSUInteger idx) {
        SACMSNode *node = SACMSNode.new;
        node.location = idx;
        node.nodeContent = [obj yy_modelToJSONString];
        return node;
    }];

    [self updateTitleViewWithConfig:config.titleConfig];
    self.dataSource = [NSArray yy_modelArrayWithClass:CMSThreeImage7x3ItemConfig.class json:self.config.getAllNodeContents];
//    [self.dataSource enumerateObjectsUsingBlock:^(CMSThreeImage7x3ItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if (HDIsStringNotEmpty(obj.title)) {
//            self.hasTitle = true;
//            *stop = true;
//        }
//    }];

    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    [self.collectionView reloadData];
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView).offset(kRealHeight(10));
        make.height.mas_equalTo(self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
        make.bottom.equalTo(self.containerView).offset(-kRealHeight(10));
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;

    height += kRealHeight(20) + (self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:CMSThreeImage7x3ItemConfig.class]) {
        CMSThreeImage7x3ScrolledCardCell *cell = [CMSThreeImage7x3ScrolledCardCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return UICollectionViewCell.new;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    SACMSNode *node = self.config.nodes[indexPath.row];
    if ([model isKindOfClass:CMSThreeImage7x3ItemConfig.class]) {
        CMSThreeImage7x3ItemConfig *trueModel = (CMSThreeImage7x3ItemConfig *)model;
        !self.clickNode ?: self.clickNode(self, node, trueModel.link, [NSString stringWithFormat:@"node@%zd", indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth, self.hasTitle ? hasTitleCellHeight : noTitleCellHeight);
}

#pragma mark - getters and setters
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSThreeImage7x3ItemConfig.class json:self.config.getAllNodeContents];
    [self.dataSource enumerateObjectsUsingBlock:^(CMSThreeImage7x3ItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (HDIsStringNotEmpty(obj.title)) {
            self.hasTitle = true;
            *stop = true;
        }
    }];
    // 先更新约束
    [self setNeedsUpdateConstraints];
    // 强制更新UI
    [self layoutIfNeeded];
    // 最后刷新collectionView，否则可能会因为高度为0，导致不刷新
    [self.collectionView reloadData];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(10);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.backgroundView = UIView.new;
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
