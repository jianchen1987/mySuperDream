//
//  TNRefundViewModel.m
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNRefundViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoViewModel.h"
#import "TNRefundCommonDictModel.h"
#import "TNRefundCustomerServerCell.h"
#import "TNRefundDTO.h"
#import "TNRefundDescriptionCell.h"
#import "TNRefundPhoneInputCell.h"


@interface TNRefundViewModel ()
///
@property (nonatomic, strong) dispatch_group_t taskGroup;
///
@property (nonatomic, strong) TNRefundDTO *refundDTO;
@end


@implementation TNRefundViewModel

- (void)hd_initialize {
    [self configViewData];
}

- (void)hd_getData:(NSString *)orderNo {
    /**
     退款类型  REFUND_TYPE
     申请原因  REFUND_REASON
     申请类型  APPLY_REASON
     */
    [self.view showloading];
    dispatch_group_enter(self.taskGroup);
    @HDWeakify(self);
    [self.refundDTO getCommonDataDictByTypes:@[@"REFUND_TYPE", @"REFUND_REASON", @"APPLY_REASON"] success:^(TNRefundCommonDictModel *_Nonnull commonDictModel) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
        if (commonDictModel) {
            self.applyReasonTypeArray = commonDictModel.REFUND_REASON;
            self.applyRefundTypeArray = commonDictModel.APPLY_REASON;
            self.refundTypeArray = commonDictModel.REFUND_TYPE;
            if (self.applyRefundTypeArray.count > 0) {
                self.currentApplyRefundType = self.applyRefundTypeArray.firstObject;
            }
            if (self.refundTypeArray.count > 0) {
                self.currentRefundType = self.refundTypeArray.firstObject;
            }
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"getSimpleOrderInfoByOrderId: %@", error);
        dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_enter(self.taskGroup);
    [self.refundDTO getSimpleOrderInfoByOrderId:orderNo success:^(TNRefundSimpleOrderInfoModel *_Nonnull orderInfoModel) {
        @HDStrongify(self);
        dispatch_group_leave(self.taskGroup);
        self.simpleOrderInfoModel = orderInfoModel;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        HDLog(@"getSimpleOrderInfoByOrderId: %@", error);
        dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^{
        [self.view dismissLoading];
        [self configViewData];
    });
}

- (void)configViewData {
    NSMutableArray<HDTableViewSectionModel *> *dataSource = NSMutableArray.new;
    HDTableViewSectionModel *section = [[HDTableViewSectionModel alloc] init];

    NSMutableArray *listArray = [NSMutableArray array];
    // 申请类型
    SAInfoViewModel *infoViewModel = SAInfoViewModel.new;
    infoViewModel.keyText = TNLocalizedString(@"tn_apply_type", @"申请类型");
    infoViewModel.keyTitletEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    infoViewModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.keyColor = HDAppTheme.TinhNowColor.cADB6C8;
    infoViewModel.lineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    infoViewModel.valueText = HDIsStringNotEmpty(self.currentApplyRefundType.name) ? self.currentApplyRefundType.name : @"";
    infoViewModel.valueColor = HDAppTheme.TinhNowColor.c343B4D;
    infoViewModel.valueFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.lineColor = HDAppTheme.TinhNowColor.lineColor;
    [listArray addObject:infoViewModel];

    // 退款类型
    infoViewModel = SAInfoViewModel.new;
    infoViewModel.leftImage = [UIImage imageNamed:@"tn_important_flag"];
    infoViewModel.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    infoViewModel.keyText = TNLocalizedString(@"tn_refund_type", @"退款类型");
    infoViewModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.keyColor = HDAppTheme.TinhNowColor.cADB6C8;
    infoViewModel.lineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    infoViewModel.valueText = HDIsStringNotEmpty(self.currentRefundType.name) ? self.currentRefundType.name : @"";
    infoViewModel.valueColor = HDAppTheme.TinhNowColor.c343B4D;
    infoViewModel.valueFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.lineColor = HDAppTheme.TinhNowColor.lineColor;
    [listArray addObject:infoViewModel];

    // 申请退款金额($)
    infoViewModel = SAInfoViewModel.new;
    infoViewModel.leftImage = [UIImage imageNamed:@"tn_important_flag"];
    infoViewModel.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    infoViewModel.keyText = TNLocalizedString(@"tn_refund_money", @"申请退款金额($)");
    infoViewModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.keyColor = HDAppTheme.TinhNowColor.cADB6C8;
    infoViewModel.lineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    infoViewModel.valueText = [NSString stringWithFormat:@"%0.2f", self.simpleOrderInfoModel.price.doubleValue];
    infoViewModel.valueColor = HDAppTheme.TinhNowColor.cFF2323;
    infoViewModel.valueFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.lineColor = HDAppTheme.TinhNowColor.lineColor;
    [listArray addObject:infoViewModel];

    // 申请原因
    infoViewModel = SAInfoViewModel.new;
    infoViewModel.leftImage = [UIImage imageNamed:@"tn_important_flag"];
    infoViewModel.leftImageViewEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    infoViewModel.keyText = TNLocalizedString(@"tn_apply_reason", @"申请原因");
    infoViewModel.keyFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.keyColor = HDAppTheme.TinhNowColor.cADB6C8;
    infoViewModel.lineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    infoViewModel.valueText = self.currentApplyReasonType ? self.currentApplyReasonType.name : TNLocalizedString(@"tn_please_select", @"请选择");
    infoViewModel.valueColor = HDAppTheme.TinhNowColor.cADB6C8;
    infoViewModel.valueFont = [HDAppTheme.TinhNowFont fontMedium:15.f];
    infoViewModel.rightButtonImage = [UIImage imageNamed:@"arrow_narrow_gray"];
    infoViewModel.lineColor = HDAppTheme.TinhNowColor.lineColor;
    infoViewModel.associatedObject = @"apply_reason";
    infoViewModel.valueNumbersOfLines = 0;
    infoViewModel.clickedValueButtonHandler = ^{
        HDLog(@"!! clickedValueButtonHandler");
    };
    [listArray addObject:infoViewModel];

    // 补充描述和凭证
    TNRefundDescriptionCellModel *viewModel = TNRefundDescriptionCellModel.new;
    [listArray addObject:viewModel];

    // 申请人 联系电话
    TNRefundPhoneInputCellModel *phoneCellModel = TNRefundPhoneInputCellModel.new;
    [listArray addObject:phoneCellModel];

    //商家电话
    TNRefundCustomerServerCellModel *customerViewModel = TNRefundCustomerServerCellModel.new;
    [listArray addObject:customerViewModel];

    section.list = listArray;
    [dataSource addObject:section];

    self.dataSource = [NSArray arrayWithArray:dataSource];
    self.refreshFlag = !self.refreshFlag;
}

- (void)postApplyInfoData:(NSDictionary *)paramsDic success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    [self.refundDTO postApplyInfoData:paramsDic success:successBlock failure:failureBlock];
}

#pragma mark -
- (TNRefundDTO *)refundDTO {
    if (!_refundDTO) {
        _refundDTO = [[TNRefundDTO alloc] init];
    }
    return _refundDTO;
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

@end
