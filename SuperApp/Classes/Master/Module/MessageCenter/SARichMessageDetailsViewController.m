//
//  SARichMessageDetailsViewController.m
//  SuperApp
//
//  Created by seeu on 2021/7/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARichMessageDetailsViewController.h"
#import "SAStartupAdVideoView.h"
#import "SASystemMessageModel.h"
#import <HDUIKit/HDUIButton.h>
#import <HDVendorKit/HDWebImageManager.h>


@interface SARichMessageDetailsViewController ()
@property (nonatomic, strong) HDUIButton *backBTN;

@property (nonatomic, strong) UIImageView *headImageView;                   ///< 头图
@property (nonatomic, strong) SAStartupAdVideoView *videoView;              ///< 视频
@property (nonatomic, strong) UILabel *titleLabel;                          ///< 标题
@property (nonatomic, strong) UILabel *dateLabel;                           ///< 时间
@property (nonatomic, strong) UILabel *contentLabel;                        ///< 内容
@property (nonatomic, strong) UIScrollView *container;                      ///< 容器
@property (nonatomic, strong) NSMutableArray<SAOperationButton *> *actions; ///< 操作
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;
@end


@implementation SARichMessageDetailsViewController

- (void)hd_setupViews {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.container];
    [self.container addSubview:self.headImageView];
    [self.container addSubview:self.videoView];
    [self.container addSubview:self.titleLabel];
    [self.container addSubview:self.dateLabel];
    [self.container addSubview:self.contentLabel];
    [self.view addSubview:self.backBTN];
}

- (void)updateViewConstraints {
    [self.backBTN sizeToFit];
    [self.backBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];

    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(-kRealHeight(70));
    }];
    if (!self.headImageView.isHidden) {
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.container);
            make.width.equalTo(self.view.mas_width);
            make.height.mas_equalTo(kScreenWidth * 250 / 375.0);
        }];
    }

    if (!self.videoView.isHidden) {
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.container);
            make.width.equalTo(self.view.mas_width);
            make.height.mas_equalTo(kScreenWidth * 250 / 375.0);
        }];
    }

    UIView *headView = !self.headImageView.isHidden ? self.headImageView : (!self.videoView.isHidden ? self.videoView : nil);

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (headView) {
            make.top.equalTo(headView.mas_bottom).offset(kRealHeight(16.5));
        } else {
            make.top.equalTo(self.container.mas_top).offset(kRealHeight(20));
        }

        make.left.equalTo(self.container.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.container.mas_right).offset(-kRealWidth(15));
        make.width.mas_equalTo(kScreenWidth - kRealWidth(15) - kRealWidth(15));
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.5);
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(kRealHeight(16.5));
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(30));
    }];

    UIView *rightView = nil;
    for (SAOperationButton *button in self.actions) {
        [button sizeToFit];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(-kRealHeight(30));
            if (rightView) {
                make.right.equalTo(rightView.mas_left).offset(-kRealWidth(15));
            } else {
                make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
            }
            make.size.mas_equalTo(button.frame.size);
        }];
        rightView = button;
    }

    [super updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.videoView.isHidden) {
        [self.videoView startVideoPlayer];
    }
}

#pragma mark - action
- (void)clickOnBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickOnAction:(SAOperationButton *)button {
    if (button.tag < self.actions.count) {
        SAMessageAction *action = self.model.buttonList[button.tag];
        [self dismissViewControllerAnimated:YES completion:^{
            [SAWindowManager openUrl:action.action withParameters:@{
                @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|消息详情"] : @"消息详情",
                @"associatedId" : HDIsStringNotEmpty(self.viewModel.associatedId) ? self.viewModel.associatedId : self.model.messageNo
            }];
        }];
    }
}

#pragma mark - setter
- (void)setModel:(SASystemMessageModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(model.headPicture)) {
        if ([model.headPicture hasSuffix:@"mp4"] || [model.headPicture hasSuffix:@"MP4"] || [model.headPicture hasSuffix:@"mP4"] || [model.headPicture hasSuffix:@"Mp4"]) {
            self.headImageView.hidden = YES;
            self.videoView.hidden = NO;
            @HDWeakify(self);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                @HDStrongify(self);
                self.videoView.contentURL = [NSURL URLWithString:model.headPicture];
            });

        } else {
            self.headImageView.hidden = NO;
            self.videoView.hidden = YES;
            [HDWebImageManager setImageWithURL:model.headPicture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, kScreenWidth * 3 / 4.0)] imageView:self.headImageView];
        }

    } else {
        self.headImageView.hidden = YES;
        self.videoView.hidden = YES;
    }

    self.titleLabel.text = model.messageName.desc;
    self.contentLabel.text = model.messageContent.desc;
    self.dateLabel.text = [SAGeneralUtil getDateStrWithDate:[NSDate dateWithTimeIntervalSince1970:model.sendTime.integerValue / 1000.0] format:@"yyyy/MM/dd HH:mm"];

    for (SAOperationButton *button in self.actions) {
        [button removeFromSuperview];
    }
    [self.actions removeAllObjects];

    if (!HDIsArrayEmpty(model.buttonList)) {
        NSArray<SAMessageAction *> *filter = [model.buttonList hd_filterWithBlock:^BOOL(SAMessageAction *_Nonnull item) {
            if (HDIsStringNotEmpty(item.title)) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSUInteger idx = 0;
        for (SAMessageAction *action in filter) {
            SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
            if ([action isEqual:model.buttonList.firstObject]) {
                button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
                [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [button applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#F46300"]];
                [button setImage:[UIImage imageNamed:@"message_details_go"] forState:UIControlStateNormal];
                button.imagePosition = HDUIButtonImagePositionRight;
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 7.5, 0, 15);
                button.titleEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 7.5);
            } else {
                [button setTitleColor:[UIColor hd_colorWithHexString:@"#F46300"] forState:UIControlStateNormal];
                button.borderColor = HDAppTheme.color.C1;
                [button applyPropertiesWithBackgroundColor:UIColor.whiteColor];
                button.titleEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 24);
            }
            [button setTitle:action.title forState:UIControlStateNormal];

            button.titleLabel.font = HDAppTheme.font.standard3;
            button.cornerRadius = 6.5;
            button.tag = idx++;
            [button addTarget:self action:@selector(clickOnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [self.actions addObject:button];
        }
    }

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - overwirte
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - lazy load
- (HDUIButton *)backBTN {
    if (!_backBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tn_video_close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOnBack) forControlEvents:UIControlEventTouchUpInside];
        _backBTN = button;
    }
    return _backBTN;
}

/** @lazy headimageview */
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor hd_colorWithHexString:@"#5A5A5A"];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

/** @lazy dateLabel */
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = HDAppTheme.font.standard4;
        _dateLabel.textColor = [UIColor hd_colorWithHexString:@"#A3A3A3"];
        _dateLabel.numberOfLines = 1;
    }
    return _dateLabel;
}

/** @lazy contentLabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor hd_colorWithHexString:@"#808080"];
        _contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
/** @lazy container */
- (UIScrollView *)container {
    if (!_container) {
        _container = [[UIScrollView alloc] init];
    }
    return _container;
}

/** @lazy actions */
- (NSMutableArray<SAOperationButton *> *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _actions;
}

- (SAStartupAdVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[SAStartupAdVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 250 / 375.0)];
        _videoView.showVideoControls = YES;
        _videoView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoView.muted = NO;
        _videoView.videoCycleOnce = YES;
        _videoView.videoPlayerFailBlock = ^{

        };
    }
    return _videoView;
}

- (SAViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

@end
