//
//  SACMSWaterfallRecommandCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSWaterfallRecommandCollectionViewCell.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDFloatLayoutView.h>
#import <YYText/YYLabel.h>


@interface SACMSWaterfallRecommandCollectionViewCell ()

///< 背景
@property (nonatomic, strong) UIView *container;
///< 阴影
@property (nonatomic, strong) UIView *shadowView;
///< 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
///< 标题
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, assign) CGSize titleSize; ///< 标题大小
///< 视频提示图片
@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) HDFloatLayoutView *floatlayoutView; ///< 标签

@end


@implementation SACMSWaterfallRecommandCollectionViewCell

- (void)hd_setupViews {
    [super hd_setupViews];

    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.container];
    [self.container addSubview:self.coverImageView];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.videoImageView];
    [self.container addSubview:self.floatlayoutView];
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
        //        make.size.mas_equalTo(self.titleSize);
        make.height.mas_equalTo(self.titleSize.height);
        if (self.floatlayoutView.isHidden) {
            make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(8));
        } else {
            make.bottom.equalTo(self.floatlayoutView.mas_top).offset(-kRealHeight(8));
        }
    }];

    if (!self.floatlayoutView.isHidden) {
        [self.floatlayoutView sizeToFit];
        [self.floatlayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.container.mas_left).offset(kRealWidth(8));
            make.right.equalTo(self.container.mas_right).offset(-kRealWidth(8));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(8));
            make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(8));
        }];
    }

    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(SACMSWaterfallCellModel *)model {
    [super setModel:model];

    [HDWebImageManager setImageWithURL:model.cover placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(170, (170 * model.coverHeight) / model.coverWidth)] imageView:self.coverImageView];

    NSMutableAttributedString *titleAttStr = [[NSMutableAttributedString alloc] init];

    if (HDIsStringNotEmpty(model.bizLine) && [model.showBizLine isEqualToString:@"Y"]) {
        SALabel *bizTagLabel = SALabel.new;
        bizTagLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        bizTagLabel.textColor = [UIColor whiteColor];
        bizTagLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#FC2040"];
        bizTagLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);
        bizTagLabel.text = model.bizLine;
        [bizTagLabel sizeToFit];
        [bizTagLabel setRoundedCorners:UIRectCornerAllCorners radius:4.0f];
        [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:bizTagLabel contentMode:UIViewContentModeCenter attachmentSize:bizTagLabel.frame.size
                                                                                          alignToFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]
                                                                                            alignment:YYTextVerticalAlignmentCenter]];
        [titleAttStr yy_appendString:@" "];
    }

    if (HDIsStringNotEmpty(model.price)) {
        SALabel *bizTagLabel = SALabel.new;
        bizTagLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightHeavy];
        bizTagLabel.textColor = HDAppTheme.color.sa_C1;
        bizTagLabel.hd_edgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
        bizTagLabel.text = model.price;
        [bizTagLabel sizeToFit];
        [titleAttStr appendAttributedString:[NSMutableAttributedString yy_attachmentStringWithContent:bizTagLabel contentMode:UIViewContentModeCenter attachmentSize:bizTagLabel.frame.size
                                                                                          alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightHeavy]
                                                                                            alignment:YYTextVerticalAlignmentCenter]];
        [titleAttStr yy_appendString:@" "];
    }

    [titleAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:model.contentTitle attributes:@{
                     NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                     NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#333333"]
                 }]];
    if ([SAMultiLanguageManager isCurrentLanguageCN]) {
        [titleAttStr yy_setLineSpacing:8 range:NSMakeRange(0, titleAttStr.string.length)];
    } else if ([SAMultiLanguageManager isCurrentLanguageKH]) {
        [titleAttStr yy_setLineSpacing:0 range:NSMakeRange(0, titleAttStr.string.length)];
    } else {
        [titleAttStr yy_setLineSpacing:4 range:NSMakeRange(0, titleAttStr.string.length)];
    }

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(model.cellWidth - kRealWidth(16), CGFLOAT_MAX)];
    container.maximumNumberOfRows = 2;
    container.truncationType = YYTextTruncationTypeEnd;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:titleAttStr];

    self.titleLabel.textLayout = layout;
    self.titleSize = layout.textBoundingSize;

    if (HDIsStringNotEmpty(model.videoLink)) {
        self.videoImageView.hidden = NO;
    } else {
        self.videoImageView.hidden = YES;
    }

    [self.floatlayoutView hd_removeAllSubviews];
    for (NSString *tag in model.tags) {
        if (HDIsStringEmpty(tag)) {
            continue;
        }
        SALabel *label = [[SALabel alloc] init];
        label.text = tag;
        label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        label.textColor = [UIColor hd_colorWithHexString:@"#FC2040"];
        label.backgroundColor = [UIColor hd_colorWithHexString:@"#FEF0F2"];
        label.layer.cornerRadius = 4.0f;
        label.hd_edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4.0f];
        };
        [self.floatlayoutView addSubview:label];
    }

    if (self.floatlayoutView.subviews.count) {
        self.floatlayoutView.hidden = NO;
    } else {
        self.floatlayoutView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods

#pragma mark - Action

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
        //        _coverImageView.clipsToBounds = true;
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

- (HDFloatLayoutView *)floatlayoutView {
    if (!_floatlayoutView) {
        _floatlayoutView = [[HDFloatLayoutView alloc] init];
        _floatlayoutView.itemMargins = UIEdgeInsetsMake(4, 4, 0, 0);
    }
    return _floatlayoutView;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_playb"]];
    }
    return _videoImageView;
}

@end
