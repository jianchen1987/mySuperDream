//
//  SACMSCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardView.h"


@interface SACMSCardView ()

/// bgView
@property (nonatomic, strong) UIView *bgView;
/// 背景图
@property (nonatomic, strong) UIImageView *bgIV;
/// 标题
@property (nonatomic, strong) SACMSTitleView *titleView;
/// 容器
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) CMNetworkRequest *request; ///< 请求对象

@end


@implementation SACMSCardView

- (instancetype)initWithConfig:(SACMSCardViewConfig *)config {
    if (self = [super init]) {
        self.config = config;
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.bgIV];
    [self.bgView addSubview:self.titleView];
    [self.bgView addSubview:self.containerView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([self.config getContentEdgeInsets]);
        // 如果卡片配置为空则卡片高度设为0
        if (HDIsObjectNil(self.config)) {
            make.height.mas_equalTo(0);
        }
    }];
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.titleView.isHidden) {
            make.left.right.top.equalTo(self.bgView);
        }
    }];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        if (self.titleView.isHidden) {
            make.top.equalTo(self.bgView);
        } else {
            make.top.equalTo(self.titleView.mas_bottom);
        }
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    _config = config;

    NSNumber *cornerRadius = config.getCardContent[@"cornerRadius"];
    self.bgView.layer.cornerRadius = cornerRadius ? cornerRadius.integerValue : 5;
    self.bgView.layer.masksToBounds = true;

    self.bgView.backgroundColor = [config getBackgroundColor];

    NSString *backgroundImage = [config getBackgroundImage];
    if (HDIsStringNotEmpty(backgroundImage)) {
        [HDWebImageManager setImageWithURL:backgroundImage placeholderImage:nil imageView:self.bgIV];
    }

    [self updateTitleViewWithConfig:config.titleConfig];
    // 判断是否需要请求
    if ([self shouldRequestDataSourceWithConfig:config]) {
        NSString *dataSource = [self dataSourcePathWithConfig:config];
        NSDictionary *params = [self setupRequestParamtersWithDataSource:dataSource cardConfig:config];
        @HDWeakify(self);
        [self requestDataSource:dataSource params:params finish:^(NSError *error, NSDictionary *response) {
            @HDStrongify(self);
            if (!error) {
                [self parsingDataSourceResponse:response withCardConfig:config];
            }
        }];
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateTitleViewWithConfig:(SACMSTitleViewConfig *)config {
    // 标题或者副标题不为空，则展示标题栏
    if (HDIsStringNotEmpty(config.getTitle) || HDIsStringNotEmpty(config.getSubTitle)) {
        self.titleView.hidden = false;
        self.titleView.config = config;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - DATA
- (void)requestDataSource:(NSString *)dataSource params:(NSDictionary *)params finish:(void (^)(NSError *error, NSDictionary *response))finishBlock {
    // 取消上一次请求
    [self.request cancel];
    self.request.requestURI = dataSource;
    self.request.requestParameter = params;
    [self.request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        finishBlock(nil, response.responseObject);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        finishBlock(response.error, nil);
    }];
}

#pragma mark - OVERWIRTE
- (BOOL)shouldRequestDataSourceWithConfig:(SACMSCardViewConfig *)config {
    return NO;
}

- (NSString *)dataSourcePathWithConfig:(SACMSCardViewConfig *)config {
    return @"";
}

- (NSDictionary *)setupRequestParamtersWithDataSource:(NSString *)dataSource cardConfig:(nonnull SACMSCardViewConfig *)config {
    return @{};
}

- (void)parsingDataSourceResponse:(NSDictionary *)responseData withCardConfig:(SACMSCardViewConfig *)config {
    [self setNeedsUpdateConstraints];
    !self.refreshCard ?: self.refreshCard(self);
}

- (CGFloat)heightOfCardView {
    return 0;
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.clipsToBounds = true;
    }
    return _bgView;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
    }
    return _bgIV;
}

- (SACMSTitleView *)titleView {
    if (!_titleView) {
        _titleView = SACMSTitleView.new;
        _titleView.hidden = true;
        @HDWeakify(self);
        _titleView.clickTitleView = ^(NSString *_Nonnull link, NSString *_Nullable spm) {
            @HDStrongify(self);
            !self.clickNode ?: self.clickNode(self, nil, link, [@"title." stringByAppendingString:HDIsStringNotEmpty(spm) ? spm : @""]);
        };
    }
    return _titleView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
    }
    return _containerView;
}

- (CMNetworkRequest *)request {
    if (!_request) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.isNeedLogin = NO;
        _request = request;
    }
    return _request;
}

@end
