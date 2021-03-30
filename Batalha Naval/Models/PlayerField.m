//
//  PlayerField.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "PlayerField.h"

@implementation PlayerField

-(instancetype)playerFieldWithDict:(NSDictionary *)data{
    NSMutableArray *arrayDeShotsTaken = [NSMutableArray new];
    for (NSDictionary *shotsTaken in data[KEY_SHOTSTAKEN]) {
        Shot *shot = [Shot new];
        [shot shotWithDict:shotsTaken];
        [arrayDeShotsTaken addObject:shot];
    }
    NSMutableArray *arrayDeShotsFired = [NSMutableArray new];
    for (NSDictionary *shotsFired in data[KEY_SHOTSFIRED]) {
        Shot *shot = [Shot new];
        [shot shotWithDict:shotsFired];
        [arrayDeShotsFired addObject:shot];
    }
    NSMutableArray *arrayDeShips = [NSMutableArray new];
    for (NSDictionary *ships in data[KEY_SHIPS]) {
        Ship *ship = [Ship new];
        [ship shiptWithDict:ships];
        [arrayDeShips addObject:ship];
    }
    self.playerFieldShotsTaken  = arrayDeShotsTaken;
    self.playerFieldShotsFired  = arrayDeShotsFired;
    self.playerFieldShips       = arrayDeShips;
    return self;
}

@end
