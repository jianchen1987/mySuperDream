//
//  TNBargainProductDetailView.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNBargainProductDetailView.h"
#import "LKDataRecord.h"
#import "NSString+extend.h"
#import "SAInfoTableViewCell.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "SJAttributesFactory.h"
#import "SJDeviceVolumeAndBrightnessManager.h"
#import "SJFloatSmallViewController.h"
#import "TNBargainProductDetailViewModel.h"
#import "TNBargainProductNavBarView.h"
#import "TNBargainSelectGoodsView.h"
#import "TNBargainSuspendWindow.h"
#import "TNBargainTipsView.h"
#import "TNBargainViewModel.h"
#import "TNCustomerServiceView.h"
#import "TNDeliverFlowModel.h"
#import "TNGlobalData.h"
#import "TNIMManger.h"
#import "TNItemModel.h"
#import "TNPhoneActionAlertView.h"
#import "TNPopMenuCell.h"
#import "TNProductBuyTipsView.h"
#import "TNProductChooseSpecificationsView.h"
#import "TNProductDeliveryInfoViewController.h"
#import "TNProductDetailBottomView.h"
#import "TNProductDetailExpressCell.h"
#import "TNProductDetailPublicImgCell.h"
#import "TNProductDetailSellerBottomView.h"
#import "TNProductDetailServiceCell.h"
#import "TNProductDetailSkeletonCell.h"
#import "TNProductDetailsActivityCell.h"
#import "TNProductDetailsBargainBottomView.h"
#import "TNProductDetailsIntroTableViewCell.h"
#import "TNProductDetailsIntroductionTableViewCell.h"
#import "TNProductDetailsRspModel.h"
#import "TNProductDetailsStoreCell.h"
#import "TNProductDetailsViewModel.h"
#import "TNProductReviewTableViewCell.h"
#import "TNProductSaleRegionAlertView.h"
#import "TNProductSaleRegionModel.h"
#import "TNProductSepcInfoModel.h"
#import "TNProductServiceAlertView.h"
#import "TNProductServiceInfoModel.h"
#import "TNShareManager.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarItemModel.h"
#import "TNShoppingCarStoreModel.h"
#import "TNShoppingCartEntryWindow.h"
#import "TNSingleVideoCollectionViewCell.h"
#import "TNSkuSpecModel.h"
#import "UIView+NAT.h"
#import "UIView+SJAnimationAdded.h"
#import "YBPopupMenu.h"
#import <KSInstantMessagingKit/KSChatUI.h>
#import <KSInstantMessagingKit/KSCore.h>
#import <MessageUI/MessageUI.h>

#define kTableHeaderHeight 45
#define kTableFooterSpace 10

static SJEdgeControlButtonItemTag TNEdgeControlBottomMuteButtonItemTag = 101; //声音按钮
static SJEdgeControlButtonItemTag TNEdgeControlCenterPlayButtonItemTag = 102; //播放按钮


@interface TNBargainProductDetailView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) TNBargainProductDetailViewModel *viewModel;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<HDTableViewSectionModel *> *dataSource;
/// 砍价页面的邀请好友助力
@property (strong, nonatomic) TNProductDetailsBargainBottomView *bargainBottomView;
///< iPhoneX 系列底部填充
@property (nonatomic, strong) UIView *iphoneXSeriousSafeAreaFillView;
/// 商品详情导航栏
@property (strong, nonatomic) TNBargainProductNavBarView *customNaviBar;
/// pop 的数据源
@property (nonatomic, strong) NSArray<TNPopMenuCellModel *> *menuDataSourceArray;
/// 砍价VM
@property (nonatomic, strong) TNBargainViewModel *bargainViewModel;
/// 砍价规格选择
@property (nonatomic, strong) TNBargainSelectGoodsView *selectView;
///
@property (nonatomic, strong) NSMutableArray *navTitleSectionArray;
/// 我的助力记录浮层
@property (strong, nonatomic) TNBargainSuspendWindow *recordWindow;
/// 播放器
@property (strong, nonatomic) SJVideoPlayer *player;
/// 播放器视图的位置  记录一次
@property (nonatomic, assign) CGFloat playerMaxY;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNBargainProductDetailView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.G5;
    [self addSubview:self.tableView];
    [self addSubview:self.customNaviBar];
    [self.customNaviBar hiddenShareAndMoreBtn];
    //砍价详情  需要显示 砍价中心按钮
    [self.recordWindow showInView:self];
    [self addSubview:self.bargainBottomView];
    @HDWeakify(self);
    [self.tableView registerEndScrollinghandler:^{
        @HDStrongify(self);
        if (!self.tableView.isScrolling) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //停止滚动的时候  收起购物车
                [self.recordWindow expand];
            });
        }
    } withKey:@"TNBargainActivityDetail_scroll_key"];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView successGetNewDataWithNoMoreData:YES];

    [self.viewModel queryBargainProductDetailsData];
    @HDWeakify(self);
    self.viewModel.failGetProductDetaulDataCallBack = ^(SARspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //商品失效或者下架 需要展示回到首页错误视图
        BOOL showGoBackHome = [rspModel.code isEqualToString:@"TN1004"] || [rspModel.code isEqualToString:@"TN1003"];
        self.dataSource = [NSArray array];
        UIViewPlaceholderViewModel *placeholderViewModel = UIViewPlaceholderViewModel.new;
        placeholderViewModel.needRefreshBtn = YES;
        @HDWeakify(self);
        placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self);
            if (showGoBackHome) {
                [[HDMediator sharedInstance] navigaveToTinhNowController:nil]; //进入电商主页
            } else {
                [self.viewModel queryBargainProductDetailsData];
            }
        };
        if (showGoBackHome) {
            placeholderViewModel.image = @"tinhnow_product_fail_bg";
            placeholderViewModel.title = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"network_error", @"网络开小差啦");
            placeholderViewModel.refreshBtnTitle = TNLocalizedString(@"tn_back_home", @"返回首页");
        } else {
            placeholderViewModel.image = @"placeholder_network_error";
            placeholderViewModel.title = SALocalizedString(@"network_error", @"网络开小差啦");
            placeholderViewModel.refreshBtnTitle = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        }
        self.tableView.placeholderViewModel = placeholderViewModel;
        [self.tableView failGetNewData];
        self.bargainBottomView.hidden = YES;
        [self.customNaviBar hiddenShareAndMoreBtn];

        if (!showGoBackHome && HDIsStringNotEmpty(rspModel.msg)) {
            [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        }
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataSource = [NSArray arrayWithArray:self.viewModel.dataSource];
        self.customNaviBar.titleArr = [self getNavTitleArray];
        [self setNavTitleSection];
        [self.tableView successGetNewDataWithNoMoreData:YES];
        self.bargainBottomView.hidden = NO;
        [self.customNaviBar showMoreBtn];
    }];
}

