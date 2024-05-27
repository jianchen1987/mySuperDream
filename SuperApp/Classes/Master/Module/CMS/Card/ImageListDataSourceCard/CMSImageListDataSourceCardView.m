//
//  CMSImageListDataSourceCardView.m
//  SuperApp
//
//  Created by seeu on 2021/8/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSImageListDataSourceCardView.h"
#import "CMSImageListCellConfig.h"


@interface CMSImageListDataSourceCardView ()

@property (nonatomic, strong) NSArray<CMSImageListCellConfig *> *dataSource; ///< 数据源

@end


@implementation CMSImageListDataSourceCardView

- (void)updateConstraints {
    UIView *topView = nil;
    for (UIView *view in self.containerView.subviews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (topView) {
                make.top.equalTo(topView.mas_bottom).offset(kRealHeight(15));
            } else {
                make.top.equalTo(self.containerView.mas_top);
            }
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
            make.height.equalTo(self.containerView.mas_width).multipliedBy(100 / 375.0);
        }];
        topView = view;
    }

    if (topView) {
        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-kRealHeight(20));
        }];
    }

    [super updateConstraints];
}

#pragma mark - private methods
- (void)configSubView {
    [self.containerView hd_removeAllSubviews];
    if (!HDIsArrayEmpty(self.dataSource)) {
        for (int i = 0; i < self.dataSource.count; i++) {
            CMSImageListCellConfig *config = self.dataSource[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 1000 + i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)]];
            [HDWebImageManager setImageWithURL:config.imageUrl placeholderImage:[HDHelper placeholderImageWithCornerRadius:config.cornerRadius size:CGSizeMake(345, 100) logoWidth:50]
                                     imageView:imageView];
            imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:config.cornerRadius];
            };

            [self.containerView addSubview:imageView];
        }
    }
    [self setNeedsUpdateConstraints];
}
#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSImageListCellConfig.class json:self.config.getAllNodeContents];
    [self configSubView];
}
#pragma mark - event response
- (void)clickItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    SACMSNode *node = self.config.nodes[index - 1000];
    CMSImageListCellConfig *itemConfig = self.dataSource[index - 1000];
    !self.clickNode ?: self.clickNode(self, node, itemConfig.link, [NSString stringWithFormat:@"node@%zd", index - 1000]);
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    __block CGFloat height = 0;
    CGFloat availableWidth = self.config.maxLayoutWidth - self.config.contentEdgeInsets.left - self.config.contentEdgeInsets.right - kRealWidth(15) - kRealWidth(15);
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        height += (availableWidth * 100) / 375.0;
    }];

    if (height > 0) {
        height += kRealHeight(20);
        height += (self.containerView.subviews.count - 1) * kRealHeight(15);
        height += [self.titleView heightOfTitleView];
        height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    }

    return height;
}

@end
