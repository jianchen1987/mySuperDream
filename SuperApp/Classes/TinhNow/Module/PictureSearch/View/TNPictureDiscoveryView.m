//
//  TNPictureDiscoveryView.m
//  SuperApp
//
//  Created by 张杰 on 2022/1/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNPictureDiscoveryView.h"
#import "SAUploadImageDTO.h"
#import "TNPictureSearchDTO.h"
#import "TNPictureSearchGoodsAlertView.h"
#import <LOTAnimationView.h>


@interface TNPictureDiscoveryView ()
/// 背景图片
@property (strong, nonatomic) UIImageView *backGroundImageView;
/// 遮罩
@property (strong, nonatomic) UIView *maskView;
/// 目标图片
@property (strong, nonatomic) UIImageView *targetImageView;
/// 动画图片
@property (strong, nonatomic) LOTAnimationView *animationImageView;
/// 提示文本
@property (strong, nonatomic) HDLabel *tipsLabel;
/// 关闭
@property (strong, nonatomic) HDUIButton *closeBtn;

/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
///
@property (strong, nonatomic) TNPictureSearchDTO *picSearchDto;
///
@property (strong, nonatomic) TNPictureSearchGoodsAlertView *goodView;
/// 图片地址
@property (nonatomic, copy) NSString *picUrl;

@end


@implementation TNPictureDiscoveryView
- (void)dealloc {
    HDLog(@"回收了");
}
- (void)hd_setupViews {
    [self addSubview:self.backGroundImageView];
    [self.backGroundImageView addSubview:self.maskView];
    [self addSubview:self.targetImageView];
    [self addSubview:self.animationImageView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.closeBtn];

    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.targetImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kNavigationBarH + kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
    }];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.targetImageView.mas_bottom).offset(kRealWidth(60));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(200), kRealWidth(250)));
    }];

    [self.closeBtn sizeToFit];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(18) - kiPhoneXSeriesSafeBottomHeight);
    }];
    [self.tipsLabel sizeToFit];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.closeBtn.mas_top).offset(-kRealWidth(38));
        make.left.equalTo(self.mas_left).offset(kRealWidth(68));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(68));
        //        make.height.mas_equalTo(kRealWidth(35));
    }];
}

- (void)setTargetImage:(id)targetImage {
    _targetImage = targetImage;

    if (self.goodView) {
        [self.goodView removeFromSuperview];
        self.goodView = nil;
    }

    if ([targetImage isKindOfClass:NSString.class]) {
        [self queryProductsWithPicUrl:targetImage];

        [HDWebImageManager setImageWithURL:self.targetImage placeholderImage:nil imageView:self.backGroundImageView];
        [HDWebImageManager setImageWithURL:self.targetImage placeholderImage:nil imageView:self.targetImageView];
    } else {
        [self upLoadImage];

        self.backGroundImageView.image = self.targetImage;
        self.targetImageView.image = self.targetImage;
    }

    self.animationImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    self.closeBtn.hidden = NO;

    [self.animationImageView play];
}
#pragma mark - 上传图片
- (void)upLoadImage {
    @HDWeakify(self);
    [self.uploadImageDTO uploadSingleImage:self.targetImage singleImageLimitedSize:250 progress:^(NSProgress *_Nonnull progress) {
    } success:^(NSString *_Nonnull imageUrl) {
        @HDStrongify(self);
        if (HDIsStringNotEmpty(imageUrl)) {
            [self queryProductsWithPicUrl:imageUrl];
        } else {
            [self showErrorAlert:@"未拿到图片地址"];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self showErrorAlert:[NSString stringWithFormat:@"%@", rspModel.msg]];
    }];
}
#pragma mark -创建搜索任务
- (void)queryProductsWithPicUrl:(NSString *)picUrl {
    self.picUrl = picUrl;
    @HDWeakify(self);
    [self.picSearchDto queryProductSimilarSearchWithPicUrl:picUrl pageNo:1 pageSize:20 success:^(TNPictureSearchRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self showGoodsAlertView:rspModel];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self showErrorAlert:[NSString stringWithFormat:@"%@", rspModel.msg]];
    }];
}
//#pragma mark -查询搜索任务
//- (void)queryPicSearchTask:(NSString *)taskId {
//    @HDWeakify(self);
//    [self.picSearchDto querySimilarSearchJobWithTaskId:taskId
//        success:^(TNPictureSearchRspModel *_Nonnull rspModel) {
//            @HDStrongify(self);
//            if ([rspModel.taskState isEqualToString:TNPictureSearchTaskStateProgressing]) {
//                //隔3s去请求一次吧
//                if (!self.isHidden) {
//                    [self performSelector:@selector(queryPicSearchTask:) withObject:rspModel.taskId afterDelay:3];
//                }
//            } else {
//                //已经有结果了
//                [self showGoodsAlertView:rspModel.products];
//            }
//        }
//        failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
//            @HDStrongify(self);
//            [self showErrorAlert:[NSString stringWithFormat:@"%@", rspModel.msg]];
//        }];
//}

#pragma mark -显示商品视图
- (void)showGoodsAlertView:(TNPictureSearchRspModel *)rspModel {
    [self hiddenAnimation];
    [self layoutIfNeeded];
    self.goodView = [[TNPictureSearchGoodsAlertView alloc] initWithRspModel:rspModel picUrl:self.picUrl];
    @HDWeakify(self);
    self.goodView.dismissCallBack = ^{
        @HDStrongify(self);
        [self dimiss];
    };
    [self.goodView showInView:self aboveView:self.targetImageView];
}

- (void)showErrorAlert:(NSString *)message {
    [self hiddenAnimation];
    @HDWeakify(self);
    [NAT showAlertWithMessage:message buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        [alertView dismiss];
        @HDStrongify(self);
        [self dimiss];
    }];
}

- (void)dimiss {
    !self.dimissCallBack ?: self.dimissCallBack();
    if (self.animationImageView.isAnimationPlaying) {
        [self.animationImageView stop];
    }
    self.hidden = YES;
}
//隐藏动图
- (void)hiddenAnimation {
    [self.animationImageView stop];
    self.animationImageView.hidden = YES;
    self.tipsLabel.hidden = YES;
    self.closeBtn.hidden = YES;
}
/** @lazy backGroundImageView */
- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] init];
        _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backGroundImageView;
}
/** @lazy maskView */
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.80];
    }
    return _maskView;
}
/** @lazy tipsLabel */
- (HDLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[HDLabel alloc] init];
        _tipsLabel.text = TNLocalizedString(@"tn_search_result_time_tips", @"预计10秒识别结果");
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.50];
        _tipsLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 2;
        _tipsLabel.hd_edgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _tipsLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:18];
        };
    }
    return _tipsLabel;
}
/** @lazy targetImageView */
- (UIImageView *)targetImageView {
    if (!_targetImageView) {
        _targetImageView = [[UIImageView alloc] init];
        _targetImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8 borderWidth:2 borderColor:[UIColor whiteColor]];
        };
    }
    return _targetImageView;
}
/** @lazy closeBtn */
- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"tn_picture_search_close"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dimiss];
        }];
    }
    return _closeBtn;
}
/** @lazy animationImageView */
- (LOTAnimationView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [LOTAnimationView animationNamed:@"search"];
        _animationImageView.loopAnimation = YES;
        _animationImageView.cacheEnable = YES;
    }
    return _animationImageView;
}
- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}
- (TNPictureSearchDTO *)picSearchDto {
    return _picSearchDto ?: ({ _picSearchDto = TNPictureSearchDTO.new; });
}

@end
