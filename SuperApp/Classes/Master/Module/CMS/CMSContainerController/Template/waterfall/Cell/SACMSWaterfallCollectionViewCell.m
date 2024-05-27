//
//  SACMSWaterfallCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/2/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallCollectionViewCell.h"
#import "NSDate+SAExtension.h"
#import "SADiscoveryDTO.h"
#import "SAOperationButton.h"
#import "SAUser.h"


@interface SACMSWaterfallCollectionViewCell ()
///< 背景
@property (nonatomic, strong) UIView *container;
///< 阴影
@property (nonatomic, strong) UIView *shadowView;
///< 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
///< 标题
@property (nonatomic, strong) YYLabel *titleLabel;
///< 标题大小
@property (nonatomic, assign) CGSize titleSize;
///< 日期
@property (nonatomic, strong) UILabel *dateLabel;
///< 视频提示图片
@property (nonatomic, strong) UIImageView *videoImageView;
///< 点赞容器
@property (nonatomic, strong) UIView *likeContainer;
///< 点赞图标
@property (nonatomic, strong) UIImageView *likeImageView;
///< 点赞数字
@property (nonatomic, strong) UILabel *likeCountLabel;
/// 是否正在点赞上传中
@property (nonatomic) BOOL isLiking;

@end


@implementation SACMSWaterfallCollectionViewCell

- (void)hd_setupViews {
    [super hd_setupViews];

    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.container];
    [self.container addSubview:self.coverImageView];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.dateLabel];
    //    [self.container addSubview:self.tagButton];
    [self.container addSubview:self.videoImageView];
    //    [self.container addSubview:self.likeButton];
    [self.container addSubview:self.likeContainer];
    [self.likeContainer addSubview:self.likeImageView];
    [self.likeContainer addSubview:self.likeCountLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnLike:)];
    [self.likeContainer addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];

    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.container);
        make.height.equalTo(self.coverImageView.mas_width).multipliedBy(self.model.coverHeight / self.model.coverWidth);
    }];

    if (!self.videoImageView.isHidden) {
        [self.videoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
            make.top.equalTo(self.coverImageView.mas_top).offset(kRealWidth(8));
            make.right.equalTo(self.coverImageView.mas_right).offset(-kRealWidth(8));
        }];
    }

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(8));
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(8));
        make.top.equalTo(self.coverImageView.mas_bottom).offset(kRealHeight(8));
        make.height.mas_equalTo(self.titleSize.height);
    }];

    [self.dateLabel sizeToFit];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.container.mas_left).offset(kRealWidth(8));
        make.right.lessThanOrEqualTo(self.likeContainer.mas_left).offset(-kRealWidth(8));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(8));
        make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(8));
    }];

    [self.likeContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(8));
        make.centerY.equalTo(self.dateLabel.mas_centerY);
    }];

    [self.likeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeContainer.mas_left).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.likeContainer.mas_top).offset(20);
        make.bottom.equalTo(self.likeContainer.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
        if (self.likeCountLabel.isHidden) {
            make.right.equalTo(self.likeContainer.mas_right);
        }
    }];

    if (!self.likeCountLabel.isHidden) {
        [self.likeCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.likeContainer.mas_right);
            make.centerY.equalTo(self.likeImageView.mas_centerY);
            make.left.equalTo(self.likeImageView.mas_right).offset(2);
            make.width.mas_greaterThanOrEqualTo(kRealWidth(10));
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(SACMSWaterfallCellModel *)model {
    [super setModel:model];

    [HDWebImageManager setImageWithURL:model.cover placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(170, (170 * model.coverHeight) / model.coverWidth)] imageView:self.coverImageView];

    self.titleLabel.text = model.contentTitle;
    self.dateLabel.text = [[NSDate dateWithTimeIntervalSince1970:model.publishTime / 1000.0f] stringWithFormatStr:@"dd/MM/yyyy HH:mm"];

    NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] init];
    if (!HDIsArrayEmpty(model.contentTags)) {
        SAOperationButton *tb = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [tb applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FC2040"]];
        [tb setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        tb.titleLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        [tb setImage:[UIImage imageNamed:@"discover_tag_hot"] forState:UIControlStateNormal];
        [tb setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 0)];
        [tb setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 4)];
        tb.cornerRadius = 4.0f;
        tb.userInteractionEnabled = NO;
        [tb setTitle:model.contentTags.firstObject forState:UIControlStateNormal];
        [tb sizeToFit];
        [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:tb contentMode:UIViewContentModeCenter attachmentSize:tb.frame.size
                                                                                          alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]
                                                                                            alignment:YYTextVerticalAlignmentCenter]];
        [titleAttStr yy_appendString:@" "];
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;

    [titleAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.contentTitle attributes:@{
                     NSFontAttributeName: [UIFont systemFontOfSize:14],
                     NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#333333"],
                     NSParagraphStyleAttributeName: paragraphStyle
                 }]];

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(model.cellWidth - kRealWidth(16), CGFLOAT_MAX)];
    container.maximumNumberOfRows = 3;
    container.truncationType = YYTextTruncationTypeEnd;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:titleAttStr];

    self.titleLabel.textLayout = layout;
    self.titleSize = layout.textBoundingSize;

    if (HDIsStringNotEmpty(model.videoLink)) {
        self.videoImageView.hidden = NO;
    } else {
        self.videoImageView.hidden = YES;
    }

    self.likeImageView.image = model.hasLike ? [UIImage imageNamed:@"discover_like_selected"] : [UIImage imageNamed:@"discover_like_normal"];
    [self updateLikeCount:model.statistics.likeCount.integerValue];

    self.isLiking = NO;

    [self setNeedsUpdateConstraints];
}

