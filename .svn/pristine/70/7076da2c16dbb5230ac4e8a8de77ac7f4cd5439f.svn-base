//
//  AfundarNavios.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/16/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "AfundarNavios.h"
#import "SinkShips.h"
#import "UserDefault.h"
#import "PlayerCompList.h"

@implementation AfundarNavios{
    IBOutlet UILabel *labelActivePlayer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self testActivePlayer];
}

-(void)testActivePlayer{
    if (![UserDefault getActivePlayerComp]) {
        [self pushPlayerList];
        return;
    }
    PlayerComp *player = [UserDefault getActivePlayerComp];
    labelActivePlayer.text = player.name;
}

-(void)pushPlayerList{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerCompList *pl = (PlayerCompList *)[storyboard instantiateViewControllerWithIdentifier:@"playerCompList"];
    [self.navigationController pushViewController:pl animated:YES];
}

- (IBAction)actionButtonSinkShip:(id)sender {
    SinkShips *ss = [SinkShips new];
    [self.navigationController pushViewController:ss animated:YES];
}

@end
