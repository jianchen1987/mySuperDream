//
//  PNPacketFriendsViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketFriendsViewController.h"

#define kContainerViewHeight (kScreenHeight * 0.8)


@interface PNPacketFriendsViewController ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) PNPacketFriendsView *friendsView;
@property (nonatomic, assign) NSInteger handOutPacketNum;

@end


@implementation PNPacketFriendsViewController

- (instancetype)initWithParam:(NSDictionary *)paramDict {
    self = [super init];
    if (self) {
        self.handOutPacketNum = [[paramDict objectForKey:@"handOutPacketNum"] integerValue];
        self.friendsView.completion = [paramDict objectForKey:@"completion"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.friendsView];

    self.friendsView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };

    self.shadowView.alpha = 0;

    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.friendsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kContainerViewHeight);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.shadowView.alpha == 0) {
        self.friendsView.transform = CGAffineTransformMakeTranslation(0, self.friendsView.bounds.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            self.shadowView.alpha = 1;
            self.friendsView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)clickedShadowViewHandler {
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.friendsView.transform = CGAffineTransformMakeTranslation(0, self.friendsView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self dismissAnimated:YES completion:nil];
    }];
}

#pragma mark
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedShadowViewHandler)];
        [_shadowView addGestureRecognizer:recognizer];
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return _shadowView;
}

- (PNPacketFriendsView *)friendsView {
    if (!_friendsView) {
        _friendsView = [[PNPacketFriendsView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kContainerViewHeight, kScreenWidth, kContainerViewHeight) handOutPacketNum:self.handOutPacketNum];

        @HDWeakify(self);
        _friendsView.closeBlock = ^{
            @HDStrongify(self);
            [self clickedShadowViewHandler];
        };
    }
    return _friendsView;
}
@end
