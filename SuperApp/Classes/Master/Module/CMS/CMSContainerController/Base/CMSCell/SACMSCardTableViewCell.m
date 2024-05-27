//
//  SACMSCardTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2021/9/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardTableViewCell.h"
#import "SACMSCardView.h"
#import "SACMSCardViewConfig.h"
#import "CMSPlayerCardView.h"


@implementation SACMSCardTableViewCellModel

@end


@interface SACMSCardTableViewCell ()

@property (nonatomic, strong) SACMSCardView *cardView; ///<

@end


@implementation SACMSCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (@available(iOS 14.0, *)) {
            self.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
        } else {
            self.backgroundColor = UIColor.clearColor;
        }
    }
    return self;
}

- (void)updateConstraints {
    if (self.cardView) {
        [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(SACMSCardTableViewCellModel *)model {
    _model = model;

    if (![self.cardView isEqual:model.cardView]) {
        [self.contentView hd_removeAllSubviews];
        self.cardView = model.cardView;
        [self.contentView addSubview:self.cardView];
    }
    [self setNeedsUpdateConstraints];
}

- (void)startPlayer {
    if (![self.cardView isKindOfClass:CMSPlayerCardView.class])
        return;
    [(CMSPlayerCardView *)self.cardView startPlayer];
}

- (void)stopPlayer {
    if (![self.cardView isKindOfClass:CMSPlayerCardView.class])
        return;
    [(CMSPlayerCardView *)self.cardView stopPlayer];
}


@end


@implementation SACMSSkeletonTableViewCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 150;
    }
    return self;
}

@end


@implementation SACMSSkeletonTableViewCell

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    NSMutableArray *arr = [NSMutableArray array];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(self.model.cellHeight - 30);
        make.height.hd_equalTo(self.model.cellHeight - 30);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(15);
    }];
    r1.skeletonCornerRadius = 10;
    [arr addObject:r1];

    CGFloat width = CGRectGetWidth(self.frame);
    HDSkeletonLayer *label = [[HDSkeletonLayer alloc] init];
    [label hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width - self.model.cellHeight - 30);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_top + 5);
        make.left.hd_equalTo(r1.hd_right + 15);
    }];
    [arr addObject:label];

    label = [[HDSkeletonLayer alloc] init];
    [label hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width / 3.0);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_top + 30);
        make.left.hd_equalTo(r1.hd_right + 15);
    }];
    [arr addObject:label];

    return arr;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.clearColor;
}

@end