/// 联系商家 - 电话
- (void)makePhoneCall {
    [HDSystemCapabilityUtil makePhoneCall:self.viewModel.productDetailsModel.storePhone];
}

/// 联系平台
- (void)showPlatform {
    TNCustomerServiceView *view = [[TNCustomerServiceView alloc] init];

    view.dataSource = [view getTinhnowDefaultPlatform];
    [view layoutyImmediately];
    TNPhoneActionAlertView *actionView = [[TNPhoneActionAlertView alloc] initWithContentView:view];
    [actionView show];
}

/// 返回主页
- (void)goBackToHome {
    [[HDMediator sharedInstance] navigaveToTinhNowController:@{}];
}
- (void)goToSearchPage {
    [SAWindowManager openUrl:@"SuperApp://TinhNow/SearchPage" withParameters:nil];
}

#pragma mark - 砍价活动分享
- (void)bagainGoodShareClick {
    TNShareModel *shareModel = [[TNShareModel alloc] init];
    if (!HDIsArrayEmpty(self.viewModel.productDetailsModel.productImages)) {
        TNImageModel *model = self.viewModel.productDetailsModel.productImages.firstObject;
        shareModel.shareImage = model.thumbnail;
    }
    shareModel.shareTitle = self.viewModel.productDetailsModel.name;
    shareModel.shareContent = TNLocalizedString(@"tn_share_bargain_desc", @"帮我助力超低价拿走商品吧！");
    NSString *headUrl = [SAUser shared].headURL;
    NSString *name = [SAUser shared].loginName;
    NSString *baseUrl = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowBargainDetail];
    NSString *shareUrl = [NSString stringWithFormat:@"%@id=%@&isWeiXin=false&name=%@&userImg=%@", baseUrl, self.viewModel.taskId, name, headUrl];
    shareModel.shareLink = shareUrl;
    shareModel.type = TNShareTypeBargainInvite;
    shareModel.sourceId = self.viewModel.activityId;
    [[TNShareManager sharedInstance] showShareWithShareModel:shareModel];
}
/// MARK: pop弹窗右上角
- (void)showPopMenu:(HDUIButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:self.menuDataSourceArray icons:self.menuDataSourceArray menuWidth:[self getMaxWidth] otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = (id)self;
        popupMenu.itemHeight = 50.f;
        popupMenu.cornerRadius = 8.f;
    }];
}

//获取显示的内容 调整pop 的宽度 （不同语种 不一样）
- (CGFloat)getMaxWidth {
    __block CGFloat width = 0;
    [self.menuDataSourceArray enumerateObjectsUsingBlock:^(TNPopMenuCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *str = obj.title;
        CGSize strSize = [str boundingAllRectWithSize:CGSizeMake(MAXFLOAT, 20.f) font:HDAppTheme.TinhNowFont.standard14];
        if (width < strSize.width) {
            width = strSize.width;
        }
    }];

    width = width + 60.f;
    return width;
}

