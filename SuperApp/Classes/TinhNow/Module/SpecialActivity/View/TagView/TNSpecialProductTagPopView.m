//
//  TNSpecialProductTagPopView.m
//  SuperApp
//
//  Created by 张杰 on 2022/11/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSpecialProductTagPopView.h"
#import "TNCollectionView.h"
#import "TNCollectionViewCell.h"
#import "TNGoodsTagModel.h"
#import "TNProductTagButton.h"
#import "UICollectionViewLeftAlignLayout.h"


@interface TNSpecialProductTagPopCell : TNCollectionViewCell
/// 标签按钮
@property (strong, nonatomic) TNProductTagButton *tagBtn;
/// 模型
@property (strong, nonatomic) TNGoodsTagModel *model;
/// 点击回调
@property (nonatomic, copy) void (^tagSelectedCallBack)(TNGoodsTagModel *model);
/// 弹窗宽度
@property (nonatomic, assign) CGFloat popWidth;

@end


@implementation TNSpecialProductTagPopCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.tagBtn];
    self.popWidth = kScreenWidth;
}
- (void)setPopWidth:(CGFloat)popWidth {
    _popWidth = popWidth;
}
- (void)setModel:(TNGoodsTagModel *)model {
    _model = model;
    [self.tagBtn setTitle:model.tagName forState:UIControlStateNormal];
    self.tagBtn.selected = model.isSelected;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.tagBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        if (self.model.itemSize.width > 0 && self.model.itemSize.height > 0) {
            make.size.mas_equalTo(self.model.itemSize);
        }
    }];
    [super updateConstraints];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width > self.popWidth - kRealWidth(20) ? self.popWidth - kRealWidth(20) : size.width;
    newFrame.size.height = kRealWidth(25);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
/** @lazy tagBtn */
- (TNProductTagButton *)tagBtn {
    if (!_tagBtn) {
        _tagBtn = [[TNProductTagButton alloc] init];
        @HDWeakify(self);
        [_tagBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.tagSelectedCallBack ?: self.tagSelectedCallBack(self.model);
        }];
    }
    return _tagBtn;
}
@end


@interface TNSpecialProductTagPopView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *filterBackgroundContainer;
/// colelction
@property (nonatomic, strong) TNCollectionView *collectionView;
/// 数据源
@property (strong, nonatomic) NSArray<TNGoodsTagModel *> *tagArr;
/// 相对view
@property (nonatomic, strong) UIView *behindView;
/// 收起按钮
@property (strong, nonatomic) HDUIButton *dismissBtn;
/// 弹窗宽度
@property (nonatomic, assign) CGFloat popWidth;
@end


@implementation TNSpecialProductTagPopView
- (void)dealloc {
    HDLog(@"TNSpecialProductTagPopView  释放");
}
- (instancetype)initWithView:(UIView *)behindView tagArr:(NSArray<TNGoodsTagModel *> *)tagArr width:(CGFloat)width {
    /// 弹窗直接加到keyWindow
    self.behindView = behindView;
    self.tagArr = tagArr;
    self.popWidth = width;
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame))];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
- (void)hd_setupViews {
    CGRect startRect = [self.behindView convertRect:self.behindView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat startY = startRect.origin.y;
    CGFloat startX = kScreenWidth - self.popWidth;
    self.shadowBackgroundView.frame = CGRectMake(startX, startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - startY);
    self.filterBackgroundContainer.frame = CGRectMake(startX, startY, self.popWidth, CGFLOAT_MIN);
    self.collectionView.frame = CGRectMake(0, 0, self.popWidth, 20);
    self.dismissBtn.frame = CGRectMake(0, self.collectionView.bottom, self.popWidth, CGFLOAT_MIN);
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.filterBackgroundContainer];
    [self.filterBackgroundContainer addSubview:self.collectionView];
    [self.filterBackgroundContainer addSubview:self.dismissBtn];

    //点击背景回收弹出视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroudTap:)];
    [self addGestureRecognizer:tap];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateContainerViewConstraintsByShowing:YES];
        });
    }];
}
#pragma mark - 点击背景回收
- (void)backGroudTap:(UIGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self];
    if (![self.filterBackgroundContainer.layer.presentationLayer hitTest:touchPoint]) { //筛选区域之外的位置  点击全部收回弹窗
        [self dismiss];
    }
}

- (void)updateContainerViewConstraintsByShowing:(BOOL)isShowing {
    CGFloat height = MIN(self.collectionView.contentSize.height, kScreenHeight / 2 - kRealWidth(140));
    if (self.collectionView.height >= height) {
        return;
    }
    if (isShowing) {
        self.filterBackgroundContainer.height = height + kRealWidth(40);
        self.collectionView.height = height;
        self.dismissBtn.top = self.collectionView.bottom;
        self.dismissBtn.height = kRealWidth(40);
    } else {
        self.filterBackgroundContainer.height = 0;
        self.collectionView.height = 0;
        self.dismissBtn.top = self.collectionView.bottom;
        self.dismissBtn.height = 0;
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.collectionView successGetNewDataWithNoMoreData:YES];
    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self updateContainerViewConstraintsByShowing:YES];
        self.shadowBackgroundView.alpha = 0.8;
    } completion:^(BOOL finished){
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self updateContainerViewConstraintsByShowing:NO];
        self.shadowBackgroundView.alpha = 0;
        self.dismissBtn.hidden = YES;
        self.filterBackgroundContainer.hidden = YES;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNSpecialProductTagPopCell *cell = [TNSpecialProductTagPopCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.popWidth = self.popWidth;
    cell.model = self.tagArr[indexPath.row];
    @HDWeakify(self);
    cell.tagSelectedCallBack = ^(TNGoodsTagModel *model) {
        @HDStrongify(self);
        if (model.isSelected) {
            return;
        }
        [self.tagArr enumerateObjectsUsingBlock:^(TNGoodsTagModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
        }];
        model.isSelected = !model.isSelected;
        [self.collectionView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        !self.tagClickCallBack ?: self.tagClickCallBack(model);
        [self dismiss];
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNGoodsTagModel *model = self.tagArr[indexPath.row];
    CGFloat width = model.itemSize.width > self.popWidth - kRealWidth(20) ? self.popWidth - kRealWidth(20) : model.itemSize.width;
    return CGSizeMake(width, model.itemSize.height);
}
/** @lazy collectionView */
- (TNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[TNCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.popWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.needRefreshFooter = NO;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRecognizeSimultaneously = YES;
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
        _filterBackgroundContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _filterBackgroundContainer;
}

@end
