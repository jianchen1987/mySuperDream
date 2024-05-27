//
//  PNMSStoreImageTakeView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreImageTakeView.h"


@interface PNMSStoreImageTakeView () <HXPhotoViewDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
/// 上传图片提示
@property (nonatomic, strong) SALabel *uploadTipLabel;
@property (strong, nonatomic) PNPhotoManager *manager;
@property (strong, nonatomic) PNPhotoView *photoView;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
@end


@implementation PNMSStoreImageTakeView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

    [self addSubview:self.titleLabel];
    [self addSubview:self.uploadTipLabel];
    [self addSubview:self.photoView];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
    }];

    [self.uploadTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadTipLabel.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
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
- (PNPhotoManager *)manager {
    if (!_manager) {
        _manager = [[PNPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 30;
    }
    return _manager;
}

- (PNPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [PNPhotoView photoManager:self.manager addViewBackgroundColor:HDAppTheme.PayNowColor.cFFFFFF];
        _photoView.delegate = self;
        _photoView.width = kScreenWidth - kRealWidth(24);
    }
    return _photoView;
}

- (SALabel *)uploadTipLabel {
    if (!_uploadTipLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"pn_upload_store_tips", @"请上传门店照片，每张不超过5MB，最多可上传30张，支持PNG/JPEG/GIF");
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textColor = [UIColor hd_colorWithHexString:@"#0052D9"];
        label.numberOfLines = 0;
        _uploadTipLabel = label;
    }
    return _uploadTipLabel;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"pn_Store_pic", @"门店照片");
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

@end
