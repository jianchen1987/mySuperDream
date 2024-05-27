//
//  SAMarketingAlertView.m
//  SuperApp
//
//  Created by seeu on 2020/11/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMarketingAlertView.h"
#import "NSDate+SAExtension.h"
#import "SACacheManager.h"
#import "SAWindowManager.h"
#import "TNHomeViewController.h"
#import "WMHomeViewController.h"
#import <HDKitCore/HDKitCore.h>
#import <HDVendorKit.h>
#import "SDImageCache.h"
#import "SALotAnimationView.h"
#import "SACollectionView.h"
#import "SAMarketingAlertViewCollectionCell.h"
#import "SACollectionViewHorizontalMiddleBigFlowLayout.h"
#import "SAUser.h"


@interface SAMarketingAlertView () <HDAlertQueueObject, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<SAMarketingAlertViewConfig *> *configs; ///< 配置
@property (nonatomic, strong) HDUIButton *closeButton;            ///< 关闭按钮
///< uicollection
@property (nonatomic, strong) SACollectionView *collectionView;
///< 暂存的跳转路径
@property (nonatomic, copy) NSString *jumpLink;
///< 暂存的图片链接
@property (nonatomic, copy) NSString *imageLink;
///<
@property (nonatomic, strong) NSArray<SAMarketingAlertItem *> *dataSource;

///<
@property (nonatomic, assign) NSInteger currentIndex;
///<
@property (nonatomic, assign) CGFloat dragStartX;
///<
@property (nonatomic, assign) CGFloat dragEndX;

@end


@implementation SAMarketingAlertView

#pragma mark - Class methods
+ (NSString *)sharedMapQueueKey {
    // 默认以类名作为映射的 key，也就w意味着不同种继承于此的弹窗默认是可以同时显示的，如果需设置它们不可同时显示，可在其实现种重写此方法返回同一字符串，达到将其置于同一队列的目的
    return @"SAMarketingAlertView";
}

+ (instancetype)alertViewWithConfigs:(NSArray<SAMarketingAlertViewConfig *> *)configs {
    return [[self alloc] initWithConfigs:configs];
}

- (instancetype)initWithConfigs:(NSArray<SAMarketingAlertViewConfig *> *)configs {
    if (self = [super init]) {
        self.configs = configs;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = false;
        self.solidBackgroundColorAlpha = 0.8;

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(languageChanged) name:kNotificationNameLanguageChanged object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - event response
- (void)languageChanged {
    // 重新获取当前语言图片
    self.configs = self.configs;
}

#pragma mark - override
- (void)layoutContainerView {
    CGFloat left = (kScreenWidth - [self containerViewWidth]) * 0.5;
    CGFloat containerHeight = 0;
    containerHeight += [self imageViewSize].height;
    containerHeight += 30;
    containerHeight += [self closeButtonSize].height;
    CGFloat top = (kScreenHeight - containerHeight) * 0.5;
    self.containerView.frame = CGRectMake(left, top, [self containerViewWidth], containerHeight);
}

- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = UIColor.clearColor;
}

- (void)setupContainerSubViews {
    // 给containerview添加子视图
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.closeButton];
}

- (void)layoutContainerViewSubViews {

    self.collectionView.frame = CGRectMake(0, 0, [self containerViewWidth], [self imageViewSize].height);

    self.closeButton.frame = (CGRect){(CGRectGetWidth(self.containerView.frame) - [self closeButtonSize].width) * 0.5, [self imageViewSize].height + 30, [self closeButtonSize]};
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth;
}

- (CGSize)imageViewSize {
    return CGSizeMake([self containerViewWidth] * 0.7, [self containerViewWidth] * 0.7 * (345 / 291.0));
}

- (CGSize)closeButtonSize {
    return CGSizeMake(30, 30);
}


- (void)dismiss {
    [self.configs enumerateObjectsUsingBlock:^(SAMarketingAlertViewConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj save];
    }];
    
    if (self.willClose) {
        self.willClose(@"", @"", @"", @"");
    }

    [super dismiss];
}
- (void)show {
    [HDAlertQueueManager show:self];
}

#pragma mark - HDAlertQueueObject
- (NSString *_Nonnull)hd_alertIdentify {
    return NSStringFromClass(self.class);
}

- (HDAlertQueuePriority)hd_alertQueuePriority {
    return HDAlertQueuePriorityLow;
}

- (void)hd_alertQueueShow {
    [super show];
    __block NSUInteger sec = 0;
    [self.configs enumerateObjectsUsingBlock:^(SAMarketingAlertViewConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sec = MAX(sec, obj.closeAfterSec);
    }];
    if (sec > 0) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:sec];
    }
}

- (void)hd_alertQueueDismiss {
    [self dismiss];
}

