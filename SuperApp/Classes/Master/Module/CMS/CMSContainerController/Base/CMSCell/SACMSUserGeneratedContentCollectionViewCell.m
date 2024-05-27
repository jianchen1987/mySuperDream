//
//  SACMSUserGeneratedContentCollectionViewCell.m
//  SuperApp
//
//  Created by seeu on 2022/11/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSUserGeneratedContentCollectionViewCell.h"
#import "SADiscoveryDTO.h"
#import "SAUGCReportView.h"


@interface SACMSUserGeneratedContentCollectionViewCell ()

///< 是否已经显示菜单
@property (atomic, assign, getter=isMenuShow) BOOL menuShow;
///< 上报功能
@property (nonatomic, strong) SAUGCReportView *reportView;

@end


@implementation SACMSUserGeneratedContentCollectionViewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.clearColor;

    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
    [self addGestureRecognizer:press];
}

- (void)setModel:(SACMSWaterfallCellModel *)model {
    _model = model;

    if (self.reportView) {
        [self.reportView removeFromSuperview];
        self.reportView = nil;
        self.menuShow = NO;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)cellLongPressed:(UIGestureRecognizer *)recognizer {
    if (!self.isMenuShow) {
        self.menuShow = YES;

        SAUGCReportView *view = [SAUGCReportView reportViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:view];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        @HDWeakify(self);
        view.closeClickedHandler = ^{
            @HDStrongify(self);
            self.menuShow = NO;
            self.reportView = nil;
        };

        view.reportClickedHander = ^(NSString *_Nonnull reason) {
            if (![SAUser hasSignedIn]) {
                [SAWindowManager switchWindowToLoginViewController];
                return;
            }

            if (HDIsStringNotEmpty(reason)) {
                @HDStrongify(self);
                [self report:reason];
            }

            [self.reportView removeFromSuperview];
            self.reportView = nil;
            self.menuShow = NO;
        };
        self.reportView = view;

        [self setNeedsUpdateConstraints];
    }
}

- (void)report:(NSString *)reason {
    @HDWeakify(self);
    [UIApplication.sharedApplication.keyWindow showloading];

    NSString *bizType = @"discovery";
    if (self.model.cellType == SACMSWaterfallCellTypeHomeRecommand) {
        bizType = @"ads";
    } else {
        bizType = @"discovery";
    }

    [SADiscoveryDTO reportContentWithContentId:self.model.contentNo reason:reason bizType:bizType success:^{
        @HDStrongify(self);
        [UIApplication.sharedApplication.keyWindow dismissLoading];
        [NAT showToastWithTitle:@"" content:SALocalizedString(@"ugc_report_success", @"反馈成功，将减少此类内容操作") type:HDTopToastTypeSuccess];
        !self.cellDidDeletedHandler ?: self.cellDidDeletedHandler(self.model);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        [UIApplication.sharedApplication.keyWindow dismissLoading];
        [NAT showToastWithTitle:@"" content:SALocalizedString(@"ugc_report_success", @"反馈成功，将减少此类内容操作") type:HDTopToastTypeSuccess];
        !self.cellDidDeletedHandler ?: self.cellDidDeletedHandler(self.model);
    }];
}

@end


@implementation SACMSWaterfallSkeletonCollectionViewCell

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    NSMutableArray *arr = [NSMutableArray array];

    CGFloat width = CGRectGetWidth(self.frame);
    
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width);
        make.height.hd_equalTo(self.model.cellHeight - 70);
        make.left.hd_equalTo(0);
        make.top.hd_equalTo(0);
    }];

    [arr addObject:r1];

    HDSkeletonLayer *label1 = [[HDSkeletonLayer alloc] init];
    [label1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width / 2);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_bottom + 10);
        make.left.hd_equalTo(r1.hd_left + 8);
    }];
    [arr addObject:label1];

    HDSkeletonLayer *label2 = [[HDSkeletonLayer alloc] init];
    [label2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width - 30);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(label1.hd_bottom + 10);
        make.left.hd_equalTo(r1.hd_left + 8);
        make.bottom.hd_equalTo(-10);
    }];
    [arr addObject:label2];

    return arr;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

@end


@implementation SACMSWaterfallSkeletonCollectionViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 250 + random() % 100;
    }
    return self;
}
@end
