//
//  TNProductDeliveryIntroductionCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDeliveryIntroductionCell.h"
#import "HDAppTheme+TinhNow.h"
#import <AVKit/AVKit.h>


@interface TNProductDeliveryIntroductionCell ()
/// 标题
@property (strong, nonatomic) HDLabel *titleLB;
/// 文本
@property (strong, nonatomic) HDLabel *contentLB;
/// 视频
@property (strong, nonatomic) UIImageView *videoIV;
/// 播放按钮
@property (strong, nonatomic) UIImageView *playIV;

@end


@implementation TNProductDeliveryIntroductionCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.videoIV];
    [self.videoIV addSubview:self.playIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideoClick:)];
    [self.videoIV addGestureRecognizer:tap];
}
#pragma mark - privite method
- (void)playVideoClick:(UITapGestureRecognizer *)tap {
    //    @"http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4"
    if (HDIsStringEmpty(self.infoModel.overseaVideo.coverUrl)) {
        return;
    }

    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.infoModel.overseaVideo.coverUrl]];
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = player;
    [self.viewController presentViewController:vc animated:YES completion:nil];
}
- (UIImage *)getCoverImageForVideoUrl {
    if (HDIsStringEmpty(self.infoModel.overseaVideo.coverUrl)) {
        return nil;
    }

    NSURL *url = [NSURL URLWithString:self.infoModel.overseaVideo.coverUrl];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef ref = [generate copyCGImageAtTime:time actualTime:NULL error:&error];
    UIImage *coverImage = [[UIImage alloc] initWithCGImage:ref];
    return coverImage;
}
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];
    if (!self.contentLB.isHidden) {
        CGFloat bottomCons = kRealWidth(15);
        if (!HDIsArrayEmpty(self.infoModel.deliverInfoImages)) {
            bottomCons = 0;
        }
        [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLB.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
            if (self.videoIV.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-bottomCons);
            }
        }];
    }
    UIView *lastTopView = self.contentLB.isHidden ? self.titleLB : self.contentLB;
    if (!self.videoIV.isHidden) {
        [self.videoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLB.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.height.mas_equalTo(kScreenWidth * 194 / 345);
            make.top.equalTo(lastTopView.mas_bottom).offset(kRealWidth(10));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
        [self.playIV sizeToFit];
        [self.playIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.videoIV);
        }];
    }
    [super updateConstraints];
}
- (void)setInfoModel:(TNDeliverInfoModel *)infoModel {
    _infoModel = infoModel;
    self.contentLB.text = infoModel.contentText;
    if (!HDIsObjectNil(infoModel.overseaVideo) && HDIsStringNotEmpty(infoModel.overseaVideo.coverUrl)) {
        self.videoIV.hidden = NO;
        if (HDIsStringNotEmpty(infoModel.overseaVideo.cover)) {
            [HDWebImageManager setImageWithURL:infoModel.overseaVideo.cover placeholderImage:nil imageView:self.videoIV];
        } else { //没有封面图就获取首帧图片
            @HDWeakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @HDStrongify(self);
                self.videoIV.image = [self getCoverImageForVideoUrl];
            });
        }
    } else {
        self.videoIV.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
/** @lazy titleLB */
- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[HDLabel alloc] init];
        _titleLB.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLB.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLB.text = TNLocalizedString(@"tn_product_details_saleArea", @"配送");
    }
    return _titleLB;
}
/** @lazy contentLB */
- (HDLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = [[HDLabel alloc] init];
        _contentLB.font = HDAppTheme.TinhNowFont.standard12;
        _contentLB.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
}
/** @lazy videoIV */
- (UIImageView *)videoIV {
    if (!_videoIV) {
        _videoIV = [[UIImageView alloc] init];
        _videoIV.userInteractionEnabled = YES;
        _videoIV.backgroundColor = [UIColor lightGrayColor];
        _videoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _videoIV;
}
/** @lazy playIV */
- (UIImageView *)playIV {
    if (!_playIV) {
        _playIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_video_play"]];
    }
    return _playIV;
}
@end
