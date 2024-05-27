//
//  TNCategorySecondLevelTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategorySecondLevelTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNCategoryMenuCollectionViewCell.h"
#import "TNCategoryModel.h"
#import "TNSecondLevelCategoryModel.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNCategorySecondLevelTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/// title
@property (nonatomic, strong) UILabel *titleLabel;
///
@property (nonatomic, strong) UICollectionView *collectionView;
/// collectionheight
@property (nonatomic, assign) CGFloat collectionFitHeight;
/// 数据源  可能品牌的数据源  可能商品的数据源
@property (nonatomic, strong) NSArray<TNCategoryModel *> *dataSource;

@end


@implementation TNCategorySecondLevelTableViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_greaterThanOrEqualTo(self.collectionFitHeight);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNSecondLevelCategoryModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    if ([model.type isEqualToString:TNCategoryTypeGoods]) {
        self.dataSource = [NSArray arrayWithArray:model.productCategories];
    } else if ([model.type isEqualToString:TNCategoryTypeBrand]) {
        self.dataSource = [NSArray arrayWithArray:model.brands];
    }
    NSArray *splitArr = [self.dataSource hd_splitArrayWithEachCount:3]; //切分分组  3个一列
    for (NSArray *subs in splitArr) {
        CGFloat maxHeight = 0;
        CGFloat nomalHeight = 18; //一行的高度
        for (TNCategoryModel *model in subs) {
            CGFloat nameHeight = [model.name boundingAllRectWithSize:CGSizeMake(kRealWidth(70), MAXFLOAT) font:HDAppTheme.font.standard3].height;
            if (nameHeight > 18) {
                maxHeight = 38; //两行的高度是38 最多两行
                break;
            }
        }
        for (TNCategoryModel *model in subs) {
            if (maxHeight > 0) {
                model.cellHeight = kRealWidth(105) + maxHeight;
            } else {
                model.cellHeight = kRealWidth(105) + nomalHeight;
            }
        }
    }
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    self.collectionFitHeight = self.collectionView.contentSize.height;
    [self setNeedsUpdateConstraints];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryModel *model = self.dataSource[indexPath.row];
    TNCategoryMenuCollectionViewCell *cell = [TNCategoryMenuCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryModel *model = self.dataSource[indexPath.row];
    CGFloat itemWidth = model.cellWidth;
    CGFloat itemHeight = model.cellHeight;
    return CGSizeMake(itemWidth, itemHeight);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TNCategoryModel *tModel = self.dataSource[indexPath.row];
    if ([self.model.type isEqualToString:TNCategoryTypeGoods]) {
        //分类搜索页面还需要将 同级的分类数据全带过去
        for (TNCategoryModel *oModel in self.dataSource) {
            oModel.isSelected = false; //全部还原
        }
        //添加全部  搜索不需要全部 按钮
        //        TNCategoryModel *allModel = [[TNCategoryModel alloc] init];
        //        allModel.name = TNLocalizedString(@"tn_title_all", @"全部");
        //        allModel.unSelectLogoImage = [UIImage imageNamed:@"tn_all_unselect"];
        //        allModel.selectLogoImage = [UIImage imageNamed:@"tn_all_select"];
        //        allModel.menuId = self.model.categoryId; //传个二级分类的id 给全部
        //        NSMutableArray *categorys = [NSMutableArray arrayWithArray:self.dataSource];
        //        [categorys insertObject:allModel atIndex:0];
        // categoryId -> 三级分类id    categoryModelList-> 三级同类兄弟分类id数组   parentSC -> 二级分类id
        [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:@{@"categoryId": tModel.menuId, @"categoryModelList": self.dataSource, @"parentSC": self.model.categoryId}];
    } else if ([self.model.type isEqualToString:TNCategoryTypeBrand]) {
        [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:@{@"brandId": tModel.menuId, @"categoryIds": tModel.productCategoryIds}];
    }

    [SATalkingData trackEvent:@"[电商]分类tab_点击三级分类" label:@"" parameters:@{@"分类ID": tModel.menuId}];
}
#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard3Bold;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _titleLabel;
}
/** @lazy collectionView */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionViewWidth = CGRectGetWidth(self.frame);
        CGFloat space = kRealWidth(20);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.sectionInset = UIEdgeInsetsMake(kRealWidth(0), kRealWidth(10), 0, kRealWidth(10));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionViewWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        }];
    }
    return _collectionView;
}

@end
