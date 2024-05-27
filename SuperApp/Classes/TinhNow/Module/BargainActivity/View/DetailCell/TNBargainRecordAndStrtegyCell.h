//
//  TNBargainRecordAndStrtegyCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainDetailModel.h"
#import "TNBargainPeopleRecordRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainRecordAndStrtegyCellModel : TNModel
/// 助力记录列表
@property (strong, nonatomic) NSMutableArray<TNHelpPeolpleRecordeModel *> *recordList;
/// 邀人攻略数据
@property (strong, nonatomic) NSArray *strategyList;
/// 助力记录table高度
@property (nonatomic, assign) CGFloat recordTableHeight;
/// 邀人攻略table高度
@property (nonatomic, assign) CGFloat strategyTableHeight;
/// 切换table
@property (nonatomic, assign) BOOL isShowStrategy;
/// 邀人攻略每条图片的高度数组
@property (nonatomic, strong) NSMutableArray *strategyImagesHeightArr;
/// 砍价任务类型
@property (nonatomic, assign) TNBargainTaskType bargainType;
/// 助力记录当前page
@property (nonatomic, assign) NSInteger currentPage;
/// 是否还有下一页
@property (nonatomic, assign) NSInteger hasNextPage;
/// 任务id
@property (nonatomic, copy) NSString *taskId;

@end


@interface TNBargainRecordAndStrtegyCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNBargainRecordAndStrtegyCellModel *model;
/// 切换通知上层reload
@property (nonatomic, copy) void (^recordAndStrtegyChangeCallBack)(void);
@end

NS_ASSUME_NONNULL_END
