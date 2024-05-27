//
//  SAMarketingAlertViewCollectionCell.m
//  SuperApp
//
//  Created by seeu on 2023/10/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMarketingAlertViewCollectionCell.h"
#import "SALotAnimationView.h"


@interface SAMarketingAlertViewCollectionCell ()
///<
@property (nonatomic, strong) SDAnimatedImageView *imageView;
///<
@property (nonatomic, strong) SALotAnimationView *lotAnimationView;
@end

@implementation SAMarketingAlertViewCollectionCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.lotAnimationView];
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
    }];
    [self.lotAnimationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}


- (void)setModel:(SAMarketingAlertItem *)model {
    _model = model;
    
    
    self.imageView.hidden = false;
    self.lotAnimationView.hidden = true;
    [self.lotAnimationView stop];
    
    if ([model.popImage hasSuffix:@"json"]) {
        self.imageView.hidden = true;
        self.lotAnimationView.hidden = false;
        [self.lotAnimationView setAnimationFromURL:model.popImage];
        [self.lotAnimationView play];
    } else {
        [HDWebImageManager setImageWithURL:model.popImage
                          placeholderImage:nil
                                 imageView:self.imageView
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
            if (error || !image) {
                self.imageView.image = [HDHelper placeholderImageWithBgColor:UIColor.whiteColor
                                                                cornerRadius:10
                                                                        size:CGSizeMake(300, 300)
                                                                   logoImage:[UIImage imageNamed:@"sa_placeholder_error"]
                                                                    logoSize:CGSizeMake(166, 120)];
            }
        }];
    }
    
    [self setNeedsUpdateConstraints];
}

///** @lazy imageView */
//
- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = SDAnimatedImageView.new;
        _imageView.runLoopMode = NSRunLoopCommonModes;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImage)];
//        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (SALotAnimationView *)lotAnimationView {
    if (!_lotAnimationView) {
        _lotAnimationView = [SALotAnimationView new];
        _lotAnimationView.userInteractionEnabled = YES;
        _lotAnimationView.hidden = true;
        _lotAnimationView.loopAnimation = YES; //无限循环
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnImage)];
//        [_lotAnimationView addGestureRecognizer:tap];
    }
    return _lotAnimationView;
}

@end