- (Class)hd_alertQueueShowInController {
    return self.configs.firstObject.showInClass;
}

#pragma mark - public methods

#pragma mark - setter
- (void)setConfigs:(NSArray<SAMarketingAlertViewConfig *> *)configs {
    _configs = configs;


    NSMutableArray<SAMarketingAlertItem *> *arr = [[NSMutableArray alloc] initWithCapacity:2];;

    for(SAMarketingAlertViewConfig *config in configs) {
        if ([SAMultiLanguageManager isCurrentLanguageCN]) {
            [config.zhImageAndLinkInfos enumerateObjectsUsingBlock:^(SAMarketingAlertItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.associatedObj = config;
                [arr addObject:obj];
            }];
            
        } else if ([SAMultiLanguageManager isCurrentLanguageKH]) {
            [config.kmImageAndLinkInfos enumerateObjectsUsingBlock:^(SAMarketingAlertItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.associatedObj = config;
                [arr addObject:obj];
            }];
            
        } else {
            [config.enImageAndLinkInfos enumerateObjectsUsingBlock:^(SAMarketingAlertItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.associatedObj = config;
                [arr addObject:obj];
            }];
        }
        
//        if (config.picShowRule == SAMarketingAlertPicRuleRandomness) {
//            // 随机取一个
//            NSUInteger idx = arc4random() % (arr.count);
//            HDLog(@"随机序号:%zd", idx);
//            SAMarketingAlertItem *item = arr[idx];
//            setting(item);
//        } else {
//            // 按顺序取一个
//            NSNumber *lastIdx = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"kMarketingAlertLastIndex_%@", config.activityId] type:SACacheTypeDocumentPublic relyLanguage:YES];
//            HDLog(@"缓存序号:%@", lastIdx);
//            NSUInteger idx = HDIsObjectNil(lastIdx) ? 0 : lastIdx.integerValue;
//            HDLog(@"当前序号:%zd", idx);
//            SAMarketingAlertItem *item = arr[idx];
//            setting(item);
//            idx = (idx + 1) % arr.count;
//            HDLog(@"下一次序号:%zd", idx);
//            [SACacheManager.shared setObject:[NSNumber numberWithUnsignedInteger:idx] forKey:[NSString stringWithFormat:@"kMarketingAlertLastIndex_%@", config.activityId] type:SACacheTypeDocumentPublic
//                                relyLanguage:YES];
//        }
    }
    HDLog(@"当前满足条件有%zd个广告", arr.count);
    if([SAUser hasSignedIn]) {
        NSUInteger idx = SAUser.shared.operatorNo.longLongValue % arr.count;
        HDLog(@"除余得到:%zd", idx);
        [arr exchangeObjectAtIndex:0 withObjectAtIndex:idx];
    }
    
    self.dataSource = arr;
    [self.collectionView successGetNewDataWithNoMoreData:YES];
    // 用活动ID做唯一标识，防止重复弹窗
//    self.identitableString = config.activityId;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAMarketingAlertItem *model = self.dataSource[indexPath.row];
    SAMarketingAlertViewCollectionCell *cell = [SAMarketingAlertViewCollectionCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SAMarketingAlertItem *model = self.dataSource[indexPath.row];
    
    SAMarketingAlertViewConfig *config = model.associatedObj;
    [config save];
    
    if (self.willJumpTo) {
        self.willJumpTo(config.activityId, config.popName, model.popImage, model.jumpLink);
    }
    
    [self dismissCompletion:^{
        if (HDIsStringNotEmpty(model.jumpLink)) {
            [SAWindowManager openUrl:model.jumpLink withParameters:@{
                @"source" : [NSString stringWithFormat:@"首页弹窗@%zd", indexPath.row],
                @"associatedId" : model.associatedObj.activityId
            }];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragStartX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}


- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (self.dragStartX - self.dragEndX >= dragMiniDistance) {
        self.currentIndex -= 1;//向右
    } else if(_dragEndX - _dragStartX >= dragMiniDistance){
        self.currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    self.currentIndex = self.currentIndex <= 0 ? 0 : self.currentIndex;
    self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;

    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

#pragma mark - lazy load
/** @lazy closeButton */
- (HDUIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"marketingAlertClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (SACollectionView *)collectionView {
    if(!_collectionView) {
        SACollectionViewHorizontalMiddleBigFlowLayout *flowLayout = SACollectionViewHorizontalMiddleBigFlowLayout.new;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake([self imageViewSize].width, [self imageViewSize].height);
        flowLayout.minimumLineSpacing = kRealWidth(13);
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat padding = (kScreenWidth - [self imageViewSize].width) * 0.5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        
        _collectionView = [[SACollectionView alloc] initWithFrame:CGRectMake(0, 0, [self containerViewWidth], [self imageViewSize].height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:SAMarketingAlertViewCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(SAMarketingAlertViewCollectionCell.class)];
    }
    return _collectionView;
}

@end


@interface SAMarketingAlertViewConfig ()

@property (nonatomic, copy) NSString *enImgUrl;
@property (nonatomic, copy) NSString *kmImgUrl;
@property (nonatomic, copy) NSString *zhImgUrl;
@property (nonatomic, copy) NSString *enUrl;
@property (nonatomic, copy) NSString *kmUrl;
@property (nonatomic, copy) NSString *zhUrl;

@end


@implementation SAMarketingAlertViewConfig

static NSString *cacheKey = @"SAMarketingAlertViewConfig.cache";

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activityId": @"popNo"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"enImageAndLinkInfos": SAMarketingAlertItem.class, @"zhImageAndLinkInfos": SAMarketingAlertItem.class, @"kmImageAndLinkInfos": SAMarketingAlertItem.class};
}

- (BOOL)isValidWithLocation:(NSString *)location {
    if (self.showCount < 1)
        return NO;

    // 判断展示位置是否满足
    if (![location isEqualToString:self.location]) {
        return NO;
    }
    // 判断设备类型是否满足
    if ([[self.termType lowercaseString] rangeOfString:@"ios"].location == NSNotFound) {
        return NO;
    }

    // 判断版本号是否满足
    if (HDIsStringNotEmpty(self.version) && [self.version rangeOfString:[HDDeviceInfo appVersion]].location == NSNotFound) {
        return NO;
    }

    // 判断结束时间是否比当前时间小，防止缓存问题
    if (self.endTime > 0 && self.endTime < (NSDate.new.timeIntervalSince1970 * 1000)) {
        return NO;
    }

    //已登录
    if ([SAUser hasSignedIn] && (self.openOcacasion == 18 || self.openOcacasion == 19)) {
        return NO;
    }

    //未登录
    if (![SAUser hasSignedIn] && (self.openOcacasion == 11 || self.openOcacasion == 12 || self.openOcacasion == 13)) {
        return NO;
    }

    // 判断时间段是否满足
    if (self.popTimeType == SAMarketingAlertShowTimeFixedTime) {
        NSString *startTime = [self.popStartTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *endTime = [self.popEndTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *nowTime = [[[NSDate new] stringWithFormatStr:@"HH:mm"] stringByReplacingOccurrencesOfString:@":" withString:@""];

        if (nowTime.integerValue > endTime.integerValue || nowTime.integerValue < startTime.integerValue) {
            return NO;
        }
    }

    NSDictionary *showHistory = [SACacheManager.shared objectForKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (showHistory && [showHistory isKindOfClass:NSDictionary.class]) {
        NSString *currentCacheDate = [self getCurrentDateStr];
        NSString *cacheDate = showHistory[@"date"];
        HDLog(@"当前日期 = %@，缓存日期 = %@", currentCacheDate, cacheDate);
        if (!cacheDate || ![currentCacheDate isEqualToString:cacheDate]) { //之前没有缓存，或者缓存的日期不一样
            HDLog(@"日期不一样，需要展示");
            //            return YES;
            return [self _checkImageCache];
        }

        if ([currentCacheDate isEqualToString:cacheDate]) { //有缓存，而且缓存日期一样

            NSArray *cacheIds = showHistory[@"showTime"];
            NSInteger times = 0;
            for (NSString *idStr in cacheIds) {
                if ([idStr isEqualToString:self.activityId]) {
                    times++;
                }
            }
            if (times >= self.showCount) {
                HDLog(@"当前日期%@已展示次数%ld次，大于等于每天要求预设数%ld次", currentCacheDate, times, self.showCount);
                return NO;
            }
        }
    }

    //    return YES;
    return [self _checkImageCache];
}

- (BOOL)_checkImageCache {
    NSArray<SAMarketingAlertItem *> *arr = nil;

    if ([SAMultiLanguageManager isCurrentLanguageCN]) {
        arr = [self.zhImageAndLinkInfos copy];
    } else if ([SAMultiLanguageManager isCurrentLanguageKH]) {
        arr = [self.kmImageAndLinkInfos copy];
    } else {
        arr = [self.enImageAndLinkInfos copy];
    }

    NSInteger count = 0;
    NSMutableArray *waitingDownloadArr = NSMutableArray.new;
    NSMutableArray *jsonDownloadArr = NSMutableArray.new;
    for (SAMarketingAlertItem *item in arr) {
        //        测试数据
        //        item.popImage = @"https://img.tinhnow.com/wownow/files/uat/app/M7B/7B/22/76/ade164804e8511ed9d18b18ad3563174.json";
        if ([item.popImage hasSuffix:@"json"]) {
            NSData *animationData = [SACacheManager.shared objectForKey:item.popImage type:SACacheTypeDocumentPublic];
            if (animationData && [animationData isKindOfClass:NSData.class]) {
                count++;
                HDLog(@"有缓存,无需下载json图片");
            } else {
                [jsonDownloadArr addObject:item.popImage];
                HDLog(@"无缓存,需要下载json图片");
            }

        } else {
            /// 判断是否有imageURL的缓存
            BOOL isExist = [[SDImageCache sharedImageCache] diskImageDataExistsWithKey:item.popImage];
            if (isExist) {
                count++;
                HDLog(@"有缓存,无需下载图片");
            } else {
                [waitingDownloadArr addObject:item.popImage];
                HDLog(@"无缓存,需要下载图片");
            }
        }
    }
    if (waitingDownloadArr.count) {
        HDLog(@"无缓存,需要下载图片%ld张", waitingDownloadArr.count);
        SDWebImagePrefetcher *fetcher = [SDWebImagePrefetcher sharedImagePrefetcher];
        [fetcher prefetchURLs:waitingDownloadArr progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
            HDLog(@"%ld-%ld", noOfTotalUrls, noOfTotalUrls);
        } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
            HDLog(@"需要下载的图片下载完毕");
        }];
    }

    if (jsonDownloadArr.count) {
        for (NSString *animationURL in jsonDownloadArr) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                NSData *animationData = [NSData dataWithContentsOfURL:[NSURL URLWithString:animationURL]];
                if (!animationData)
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SACacheManager.shared setObject:animationData forKey:animationURL type:SACacheTypeDocumentPublic];
                    HDLog(@"需要下载的json图片下载完毕-%@", animationURL);
                });
            });
        }
    }

    return count == arr.count;
}

