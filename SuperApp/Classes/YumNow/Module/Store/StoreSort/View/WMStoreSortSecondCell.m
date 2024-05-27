//
//  WMStoreSortSecondCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreSortSecondCell.h"
#import "WMSortCollectionViewCell.h"


@interface WMStoreSortSecondCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView; ///列表

@property (nonatomic, strong) HDLabel *titleLB; ///标题

@property (nonatomic, strong) HDUIButton *allBtn; /// alll

@property (nonatomic, strong) UIView *headView; /// headView

@end


@implementation WMStoreSortSecondCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.headView];
    [self.headView addSubview:self.titleLB];
    [self.headView addSubview:self.allBtn];
}
- (void)updateConstraints {
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];

    [self.allBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(7.5));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(5));
        make.left.mas_equalTo(0);
        make.right.equalTo(self.allBtn.mas_left).offset(-kRealWidth(5));
        make.bottom.mas_equalTo(kRealWidth(-5));
    }];

    CGFloat height = ceil(self.model.subClassifications.count / 3.0) * kRealHeight(120);
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(height).priorityHigh();
    }];
    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.allBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}

- (void)setModel:(WMCategoryItem *)model {
    _model = model;
    self.titleLB.text = model.message.desc;
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.subClassifications.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMSortCollectionViewCell *cell = [WMSortCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = self.model.subClassifications[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockOnClickItem) {
        self.blockOnClickItem(self.model.subClassifications[indexPath.row]);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        [self layoutIfNeeded];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;

        const CGFloat width = (kScreenWidth - kRealWidth(130)) / 3;
        const CGFloat height = kRealHeight(120);
        flowLayout.itemSize = CGSizeMake(width, height);

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.scrollEnabled = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.backgroundView = UIView.new;
        collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 2;
        _titleLB.font = HDAppTheme.font.standard2Bold;
        _titleLB.textColor = HDAppTheme.WMColor.B3;
    }
    return _titleLB;
}

- (HDUIButton *)allBtn {
    if (!_allBtn) {
        _allBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn setTitle:WMLocalizedString(@"home_all", @"全部") forState:UIControlStateNormal];
        [_allBtn setTitleColor:HDAppTheme.WMColor.B6 forState:UIControlStateNormal];
        _allBtn.titleLabel.font = HDAppTheme.font.standard4;
        [_allBtn setImage:[UIImage imageNamed:@"store_sort_more"] forState:UIControlStateNormal];
        _allBtn.spacingBetweenImageAndTitle = kRealWidth(5);
        _allBtn.imagePosition = HDUIButtonImagePositionRight;
        @HDWeakify(self);
        [_allBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.blockOnClickAll) {
                self.blockOnClickAll();
            }
        }];
    }
    return _allBtn;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = UIView.new;
    }
    return _headView;
}

@end