/// MARK: 获取商户客服列表
- (void)getCustomerList:(NSString *)storeNo {
    [self showloading];
    @HDWeakify(self);
    [[TNIMManger shared] getCustomerServerList:storeNo success:^(NSArray<TNIMRspModel *> *_Nonnull rspModelArray) {
        @HDStrongify(self);
        [self dismissLoading];
        if (rspModelArray.count > 0) {
            TNIMRspModel *imModel = rspModelArray.firstObject;
            [self openIMViewControllerWithOperatorNo:imModel.operatorNo storeNo:storeNo];
        } else {
            HDLog(@"没获取到数据");
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        HDLog(@"%@", error.domain);
    }];
}

- (void)openIMViewControllerWithOperatorNo:(NSString *)operatorNo storeNo:(NSString *)storeNo {
    NSString *imageUrl = self.viewModel.productDetailsModel.productImages.count > 0 ? self.viewModel.productDetailsModel.productImages.firstObject.thumbnail : @"";

    NSDictionary *extensionJsonDict = @{
        @"type": @"productDetails",
        @"value": [self.viewModel.originParameters yy_modelToJSONString],
        @"businessLine": SAClientTypeTinhNow,
    };

    NSDictionary *cardDict = @{
        @"title": self.viewModel.productDetailsModel.name ?: @"",
        @"content": self.viewModel.productDetailsModel.price.thousandSeparatorAmount ?: @"",
        @"imageUrl": imageUrl,
        @"link": self.viewModel.productDetailsModel.shareUrl ?: @"",
        @"extensionJson": [extensionJsonDict yy_modelToJSONString],
    };
    NSString *cardJsonStr = [cardDict yy_modelToJSONString];

    NSDictionary *dict = @{@"operatorType": @(8), @"operatorNo": operatorNo ?: @"", @"storeNo": storeNo ?: @"", @"card": cardJsonStr, @"scene": SAChatSceneTypeTinhNowConsult};
    [[HDMediator sharedInstance] navigaveToIMViewController:dict];
}

/// MARK: 弹出砍价规格选择窗口
- (void)showBargainSpecView {
    @HDWeakify(self);
    self.bargainViewModel.view = self;
    // 1弹出规格选择界面
    [self.bargainViewModel getGoodSkuSpecAndAdressByActivityId:self.viewModel.activityId completion:^{
        @HDStrongify(self);
        if (self.bargainViewModel.skuModel) {
            //构造一个 需要的数据
            TNBargainGoodModel *gModel = [[TNBargainGoodModel alloc] init];
            gModel.goodsPriceMoney = self.viewModel.productDetailsModel.marketPrice;
            gModel.lowestPriceMoney = self.viewModel.productDetailsModel.lowestPrice;
            gModel.goodsName = self.viewModel.productDetailsModel.name;
            gModel.activityId = self.viewModel.activityId;
            gModel.goodsId = self.viewModel.productDetailsModel._id;
            if (!HDIsArrayEmpty(self.viewModel.productDetailsModel.productImages)) {
                gModel.images = self.viewModel.productDetailsModel.productImages.firstObject.thumbnail;
                gModel.skuLargeImg = self.viewModel.productDetailsModel.productImages.firstObject.source;
            }
            self.bargainViewModel.goodModel = gModel;
            self.selectView = nil;
            self.selectView = [[TNBargainSelectGoodsView alloc] init];
            self.selectView.viewModel = self.bargainViewModel;
            self.selectView.createTaskClickCallBack = ^(TNBargainSelectGoodsView *_Nonnull showView) {
                @HDStrongify(self);
                [self showloading];
                // 2、校验配送范围
                [self.bargainViewModel checkRegion:^(TNCheckRegionModel *_Nonnull checkModel) {
                    @HDStrongify(self);
                    if (checkModel.deliveryValid == YES) {
                        // 3、创建 砍价任务
                        [self.bargainViewModel createBargainTaskWithModel:[self.bargainViewModel createBargainTaskModel] completion:^(NSString *_Nonnull taskId) {
                            //创建成功后  进入助力详情
                            if (HDIsStringNotEmpty(taskId)) {
                                [[HDMediator sharedInstance] navigaveToTinhNowBargainDetailViewController:@{@"taskId": taskId}];
                                //刷新首页的正在进行中数据
                                //                                                        [self.bargainViewModel getUnderwayTaskData];
                            }
                            [showView removeFromSuperview];
                        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                            @HDStrongify(self);
                            HDLog(@"%@", error);
                            HDLog(@"%@", rspModel);
                            //正在助力这个商品，请结束后再发起。"
                            if ([rspModel.code isEqualToString:@"10065"]) {
                                [self.selectView dissmiss];

                                TNBargainTipsViewConfig *config = TNBargainTipsViewConfig.new;
                                config.logoName = @"tinhnow_my_record_big";
                                config.logoFrame = [self.recordWindow getIconFrame];
                                config.contentStr = rspModel.msg;
                                config.contentTitleColor = [UIColor whiteColor];
                                config.contentFont = [[HDAppTheme TinhNowFont] fontSemibold:14.f];
                                config.contentBackgroundColor = [UIColor hd_colorWithHexString:@"FF9657"];
                                TNBargainTipsView *vc = [[TNBargainTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                                vc.config = config;
                                [vc show];

                            } else {
                                [HDTips showWithText:rspModel.msg inView:self hideAfterDelay:3];
                            }
                        }];
                    } else {
                        [self dismissLoading];
                        [NAT showAlertWithMessage:HDIsStringNotEmpty(checkModel.tipsInfo) ? checkModel.tipsInfo : TNLocalizedString(@"tn_check_region_tip", @"商品仅配送至金边主城区，请修改收货地址")
                                      buttonTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                          [alertView dismiss];
                                      }];
                    }
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self dismissLoading];
                }];
            };
            [self.selectView show:self];
        }
    }];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    TNPopMenuCellModel *model = self.menuDataSourceArray[index];
    if (model.type == TNPopMenuTypeHome) {
        [self goBackToHome];
    } else if (model.type == TNPopMenuTypeContactPlatform) {
        [self showPlatform];
    } else if (model.type == TNPopMenuTypeContactMerchant) {
        [self makePhoneCall];
    } else if (model.type == TNPopMenuTypeSearch) {
        [self goToSearchPage];
    }
}

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index {
    TNPopMenuCell *cell = [TNPopMenuCell cellWithTableView:ybPopupMenu.tableView];
    cell.model = self.menuDataSourceArray[index];

    return cell;
}

//#pragma mark -
//#pragma mark - 发短信
//- (void)sendMessage {
//    if ([MFMessageComposeViewController canSendText]) {
//        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = @[ [self.viewModel.productDetailsModel.storePhone filterCambodiaPhoneNum] ];
//        //            controller.body = @"";
//        controller.messageComposeDelegate = self;
//        [self.viewController presentViewController:controller animated:YES completion:nil];
//    } else {
//        // @"该设备不支持短信功能"
//        [NAT showToastWithTitle:nil content:TNLocalizedString(@"tn_no_authority", @"权限不足") type:HDTopToastTypeError];
//    }
//}
//// MFMessageComposeViewController delegate
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
//    if (result == MessageComposeResultCancelled) {
//        HDLog(@"取消发送");
//    } else if (result == MessageComposeResultSent) {
//        HDLog(@"发送成功");
//    } else if (result == MessageComposeResultFailed) {
//        HDLog(@"发送失败");
//    }
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - 播放器相关
#pragma mark 设置播放器默认配置
//有时间 重写播放器控制层
- (void)setUpVideoPlayer {
    //设置颜色
    SJVideoPlayer.update(^(SJVideoPlayerConfigurations *_Nonnull configs) {
        configs.resources.progressThumbSize = 10;
        configs.resources.progressThumbColor = [UIColor whiteColor];
        configs.resources.progressTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.bottomIndicatorTraceColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.backImage = [UIImage imageNamed:@"tn_video_close_big"];
        configs.resources.floatSmallViewCloseImage = [UIImage imageNamed:@"tn_video_close"];
        configs.resources.playFailedButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.resources.noNetworkButtonBackgroundColor = HDAppTheme.TinhNowColor.C1;
        configs.localizedStrings.reload = TNLocalizedString(@"tn_button_reload_title", @"重新加载");
        configs.localizedStrings.playbackFailedPrompt = @"";
        configs.localizedStrings.noNetworkPrompt = SALocalizedString(@"network_error", @"网络开小差啦");
    });

    _player.onlyUsedFitOnScreen = YES;
    _player.resumePlaybackWhenScrollAppeared = NO;
    _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = NO;
    if (@available(iOS 14.0, *)) {
        _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
    } else {
        // Fallback on earlier versions
    }

    //设置占位图图片样式
    _player.presentView.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    //默认静音播放
    _player.muted = YES;
    //设置小窗样式
    SJFloatSmallViewController *floatSmallViewController = (SJFloatSmallViewController *)_player.floatSmallViewController;
    floatSmallViewController.layoutPosition = SJFloatViewLayoutPositionTopRight;
    floatSmallViewController.layoutInsets = UIEdgeInsetsMake(kNavigationBarH - kStatusBarH, 12, 20, 12);
    floatSmallViewController.layoutSize = CGSizeMake(kRealWidth(120), kRealWidth(120));
    floatSmallViewController.floatView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //删除原有的播放  放大按钮
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Play];
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];

    //当前时间
    SJEdgeControlButtonItem *currentTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_CurrentTime];
    currentTimeItem.insets = SJEdgeInsetsMake(15, 0);
    [_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_Progress withItemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    SJEdgeControlButtonItem *durationTimeItem = [_player.defaultEdgeControlLayer.bottomAdapter itemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    durationTimeItem.insets = SJEdgeInsetsMake(0, 60);

    //声音按钮固定在底部控制层
    __block HDUIButton *muteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [muteBtn setImage:[UIImage imageNamed:@"tn_video_mute"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"tn_video_unmute"] forState:UIControlStateSelected];
    muteBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    [muteBtn addTarget:self action:@selector(muteClick) forControlEvents:UIControlEventTouchUpInside];
    muteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [muteBtn sizeToFit];
    [_player.defaultEdgeControlLayer.controlView addSubview:muteBtn];
    [muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view);
        make.right.equalTo(_player.defaultEdgeControlLayer.bottomAdapter.view.mas_right).offset(-15);
    }];
    muteBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:12];
    };

    //小窗添加一个是否禁音按钮
    __block SJEdgeControlButtonItem *muteItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"tn_video_mute"] target:self action:@selector(muteClick)
                                                                                           tag:TNEdgeControlBottomMuteButtonItemTag];
    SJEdgeControlButtonItem *fillItem = [[SJEdgeControlButtonItem alloc] initWithTag:200];
    fillItem.fill = YES;
    _player.defaultFloatSmallViewControlLayer.bottomHeight = 35;
    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:fillItem];
    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:muteItem];

    //静音回调
    @HDWeakify(self);
    _player.playbackObserver.mutedDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        muteBtn.selected = !player.isMuted;
        if (player.isMuted) {
            muteItem.image = [UIImage imageNamed:@"tn_video_mute"];
        } else {
            muteItem.image = [UIImage imageNamed:@"tn_video_unmute"];
        }
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
        }
    };

    //添加 中间播放按钮
    [_player.defaultEdgeControlLayer.centerAdapter removeItemForTag:SJEdgeControlLayerCenterItem_Replay];

    SJEdgeControlButtonItem *playItem = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"tn_product_video_play"] target:self action:@selector(playClick)
                                                                                   tag:TNEdgeControlCenterPlayButtonItemTag];
    playItem.hidden = YES;
    [_player.defaultEdgeControlLayer.centerAdapter addItem:playItem];
    [_player.defaultEdgeControlLayer.centerAdapter reload];

    //播放完毕事件回调
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self.player.presentView showPlaceholderAnimated:YES];
        [self setPlayItemHidden:NO];
    };

    //全屏回调
    _player.fitOnScreenObserver.fitOnScreenWillBeginExeBlock = ^(id<SJFitOnScreenManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isFitOnScreen) {
            //进入全屏就打开声音
            if (self.player.isMuted) {
                self.player.muted = NO;
            }
        } else {
            if (self.tableView.contentOffset.y > self.playerMaxY) { //这种情况是浮窗进入大屏  再放小的情况  这个时候 暂停视频
                [self.player pauseForUser];
            }
        }
    };

    _player.gestureControl.supportedGestureTypes = SJPlayerGestureTypeMask_SingleTap | SJPlayerGestureTypeMask_Pan;
    //单击事件回调
    _player.gestureControl.singleTapHandler = ^(id<SJPlayerGestureControl> _Nonnull control, CGPoint location) {
        @HDStrongify(self);
        if (self.player.floatSmallViewController.isAppeared) {
            [self.player.floatSmallViewController dismissFloatView];
            [self.player setFitOnScreen:YES animated:YES];
        } else {
            if (!self.player.isFitOnScreen) {
                [self.player setFitOnScreen:YES animated:YES];
            } else {
                if (self.player.controlLayerAppearManager.isAppeared) {
                    [self.player controlLayerNeedDisappear];
                } else {
                    [self.player controlLayerNeedAppear];
                }
            }
        }
    };
    _player.controlLayerAppearObserver.appearStateDidChangeExeBlock = ^(id<SJControlLayerAppearManager> _Nonnull mgr) {
        @HDStrongify(self);
        if (mgr.isAppeared) {
            if (self.player.isFitOnScreen) {
                [self setPlayItemHidden:NO];
            } else {
                [self setPlayItemHidden:self.player.isPlaying];
            }
        } else {
            [self setPlayItemHidden:self.player.isPlaying];
        }
    };
    _player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer *_Nonnull player) {
        @HDStrongify(self);
        [self showPlayItemImage:self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused];
        if (self.player.isPlaying && !self.player.isFitOnScreen) {
            [self setPlayItemHidden:YES];
        }
        //全屏状态下  如果播放后 控制层不在 马上隐藏播放按钮
        if (self.player.isPlaying && self.player.isFitOnScreen && !self.player.controlLayerAppeared) {
            [self setPlayItemHidden:YES];
        }
        if (self.player.isPaused) {
            [self setPlayItemHidden:NO];
        }
    };
}
- (void)setPlayItemHidden:(BOOL)hidden {
    SJEdgeControlButtonItem *playitem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:TNEdgeControlCenterPlayButtonItemTag];
    playitem.hidden = hidden;
    [self.player.defaultEdgeControlLayer.centerAdapter reload];
}
//设置播放图片
- (void)showPlayItemImage:(BOOL)isPlaying {
    SJEdgeControlButtonItem *playItem = [_player.defaultEdgeControlLayer.centerAdapter itemForTag:TNEdgeControlCenterPlayButtonItemTag];
    if (isPlaying) {
        playItem.image = [UIImage imageNamed:@"tn_video_pause"];
    } else {
        playItem.image = [UIImage imageNamed:@"tn_product_video_play"];
    }
    [self.player.defaultEdgeControlLayer.centerAdapter reload];

    if (isPlaying && !self.player.presentView.isPlaceholderImageViewHidden) {
        [self.player.presentView hiddenPlaceholderAnimated:YES];
    }
}

