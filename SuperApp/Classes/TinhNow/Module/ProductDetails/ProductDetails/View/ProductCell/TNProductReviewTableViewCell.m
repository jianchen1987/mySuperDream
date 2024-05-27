//
//  TNProductReviewTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductReviewTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "NSDate+SAExtension.h"
#import "NSString+SA_Extension.h"
#import "SASingleImageCollectionViewCell.h"
#import "TNProductReviewModel.h"


@interface TNProductReviewTableViewCell () <HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>

///
@property (strong, nonatomic) UIView *sectionView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (strong, nonatomic) UILabel *subTitleLabel;
///
@property (strong, nonatomic) UIImageView *arrowImageView;
///
@property (strong, nonatomic) UIView *lineView;

/// 评论容器
@property (strong, nonatomic) UIView *reviewContainer;

/// 头像
@property (nonatomic, strong) UIImageView *profileImageView;
/// 姓名
@property (nonatomic, strong) UILabel *nameLabel;
/// 评分
@property (nonatomic, strong) HDRatingStarView *ratingStartView;
/// 时间
@property (nonatomic, strong) UILabel *timeLabel;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 评论图片
@property (nonatomic, strong) HDCyclePagerView *cyclePageView;
/// 图片数量
@property (nonatomic, strong) HDLabel *imageNumLabel;
/// 数据源
@property (nonatomic, strong) NSArray<SASingleImageCollectionViewCellModel *> *dataSource;
/// 回复容器
@property (nonatomic, strong) UIView *replyContainer;
/// 回复列表
@property (nonatomic, strong) NSMutableArray<UIView *> *replyViews;
@end


@implementation TNProductReviewTableViewCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.sectionView];
    [self.sectionView addSubview:self.titleLabel];
    [self.sectionView addSubview:self.subTitleLabel];
    [self.sectionView addSubview:self.arrowImageView];
    [self.sectionView addSubview:self.lineView];

    [self.contentView addSubview:self.reviewContainer];
    [self.reviewContainer addSubview:self.profileImageView];
    [self.reviewContainer addSubview:self.nameLabel];
    [self.reviewContainer addSubview:self.ratingStartView];
    [self.reviewContainer addSubview:self.timeLabel];
    [self.reviewContainer addSubview:self.contentLabel];
    [self.reviewContainer addSubview:self.cyclePageView];
    [self.reviewContainer addSubview:self.imageNumLabel];
    [self.reviewContainer addSubview:self.replyContainer];
}

- (void)updateConstraints {
    [self.sectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(40));
        if (self.reviewContainer.isHidden) {
            make.bottom.equalTo(self.contentView);
        }
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionView.mas_centerY);
        make.left.equalTo(self.sectionView.mas_left).offset(kRealWidth(10));
    }];
    if (!self.arrowImageView.isHidden) {
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.sectionView.mas_centerY);
            make.right.equalTo(self.sectionView.mas_right).offset(-kRealWidth(10));
        }];
    }
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionView.mas_centerY);
        if (self.arrowImageView.isHidden) {
            make.right.equalTo(self.sectionView.mas_right).offset(-kRealWidth(10));
        } else {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kRealWidth(5));
        }
    }];

    if (!self.reviewContainer.isHidden) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sectionView);
            make.left.equalTo(self.sectionView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.sectionView.mas_right).offset(-kRealWidth(10));
            make.height.mas_equalTo(0.5);
        }];

        [self.reviewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.sectionView.mas_bottom);
        }];

        [self.profileImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reviewContainer.mas_top).offset(15);
            make.left.equalTo(self.reviewContainer.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
        }];

        [self.ratingStartView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.reviewContainer.mas_right).offset(-15);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.size.mas_equalTo([self.ratingStartView sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]);
        }];

        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileImageView.mas_right).offset(15);
            make.top.equalTo(self.profileImageView.mas_top);
            make.right.mas_equalTo(self.ratingStartView.mas_left).offset(-5.f);
        }];

        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileImageView.mas_right).offset(15);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profileImageView.mas_right).offset(15);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
            make.right.equalTo(self.reviewContainer.mas_right).offset(-15);
            if (!self.cyclePageView.isHidden) {
                make.bottom.equalTo(self.cyclePageView.mas_top).offset(-8);
            } else if (!self.replyContainer.isHidden) {
                make.bottom.equalTo(self.replyContainer.mas_top).offset(-8);
            } else {
                make.bottom.equalTo(self.reviewContainer.mas_bottom).offset(-15);
            }
        }];

        if (!self.cyclePageView.isHidden) {
            [self.cyclePageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.profileImageView.mas_right).offset(15);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
                make.right.equalTo(self.reviewContainer.mas_right).offset(-15);
                if (!self.replyContainer.isHidden) {
                    make.bottom.equalTo(self.replyContainer.mas_top).offset(-8);
                } else {
                    make.bottom.equalTo(self.reviewContainer.mas_bottom).offset(-15);
                }
                make.height.mas_equalTo(kRealWidth(92));
            }];
        }

        if (!self.imageNumLabel.isHidden) {
            [self.imageNumLabel sizeToFit];
            [self.imageNumLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.cyclePageView.mas_right).offset(-4);
                make.bottom.equalTo(self.cyclePageView.mas_bottom).offset(-4);
            }];
        }

        if (!self.replyContainer.isHidden) {
            [self.replyContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.reviewContainer.mas_left).offset(15);
                make.right.equalTo(self.reviewContainer.mas_right).offset(-15);
                make.bottom.equalTo(self.reviewContainer.mas_bottom).offset(-15);
                if (!self.cyclePageView.isHidden) {
                    make.top.equalTo(self.cyclePageView.mas_bottom).offset(8);
                } else {
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(8);
                }
            }];
        }

        TNReviewReplyView *topView = nil;
        for (TNReviewReplyView *reply in self.replyViews) {
            [reply mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.replyContainer);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom).offset(5);
                } else {
                    make.top.equalTo(self.replyContainer.mas_top);
                }
            }];
            topView = reply;
        }

        if (topView) {
            [topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.replyContainer.mas_bottom);
            }];
        }
    }
    [super updateConstraints];
}