- (BOOL)save {
    if (HDIsStringEmpty(self.activityId)) {
        return NO;
    }
    NSDictionary *showHistory = [SACacheManager.shared objectForKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:NO];

    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:showHistory];

    NSString *currentCacheDate = [self getCurrentDateStr];

    NSMutableArray *mArr = NSMutableArray.new;
    if (showHistory && [showHistory isKindOfClass:NSDictionary.class]) {
        NSString *cacheDate = showHistory[@"date"];
        if (cacheDate && [currentCacheDate isEqualToString:cacheDate]) { //之前没有缓存，或者缓存的日期不一样,更新当前记录时间
            NSArray *cacheIds = showHistory[@"showTime"];
            [mArr addObjectsFromArray:cacheIds];
        }
    }

    [mArr addObject:self.activityId];
    tmp[@"date"] = currentCacheDate;
    tmp[@"showTime"] = mArr;
    [SACacheManager.shared setObject:tmp forKey:cacheKey type:SACacheTypeDocumentPublic relyLanguage:NO];
    return YES;
}

- (NSString *)getCurrentDateStr {
    return [NSDate.new stringWithFormatStr:@"yyyyMMdd"];
    //    switch (self.showType) {
    //        case SAMarketingAlertShowTypeOnce:  // 只展示一次
    //            return kCacheKeyAlertLocalCache;
    //        case SAMarketingAlertShowTypeOnceInDay:  // 每天一次
    //            return [NSDate.new stringWithFormatStr:@"yyyyMMdd"];
    //        case SAMarketingAlertShowTypeAlways:  // 一直展示
    //            return nil;
    //    }
}

