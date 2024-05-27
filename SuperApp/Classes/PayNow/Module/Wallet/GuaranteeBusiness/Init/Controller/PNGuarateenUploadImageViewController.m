//
//  PNGuarateenUploadImageViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGuarateenUploadImageViewController.h"
#import "PNGuarateenUploadImageView.h"
#import "PNUploadImageDTO.h"


@interface PNGuarateenUploadImageViewController ()
@property (nonatomic, strong) PNGuarateenUploadImageView *contentView;
@property (nonatomic, strong) HDUIButton *doneBtn;
@property (nonatomic, strong) PNUploadImageDTO *uploadDTO;
@property (nonatomic, copy) void (^completion)(NSArray *imageURLs);
@end


@implementation PNGuarateenUploadImageViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.contentView.imageURLs = [parameters objectForKey:@"imageURLs"];
        self.completion = [parameters objectForKey:@"completion"];
    }
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    //    self.hd_navRightBarButtonItems = @[ [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn] ];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"rZ4MZvCF", @"上传附件");
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.contentView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    [self.uploadDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [hud hideAnimated:YES];
    }];
}

- (void)clickDoneAction {
    if (self.contentView.selectedPhotos.count > 0) {
        [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            HDLog(@"%@", imgUrlArray);
            !self.completion ?: self.completion(imgUrlArray);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark
- (PNGuarateenUploadImageView *)contentView {
    if (!_contentView) {
        _contentView = [[PNGuarateenUploadImageView alloc] init];

        @HDWeakify(self);
        _contentView.doneBlock = ^{
            @HDStrongify(self);
            [self clickDoneAction];
        };
    }
    return _contentView;
}

- (PNUploadImageDTO *)uploadDTO {
    if (!_uploadDTO) {
        _uploadDTO = [[PNUploadImageDTO alloc] init];
    }
    return _uploadDTO;
}

//- (HDUIButton *)doneBtn {
//    if (!_doneBtn) {
//        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:0];
//        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
//        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
//        [button addTarget:self action:@selector(clickDoneAction) forControlEvents:UIControlEventTouchUpInside];
//
//        _doneBtn = button;
//    }
//    return _doneBtn;
//}

@end
