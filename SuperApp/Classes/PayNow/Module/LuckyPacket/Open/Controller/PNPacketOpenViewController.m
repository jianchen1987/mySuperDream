//
//  PNPacketOpenViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketOpenViewController.h"
#import "PNPacketOpenDTO.h"
#import "PNPacketOpenView.h"


@interface PNPacketOpenViewController ()
@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, strong) PNPacketOpenDTO *openDTO;
@end


@implementation PNPacketOpenViewController

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [super init];
    if (self) {
        self.packetId = [param objectForKey:@"packetId"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view showloading];

    @HDWeakify(self);
    [self.openDTO getOpenPacketDetail:self.packetId page:1 success:^(PNPacketDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        PNPacketOpenView *alert = [[PNPacketOpenView alloc] initWithModel:rspModel];
        [alert show];

        alert.closeBtnBlock = ^{
            [self dismissAnimated:YES completion:nil];
        };
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        [self dismissAnimated:YES completion:nil];
    }];
}

- (PNPacketOpenDTO *)openDTO {
    if (!_openDTO) {
        _openDTO = [[PNPacketOpenDTO alloc] init];
    }
    return _openDTO;
}
@end
