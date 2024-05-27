//
//  TNBargainShowBannerContainrView.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainShowBannerContainrView.h"
#import "TNBargainSuccessBannerView.h"
#import "TNBargainSuccessModel.h"


@interface TNBargainShowBannerContainrView ()
@property (nonatomic, assign) CGFloat bannerWidth;
@property (nonatomic, assign) CGFloat bannerHeight;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) NSMutableArray *bannerViewArr;
@end


@implementation TNBargainShowBannerContainrView
- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    self.scrollView.scrollEnabled = false;
    self.currentPage = 1;
    self.scrollInterval = 3;
    self.animationInterVale = 0.7;
    self.bannerHeight = kRealWidth(36);
}
- (void)setDataArr:(NSArray<TNBargainSuccessModel *> *)dataArr {
    _dataArr = dataArr;
    if (_dataArr.count == 1) { //一条数据也要循环播放 多复制一条数据
        NSMutableArray *copyArr = [NSMutableArray arrayWithArray:dataArr];
        [copyArr addObjectsFromArray:dataArr];
        _dataArr = copyArr;
    }
    [self addTimer];
    [self initSubviews];
}
- (void)showInView:(UIView *)inView {
    [inView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inView);
        make.top.equalTo(inView.mas_top).offset(kRealWidth(70));
        make.size.mas_equalTo(CGSizeMake(self.bannerWidth, (self.bannerHeight + kRealWidth(12)) * 2));
    }];
    [self setNeedsUpdateConstraints];
}
- (void)changeOffSet {
    self.currentPage++;
    if (self.currentPage == self.dataArr.count + 1) {
        self.currentPage = 1;
    }
    TNBargainSuccessBannerView *currentBannerView = self.bannerViewArr[self.currentPage];
    TNBargainSuccessBannerView *onBannerView = self.bannerViewArr[self.currentPage - 1];   //上一条
    TNBargainSuccessBannerView *nextBannerView = self.bannerViewArr[self.currentPage + 1]; //下一条
    [UIView animateWithDuration:self.animationInterVale animations:^{
        self.scrollView.contentOffset = CGPointMake(0, (self.bannerHeight + kRealWidth(12)) * self.currentPage);
        [self identityView:currentBannerView];
        [self scaleView:nextBannerView];
    } completion:^(BOOL finished) {
        if (self.currentPage == self.dataArr.count) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (self.currentPage != 1) {
            [self scaleView:onBannerView];
        }
    }];
}
- (void)addTimer {
    if (!_timer) {
        @HDWeakify(self);
        _timer = [HDWeakTimer scheduledTimerWithTimeInterval:self.scrollInterval block:^(id userInfo) {
            @HDStrongify(self);
            [self changeOffSet];
        } userInfo:nil repeats:true];
    }
}
- (void)initSubviews {
    if (self.dataArr.count <= 0) {
        return;
    }
    self.bannerViewArr = [NSMutableArray array];
    UIView *lastView = nil;
    for (int i = 0; i < self.dataArr.count + 2; i++) {
        TNBargainSuccessBannerView *bannerView = [[TNBargainSuccessBannerView alloc] init];
        TNBargainSuccessModel *model;
        if (i == 0) {
            model = self.dataArr.lastObject;
        } else if (i == self.dataArr.count + 1) {
            model = self.dataArr.firstObject;
        } else {
            model = self.dataArr[i - 1];
        }
        bannerView.model = model;
        [self.scrollView addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView);
            make.height.mas_equalTo(self.bannerHeight + kRealWidth(12));
            CGFloat width = [bannerView systemLayoutSizeFittingSize:CGSizeMake(MAXFLOAT, self.bannerHeight)].width;
            if (width > kScreenWidth) {
                width = kScreenWidth;
            }
            if (width > self.bannerWidth) {
                self.bannerWidth = width;
            }
            make.width.mas_equalTo(width);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollView);
            }
            if (i == self.dataArr.count) {
                make.bottom.equalTo(self.scrollView);
            }
        }];
        lastView = bannerView;
        //缩放
        if (i != 0) { //第0条是占位显示  不替换
            [self scaleView:bannerView];
        }
        [self.bannerViewArr addObject:bannerView];
    }
    self.scrollView.frame = CGRectMake(0, 0, self.bannerWidth, (self.bannerHeight + kRealWidth(12)) * 2);
    self.scrollView.contentSize = CGSizeMake(self.bannerWidth, (self.bannerHeight + kRealWidth(12)) * (self.dataArr.count + 2));
    self.scrollView.contentOffset = CGPointMake(0, self.bannerHeight + kRealWidth(12));
    //第一个显示的正常
    [self identityView:self.bannerViewArr[1]];
}
- (void)scaleView:(TNBargainSuccessBannerView *)bannerView {
    bannerView.layer.anchorPoint = CGPointMake(0.63, 0.5);
    CATransform3D t = CATransform3DMakeScale(0.8, 0.8, 1);
    bannerView.layer.transform = CATransform3DScale(t, 1, 1, 1);
    [bannerView setBackgroundColorAlpha:0.29];
}
- (void)identityView:(TNBargainSuccessBannerView *)bannerView {
    bannerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    bannerView.layer.transform = CATransform3DIdentity;
    [bannerView setBackgroundColorAlpha:0.7];
}
@end