#pragma mark - setter
- (void)setEnImgUrl:(NSString *)enImgUrl {
    _enImgUrl = enImgUrl;
    self.imageUrl.en_US = enImgUrl;
}

- (void)setKmImgUrl:(NSString *)kmImgUrl {
    _kmImgUrl = kmImgUrl;
    self.imageUrl.km_KH = kmImgUrl;
}

- (void)setZhImgUrl:(NSString *)zhImgUrl {
    _zhImgUrl = zhImgUrl;
    self.imageUrl.zh_CN = zhImgUrl;
}

- (void)setEnUrl:(NSString *)enUrl {
    _enUrl = enUrl;
    self.action.en_US = enUrl;
}

- (void)setKmUrl:(NSString *)kmUrl {
    _kmUrl = kmUrl;
    self.action.km_KH = kmUrl;
}

- (void)setZhUrl:(NSString *)zhUrl {
    _zhUrl = zhUrl;
    self.action.zh_CN = zhUrl;
}

#pragma mark - getter
- (SAInternationalizationModel *)imageUrl {
    if (!_imageUrl) {
        _imageUrl = SAInternationalizationModel.new;
    }
    return _imageUrl;
}

- (SAInternationalizationModel *)action {
    if (!_action) {
        _action = SAInternationalizationModel.new;
    }
    return _action;
}

@end


@implementation SAMarketingAlertItem

@end
