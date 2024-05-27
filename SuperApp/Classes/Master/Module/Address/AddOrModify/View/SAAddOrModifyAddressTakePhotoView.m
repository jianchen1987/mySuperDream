//
//  SAAddOrModifyAddressTakePhotoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressTakePhotoView.h"


@interface SAAddOrModifyAddressTakePhotoView () <HXPhotoViewDelegate>
/// 上传图片提示
@property (nonatomic, strong) SALabel *uploadTipLabel;
@property (strong, nonatomic) SAPhotoManager *manager;
@property (strong, nonatomic) SAPhotoView *photoView;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
@end


@implementation SAAddOrModifyAddressTakePhotoView

- (void)hd_setupViews {
    [self addSubview:self.uploadTipLabel];
    [self addSubview:self.photoView];

    [self.uploadTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(15));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    }];

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadTipLabel.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self).offset(-kRealWidth(15));
    }];

    [self.photoView.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoView);
    }];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    self.selectedPhotos = photos;
    [self.selectedPhotos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    [UIView animateWithDuration:0.25 animations:^{
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(frame.size.height);
        }];
        [self layoutIfNeeded];
    }];
}

#pragma mark - setter
- (void)setImageURLs:(NSArray<NSString *> *)imageURLs {
    _imageURLs = imageURLs;

    if (!HDIsArrayEmpty(imageURLs)) {
        // 图片
        NSArray<HXCustomAssetModel *> *images = [imageURLs mapObjectsUsingBlock:^id _Nonnull(NSString *_Nonnull obj, NSUInteger idx) {
            return [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:obj] selected:true];
        }];

        [self.manager addCustomAssetModel:images];
        [self.photoView refreshView];
    }
}

#pragma mark - lazy load
- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
        _photoView.width = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    }
    return _photoView;
}

- (SALabel *)uploadTipLabel {
    if (!_uploadTipLabel) {
        SALabel *label = SALabel.new;
        NSString *maxCount = [NSString stringWithFormat:SALocalizedString(@"max_count_some", @"Up to %zd"), 5];
        label.text = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"environment_picture", @"环境照片"), maxCount];
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _uploadTipLabel = label;
    }
    return _uploadTipLabel;
}
@end
