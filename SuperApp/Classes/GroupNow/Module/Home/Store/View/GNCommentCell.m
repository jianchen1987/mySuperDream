//
//  GNCommentCell.m
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentCell.h"
#import "GNImageTableViewCell.h"
#import "GNStarView.h"
#import "GNStringUntils.h"
#import "SAGeneralUtil.h"
#import "YBImageBrowser.h"


@interface GNCommentCell ()
/// ICON
@property (nonatomic, strong) UIImageView *iconIV;
/// name
@property (nonatomic, strong) HDLabel *nameLB;
/// 日期
@property (nonatomic, strong) HDLabel *dateLB;
/// 评分
@property (nonatomic, strong) GNStarView *serviceScoreStarView;
/// 内容
@property (nonatomic, strong) YYLabel *contentLB;
/// 图片视图
@property (nonatomic, strong) UIView *imageContainerView;
/// 图片数组
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageArr;
/// product
@property (nonatomic, strong) HDLabel *productLB;
/// bg
@property (nonatomic, strong) YYLabel *replayLB;

@end


@implementation GNCommentCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.dateLB];
    [self.contentView addSubview:self.serviceScoreStarView];
    [self.contentView addSubview:self.contentLB];
    [self.contentView addSubview:self.productLB];
    [self.contentView addSubview:self.replayLB];
    for (int i = 0; i < 9; i++) {
        UIImageView *tempImageView = [UIImageView new];
        tempImageView.hidden = YES;
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = YES;
        tempImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheImageView:)];
        [tempImageView addGestureRecognizer:tap];
        [self.imageContainerView addSubview:tempImageView];
        [self.imageArr addObject:tempImageView];
    }
    [self.contentView addSubview:self.imageContainerView];

    self.productLB.userInteractionEnabled = YES;
    UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productAction:)];
    [self.productLB addGestureRecognizer:ta];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
        make.top.mas_equalTo(kRealWidth(16));
        make.left.mas_equalTo(kRealWidth(12));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_top).offset(kRealWidth(2));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.height.mas_equalTo(kRealWidth(20));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.dateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(-kRealWidth(2));
        make.left.right.equalTo(self.nameLB);
        make.height.mas_equalTo(kRealWidth(16));
    }];

    [self.serviceScoreStarView sizeToFit];
    [self.serviceScoreStarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV);
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(4));
        make.height.mas_equalTo(self.serviceScoreStarView.textLayout.textBoundingSize.height);
    }];

    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceScoreStarView.mas_bottom).offset(kRealWidth(8));
        make.right.equalTo(self.nameLB);
        make.left.equalTo(self.iconIV);
        if (self.replayLB.hidden && self.productLB.hidden && self.imageContainerView.hidden)
            make.bottom.mas_equalTo(-kRealWidth(16));
    }];

    UIView *temp = self.contentLB;

    [self.imageContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageContainerView.hidden) {
            make.top.equalTo(temp.mas_bottom).offset(kRealWidth(8));
            make.left.right.equalTo(self.contentLB);
            make.height.mas_equalTo(self.model.height);
            if (self.replayLB.hidden && self.productLB.hidden) {
                make.bottom.mas_equalTo(-kRealWidth(16));
            }
        }
    }];

    [self.productLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.productLB.hidden) {
            if (!self.imageContainerView.hidden) {
                make.top.equalTo(self.imageContainerView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(temp.mas_bottom).offset(kRealWidth(8));
            }
            make.left.equalTo(self.contentLB);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - kRealWidth(24));
            if (self.replayLB.hidden) {
                make.bottom.mas_equalTo(-kRealWidth(16));
            }
        }
    }];

    [self.replayLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.replayLB.hidden) {
            if (!self.productLB.hidden) {
                make.top.equalTo(self.productLB.mas_bottom).offset(kRealWidth(8));
            } else {
                if (!self.imageContainerView.hidden) {
                    make.top.equalTo(self.imageContainerView.mas_bottom).offset(kRealWidth(8));
                } else {
                    make.top.equalTo(temp.mas_bottom).offset(kRealWidth(8));
                }
            }
            make.left.right.equalTo(self.contentLB);
            make.bottom.mas_equalTo(-kRealWidth(16));
        }
    }];

    [super updateConstraints];
}

- (void)productAction:(UITapGestureRecognizer *)ta {
    [GNEvent eventResponder:self target:self.productLB key:@"commentProduct" indexPath:nil info:@{@"data": self.model.productInfo}];
}

