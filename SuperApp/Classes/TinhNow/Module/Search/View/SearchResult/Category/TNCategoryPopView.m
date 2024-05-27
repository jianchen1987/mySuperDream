//
//  TNCategoryPopView.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryPopView.h"
#import "TNCategoryModel.h"
#import "TNCategoryListElementCell.h"


@interface TNCategoryPopView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/// 是否在展示中
@property (nonatomic, assign) BOOL isShowing;
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *popBackgroundContainer;
/// 数据源
@property (strong, nonatomic) NSArray<TNCategoryModel *> *dataSource;
/// 顶部视图
@property (strong, nonatomic) UIView *topView;
/// collectionView
@property (strong, nonatomic) UICollectionView *collectionView;
/// collectionView高度
@property (nonatomic, assign) CGFloat collectionViewHeight;
@end


@implementation TNCategoryPopView

- (instancetype)initWithCategoryArr:(nonnull NSArray *)categoryArr {
    /// 弹窗直接加到keyWindow
    self.dataSource = categoryArr;
    [self.dataSource enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.imageWidth = kRealWidth(70);
    }];
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame))];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
- (void)hd_setupViews {
    TNCategoryModel *firstModel = self.dataSource.firstObject;
    self.collectionViewHeight = firstModel.itemHeight * 2 + firstModel.itemHeight / 2 + kRealWidth(20) + kRealWidth(15);
    CGFloat startY = kStatusBarH + kRealWidth(44);
    self.shadowBackgroundView.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - startY);
    self.popBackgroundContainer.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), 0);

    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.popBackgroundContainer];

    [self.popBackgroundContainer addSubview:self.topView];
    [self.popBackgroundContainer addSubview:self.collectionView];
    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroudTap:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - 点击背景回收
- (void)backGroudTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (![self.popBackgroundContainer.layer.presentationLayer hitTest:touchPoint]) { //筛选区域之外的位置  点击全部收回弹窗
        [self dismiss];
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.isShowing = YES;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.shadowBackgroundView.alpha = 0.8;
        self.popBackgroundContainer.height = self.collectionViewHeight + kRealWidth(50);
        self.topView.alpha = 1;
        self.collectionView.height = self.collectionViewHeight;
    } completion:^(BOOL finished){

    }];
}
- (void)dismiss {
    self.isShowing = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.popBackgroundContainer.height = 0;
        self.topView.alpha = 0;
        self.collectionView.height = 0;
        self.shadowBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryModel *model = self.dataSource[indexPath.row];
    TNCategoryListElementCell *cell = [TNCategoryListElementCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.notShowSelectedStyle = YES;
    cell.model = model;
    @HDWeakify(self);
    cell.itemClickCallBack = ^(TNCategoryModel *_Nonnull tModel) {
        @HDStrongify(self);
        if (self.itemClickCallBack) {
            self.itemClickCallBack(tModel);
        }
        [self dismiss];
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryModel *model = self.dataSource[indexPath.row];
    return CGSizeMake(model.imageWidth, model.itemHeight);
}

/** @lazy shadowbackgroundView */
- (UIView *)shadowBackgroundView {
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = UIColor.blackColor;
        _shadowBackgroundView.alpha = 0;
        _shadowBackgroundView.userInteractionEnabled = YES;
    }
    return _shadowBackgroundView;
}
/** @lazy popBackgroundContainer */
- (UIView *)popBackgroundContainer {
    if (!_popBackgroundContainer) {
        _popBackgroundContainer = [[UIView alloc] init];
        _popBackgroundContainer.backgroundColor = UIColor.whiteColor;
    }
    return _popBackgroundContainer;
}
/** @lazy topView */
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, kRealWidth(50));
        _topView.alpha = 0;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = TNLocalizedString(@"ZYmXF0W9", @"全部分类");
        titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        [_topView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kRealWidth(15));
        }];

        HDUIButton *upBtn = [[HDUIButton alloc] init];
        [upBtn setImage:[UIImage imageNamed:@"tn_category_up"] forState:UIControlStateNormal];
        [upBtn setTitle:TNLocalizedString(@"tn_store_less", @"收起") forState:UIControlStateNormal];
        [upBtn setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
        upBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        upBtn.imagePosition = HDUIButtonImagePositionRight;
        upBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [upBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        [_topView addSubview:upBtn];
        [upBtn sizeToFit];
        [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-kRealWidth(15));
        }];
    }
    return _topView;
}
/** @lazy collectionView */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kRealWidth(15);
        flowLayout.minimumInteritemSpacing = kRealWidth(20);
        flowLayout.sectionInset = UIEdgeInsetsMake(kRealWidth(0), kRealWidth(15), kRealWidth(15), kRealWidth(15));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kRealWidth(50), kScreenWidth, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
@end