#pragma mark 静音按钮点击
- (void)muteClick {
    _player.muted = !_player.isMuted;
}
#pragma mark 播放按钮点击
- (void)playClick {
    //放大状态下
    if (self.player.isPlaying) {
        [self.player pauseForUser];
    } else {
        if (!self.player.presentView.isPlaceholderImageViewHidden) {
            [self.player.presentView hiddenPlaceholderAnimated:YES];
        }
        if (self.player.isPlaybackFinished) {
            [self.player replay];
        } else {
            [self.player play];
        }
    }
}
#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    //更新alpha显示
    [self.customNaviBar updateUIWithScrollViewOffsetY:offsetY];

    if (self.player.timeControlStatus != SJPlaybackTimeControlStatusPaused || self.player.floatSmallViewController.isAppeared) {
        if (self.playerMaxY <= 0) {
            self.playerMaxY = CGRectGetMaxY(self.player.presentView.frame);
        }
        if (offsetY > self.playerMaxY) {
            CGPoint scrollVelocity = [scrollView.panGestureRecognizer translationInView:self];
            if (!self.player.floatSmallViewController.isAppeared && !self.player.isFitOnScreen && scrollVelocity.y < 0 && !self.player.isFitOnScreen) { //大屏和向上滑都不触发显示小屏
                [self.player.floatSmallViewController showFloatView];
            }
        } else {
            if (self.player.floatSmallViewController.isAppeared) {
                [self.player.floatSmallViewController dismissFloatView];
            }
        }
    }

    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        // HDLog(@"不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理");
        return;
    }

    //更新 标题栏移动位置
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, offsetY + self.customNaviBar.hd_height + kStatusBarH)];
    if (indexPath) {
        NSInteger section = indexPath.section;
        [self setIndex:section];
    }

    //    if (self.viewModel.bargainStyle > BargainStyleNone) {
    scrollView.isScrolling = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.1];
    //    }
}

