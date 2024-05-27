//
//  SAImageAccessor.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAImageAccessor.h"
#import "HDTakingPhotoViewController.h"
#import "SAMultiLanguageManager.h"
#import "SAPhotoManager.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIViewController+HDKitCore.h>
#import <HDUIKit/HDAppTheme.h>
#import <HDUIKit/HDImageCropper.h>
#import <HDUIKit/NAT.h>


@interface SAImageAccessor () <HDImageCropViewControllerDelegate, HDImageCropViewControllerDataSource>
/// 控制器
@property (nonatomic, strong) UIViewController *viewController;
/// 是否要裁剪
@property (nonatomic, assign) BOOL needCrop;
@property (nonatomic, assign) SAImageCropMode cropMode;
/// 回调
@property (nonatomic, copy) SAImageAccessorCompletionBlock completionBlock;
@property (nonatomic, copy) SAImageAccessorMultiImageCompletionBlock multiImageCompletionBlock;
@property (strong, nonatomic) SAPhotoManager *manager;
@end


@implementation SAImageAccessor
- (instancetype)initWithSourceViewController:(UIViewController *)viewController needCrop:(BOOL)needCrop {
    if (self = [super init]) {
        self.viewController = viewController;
        self.needCrop = needCrop;
        self.cropMode = SAImageCropModeCircle;
    }
    return self;
}

- (void)fetchImageWithType:(SAImageAccessorType)type needCrop:(BOOL)needCrop completion:(SAImageAccessorCompletionBlock)completionBlock {
    self.needCrop = needCrop;
    self.completionBlock = completionBlock;
    [self fetchImageWithType:type maxImageCount:1 completion:nil];
}

- (void)fetchImageWithType:(SAImageAccessorType)type cropMode:(SAImageCropMode)cropMode completion:(SAImageAccessorCompletionBlock)completionBlock {
    self.needCrop = YES;
    self.completionBlock = completionBlock;
    self.cropMode = cropMode;
    [self fetchImageWithType:type maxImageCount:1 completion:nil];
}

- (void)fetchImageWithType:(SAImageAccessorType)type completion:(SAImageAccessorCompletionBlock)completionBlock {
    self.completionBlock = completionBlock;
    self.cropMode = SAImageCropModeCircle;
    [self fetchImageWithType:type maxImageCount:1 completion:nil];
}

- (void)fetchImageWithType:(SAImageAccessorType)type maxImageCount:(NSUInteger)maxImageCount completion:(SAImageAccessorMultiImageCompletionBlock)multiImageCompletionBlock {
    if (maxImageCount > 1) {
        type = SAImageAccessorTypeBrowserPhotos;
    }

    self.multiImageCompletionBlock = multiImageCompletionBlock;

    UIViewController *viewController = self.viewController ? self.viewController : SAWindowManager.visibleViewController;

    @HDWeakify(self);
    if (type == SAImageAccessorTypeTakingPhoto) {
        HDTakingPhotoViewController *vc = [[HDTakingPhotoViewController alloc] init];
        HDTakingPhotoViewConfig *config = [[HDTakingPhotoViewConfig alloc] init];
        config.showFocusFrame = true;
        vc.config = config;
        vc.choosedImageBlock = ^(UIImage *_Nullable image, NSError *_Nullable error) {
            @HDStrongify(self);
            if (!error) {
                [viewController.view showloading];
                if (self.needCrop) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [viewController.view dismissLoading];
                        HDImageCropViewController *imageCropVC = [[HDImageCropViewController alloc] initWithImage:image cropMode:[self imageCropModel]];
                        imageCropVC.delegate = self;
                        imageCropVC.dataSource = self;
                        [viewController presentViewController:imageCropVC animated:true completion:nil];
                    });
                } else {
                    [viewController.view dismissLoading];
                    [self adjustInvokeBlockWithImage:image error:error];
                }
            } else {
                [self adjustInvokeBlockWithImage:nil error:error];
            }
        };
        [viewController presentViewController:vc animated:YES completion:nil];
    } else if (type == SAImageAccessorTypeBrowserPhotos) {
        self.manager.configuration.singleSelected = maxImageCount <= 1;
        self.manager.configuration.photoMaxNum = maxImageCount;
        [viewController hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList,
                                                                                          NSArray<HXPhotoModel *> *photoList,
                                                                                          NSArray<HXPhotoModel *> *videoList,
                                                                                          BOOL isOriginal,
                                                                                          UIViewController *hdViewController,
                                                                                          HXPhotoManager *manager) {
            @HDStrongify(self);
            NSMutableArray<UIImage *> *resultImageList = [NSMutableArray arrayWithCapacity:photoList.count];
            [self requestPreviewImageList:photoList resultImageList:resultImageList index:0 completion:^{
                @HDStrongify(self);
                if (self.needCrop) {
                    HDImageCropViewController *imageCropVC = [[HDImageCropViewController alloc] initWithImage:resultImageList.firstObject cropMode:[self imageCropModel]];
                    imageCropVC.delegate = self;
                    imageCropVC.dataSource = self;
                    [viewController presentViewController:imageCropVC animated:true completion:nil];
                } else {
                    !self.completionBlock ?: self.completionBlock(resultImageList.firstObject, nil);
                    !self.multiImageCompletionBlock ?: self.multiImageCompletionBlock(resultImageList, nil);
                }
            }];
        } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
            @HDStrongify(self);
            [self adjustInvokeBlockWithImage:nil error:[NSError errorWithDomain:@"user reject" code:-1 userInfo:nil]];
        }];
    }
}

