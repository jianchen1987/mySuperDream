//
//  TNOneLevelCategoryFilterView.m
//  SuperApp
//
//  Created by 张杰 on 2022/5/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOneLevelCategoryFilterView.h"
#import "TNCollectionView.h"
#import "TNCollectionViewCell.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNOneLevelTagCell : TNCollectionViewCell
///
@property (strong, nonatomic) HDLabel *tagLabel;
///
@property (strong, nonatomic) TNCategoryModel *model;
///
@property (nonatomic, copy) void (^itemClickCallBack)(TNCategoryModel *targetModel);
@end


@implementation TNOneLevelTagCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.tagLabel];
    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - 点击背景回收
- (void)clickItem:(UIGestureRecognizer *)tap {
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
    self.tagLabel.text = name;
    if (model.isSelected) {
        self.tagLabel.textColor = [UIColor whiteColor];
        self.tagLabel.backgroundColor = HDAppTheme.TinhNowColor.C1;
        self.tagLabel.layer.borderColor = HDAppTheme.TinhNowColor.C1.CGColor;
    } else {
        self.tagLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        self.tagLabel.backgroundColor = [UIColor whiteColor];
        self.tagLabel.layer.borderColor = HDAppTheme.TinhNowColor.c5d667f.CGColor;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(30));
    }];
    [super updateConstraints];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width > kScreenWidth - 50 ? kScreenWidth - 50 : size.width;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
#pragma mark - lazy load
/** @lazy  */
- (HDLabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[HDLabel alloc] init];
        _tagLabel.font = HDAppTheme.TinhNowFont.standard14;
        _tagLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _tagLabel.backgroundColor = [UIColor whiteColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.numberOfLines = 1;
        _tagLabel.hd_edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _tagLabel.layer.cornerRadius = 15;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.borderWidth = 1;
        _tagLabel.layer.borderColor = HDAppTheme.TinhNowColor.c5d667f.CGColor;
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}
@end


@interface TNOneLevelCategoryFilterView () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *filterBackgroundContainer;
/// colelction
@property (nonatomic, strong) TNCollectionView *collectionView;
/// 数据源
@property (strong, nonatomic) NSArray<TNCategoryModel *> *categoryArr;
/// 相对view
@property (nonatomic, strong) UIView *behindView;
/// 收起按钮
@property (strong, nonatomic) HDUIButton *dismissBtn;
@end


@implementation TNOneLevelCategoryFilterView
- (void)dealloc {
    HDLog(@"TNOneLevelCategoryFilterView  释放");
}
- (instancetype)initWithView:(UIView *)behindView categoryArr:(nonnull NSArray *)categoryArr {
    /// 弹窗直接加到keyWindow
    self.behindView = behindView;
    self.categoryArr = categoryArr;
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame))];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
- (void)hd_setupViews {
    CGRect startRect = [self.behindView convertRect:self.behindView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat startY = startRect.origin.y;
    self.shadowBackgroundView.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - startY);
    self.filterBackgroundContainer.frame = CGRectMake(0, startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    self.dismissBtn.frame = CGRectMake(0, self.collectionView.bottom, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.filterBackgroundContainer];
    [self.filterBackgroundContainer addSubview:self.collectionView];
    [self.filterBackgroundContainer addSubview:self.dismissBtn];

    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroudTap:)];
    [self addGestureRecognizer:tap];
}
#pragma mark - 点击背景回收
- (void)backGroudTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (![self.filterBackgroundContainer.layer.presentationLayer hitTest:touchPoint]) { //筛选区域之外的位置  点击全部收回弹窗
        [self dismiss];
    }
}
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    self.isShowing = YES;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.filterBackgroundContainer.height = kRealWidth(240);
        self.collectionView.height = kRealWidth(200);
        self.dismissBtn.top = self.collectionView.bottom;
        self.dismissBtn.height = kRealWidth(40);
        self.shadowBackgroundView.alpha = 0.8;
    } completion:^(BOOL finished){

    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBackgroundContainer.height = 0;
        self.collectionView.height = 0;
        self.dismissBtn.top = self.collectionView.bottom;
        self.dismissBtn.height = 0;
        self.shadowBackgroundView.alpha = 0;
        self.dismissBtn.hidden = YES;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNOneLevelTagCell *cell = [TNOneLevelTagCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    TNCategoryModel *model = self.categoryArr[indexPath.row];
    cell.model = model;
    @HDWeakify(self);
    cell.itemClickCallBack = ^(TNCategoryModel *targetModel) {
        @HDStrongify(self);
        if (targetModel.isSelected) {
            return;
        }
        [self.categoryArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
        }];
        targetModel.isSelected = YES;
        [self.collectionView successLoadMoreDataWithNoMoreData:YES];
        !self.selectedCategoryCallBack ?: self.selectedCategoryCallBack(targetModel);
        [self dismiss];
    };
    return cell;
}
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(70, 30);
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needRefreshFooter = NO;
        _collectionView.needRefreshHeader = NO;
    }
    return _collectionView;
}
/** @lazy dismissBtn */
- (HDUIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [[HDUIButton alloc] init];
        [_dismissBtn setTitle:TNLocalizedString(@"tn_click_collapse", @"点击收起") forState:UIControlStateNormal];
        [_dismissBtn setImage:[UIImage imageNamed:@"tn_direction_up"] forState:UIControlStateNormal];
        _dismissBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_dismissBtn setTitleColor:HDAppTheme.TinhNowColor.c5d667f forState:UIControlStateNormal];
        _dismissBtn.spacingBetweenImageAndTitle = 5;
        _dismissBtn.imagePosition = HDUIButtonImagePositionRight;
        [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}
#pragma mark - lazy load
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
/** @lazy filterbackgroundcontainer */
- (UIView *)filterBackgroundContainer {
    if (!_filterBackgroundContainer) {
        _filterBackgroundContainer = [[UIView alloc] init];
        _filterBackgroundContainer.backgroundColor = UIColor.whiteColor;
    }
    return _filterBackgroundContainer;
}

@end