- (void)setModel:(TNProductReviewTableViewCellModel *)model {
    _model = model;
    if (model.totalReviews <= 0) {
        self.arrowImageView.hidden = YES;
        self.reviewContainer.hidden = YES;
        return;
    }

    self.arrowImageView.hidden = NO;
    self.reviewContainer.hidden = NO;
    NSString *reviewsCount = [NSString stringWithFormat:@"(%ld)", model.totalReviews];
    if (model.totalReviews > 100) {
        reviewsCount = @"(100+)";
    }
    self.subTitleLabel.text = [TNLocalizedString(@"tn_all_review", @"see all review") stringByAppendingString:reviewsCount];

    [HDWebImageManager setImageWithURL:_model.headImageUrl placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.profileImageView];

    self.nameLabel.text = _model.reviewerName;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:_model.timeInterval / 1000.0] stringWithFormatStr:@"dd/MM/yyyy"];
    self.ratingStartView.score = _model.score.floatValue;
    self.contentLabel.text = _model.content;

    if (_model.images.count > 0) {
        NSMutableArray<SASingleImageCollectionViewCellModel *> *tmp = NSMutableArray.new;
        for (NSString *url in _model.images) {
            SASingleImageCollectionViewCellModel *bannerModel = SASingleImageCollectionViewCellModel.new;
            bannerModel.url = url;
            [tmp addObject:bannerModel];
        }
        self.dataSource = [NSArray arrayWithArray:tmp];
        [self.cyclePageView setHidden:NO];
    } else {
        [self.cyclePageView setHidden:YES];
    }

    if (self.dataSource.count > 3) {
        [self.imageNumLabel setHidden:NO];
        [self setPageNoWithIndex:3];
    } else {
        [self.imageNumLabel setHidden:YES];
    }

    if (_model.merchantReplys.count > 0) {
        [self.replyContainer hd_removeAllSubviews];
        [self.replyViews removeAllObjects];
        for (TNReviewMerchantReplyModel *replyModel in _model.merchantReplys) {
            TNReviewReplyView *view = TNReviewReplyView.new;
            view.model = replyModel;
            view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
                view.layer.cornerRadius = 10.0f;
                view.layer.masksToBounds = YES;
            };
            [self.replyViews addObject:view];
            [self.replyContainer addSubview:view];
        }
        [self.replyContainer setHidden:NO];
    } else {
        [self.replyContainer setHidden:YES];
    }

    [self setNeedsUpdateConstraints];
}

- (void)setPageNoWithIndex:(NSUInteger)index {
    NSString *start = [NSString stringWithFormat:@"%zd", index];
    NSString *end = [NSString stringWithFormat:@"/%zd", self.dataSource.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[start stringByAppendingString:end]];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15B, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, start.length)];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard12, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(start.length, end.length)];
    self.imageNumLabel.attributedText = str;
}

- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (NSString *url in self.model.images) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:url];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);
    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.cyclePageView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };

    browser.toolViewHandlers = @[toolViewHandler];
    [browser show];
}

#pragma mark - HDCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
    SASingleImageCollectionViewCellModel *model = self.dataSource[index];
    model.cornerRadius = 8;
    model.placholderImage = [HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(90), kRealWidth(90)) logoWidth:70];
    cell.model = model;
    return cell;
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    SASingleImageCollectionViewCell *trueCell = (SASingleImageCollectionViewCell *)cell;
    [self showImageBrowserWithInitialProjectiveView:trueCell.imageView index:index];
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = 92.0f;
    const CGFloat height = 92.0f;
    layout.itemSpacing = 9;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self setPageNoWithIndex:toIndex];
}