- (void)setIndex:(NSInteger)section {
    if ([self.navTitleSectionArray containsObject:@(section)]) {
        NSInteger index = [self getIndexWithSection:section];
        if (index != [self.customNaviBar currentTitleIndex]) {
            [self.customNaviBar updateSectionViewSelectedItemWithIndex:index];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.recordWindow shrink];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //    if (self.viewModel.bargainStyle > BargainStyleNone) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    scrollView.isScrolling = false;
    //    }
}

//获取在数组中存在第几个index
- (NSInteger)getIndexWithSection:(NSInteger)section {
    __block NSInteger index = 0;
    [self.viewModel.titleArr enumerateObjectsUsingBlock:^(TNProductNavTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.section == section) {
            index = idx;
            *stop = YES;
        }
    }];

    return index;
}

- (CGFloat)getAllSectionHeaderHeight {
    __block CGFloat height = 0;
    [self.viewModel.titleArr enumerateObjectsUsingBlock:^(TNProductNavTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.isSectionHeader) {
            height += kTableHeaderHeight;
        }
    }];
    return height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.dataSource[section].list;
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.dataSource.count)
        return nil;
    HDTableViewSectionModel *sectionModel = self.dataSource[indexPath.section];
    if (indexPath.row >= sectionModel.list.count)
        return nil;

    id model = sectionModel.list[indexPath.row];
    if ([model isKindOfClass:TNProductDetailsIntroTableViewCellModel.class]) {
        TNProductDetailsIntroTableViewCell *cell = [TNProductDetailsIntroTableViewCell cellWithTableView:tableView];
        TNProductDetailsIntroTableViewCellModel *trueModel = (TNProductDetailsIntroTableViewCellModel *)model;
        @HDWeakify(self);
        cell.videoTapClick = ^(HDCyclePagerView *_Nonnull pagerView, NSIndexPath *_Nonnull indexPath, TNSingleVideoCollectionViewCellModel *model) {
            @HDStrongify(self);
            [self.player.presentView.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageUrl]];
            SJPlayModel *playModel = [SJPlayModel playModelWithCollectionView:pagerView.collectionView indexPath:indexPath superviewSelector:NSSelectorFromString(@"videoContentView")];
            self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.videoUrl] playModel:playModel];
            HDReachability *reachability = [HDReachability reachabilityForInternetConnection];
            if (reachability.currentReachabilityStatus == ReachableViaWWAN) {
                [HDTips showWithText:TNLocalizedString(@"tn_video_play_tip", @"您正在使用非WiFi播放，请注意手机流量消耗") hideAfterDelay:3];
            }
            [self.player play];
        };
        cell.pagerViewChangePage = ^(NSInteger index) {
            @HDStrongify(self);
            if (index == 0) {
                self.player.floatSmallViewController.enabled = YES;
            } else {
                self.player.floatSmallViewController.enabled = NO;
            }
        };
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:TNProductSaleRegionCellModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView
                                                                identifier:[NSString stringWithFormat:@"TNProductSaleRegionCellModel section %ld  row %ld", indexPath.section, indexPath.row]];
        SAInfoViewModel *trueModel = (TNProductSaleRegionCellModel *)model;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:SAInfoViewModel.class]) {
        SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView identifier:[NSString stringWithFormat:@"SAInfoViewModel section %ld  row %ld", indexPath.section, indexPath.row]];
        SAInfoViewModel *trueModel = (SAInfoViewModel *)model;
        cell.model = trueModel;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailsIntroductionTableViewCellModel.class]) {
        TNProductDetailsIntroductionTableViewCell *cell = [TNProductDetailsIntroductionTableViewCell cellWithTableView:tableView];
        TNProductDetailsIntroductionTableViewCellModel *trueModel = (TNProductDetailsIntroductionTableViewCellModel *)model;
        cell.model = trueModel;
        @HDWeakify(self);
        cell.getWebViewHeightCallBack = ^{ //刷新table 展开高度
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailsActivityCellModel.class]) {
        TNProductDetailsActivityCell *cell = [TNProductDetailsActivityCell cellWithTableView:tableView];
        cell.model = ((TNProductDetailsActivityCellModel *)model).model;
        return cell;
    } else if ([model isKindOfClass:TNDeliverFlowModel.class]) {
        TNProductDetailExpressCell *cell = [TNProductDetailExpressCell cellWithTableView:tableView];
        cell.model = (TNDeliverFlowModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailServiceCellModel.class]) {
        TNProductDetailServiceCell *cell = [TNProductDetailServiceCell cellWithTableView:tableView];
        cell.model = (TNProductDetailServiceCellModel *)model;
        return cell;
    } else if ([model isKindOfClass:TNProductDetailPublicImgCellModel.class]) {
        TNProductDetailPublicImgCell *cell = [TNProductDetailPublicImgCell cellWithTableView:tableView];
        cell.model = (TNProductDetailPublicImgCellModel *)model;
        @HDWeakify(self);
        cell.getImageViewHeightCallBack = ^{ //刷新table 展开高度
            @HDStrongify(self);
            [UIView performWithoutAnimation:^{ //防止iOS13以下 刷新晃动的问题
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HDTableViewSectionModel *sectionModel = self.dataSource[section];
//    if (!sectionModel.headerModel) return nil;
//
//    HDTableHeaderFootView *headView = [HDTableHeaderFootView headerWithTableView:tableView];
//    HDTableHeaderFootViewModel *model = sectionModel.headerModel;
//    model.titleFont = HDAppTheme.TinhNowFont.standard17B;
//    model.titleColor = HDAppTheme.TinhNowColor.G1;
//    //    model.marginToBottom = kRealWidth(10);
//    headView.model = model;
//    headView.rightButtonClickedHandler = ^{
//        if (!HDIsArrayEmpty(sectionModel.list)) {
//            id model = sectionModel.list.firstObject;
//            if ([model isKindOfClass:TNProductReviewTableViewCellModel.class]) {
//                [SATalkingData trackEvent:[self.viewModel.trackPrefixName stringByAppendingString:@"商品详情页_点击商品评价"]];
//            }
//        }
//        [SAWindowManager openUrl:model.routePath withParameters:nil];
//    };
//    return headView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    HDTableViewSectionModel *sectionModel = self.dataSource[section];
//    if (sectionModel.headerModel) {
//        return kTableHeaderHeight;
//    } else {
//        return 0.0f;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kTableFooterSpace;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:TNProductDetailServiceCellModel.class]) {
        TNProductServiceAlertView *alertView = [[TNProductServiceAlertView alloc] initWithDataArr:self.viewModel.productDetailsModel.servicesGuaranteeList];
        [alertView show];

    } else if ([model isKindOfClass:TNProductSaleRegionCellModel.class]) {
        TNProductSaleRegionModel *sRmodel = ((TNProductSaleRegionCellModel *)model).saleRegionModel;
        if ([self.viewModel.productDetailsModel.type isEqualToString:TNGoodsTypeOverseas]) {
            //海外购订单
            TNProductDeliveryInfoViewController *vc = [[TNProductDeliveryInfoViewController alloc]
                initWithRouteParameters:@{@"storeId": self.viewModel.productDetailsModel.storeNo, @"region": ((TNProductSaleRegionCellModel *)model).valueText}];
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        } else { //其它订单  如果不是配送至全国  就显示配送地点信息弹窗
            if (self.viewModel.productDetailsModel.canOpenMap) {
                //商品可以查看配送区域的
                [HDMediator.sharedInstance navigaveToTinhNowDeliveryAreaMapViewController:@{@"addressModel": [TNGlobalData shared].orderAdress}];
            } else {
                if (sRmodel.regionType == TNRegionTypeSpecifiedArea) { // 显示配送区域
                    NSString *showStr = sRmodel.regionNames ?: @"";

                    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
                    config.buttonTitle = TNLocalizedString(@"tn_completed", @"完成");
                    config.buttonBgColor = HDAppTheme.TinhNowColor.C1;
                    config.buttonTitleFont = HDAppTheme.TinhNowFont.standard17B;
                    config.buttonTitleColor = UIColor.whiteColor;
                    config.iPhoneXFillViewBgColor = HDAppTheme.TinhNowColor.C1;

                    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;
                    TNProductSaleRegionAlertView *view = [[TNProductSaleRegionAlertView alloc] initWithFrame:CGRectMake(0, 0, width, 10.f) data:showStr];
                    [view layoutyImmediately];
                    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
                    [actionView show];
                }
            }
        }
    } else if ([model isKindOfClass:TNProductDetailPublicImgCellModel.class]) {
        TNProductDetailPublicImgCellModel *publicImgCellModel = (TNProductDetailPublicImgCellModel *)model;

        if (HDIsStringNotEmpty(publicImgCellModel.publicDetailAppLink)) {
            [SAWindowManager openUrl:publicImgCellModel.publicDetailAppLink withParameters:nil];
            [SATalkingData trackEvent:@"[电商]公共详情图" label:@"" parameters:@{@"link": publicImgCellModel.publicDetailAppLink}];
        }
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.customNaviBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kNavigationBarH);
        make.left.right.top.equalTo(self);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bargainBottomView.mas_top);
    }];
    [self.bargainBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kRealHeight(49) + kiPhoneXSeriesSafeBottomHeight);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = YES;
    }
    return _tableView;
}
/** @lazy bargainBottomView */
- (TNProductDetailsBargainBottomView *)bargainBottomView {
    if (!_bargainBottomView) {
        _bargainBottomView = [[TNProductDetailsBargainBottomView alloc] initWithViewModel:self.viewModel];
        _bargainBottomView.hidden = YES;
        @HDWeakify(self);
        _bargainBottomView.shareButtonClickedHander = ^{
            @HDStrongify(self);
            [self bagainGoodShareClick];
        };
        _bargainBottomView.customerServiceButtonClickedHander = ^(NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [self getCustomerList:storeNo];
        };
        _bargainBottomView.buyNowButtonClickedHander = ^(NSString *_Nonnull productId) {
            [[HDMediator sharedInstance] navigaveTinhNowProductDetailViewController:@{@"productId": productId}];
        };
        _bargainBottomView.createTaskButtonClickedHander = ^{
            @HDStrongify(self);
            if (![SAUser hasSignedIn]) {
                [SAWindowManager switchWindowToLoginViewController];
                return;
            }
            [self showBargainSpecView];
        };
    }
    return _bargainBottomView;
}

