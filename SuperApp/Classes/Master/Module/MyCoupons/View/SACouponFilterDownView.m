//
//  SACouponFilterDownView.m
//  SuperApp
//
//  Created by Tia on 2022/8/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACouponFilterDownView.h"
#import "SAAppSwitchManager.h"
#import "SACouponFilterAlertViewCollectionCell.h"
#import "SACouponFilterAlertViewCollectionReusableView.h"
#import "UICollectionViewLeftAlignLayout.h"
#import <YYModel/YYModel.h>


@implementation SACouponFilterSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"option": @"SACouponFilterOptionModel"};
}

@end


@implementation SACouponFilterOptionModel

- (void)setName:(SAInternationalizationModel *)name {
    self.width = [name.desc boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(28)) font:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] lineSpacing:0].width + 32;

    [super setName:name];
}

@end


@implementation SACouponFilterModel

@end


@interface SACouponFilterDownView () <UICollectionViewDelegate, UICollectionViewDataSource>
/// 相对视图
@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, strong) UICollectionView *collectionView;
/// 初始数据
@property (nonatomic, strong) NSArray *defaultDataArr;
/// 背景
@property (nonatomic, strong) UIView *shadowBackgroundView;
/// Container
@property (nonatomic, strong) UIView *containerView;
/// 是否展开
@property (nonatomic, assign) BOOL showing;

/// 重置按钮
@property (nonatomic, strong) UIButton *resetBTN;
/// 确定按钮
@property (nonatomic, strong) UIButton *submitBtn;

@end


@implementation SACouponFilterDownView

- (instancetype)initWithStartOffsetY:(CGFloat)offset {
    self.startY = offset;
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return self;
}

- (void)hd_setupViews {
    self.shadowBackgroundView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.startY);
    self.containerView.frame = CGRectMake(0, self.startY, CGRectGetWidth(self.frame), CGFLOAT_MIN);
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.resetBTN];
    [self.containerView addSubview:self.submitBtn];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.shadowBackgroundView addGestureRecognizer:tap];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.containerView);
                make.height.mas_equalTo(self.collectionView.contentSize.height);
            }];
        });
    }];
}

- (void)updateConstraints {
    [self updateContainerConstraints];
    [super updateConstraints];
}

- (void)updateContainerConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.startY);
    }];

    [self.resetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(kRealWidth(16));
        make.left.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(48));
        make.width.equalTo(self.containerView).multipliedBy(0.5);
    }];

    [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.resetBTN);
        make.right.equalTo(self.containerView);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark - public methods
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.showing = YES;
    [self.containerView setNeedsUpdateConstraints];
    self.shadowBackgroundView.alpha = 0.7;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.shadowBackgroundView.alpha = 0.7;
        [self updateContainerConstraints];
    } completion:^(BOOL finished){
    }];
}

- (void)dismiss {
    [self dismissCompleted:nil];
}

- (void)dismissCompleted:(void (^__nullable)(void))completed {
    //    !self.slideDownViewWillDisappear ?: self.slideDownViewWillDisappear(self);
    self.showing = NO;
    [self.containerView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.1 animations:^{
        self.shadowBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self updateContainerConstraints];
        if (completed) {
            completed();
        }
    }];
}

