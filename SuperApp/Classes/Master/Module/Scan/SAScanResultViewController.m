//
//  SAScanResultViewController.m
//  SuperApp
//
//  Created by Tia on 2023/4/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAScanResultViewController.h"
#import "SAUploadImageDTO.h"
#import "SAAppEnvManager.h"


@interface SAScanResultViewController ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *normalImgView;
@property (nonatomic, strong) UIImageView *clipImageView;
@property (nonatomic, strong) UIView *bottomView; ///< 底部工具栏
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;

@end


@implementation SAScanResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.hd_navigationItem.title = SALocalizedString(@"ocr_Document_scanning", @"证件扫描");

    [self setupView];
}

#pragma mark - 初始化视图
- (void)setupView {
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.76];
    [self.view addSubview:self.backgroundView];

    [self setupBottomView];

    self.normalImgView = [[UIImageView alloc] init];
    self.normalImgView.contentMode = UIViewContentModeScaleToFill;
    self.normalImgView.clipsToBounds = YES;
    [self.view addSubview:self.normalImgView];

    self.clipImageView = [[UIImageView alloc] init];
    self.clipImageView.contentMode = UIViewContentModeScaleToFill;
    self.clipImageView.clipsToBounds = YES;
    [self.view addSubview:self.clipImageView];

    // layout
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.normalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    [self.clipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scanRetangleRect.origin.y);
        make.left.mas_equalTo(self.scanRetangleRect.origin.x);
        make.width.mas_equalTo(self.scanRetangleRect.size.width);
        make.height.mas_equalTo(self.scanRetangleRect.size.height);
    }];
}

- (void)setupBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];

    UIButton *remakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    remakeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [remakeButton setTitle:SALocalizedString(@"ocr_retake", @"重拍") forState:UIControlStateNormal];
    [remakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [remakeButton addTarget:self action:@selector(didClickRemakeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:remakeButton];

    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [determineButton setTitle:SALocalizedString(@"ocr_Finish", @"完成") forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(didClickDetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:determineButton];

    // layout
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@(100 + kiPhoneXSeriesSafeBottomHeight));
    }];

    [remakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(@0);
        make.width.equalTo(remakeButton.mas_height);
    }];

    [determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(@0);
        make.width.equalTo(determineButton.mas_height);
    }];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - Actions
- (void)didClickRemakeButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SAScanResultControllerClickRemake)]) {
        [self.delegate SAScanResultControllerClickRemake];
    }
}

- (void)didClickDetermineButton:(UIButton *)sender {
    @HDWeakify(self);
    [self showloading];
    [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
        @HDStrongify(self);
        if (imgUrlArray) {
            HDLog(@"%@", imgUrlArray);
            @HDWeakify(self);
            [self ocrWithUrl:imgUrlArray.firstObject withCompletionHandler:^(NSDictionary *d, NSError *error) {
                @HDStrongify(self);
                [self dismissLoading];
                if ([self.delegate respondsToSelector:@selector(SAScanResultControllerClickDetermineWithDic:)]) {
                    NSMutableDictionary *dic = NSMutableDictionary.new;
                    if (!error) {
                        dic[@"data"] = d;
                    }
                    [self.navigationController popViewControllerAnimated:NO];
                    NSData *data = UIImageJPEGRepresentation(self.clipImageView.image, 0.5);
                    NSString *imageBase64Str = [data base64EncodedStringWithOptions:0];
                    dic[@"oriImageData"] = imageBase64Str;
                    [self.delegate SAScanResultControllerClickDetermineWithDic:dic];
                }
            }];
        } else {
            [self dismissLoading];
        }
    }];
}

#pragma mark - public
- (void)setImage:(UIImage *)image {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.normalImgView.hidden = YES;
        self.clipImageView.hidden = NO;
        self.clipImageView.image = image;
    });
}

#pragma mark - private methods
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    if (!self.clipImageView.image)
        return;

    //裁切后的image
    //    UIImage *image = [self cropSquareImage:self.clipImageView.image];

    [self.uploadImageDTO batchUploadImages:@[self.clipImageView.image] singleImageLimitedSize:250 progress:^(NSProgress *_Nonnull progress) {

    } success:^(NSArray *_Nonnull imageURLArray) {
        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !completion ?: completion(nil);
    }];
}

- (UIImage *)cropSquareImage:(UIImage *)image {
    CGImageRef sourceImageRef = [image CGImage]; //将UIImage转换成CGImageRef
    CGFloat imageWidth = image.size.width * image.scale;
    CGFloat imageHeight = image.size.height * image.scale;

    CGFloat heightAspectRatio = 0.63;

    CGRect rect = CGRectMake(0, imageHeight * heightAspectRatio, imageWidth, imageHeight);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect); //按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

    return newImage;
}

- (void)ocrWithUrl:(NSString *)url withCompletionHandler:(void (^)(NSDictionary *dic, NSError *error))completionHandler {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.baseURI = SAAppEnvManager.sharedInstance.appEnvConfig.ocrServer;
    request.requestURI = @"https://ocr.lifekh.com/apis/ocr/upload";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"url"] = url;
    params[@"type"] = @(self.type);
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"%@", response.responseObject);
        NSDictionary *dic = response.responseObject[@"data"];
        if (dic && [dic isKindOfClass:NSDictionary.class]) {
            completionHandler(dic, nil);
        } else {
            completionHandler(nil, NSError.new);
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        completionHandler(nil, NSError.new);
    }];
}


#pragma mark - lazy load
- (SAUploadImageDTO *)uploadImageDTO {
    if (!_uploadImageDTO) {
        _uploadImageDTO = SAUploadImageDTO.new;
        _uploadImageDTO.uploadToBoss = YES;
    }
    return _uploadImageDTO;
}
@end