- (TNBargainProductNavBarView *)customNaviBar {
    if (!_customNaviBar) {
        _customNaviBar = [[TNBargainProductNavBarView alloc] init];
        @HDWeakify(self);
        _customNaviBar.callPhoneCallBack = ^{
            @HDStrongify(self);
            [self makePhoneCall];
        };
        _customNaviBar.moreCallBack = ^(HDUIButton *_Nonnull sender) {
            @HDStrongify(self);
            [self showPopMenu:sender];
        };
        _customNaviBar.searchCallBack = ^{
            @HDStrongify(self);
            [self goToSearchPage];
        };
        _customNaviBar.selectedItemCallBack = ^(NSInteger index) {
            @HDStrongify(self);
            if (HDIsArrayEmpty(self.viewModel.titleArr)) {
                return;
            }

            TNProductNavTitleModel *tModel = [self.viewModel.titleArr objectAtIndex:index];
            NSInteger section = tModel.section;
            CGRect rect = [self.tableView rectForHeaderInSection:section];
            CGFloat space = rect.size.height + kTableFooterSpace * section;
            if (iPhoneXSeries) {
                space = rect.size.height * 2;
            }
            [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - space) animated:YES];
        };
    }
    return _customNaviBar;
}

- (NSArray *)getNavTitleArray {
    NSMutableArray *returnTitleArray = [NSMutableArray array];
    for (TNProductNavTitleModel *itemModel in self.viewModel.titleArr) {
        [returnTitleArray addObject:itemModel.title];
    }
    return returnTitleArray;
}