/// 转换成 HDImageCropViewController 的裁剪枚举
- (HDImageCropMode)imageCropModel {
    if (self.cropMode == SAImageCropModeCircle) {
        return HDImageCropModeCircle;
    } else if (self.cropMode == SAImageCropModeSquare) {
        return HDImageCropModeSquare;
    } else {
        return HDImageCropModeCustom;
    }
}

- (void)requestPreviewImageList:(NSArray<HXPhotoModel *> *)list resultImageList:(NSMutableArray<UIImage *> *)resultImageList index:(NSUInteger)index completion:(void (^)(void))completion {
    if (index >= list.count) {
        !completion ?: completion();
        return;
    }
    @HDWeakify(self);
    HXPhotoModel *model = list[index];
    if (model.subType == HXPhotoModelMediaSubTypePhoto) {
        @HDStrongify(self);
        [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
            // 下一个
            const NSUInteger newIndex = index + 1;
            [resultImageList addObject:image];
            [self requestPreviewImageList:list resultImageList:resultImageList index:newIndex completion:completion];
        } failed:^(NSDictionary *info, HXPhotoModel *model) {
            // 下一个
            const NSUInteger newIndex = index + 1;
            [self requestPreviewImageList:list resultImageList:resultImageList index:newIndex completion:completion];
        }];
    }
}

#pragma mark - private methods
- (void)adjustInvokeBlockWithImage:(UIImage *)image error:(NSError *)error {
    !self.completionBlock ?: self.completionBlock(image, error);
    !self.multiImageCompletionBlock ?: self.multiImageCompletionBlock(image ? @[image] : nil, error);
}

#pragma mark - HDImageCropViewControllerDataSource
/// 自定义 rect
- (CGRect)imageCropViewControllerCustomMaskRect:(HDImageCropViewController *)controller {
    CGFloat viewWidth = kScreenWidth;
    CGFloat viewHeight = kScreenHeight;

    CGFloat length;
    length = MIN(viewWidth, viewHeight) - 20 * 2;

    CGSize maskSize = CGSizeMake(length, length - 80);

    return CGRectMake((viewWidth - maskSize.width) * 0.5f, (viewHeight - maskSize.height) * 0.5f, maskSize.width, maskSize.height);
}

/// 可移动区域
- (CGRect)imageCropViewControllerCustomMovementRect:(HDImageCropViewController *)controller {
    CGFloat viewWidth = kScreenWidth;
    CGFloat viewHeight = kScreenHeight;

    CGFloat length;
    length = MIN(viewWidth, viewHeight) - 20 * 2;

    CGSize maskSize = CGSizeMake(length, length - 80);

    return CGRectMake((viewWidth - maskSize.width) * 0.5f, (viewHeight - maskSize.height) * 0.5f, maskSize.width, maskSize.height);
}

/// 指定贝塞尔曲线
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(HDImageCropViewController *)controller {
    CGFloat width = SCREEN_WIDTH - 40;
    CGFloat height = 0;
    if (self.cropMode == SAImageCropMode16To9) {
        height = width * 9 / 16.f;
    } else {
        height = width * 3 / 4.f;
    }
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectMake(20, (kScreenHeight - height) / 2, width, height)];
    return clipPath;
}

#pragma mark - HDImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(HDImageCropViewController *)controller {
    [self adjustInvokeBlockWithImage:nil error:[NSError errorWithDomain:@"user cancel crop" code:-1 userInfo:nil]];
    [controller dismissAnimated:true completion:nil];
}

- (void)imageCropViewController:(HDImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    [self adjustInvokeBlockWithImage:croppedImage error:nil];
    [controller dismissAnimated:true completion:nil];
}

- (NSString *)localizedTitleForChooseButton {
    return SALocalizedString(@"sa_choose", @"选择");
}

- (NSString *)localizedTitleForCancelButton {
    return SALocalizedString(@"cancel", @"取消");
}

#pragma mark - lazy load
- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.singleSelected = true;
    }
    return _manager;
}
@end
