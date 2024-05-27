//
//  PNMSStorePhotoCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStorePhotoCell.h"
#import "PNCollectionView.h"
#import "PNMSStorePhotoItemCell.h"
#import "PNMSStorePhotoModel.h"
#import "PNUploadImageDTO.h"
#import "SAImageAccessor.h"
#import "TNTakePhotoItemCell.h"


@interface PNMSStorePhotoCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) SAImageAccessor *imageAccessor;
/// 上传图片 VM
@property (nonatomic, strong) PNUploadImageDTO *uploadImageDTO;

@property (nonatomic, assign) NSInteger clickCurrentIndex;

@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *subTitleLabel;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat collectionViewHeight;
@property (nonatomic, assign) CGFloat sectionInsetTop;
@property (nonatomic, assign) CGFloat sectionInsetLeft;
@property (nonatomic, assign) CGFloat sectionInsetBottom;
@property (nonatomic, assign) CGFloat sectionInsetRight;
@property (nonatomic, assign) CGFloat minimumLineSpacingUpDown;
@property (nonatomic, assign) CGFloat minimumInteritemSpacingLeftRight;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
///
@property (nonatomic, assign) NSInteger rowCount;

@property (nonatomic, assign) CGFloat cellHeight;
@end


@implementation PNMSStorePhotoCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(16));
    }];

    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(kRealWidth(14));
        make.height.equalTo(@(self.cellHeight));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-PixelOne));
        make.height.mas_equalTo(@(PixelOne));
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark
- (void)setModel:(PNMSStorePhotoModel *)model {
    _model = model;
    if (!WJIsObjectNil(self.model.attrTitle)) {
        self.titleLabel.attributedText = self.model.attrTitle;
    } else {
        self.titleLabel.text = model.title;
    }

    self.subTitleLabel.text = model.subTitle;
    [self.collectionView successGetNewDataWithNoMoreData:NO];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.cellHeight = self.collectionView.contentSize.height;
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)handlerChooseHeadImage {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    SAImageAccessorCompletionBlock block = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if (image) {
            [self uploadImage:image];
        }
    };

    // clang-format off
    HDActionSheetViewButton *takePhotoBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Take_photo", @"立即拍照") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto needCrop:NO completion:block];
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Upload_from_gallery", @"从相册上传") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos needCrop:NO completion:block];
    }];
    // clang-format on
    [sheetView addButtons:@[takePhotoBTN, chooseImageBTN]];
    [sheetView show];
}

- (void)uploadImage:(UIImage *)image {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.viewController.view];

    [self.uploadImageDTO uploadImages:@[image] progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                HDLog(@"结果：%@", imageURLArray.firstObject);
                PNMSStorePhotoItemModel *model = [self.model.imageArray objectAtIndex:self.clickCurrentIndex];
                model.url = imageURLArray.firstObject;
                [self.collectionView successGetNewDataWithNoMoreData:NO];
            }
        });
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        HDLog(@"上传失败error: %@", error);
        [hud hideAnimated:true];
    }];
}

#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNMSStorePhotoItemCell *cell = [PNMSStorePhotoItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    PNMSStorePhotoItemModel *itemModel = [self.model.imageArray objectAtIndex:indexPath.item];
    cell.model = itemModel;

    @HDWeakify(self);
    cell.deleteBlock = ^{
        @HDStrongify(self);
        itemModel.url = @"";
        [self.collectionView successGetNewDataWithNoMoreData:NO];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.clickCurrentIndex = indexPath.item;
    [self handlerChooseHeadImage];
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        //        self.sectionInsetTop = self.sectionInsetBottom = self.sectionInsetLeft = self.sectionInsetRight = 0;
        //        self.minimumLineSpacingUpDown = 10.f;
        //        self.minimumInteritemSpacingLeftRight = 5.f;
        //        self.column = 4;

        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        self.flowLayout.sectionInset = UIEdgeInsetsMake(self.sectionInsetTop, self.sectionInsetLeft, self.sectionInsetBottom, self.sectionInsetRight);
        //        self.flowLayout.minimumLineSpacing = self.minimumLineSpacingUpDown;
        //        self.flowLayout.minimumInteritemSpacing = self.minimumInteritemSpacingLeftRight;
        //        self.collectionViewHeight = self.itemWidth = ((kScreenWidth - 44 - 15 - ((self.column - 1) * self.minimumInteritemSpacingLeftRight)) / self.column);
        self.flowLayout.itemSize = CGSizeMake(kRealWidth(80), kRealWidth(80));
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.backgroundColor;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"ms_shop_photo", @"店铺门头照");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#0052D9"];
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"ms_image_support_formats", @"支持jpg、jpeg、png、bmp格式，不超过5MB");
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _line = view;
    }
    return _line;
}

- (SAImageAccessor *)imageAccessor {
    return _imageAccessor ?: ({ _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.viewController needCrop:true]; });
}

- (PNUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = PNUploadImageDTO.new; });
}

@end
