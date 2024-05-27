//
//  PNUploadInfoView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadInfoView.h"
#import "PNUploadImageDTO.h"
#import "PNUtilMacro.h"


@interface PNUploadInfoView ()

@property (nonatomic, strong) SAImageAccessor *imageAccessor;

@property (nonatomic, strong) PNUploadImageDTO *uploadImageDTO;
@end


@implementation PNUploadInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.needCrop = YES;
        self.cropMode = SAImageCropModeSquare;
    }
    return self;
}

- (void)setModel:(PNInfoViewModel *)model {
    [super setModel:model];

    @HDWeakify(self);
    self.model.eventHandler = ^{
        @HDStrongify(self);
        HDLog(@"click upload %@", self.model.keyText);
        [self handlerChooseHeadImage];
    };
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
        if (self.needCrop) {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto cropMode:self.cropMode completion:block];
        } else {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto needCrop:self.needCrop completion:block];
        }
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Upload_from_gallery", @"从相册上传") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        if (self.needCrop) {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos cropMode:self.cropMode completion:block];
        } else {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos needCrop:self.needCrop completion:block];
        }
    }];
    
    NSMutableArray *buttonArr = [NSMutableArray arrayWithObjects:takePhotoBTN, chooseImageBTN, nil];
    if (self.isCanSelectDefaultPhoto) {
        HDActionSheetViewButton *defaultImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"pn_use_default_photo", @"使用默认照片") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
            [sheetView dismiss];
            !self.uploadInfoBlock ?: self.uploadInfoBlock(PN_Default_Photo_URL);
        }];
        [buttonArr addObject:defaultImageBTN];
    }

    // clang-format on
    [sheetView addButtons:buttonArr];
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
                !self.uploadInfoBlock ?: self.uploadInfoBlock(imageURLArray.firstObject);
            }
        });
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        HDLog(@"上传失败error: %@", error);
        [hud hideAnimated:true];
    }];
}

#pragma mark
- (SAImageAccessor *)imageAccessor {
    return _imageAccessor ?: ({ _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.viewController needCrop:true]; });
}

- (PNUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = PNUploadImageDTO.new; });
}
@end