- (void)setNavTitleSection {
    [self.navTitleSectionArray removeAllObjects];
    @HDWeakify(self);
    [self.viewModel.titleArr enumerateObjectsUsingBlock:^(TNProductNavTitleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        [self.navTitleSectionArray addObject:@(obj.section)];
    }];
}

- (NSMutableArray *)navTitleSectionArray {
    if (!_navTitleSectionArray) {
        _navTitleSectionArray = [NSMutableArray array];
    }
    return _navTitleSectionArray;
}

- (NSArray<TNPopMenuCellModel *> *)menuDataSourceArray {
    if (!_menuDataSourceArray) {
        TNPopMenuCellModel *phoneModel = TNPopMenuCellModel.new;
        phoneModel.icon = @"tinhnow_product_nav_menu_contactmerchant";
        phoneModel.title = TNLocalizedString(@"tn_contact", @"联系商家");
        phoneModel.type = TNPopMenuTypeContactMerchant;

        TNPopMenuCellModel *homeModel = TNPopMenuCellModel.new;
        homeModel.icon = @"tinhnow_product_nav_menu_home";
        homeModel.title = TNLocalizedString(@"tn_product_backhome", @"主页");
        homeModel.type = TNPopMenuTypeHome;

        TNPopMenuCellModel *searchModel = TNPopMenuCellModel.new;
        searchModel.icon = @"tinhnow_product_nav_menu_search";
        searchModel.title = TNLocalizedString(@"tn_search_k", @"搜索");
        searchModel.type = TNPopMenuTypeSearch;

        TNPopMenuCellModel *platformModel = TNPopMenuCellModel.new;
        platformModel.icon = @"tinhnow_product_nav_menu_contactplatform";
        platformModel.title = TNLocalizedString(@"tn_service", @"联系平台");
        platformModel.type = TNPopMenuTypeContactPlatform;

        _menuDataSourceArray = [NSArray arrayWithObjects:phoneModel, homeModel, searchModel, platformModel, nil];
    }
    return _menuDataSourceArray;
}