#pragma mark - override system methods
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.showing) { // 展开
        if (!CGRectContainsPoint(self.containerView.frame, point)) {
            dispatch_async(dispatch_get_main_queue(), ^{ //点击非内容页面，隐藏view
                [self dismiss];
            });
        }
        return CGRectContainsPoint(self.containerView.frame, point) || CGRectContainsPoint(self.shadowBackgroundView.frame, point);
    }
    // 收起
    return [super pointInside:point withEvent:event];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.defaultDataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SACouponFilterSectionModel *model = self.defaultDataArr[section];
    return model.option.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACouponFilterAlertViewCollectionCell *cell = [SACouponFilterAlertViewCollectionCell cellWithCollectionView:collectionView forIndexPath:indexPath
                                                                                                     identifier:NSStringFromClass(SACouponFilterAlertViewCollectionCell.class)];
    SACouponFilterSectionModel *model = self.defaultDataArr[indexPath.section];
    SACouponFilterOptionModel *m = model.option[indexPath.row];
    cell.text = m.name.desc;
    cell.isSelected = m.isSelected;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SACouponFilterAlertViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:NSStringFromClass(SACouponFilterAlertViewCollectionReusableView.class)
                                                                                                              forIndexPath:indexPath];
        SACouponFilterSectionModel *model = self.defaultDataArr[indexPath.section];
        headerView.text = model.title.desc;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.hd_width, kRealWidth(40));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SACouponFilterSectionModel *model = self.defaultDataArr[indexPath.section];
    SACouponFilterOptionModel *m = model.option[indexPath.row];
    NSInteger width = m.width;
    if (width == 0) {
        width = [m.name.desc boundingAllRectWithSize:CGSizeMake(MAXFLOAT, kRealWidth(40)) font:kSACouponFilterAlertViewCollectionCellFont lineSpacing:0].width + 32;
        m.width = width;
    }
    return CGSizeMake(width, kRealWidth(28));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SACouponFilterSectionModel *model = self.defaultDataArr[indexPath.section];
    SACouponFilterOptionModel *m = model.option[indexPath.row];
    if (m.isSelected)
        return;
    for (SACouponFilterOptionModel *m1 in model.option) {
        if (m1 != m && m1.isSelected) {
            m1.isSelected = NO;
        } else if (m1 == m) {
            m1.isSelected = YES;
        }
    }
    [self.collectionView reloadData];
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
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8];
        };
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLeftAlignLayout *flowLayout = [[UICollectionViewLeftAlignLayout alloc] init];
        flowLayout.minimumLineSpacing = 8.0f;
        flowLayout.minimumInteritemSpacing = 12.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - HDAppTheme.value.padding.left - HDAppTheme.value.padding.right, 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:SACouponFilterAlertViewCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(SACouponFilterAlertViewCollectionReusableView.class)];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)resetBTN {
    if (!_resetBTN) {
        _resetBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBTN setTitle:SALocalizedStringFromTable(@"reset", @"重置", @"Buttons") forState:UIControlStateNormal];
        [_resetBTN setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        _resetBTN.backgroundColor = [HDAppTheme.color normalBackground];
        _resetBTN.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _resetBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        @HDWeakify(self);
        [_resetBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.defaultDataArr = nil;
            [self.collectionView reloadData];
        }];
    }
    return _resetBTN;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [HDAppTheme.font boldForSize:14];
        _submitBtn.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(2), kRealWidth(5), kRealHeight(2), kRealWidth(5));
        _submitBtn.backgroundColor = HDAppTheme.color.sa_C1;
        @HDWeakify(self);
        [_submitBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.submitBlock) {
                NSInteger sceneType = 9;
                SACouponFilterSectionModel *m = self.defaultDataArr[0];
                for (SACouponFilterOptionModel *m1 in m.option) {
                    if (m1.isSelected) {
                        sceneType = m1.sceneType;
                        break;
                    }
                }

                SAClientType businessLine;
                m = self.defaultDataArr[1];
                for (SACouponFilterOptionModel *m1 in m.option) {
                    if (m1.isSelected) {
                        businessLine = m1.businessLine;
                        break;
                    }
                }

                NSInteger orderBy = 10;
                m = self.defaultDataArr[2];
                for (SACouponFilterOptionModel *m1 in m.option) {
                    if (m1.isSelected) {
                        orderBy = m1.orderBy;
                        break;
                    }
                }
                self.submitBlock(sceneType, businessLine, orderBy);
            }

            [self dismiss];
        }];
    }
    return _submitBtn;
}

- (NSArray *)defaultDataArr {
    if (!_defaultDataArr) {
        //根据后台配置控制获取筛选数据，默认显示
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchCouponFilterOption];
        SACouponFilterModel *model = [SACouponFilterModel yy_modelWithJSON:jsonStr];
        _defaultDataArr = @[model.couponType, model.availableRange, model.sort];
    }
    return _defaultDataArr;
}

@end