#pragma mark - Action
- (void)clickedOnLike:(UITapGestureRecognizer *)tap {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    if (self.isLiking)
        return;

    self.isLiking = YES;
    @HDWeakify(self);
    if (self.model.hasLike) {
        [SADiscoveryDTO unlikeContentWithContentId:self.model.contentNo success:^{
            @HDStrongify(self);
            self.isLiking = NO;
            self.model.hasLike = NO;
            self.likeImageView.image = [UIImage imageNamed:@"discover_like_normal"];
            [self.likeImageView.layer addAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@1.3] forKey:nil];

            [self updateLikeCount:self.model.statistics.likeCount.integerValue - 1];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.isLiking = NO;
        }];
    } else {
        [SADiscoveryDTO likeContentWithContentId:self.model.contentNo taskId:self.model.taskId success:^{
            @HDStrongify(self);
            self.isLiking = NO;
            self.model.hasLike = YES;
            self.likeImageView.image = [UIImage imageNamed:@"discover_like_selected"];
            [self.likeImageView.layer addAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@1.3] forKey:nil];
            [self updateLikeCount:self.model.statistics.likeCount.integerValue + 1];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            self.isLiking = NO;
        }];
    }
}

- (void)updateLikeCount:(NSInteger)count {
    if (count > 0) {
        self.likeCountLabel.hidden = NO;
        if (count > 999999) {
            self.likeCountLabel.text = [NSString stringWithFormat:@"%0.1fm", count / 1000000.0];
        } else if (count > 999) {
            self.likeCountLabel.text = [NSString stringWithFormat:@"%0.1fk", count / 1000.0];
        } else {
            self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", count];
        }
    } else {
        self.likeCountLabel.hidden = YES;
    }
    self.model.statistics.likeCount = @(count);
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        _container.backgroundColor = UIColor.whiteColor;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
        };
    }

    return _container;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = UIView.new;
        _shadowView.backgroundColor = UIColor.whiteColor;
        _shadowView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (!CGRectEqualToRect(precedingFrame, CGRectZero)) {
                view.layer.cornerRadius = 10;
                view.layer.shadowColor = HDAppTheme.color.G4.CGColor;
                view.layer.shadowRadius = 5;
                view.layer.shadowOffset = CGSizeMake(0, 0);
                view.layer.shadowOpacity = 1;
            }
        };
    }
    return _shadowView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = true;
    }
    return _coverImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        label.numberOfLines = 3;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 1;
        _dateLabel = label;
    }
    return _dateLabel;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_playb"]];
    }
    return _videoImageView;
}

- (UIView *)likeContainer {
    if (!_likeContainer) {
        _likeContainer = UIView.new;
    }
    return _likeContainer;
}

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = UIImageView.new;
    }
    return _likeImageView;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont systemFontOfSize:12];
        _likeCountLabel.textColor = [UIColor hd_colorWithHexString:@"#999999"];
    }
    return _likeCountLabel;
}

@end
