//
//  PNPacketSendToItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketSendToItemView.h"
#import "PNHandOutViewModel.h"
#import "PNInfoView.h"
#import "PNPacketFriendsUserModel.h"
#import "PNPacketFriendsViewController.h"
#import <HDKitCore/UIImage+HDKitCore.h>


@interface PNPacketSendToItemView ()
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *selectedImageBgView;
@property (nonatomic, strong) HDUIButton *wownowBtn;
@property (nonatomic, strong) HDUIButton *tgBtn;
@property (nonatomic, strong) UIImageView *wownowIconImgView;
@property (nonatomic, strong) SALabel *wownowTitleLabel;
@property (nonatomic, strong) UIImageView *tgIconImgView;
@property (nonatomic, strong) SALabel *tgTitleLabel;

@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, assign) NSInteger currentSelectType;
@property (nonatomic, strong) NSMutableArray *selectImageViewArray;
@end


@implementation PNPacketSendToItemView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.packetType = self.viewModel.model.packetType;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.KVOController hd_observe:self.viewModel keyPath:@"model.packetType" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        if (self.viewModel.model.packetType != self.packetType) {
            self.wownowBtn.selected = NO;
            self.tgBtn.selected = NO;
        }
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
    [self addSubview:self.titleLabel];
    [self addSubview:self.wownowIconImgView];
    [self addSubview:self.wownowTitleLabel];
    [self addSubview:self.tgIconImgView];
    [self addSubview:self.tgTitleLabel];
    [self addSubview:self.wownowBtn];
    [self addSubview:self.tgBtn];
    [self addSubview:self.selectedImageBgView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(20));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    [self.wownowIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
    }];

    [self.wownowTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wownowIconImgView.mas_right).offset(kRealWidth(4));
        make.centerY.mas_equalTo(self.wownowIconImgView.mas_centerY);
        if (self.selectedImageBgView.hidden) {
            make.right.mas_equalTo(self.wownowBtn.mas_left);
        }
    }];

    [self.wownowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wownowIconImgView);
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    if (!self.selectedImageBgView.hidden) {
        [self.selectedImageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wownowTitleLabel.mas_right);
            make.right.mas_equalTo(self.wownowBtn.mas_left);
            make.centerY.mas_equalTo(self.wownowIconImgView.mas_centerY);
            make.height.equalTo(@(kRealWidth(28)));
        }];

        UIImageView *lastView;
        for (UIImageView *imgView in self.selectImageViewArray) {
            [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.centerX.mas_equalTo(lastView.mas_left);
                } else {
                    make.right.mas_equalTo(self.selectedImageBgView.mas_right);
                }
                make.top.bottom.equalTo(self.selectedImageBgView);
                make.height.equalTo(imgView.mas_width);
            }];
            lastView = imgView;
        }
    }

    [self.tgIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.wownowIconImgView);
        make.left.equalTo(self.wownowIconImgView);
        make.top.mas_equalTo(self.wownowIconImgView.mas_bottom).offset(kRealWidth(16));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.tgTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tgIconImgView.mas_right).offset(kRealWidth(4));
        make.centerY.mas_equalTo(self.tgIconImgView.mas_centerY);
        make.right.mas_equalTo(self.tgBtn.mas_left);
    }];

    [self.tgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tgIconImgView);
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)selectPhoneNumber {
    void (^completion)(NSArray<NSString *> *) = ^(NSArray<PNPacketFriendsUserModel *> *selectedUserArray) {
        if (!WJIsArrayEmpty(selectedUserArray)) {
            NSMutableArray *loginNamesArray = [NSMutableArray arrayWithCapacity:selectedUserArray.count];
            NSMutableArray *headURLArray = [NSMutableArray arrayWithCapacity:selectedUserArray.count];
            for (PNPacketFriendsUserModel *itemUserModel in selectedUserArray) {
                [loginNamesArray addObject:itemUserModel.userPhone];
                [headURLArray addObject:itemUserModel.headUrl ?: @""];
            }

            self.viewModel.model.receivers = [NSArray arrayWithArray:loginNamesArray];
            self.viewModel.model.grantObject = PNPacketGrantObject_In;

            self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;

            self.tgBtn.selected = NO;
            self.wownowBtn.selected = YES;

            [self showSelectedImage:headURLArray];
        }
    };

    PNPacketFriendsViewController *vc = [[PNPacketFriendsViewController alloc] initWithParam:@{
        @"handOutPacketNum": @(self.viewModel.model.qty),
        @"completion": completion,
    }];

    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[SAWindowManager visibleViewController].navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)showSelectedImage:(NSArray *)headURLArray {
    if (self.viewModel.model.grantObject == PNPacketGrantObject_In && self.viewModel.model.receivers.count > 0) {
        self.selectedImageBgView.hidden = NO;

        [self.selectedImageBgView hd_removeAllSubviews];

        NSInteger count = headURLArray.count;
        if (count > 5) {
            count = 5;
        }
        for (int i = 0; i < count; i++) {
            NSString *headURLStr = [headURLArray objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.layer.cornerRadius = kRealWidth(14);
            imgView.layer.masksToBounds = YES;
            [self.selectedImageBgView bringSubviewToFront:imgView];
            [HDWebImageManager setImageWithURL:headURLStr size:CGSizeMake(kRealWidth(28), kRealWidth(28)) placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:imgView];

            [self.selectedImageBgView addSubview:imgView];

            [self.selectImageViewArray addObject:imgView];
        }
    } else {
        self.selectedImageBgView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNLocalizedString(@"pn_send_to", @"发给谁:");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyText = key;
    model.lineWidth = 0;
    model.keyFont = HDAppTheme.PayNowFont.standard12;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.backgroundColor = [UIColor whiteColor];
    model.rightButtonaAlignKey = YES;
    //    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(10), kRealWidth(12));
    return model;
}

- (UIImageView *)wownowIconImgView {
    if (!_wownowIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_send_to_wownow"];
        _wownowIconImgView = imageView;
    }
    return _wownowIconImgView;
}

- (SALabel *)wownowTitleLabel {
    if (!_wownowTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12M;
        label.text = PNLocalizedString(@"pn_friends_wownow", @"好友");
        _wownowTitleLabel = label;
    }
    return _wownowTitleLabel;
}

- (UIImageView *)tgIconImgView {
    if (!_tgIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_send_to_tg"];
        _tgIconImgView = imageView;
    }
    return _tgIconImgView;
}

- (SALabel *)tgTitleLabel {
    if (!_tgTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12M;
        label.text = PNLocalizedString(@"pn_friends_Telegram", @"好友");
        _tgTitleLabel = label;
    }
    return _tgTitleLabel;
}

- (HDUIButton *)wownowBtn {
    if (!_wownowBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_icon_select_circular"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"pn_icon_unSelect_circular"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(20), kRealWidth(10), kRealWidth(10));
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click wownow");
            self.viewModel.hideKeyBoardFlag = !self.viewModel.hideKeyBoardFlag;

            if (!btn.selected) {
                if (self.viewModel.model.qty <= 0) {
                    [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_enter_packet_number", @"请先输入红包个数") type:HDTopToastTypeError];
                    return;
                }

                [self selectPhoneNumber];
            } else {
                btn.selected = !btn.selected;
                self.selectedImageBgView.hidden = YES;
                self.viewModel.model.receivers = @[];
                [self.selectImageViewArray removeAllObjects];
                self.viewModel.model.grantObject = PNPacketGrantObject_Non;
            }

            self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
        }];

        _wownowBtn = button;
    }
    return _wownowBtn;
}

- (HDUIButton *)tgBtn {
    if (!_tgBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_icon_select_circular"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"pn_icon_unSelect_circular"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(20), kRealWidth(10), kRealWidth(10));
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click tg");
            self.viewModel.hideKeyBoardFlag = !self.viewModel.hideKeyBoardFlag;

            btn.selected = !btn.selected;
            if (btn.selected) {
                self.wownowBtn.selected = NO;
                self.viewModel.model.grantObject = PNPacketGrantObject_Out;
                self.selectedImageBgView.hidden = YES;
                self.viewModel.model.receivers = @[];
                [self.selectImageViewArray removeAllObjects];
            } else {
                self.viewModel.model.grantObject = PNPacketGrantObject_Non;
                self.selectedImageBgView.hidden = YES;
                self.viewModel.model.receivers = @[];
                [self.selectImageViewArray removeAllObjects];
            }
            self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
        }];

        _tgBtn = button;
    }
    return _tgBtn;
}

- (UIView *)selectedImageBgView {
    if (!_selectedImageBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hidden = YES;
        _selectedImageBgView = view;
    }
    return _selectedImageBgView;
}

- (NSMutableArray *)selectImageViewArray {
    if (!_selectImageViewArray) {
        _selectImageViewArray = [NSMutableArray array];
    }
    return _selectImageViewArray;
}
@end
