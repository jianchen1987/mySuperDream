//
//  HDOrderPayResultViewController.m
//  customer
//
//  Created by null on 2019/3/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDOrderPayResultViewController.h"
#import "HDSingleLineView.h"
#import "HDPayOrderRspModel.h"
#import "HDCommonUtils.h"


@interface HDOrderPayResultViewController ()

@end


@implementation HDOrderPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray<HDSingleLineView *> *)detailsContentByModel:(HDPayOrderRspModel *)rspModel {
    NSMutableArray<HDSingleLineView *> *detailArr = [[NSMutableArray alloc] init];

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:@"" describe:@"" type:HDSingleLineViewTypeLine]];

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额", nil)
                                                        describe:[HDCommonUtils thousandSeparatorAmount:[HDCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.orderCy]
                                                            type:HDSingleLineViewTypeText]];

    if (![rspModel.fee isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_DISCOUNT_AMOUNT", @"折扣金额", nil)
                                                            describe:[HDCommonUtils thousandSeparatorAmount:[HDCommonUtils fenToyuan:rspModel.fee.stringValue] currencyCode:rspModel.cy]
                                                                type:HDSingleLineViewTypeText]];
    }

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_PAYER_ACCOUNT", @"付款账户", nil)
                                                        describe:[HDCommonUtils getAccountNameByCode:rspModel.cy]
                                                            type:HDSingleLineViewTypeText]];

    [detailArr
        addObject:[[HDSingleLineView alloc]
                      initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)
                              title:HDLocalizedString(@"PAGE_TEXT_PAYEE", @"收款方", nil)
                           describe:rspModel.tradeType == HDTransTypeConsume ? rspModel.payeeName : [NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.payeeName) ? rspModel.payeeName : @""]
                               type:HDSingleLineViewTypeText]];

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"业务类型", nil)
                                                        describe:[HDCommonUtils getTradeTypeNameByCode:rspModel.tradeType]
                                                            type:HDSingleLineViewTypeText]];

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间", nil)
                                                        describe:[HDCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm"
                                                                                          withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.date.integerValue / 1000]]
                                                            type:HDSingleLineViewTypeText]];

    [detailArr addObject:[[HDSingleLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:HDLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号", nil) describe:rspModel.tradeNo
                                                            type:HDSingleLineViewTypeText]];

    return [detailArr copy];
}

@end
