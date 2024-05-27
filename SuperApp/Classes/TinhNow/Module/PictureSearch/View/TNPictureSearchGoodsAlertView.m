//
//  TNPictureSearchGoodsAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureSearchGoodsAlertView.h"
#import "HDCollectionViewVerticalLayout.h"
#import "SACollectionView.h"
#import "TNPictureSearchDTO.h"
#import "TNPictureSearchProductCell.h"


@interface TNPictureSearchGoodsAlertView () <UICollectionViewDelegate, UICollectionViewDataSource, HDCollectionViewBaseFlowLayoutDelegate>
///
@property (strong, nonatomic) UIView *topView;
///
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (strong, nonatomic) HDUIButton *closeBTN;
/// collection
@property (nonatomic, strong) SACollectionView *collectionView;
///
@property (strong, nonatomic) NSMutableArray<TNPictureSearchModel *> *dataArr;
///
@property (strong, nonatomic) TNPictureSearchDTO *picSearchDto;
/// 图片地址
@property (nonatomic, copy) NSString *picUrl;
/// 是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 当前页
@property (nonatomic, assign) NSInteger currentPage;
@end


@implementation TNPictureSearchGoodsAlertView
- (instancetype)initWithRspModel:(TNPictureSearchRspModel *)rspModel picUrl:(NSString *)picUrl {
    self.hasNextPage = rspModel.hasNextPage;
    self.picUrl = picUrl;
    self.currentPage = 1;
    [self.dataArr removeAllObjects];
    if (!HDIsArrayEmpty(rspModel.items)) {
        [self.dataArr addObjectsFromArray:rspModel.items];
    }
    if (!HDIsArrayEmpty(self.dataArr)) {
        [self.dataArr enumerateObjectsUsingBlock:^(TNPictureSearchModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj configCellHeight];
        }];
    }
    return [super init];
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    if (!HDIsArrayEmpty(self.dataArr)) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self.topView addSubview:self.closeBTN];
        [self addSubview:self.collectionView];
    } else {
        [self addSubview:self.collectionView];
    }

    [self.collectionView successGetNewDataWithNoMoreData:!self.hasNextPage];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
    };
}

#pragma mark -查询更多
- (void)loadMoreProducts {
    @HDWeakify(self);
    [self.picSearchDto queryProductSimilarSearchWithPicUrl:self.picUrl pageNo:++self.currentPage pageSize:20 success:^(TNPictureSearchRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.hasNextPage = rspModel.hasNextPage;
        if (!HDIsArrayEmpty(rspModel.items)) {
            [rspModel.items enumerateObjectsUsingBlock:^(TNPictureSearchModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                [obj configCellHeight];
            }];

            [self.dataArr addObjectsFromArray:rspModel.items];
        }
        [self.collectionView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.collectionView successLoadMoreDataWithNoMoreData:!self.hasNextPage];
    }];
}
- (void)showInView:(UIView *)inView aboveView:(UIView *)aboveView {
    [inView addSubview:self];
    CGRect frame = inView.frame;
    CGFloat y = CGRectGetMaxY(aboveView.frame) + kRealWidth(30);
    CGFloat height = frame.size.height - y;
    frame.origin.y = frame.size.height;
    frame.size.height = height;
    self.frame = frame;
    frame.origin.y = y;
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = frame;
        [self setNeedsUpdateConstraints];
    }];
}
- (void)dismiss {
    !self.dismissCallBack ?: self.dismissCallBack();
    CGRect frame = self.frame;
    frame.origin.y = kScreenHeight;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)updateConstraints {
    if (!HDIsArrayEmpty(self.dataArr)) {
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
        [self.closeBTN sizeToFit];
        [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView.mas_left).offset(kRealWidth(15));
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView.mas_left).offset(kRealWidth(50));
            make.right.equalTo(self.topView.mas_right).offset(-kRealWidth(50));
            make.top.equalTo(self.topView.mas_top).offset(kRealWidth(12));
            make.bottom.equalTo(self.topView.mas_bottom).offset(-kRealWidth(12));
        }];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
        }];
    } else {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    [super updateConstraints];
}

#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNPictureSearchProductCell *cell = [TNPictureSearchProductCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TNPictureSearchModel *model = self.dataArr[indexPath.row];
    TNPictureSearchProductCell *goodCell = (TNPictureSearchProductCell *)cell;
    goodCell.model = model;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TNPictureSearchModel *model = self.dataArr[indexPath.row];
    [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"sn": model.sn, @"channel": model.channel}];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TNPictureSearchModel *model = self.dataArr[indexPath.row];
    return CGSizeMake(model.preferredWidth, model.cellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(10), kRealWidth(15));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRealWidth(10);
}
#pragma mark - HDCollectionViewVerticalLayoutDelegate
- (HDCollectionLayoutType)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return HDCollectionLayoutTypeColumn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(HDCollectionViewBaseFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}

/** @lazy topView */
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = TNLocalizedString(@"17BaSXBw", @"为您找到以下相似商品");
    }
    return _titleLabel;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy collectionView */
- (SACollectionView *)collectionView {
    if (!_collectionView) {
        HDCollectionViewVerticalLayout *flowLayout = [[HDCollectionViewVerticalLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[SACollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _collectionView.needRefreshHeader = NO;
        _collectionView.needRefreshFooter = YES;
        _collectionView.needShowNoDataView = YES;
        @HDWeakify(self);
        _collectionView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadMoreProducts];
        };
        UIViewPlaceholderViewModel *placeHolder = UIViewPlaceholderViewModel.new;
        placeHolder.title = TNLocalizedString(@"Mk1LMz7W", @"未识别到相似商品");
        placeHolder.titleFont = HDAppTheme.TinhNowFont.standard15;
        placeHolder.titleColor = HDAppTheme.TinhNowColor.G3;
        placeHolder.image = @"tinhnow_product_fail_bg";
        placeHolder.imageSize = CGSizeMake(218, 131);
        placeHolder.needRefreshBtn = YES;
        placeHolder.refreshBtnTitle = TNLocalizedString(@"5lKamBqi", @"返回");
        placeHolder.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            [self dismiss];
        };
        _collectionView.placeholderViewModel = placeHolder;
    }
    return _collectionView;
}
/** @lazy dataArr */
- (NSMutableArray<TNPictureSearchModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (TNPictureSearchDTO *)picSearchDto {
    return _picSearchDto ?: ({ _picSearchDto = TNPictureSearchDTO.new; });
}

@end