- (void)setGNModel:(GNCommentModel *)data {
    if ([data isKindOfClass:GNCommentModel.class]) {
        self.model = data;
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.customerHeadPhoto] placeholderImage:HDHelper.placeholderImage];
        self.nameLB.text = data.customerNameStr;
        self.serviceScoreStarView.score = data.reviewScore;

        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(data.reviewContent)];
        mstr.yy_font = [HDAppTheme.font gn_ForSize:14];
        mstr.yy_color = HDAppTheme.color.gn_333Color;
        mstr.yy_lineSpacing = kRealWidth(5);
        self.contentLB.numberOfLines = data.isSelected ? 0 : 4;
        self.contentLB.attributedText = mstr;
        self.dateLB.text = data.createTime ? [SAGeneralUtil getDateStrWithTimeInterval:data.createTime / 1000 format:@"dd/MM/yyyy"] : @" ";
        UIImageView *lastImageView = nil;
        CGFloat itemW = floor((kScreenWidth - kRealWidth(34)) / 3.0);
        CGFloat itemH = itemW;
        NSInteger count = self.imageArr.count;
        NSInteger currentCount = data.dataSource.count;
        for (NSInteger i = currentCount; i < count; i++) {
            self.imageArr[i].hidden = YES;
        }
        for (NSInteger i = 0; i < currentCount; i++) {
            id model = data.dataSource[i];
            UIImageView *imageView = self.imageArr[i];
            imageView.hidden = NO;
            if ([model isKindOfClass:NSString.class]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:model] placeholderImage:HDHelper.placeholderImage];
            }
            [imageView setTag:10000 + i];
            NSInteger section = (i + 1) % 3;
            CGRect rect = CGRectZero;
            if (!lastImageView) {
                rect = CGRectMake(0, 0, itemW, itemH);
            } else {
                if (section == 1) {
                    rect = CGRectMake(0, CGRectGetMaxY(lastImageView.frame) + kRealWidth(8), itemW, itemH);
                } else {
                    rect = CGRectMake(CGRectGetMaxX(lastImageView.frame) + kRealWidth(8), CGRectGetMinY(lastImageView.frame), itemW, itemH);
                }
            }
            imageView.frame = rect;
            lastImageView = imageView;
        }

        self.model.height = CGRectGetMaxY(lastImageView.frame);
        NSMutableAttributedString *productStr = [[NSMutableAttributedString alloc]
            initWithString:[NSString
                               stringWithFormat:@"%@：%@  %@", GNLocalizedString(@"gn_consumed", @"已消费"), GNFillEmptySpace(data.productInfo.name.desc), GNFillMonEmpty(data.productInfo.price)]];
        [GNStringUntils attributedString:productStr color:HDAppTheme.color.gn_666Color colorRange:productStr.string font:[HDAppTheme.font gn_ForSize:12] fontRange:productStr.string];
        self.productLB.attributedText = productStr;
        if (!HDIsArrayEmpty(data.reply)) {
            GNReviewModel *replyModel = data.reply.firstObject;
            NSMutableAttributedString *replyNameMstr = [[NSMutableAttributedString alloc] initWithString:[GNLocalizedString(@"gn_merchant_reply", @"商家回复") stringByAppendingString:@"："]];
            replyNameMstr.yy_font = [HDAppTheme.font gn_ForSize:12];
            replyNameMstr.yy_color = HDAppTheme.color.gn_mainColor;
            replyNameMstr.yy_lineSpacing = kRealWidth(4);

            NSMutableAttributedString *replyMstr = [[NSMutableAttributedString alloc] initWithString:GNFillEmpty(replyModel.replyContent)];
            replyMstr.yy_font = [HDAppTheme.font gn_ForSize:12];
            replyMstr.yy_color = HDAppTheme.color.gn_333Color;
            replyMstr.yy_lineSpacing = kRealWidth(4);
            [replyNameMstr appendAttributedString:replyMstr];
            self.replayLB.numberOfLines = replyModel.isSelected ? 0 : 2;
            self.replayLB.attributedText = replyNameMstr;
        }

        if (self.model.imageHide) {
            self.imageContainerView.hidden = YES;
        } else {
            self.imageContainerView.hidden = !self.model.dataSource.count;
        }

        if (self.model.imageLeft) {
            self.replayLB.hidden = YES;
        } else {
            self.replayLB.hidden = !self.model.reply.count;
        }

        if (self.model.leftHigh) {
            self.productLB.hidden = YES;
        } else {
            self.productLB.hidden = !self.model.productInfo;
        }

        [self setNeedsUpdateConstraints];
    }
}

