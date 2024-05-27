//
//  TNCategoryListCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryListCell.h"
#import "TNCategoryListElementCell.h"
#import "TNCategoryPopView.h"


@interface TNCategoryListCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNCategoryModel *> *dataArr;
/// 下拉弹窗按钮
@property (strong, nonatomic) HDUIButton *downPopBtn;
/// 用于限制刷新次数  因为cell只有一个 不会复用
@property (nonatomic, strong) TNCategoryListCellModel *oldModel;
@end


@implementation TNCategoryListCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.downPopBtn];
}
- (void)updateConstraints {
    if (!self.downPopBtn.isHidden) {
        [self.downPopBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.width.mas_equalTo(kRealWidth(40));
            make.height.mas_equalTo(self.model.cellHeight);
        }];
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        if (self.downPopBtn.isHidden) {
            make.right.equalTo(self.contentView.mas_right);
        } else {
            make.right.equalTo(self.downPopBtn.mas_left);
        }
        make.height.mas_equalTo(self.model.cellHeight);
    }];

    [super updateConstraints];
}
- (void)setModel:(TNCategoryListCellModel *)model {
    _model = model;
    if (HDIsObjectNil(self.oldModel) || ![self.oldModel.list isEqualToArray:model.list]) {
        [self setNeedsUpdateConstraints];
        [self.dataArr removeAllObjects];
        if (model.displayType == TNCategoryListCellDisplayTypeNormal) {
            self.downPopBtn.hidden = model.list.count <= 8;
            [self.dataArr addObjectsFromArray:model.list];

        } else if (model.displayType == TNCategoryListCellDisplayTypeStore) {
            //店铺15个  之后要添加一个更多按钮
            if (model.list.count >= 16) { //推荐类目不算
                [self.dataArr addObjectsFromArray:[model.list subarrayWithRange:NSMakeRange(0, 16)]];
                TNCategoryModel *moreModel = [[TNCategoryModel alloc] init];
                UIImage *moreImage = [UIImage imageNamed:@"tn_category_more"];
                moreModel.unSelectLogoImage = moreImage;
                moreModel.menuId = kCategotyMoreItemName;
                moreModel.name = TNLocalizedString(@"tn_store_more", @"更多");
                [self.dataArr addObject:moreModel];
            } else {
                [self.dataArr addObjectsFromArray:model.list];
            }
        }
        [self.collectionView reloadData];
        if (model.isNeedScrollerToSelected == true && model.scrollerToIndex < self.dataArr.count) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:model.scrollerToIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:NO];
            });
        }

        self.oldModel = model;
    }
}
#pragma mark - private method
- (void)downPopViewClick {
    TNCategoryPopView *popView = [[TNCategoryPopView alloc] initWithCategoryArr:self.dataArr];
    @HDWeakify(self);
    popView.itemClickCallBack = ^(TNCategoryModel *_Nonnull targetModel) {
        @HDStrongify(self);
        self.model.isNeedScrollerToSelected = NO;
        __block NSInteger targetIndex = 0;
        [self.dataArr enumerateObjectsUsingBlock:^(TNCategoryModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj.menuId isEqualToString:targetModel.menuId]) {
                if (obj.isSelected == YES) {
                    return;
                }
                obj.isSelected = YES;
                targetIndex = idx;
            } else {
                obj.isSelected = NO;
            }
        }];

        [self.collectionView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });

        if (self.categorySelectedCallBack) {
            self.categorySelectedCallBack(targetModel);
        }
    };
    [popView show];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNCategoryListElementCell *cell = [TNCategoryListElementCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    TNCategoryModel *model = self.dataArr[indexPath.row];
    model.imageWidth = kRealWidth(50);
    cell.model = model;
    @HDWeakify(self);
    cell.itemClickCallBack = ^(TNCategoryModel *_Nonnull tModel) {
        @HDStrongify(self);
        self.model.isNeedScrollerToSelected = false;                 //滚动过后就结束
        if ([tModel.menuId isEqualToString:kCategotyMoreItemName]) { //更多按钮 点击
            if (self.moreCategoryClickCallBack) {
                self.moreCategoryClickCallBack();
            }
            return;
        }
        if (tModel.isSelected == true) {
            if (HDIsStringEmpty(tModel.menuId)) { //已选中状态下  全部按钮还可以响应切换更多按钮
                if (self.moreCategoryClickCallBack) {
                    self.moreCategoryClickCallBack();
                }
            }
            return; //已经选中就不要了
        }
        tModel.isSelected = !tModel.isSelected;
        for (TNCategoryModel *otherModel in self.dataArr) {
            if (tModel != otherModel) {
                otherModel.isSelected = false;
            }
        }
        [self.collectionView reloadData];
        if (self.categorySelectedCallBack) {
            self.categorySelectedCallBack(tModel);
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kRealWidth(50), self.model.cellHeight);
}
/** @lazy collectionView */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _collectionView;
}
/** @lazy dataArr */
- (NSMutableArray<TNCategoryModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/** @lazy downPopBtn */
- (HDUIButton *)downPopBtn {
    if (!_downPopBtn) {
        _downPopBtn = [[HDUIButton alloc] init];
        [_downPopBtn setImage:[UIImage imageNamed:@"tn_category_down"] forState:UIControlStateNormal];
        _downPopBtn.backgroundColor = [UIColor whiteColor];
        _downPopBtn.hidden = YES;
        [_downPopBtn addTarget:self action:@selector(downPopViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downPopBtn;
}
@end


@implementation TNCategoryListCellModel
- (CGFloat)labelHeight {
    if (!_labelHeight || _labelHeight <= 0) {
        _labelHeight = 15;
        for (TNCategoryModel *obj in self.list) {
            NSString *name = @"";
            if (HDIsStringNotEmpty(obj.menuName.desc)) {
                name = obj.menuName.desc;
            } else {
                name = obj.name;
            }
            CGFloat height = [name boundingAllRectWithSize:CGSizeMake(kRealWidth(50), MAXFLOAT) font:HDAppTheme.font.standard4 lineSpacing:0].height;
            if (height > 15) {
                height = 31;
                _labelHeight = height;
                break;
            }
        }
    }
    return _labelHeight;
}
- (CGFloat)cellHeight {
    CGFloat height = 0;
    if (!HDIsArrayEmpty(self.list)) {
        //上间距
        height += kRealHeight(10);
        //图片
        height += kRealWidth(50);
        //图片与文字间距
        height += kRealHeight(10);
        //文字高度
        height += self.labelHeight;
        //底部间距
        height += kRealWidth(10);
    }
    return height;
}
@end
