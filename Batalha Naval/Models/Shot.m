//
//  Shot.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Shot.h"

@implementation Shot

-(Shot *)shotWithDict:(NSDictionary *)data{
    self.shotPosition = [Position new];
    [self.shotPosition positionWithDict:data];
    self.shotHit = [data[KEY_HIT] boolValue];
    return self;
}

-(Shot *)lastShotFired:(PlayerField *)playerField{
    return playerField.playerFieldShotsFired.lastObject;
}

-(Shot *)lastShotTaken:(PlayerField *)playerField{
    return playerField.playerFieldShotsTaken.lastObject;
}

@end