- (void)showIndex:(NSInteger)index {
    NSMutableArray<YBIBImageData *> *marr = [NSMutableArray new];
    for (id model in self.model.dataSource) {
        YBIBImageData *data = [YBIBImageData new];
        if ([model isKindOfClass:NSString.class]) {
            NSString *modelStr = (NSString *)model;
            data.imageURL = [NSURL URLWithString:modelStr];
        } else if ([model isKindOfClass:UIImage.class]) {
            data.image = ^UIImage *_Nullable {
                return (UIImage *)model;
            };
        } else if ([model isKindOfClass:GNCellModel.class]) {
            GNCellModel *baseModel = (GNCellModel *)model;
            if ([baseModel.imageTitle isKindOfClass:NSString.class]) {
                data.imageURL = [NSURL URLWithString:baseModel.imageTitle];
            } else if ([baseModel.imageTitle isKindOfClass:UIImage.class]) {
                data.image = ^UIImage *_Nullable {
                    return (UIImage *)baseModel.imageTitle;
                };
            }
        }
        [marr addObject:data];
    }
    YBImageBrowser *browser = [YBImageBrowser new];

    GNImageHandle *handle = GNImageHandle.new;
    handle.sourceView = self;
    browser.toolViewHandlers = @[handle];

    browser.dataSourceArray = marr;
    browser.autoHideProjectiveView = false;
    [browser.defaultToolViewHandler yb_hide:YES];
    browser.currentPage = index;
    [browser show];
}

- (UIView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = UIView.new;
    }
    return _imageContainerView;
}

- (NSMutableArray<UIImageView *> *)imageArr {
    if (!_imageArr) {
        _imageArr = NSMutableArray.new;
    }
    return _imageArr;
}

- (void)tapTheImageView:(UITapGestureRecognizer *)ta {
    [self showIndex:ta.view.tag - 10000];
}

- (GNStarView *)serviceScoreStarView {
    if (!_serviceScoreStarView) {
        _serviceScoreStarView = GNStarView.new;
        _serviceScoreStarView.defaultImage = @"gn_storeinfo_pentagram_nor";
        _serviceScoreStarView.selectImage = @"gn_storeinfo_pentagram_sel";
        _serviceScoreStarView.space = 1;
        _serviceScoreStarView.maxValue = 5;
        _serviceScoreStarView.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightHeavy];
    }
    return _serviceScoreStarView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.clipsToBounds = YES;
        _iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = kRealWidth(20);
        };
    }
    return _iconIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightMedium];
        label.textColor = HDAppTheme.color.gn_333Color;
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)dateLB {
    if (!_dateLB) {
        HDLabel *label = HDLabel.new;
        label.font = [HDAppTheme.font gn_ForSize:11];
        label.textColor = HDAppTheme.color.gn_999Color;
        _dateLB = label;
    }
    return _dateLB;
}

- (YYLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = YYLabel.new;
        _contentLB.numberOfLines = 4;
        _contentLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
        _contentLB.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentLB.font = [HDAppTheme.font gn_ForSize:14];
        @HDWeakify(self)[GNStringUntils addSeeMoreButton:_contentLB more:GNLocalizedString(@"gn_view_more", @"Read more") moreColor:HDAppTheme.color.gn_mainColor before:@"...   "
                                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                                   @HDStrongify(self) self.model.select = YES;
                                                   [GNEvent eventResponder:self target:self.contentLB key:@"reloadAction" indexPath:self.model.indexPath];
                                               }];
    }
    return _contentLB;
}

- (HDLabel *)productLB {
    if (!_productLB) {
        _productLB = HDLabel.new;
        _productLB.textColor = HDAppTheme.color.gn_666Color;
        _productLB.numberOfLines = 0;
        _productLB.font = [HDAppTheme.font forSize:12];
        _productLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        _productLB.layer.backgroundColor = HDAppTheme.color.gn_mainBgColor.CGColor;
        _productLB.layer.cornerRadius = kRealWidth(2);
    }
    return _productLB;
}

- (UIView *)replayLB {
    if (!_replayLB) {
        _replayLB = YYLabel.new;
        _replayLB.numberOfLines = 2;
        _replayLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
        _replayLB.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _replayLB.font = [HDAppTheme.font gn_ForSize:12];
        @HDWeakify(self)[GNStringUntils addSeeMoreButton:_replayLB more:GNLocalizedString(@"gn_view_more", @"Read more") moreColor:HDAppTheme.color.gn_mainColor before:@"...   "
                                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                                   @HDStrongify(self) if (!HDIsArrayEmpty(self.model.reply)) {
                                                       GNReviewModel *replyModel = self.model.reply.firstObject;
                                                       replyModel.select = YES;
                                                   }
                                                   [GNEvent eventResponder:self target:self.replayLB key:@"reloadAction" indexPath:self.model.indexPath];
                                               }];
    }
    return _replayLB;
}

@end
