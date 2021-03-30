//
//  BatalhaVsComputador.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/16/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "BatalhaVsComputador.h"
#import "BatalhaOffline.h"
#import "ShipGenerator.h"
#import "UserDefault.h"
#import "PlayerCompList.h"

@implementation BatalhaVsComputador{
    IBOutlet UILabel *labelActivePlayer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self testActivePlayer];
}

-(void)testActivePlayer{
    if (![UserDefault getActivePlayerComp]) {
        [self actionButtonPlayerList:nil];
        return;
    }
    PlayerComp *player = [UserDefault getActivePlayerComp];
    labelActivePlayer.text = player.name;
}

- (IBAction)actionButtonInitBattle:(id)sender {
    if (![UserDefault getActivePlayerComp]) {
        [self actionButtonPlayerList:nil];
        return;
    }
    BatalhaOffline *bOff = [BatalhaOffline new];
    bOff.game = [[GameComp alloc]initWithShipPlayer:nil andShipOpponent:nil];
    [self.navigationController pushViewController:bOff animated:YES];
}

- (IBAction)actionButtonPlayerList:(id)sender {
    PlayerCompList *pl = [PlayerCompList new];
    [self.navigationController pushViewController:pl animated:YES];
}

@end