- (TNBargainViewModel *)bargainViewModel {
    if (!_bargainViewModel) {
        _bargainViewModel = [[TNBargainViewModel alloc] init];
    }
    return _bargainViewModel;
}
- (TNBargainSuspendWindow *)recordWindow {
    if (!_recordWindow) {
        _recordWindow = [[TNBargainSuspendWindow alloc] init];
    }
    return _recordWindow;
}
///** @lazy player */
- (SJVideoPlayer *)player {
    if (!_player) {
        _player = [SJVideoPlayer player];
        [self setUpVideoPlayer];
    }
    return _player;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNProductDetailSkeletonImageCell cellWithTableView:tableview];
            } else if (indexPath.row == 1) {
                return [TNProductDetailSkeletonInfoCell cellWithTableView:tableview];
            } else {
                return [TNProductDetailSkeletonCell cellWithTableView:tableview];
            }
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row == 0) {
                return [TNProductDetailSkeletonImageCell skeletonViewHeight];
            } else if (indexPath.row == 1) {
                return [TNProductDetailSkeletonInfoCell skeletonViewHeight];
            } else {
                return [TNProductDetailSkeletonCell skeletonViewHeight];
            }
        }];
        _provider.numberOfRowsInSection = 4;
    }
    return _provider;
}

@end
