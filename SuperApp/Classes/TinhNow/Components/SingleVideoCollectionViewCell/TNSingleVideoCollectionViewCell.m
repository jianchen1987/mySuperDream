//
//  TNSingleVideoCollectionViewCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/6/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSingleVideoCollectionViewCell.h"
#import <HDReachability.h>


@implementation TNSingleVideoCollectionViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cornerRadius = 5;
        self.placholderImage = [UIImage imageNamed:@"ic_found_banner_placeholder"];
    }
    return self;
}
@end


@interface TNSingleVideoCollectionViewCell ()
@property (nonatomic, strong) SDAnimatedImageView *videoContentView; ///< 图片
/// 播放按钮
@property (strong, nonatomic) UIImageView *playIV;
@end


@implementation TNSingleVideoCollectionViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.videoContentView];
    [self.videoContentView addSubview:self.playIV];
    [self.videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.playIV sizeToFit];
    [self.playIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContentView);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    [self.videoContentView addGestureRecognizer:tap];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.model.heightFullRounded) {
        // 圆角
        [self setRoundedCorners:UIRectCornerAllCorners radius:CGRectGetHeight(self.frame) * 0.5];
    } else {
        // 圆角
        [self setRoundedCorners:UIRectCornerAllCorners radius:self.model.cornerRadius];
    }
}
- (void)playClick {
    if (self.videoPlayClickCallBack) {
        self.videoPlayClickCallBack([NSURL URLWithString:self.model.videoUrl]);
    }
}
- (void)setAutoPlay {
    HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus == ReachableViaWiFi) {
        if (self.videoAutoPlayCallBack) {
            self.videoAutoPlayCallBack([NSURL URLWithString:self.model.videoUrl]);
        }
    }
}
#pragma mark - getters and setters
- (void)setModel:(TNSingleVideoCollectionViewCellModel *)model {
    _model = model;
    [HDWebImageManager setGIFImageWithURL:model.coverImageUrl placeholderImage:model.placholderImage imageView:self.videoContentView];
    //自动播放  延迟一下
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setAutoPlay];
    });
}
/** @lazy playIV */
- (UIImageView *)playIV {
    if (!_playIV) {
        _playIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_product_video_play"]];
    }
    return _playIV;
}
#pragma mark - lazy load
- (SDAnimatedImageView *)videoContentView {
    if (!_videoContentView) {
        _videoContentView = SDAnimatedImageView.new;
        _videoContentView.contentMode = UIViewContentModeScaleAspectFill;
        _videoContentView.userInteractionEnabled = YES;
    }
    return _videoContentView;
}
@end