#pragma mark - lazy load
/** @lazy profileImageView */
- (UIImageView *)profileImageView {
    if (!_profileImageView) {
        _profileImageView = [[UIImageView alloc] init];
        _profileImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _profileImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
/** @lazy timelabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _timeLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _timeLabel;
}

/** @lazy contentlabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HDAppTheme.TinhNowFont.standard15;
        _contentLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
/** @lazy cyclepageView */
- (HDCyclePagerView *)cyclePageView {
    if (!_cyclePageView) {
        _cyclePageView = [[HDCyclePagerView alloc] init];
        _cyclePageView.autoScrollInterval = 0;
        _cyclePageView.isInfiniteLoop = NO;
        _cyclePageView.dataSource = self;
        _cyclePageView.delegate = self;
        [_cyclePageView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _cyclePageView;
}
/** @lazy ratingStart */
- (HDRatingStarView *)ratingStartView {
    if (!_ratingStartView) {
        _ratingStartView = [[HDRatingStarView alloc] init];
        _ratingStartView.allowTouchToSelectScore = false;
        _ratingStartView.renderColors = @[HDAppTheme.TinhNowColor.C1, HexColor(0xFFC95F)];
        _ratingStartView.shouldFixScore = true;
        _ratingStartView.starWidth = kRealWidth(15);
        _ratingStartView.starImage = [UIImage imageNamed:@"starUnselected"];
    }
    return _ratingStartView;
}

- (HDLabel *)imageNumLabel {
    if (!_imageNumLabel) {
        _imageNumLabel = [[HDLabel alloc] init];
        _imageNumLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _imageNumLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _imageNumLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _imageNumLabel;
}
/** @lazy replyContainer */
- (UIView *)replyContainer {
    if (!_replyContainer) {
        _replyContainer = [[UIView alloc] init];
    }
    return _replyContainer;
}
/** @lazy replays */
- (NSMutableArray<UIView *> *)replyViews {
    if (!_replyViews) {
        _replyViews = [[NSMutableArray alloc] init];
    }
    return _replyViews;
}

/** @lazy sectionView */
- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
    }
    return _sectionView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"tn_product_reviews", @"Item Reviews");
    }
    return _titleLabel;
}
/** @lazy subTitleLabel */
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _subTitleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _subTitleLabel.text = TNLocalizedString(@"tn_no_reviews", @"暂无评论");
    }
    return _subTitleLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
/** @lazy reviewContainer */
- (UIView *)reviewContainer {
    if (!_reviewContainer) {
        _reviewContainer = [[UIView alloc] init];
    }
    return _reviewContainer;
}
@end


@implementation TNProductReviewTableViewCellModel

+ (TNProductReviewTableViewCellModel *)modelWithProductReviewModel:(TNProductReviewModel *)reviewMoel {
    TNProductReviewTableViewCellModel *cellModel = TNProductReviewTableViewCellModel.new;
    cellModel.headImageUrl = reviewMoel.head;
    if (reviewMoel.anonymous && HDIsStringNotEmpty(reviewMoel.username)) {
        cellModel.reviewerName = [reviewMoel.username SA_desensitize];
    } else {
        cellModel.reviewerName = reviewMoel.username;
    }

    cellModel.timeInterval = reviewMoel.createdDate;
    cellModel.score = HDIsObjectNil(reviewMoel.itemScore) ? @0 : reviewMoel.itemScore;
    cellModel.content = reviewMoel.content;
    cellModel.images = [NSArray arrayWithArray:reviewMoel.images];
    cellModel.merchantReplys = [NSArray arrayWithArray:reviewMoel.replys];
    return cellModel;
}

@end


@interface TNReviewReplyView ()

/// label
@property (nonatomic, strong) UILabel *replyLabel;

@end


@implementation TNReviewReplyView

- (void)hd_setupViews {
    self.replyLabel = [[UILabel alloc] init];
    self.replyLabel.textColor = HDAppTheme.TinhNowColor.G2;
    self.replyLabel.font = HDAppTheme.TinhNowFont.standard15;

    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self addSubview:self.replyLabel];
}

- (void)updateConstraints {
    [self.replyLabel sizeToFit];
    [self.replyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 12, 12, 12));
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [super updateConstraints];
}

- (void)setModel:(TNReviewMerchantReplyModel *)model {
    _model = model;
    NSString *merchantName = nil;
    if (_model.anoymous && HDIsStringNotEmpty(model.content)) {
        NSUInteger lenght = _model.replyName.length / 2;
        merchantName = [_model.replyName stringByReplacingCharactersInRange:NSMakeRange(lenght, _model.replyName.length - lenght) withString:@"****"];
    } else {
        merchantName = _model.replyName;
    }

    self.replyLabel.text = [NSString stringWithFormat:@"%@:%@", merchantName, _model.content];

    [self setNeedsUpdateConstraints];
}

@end
