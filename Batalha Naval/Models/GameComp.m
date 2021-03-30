//
//  Jogo.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/25/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "GameComp.h"

@implementation GameComp

-(GameComp *)initWithShipPlayer:(NSArray *)shipPlayer andShipOpponent:(NSArray *)shipOpponent{
    if (self = [super init]) {
        self.shipPlayer   = shipPlayer;
        self.shipOpponent = shipOpponent;
        self.shotPlayer   = [NSMutableArray new];
        self.shotOpponent = [NSMutableArray new];
        self.turnPlayerId = rand() % 2;
    }
    return self;
}

@end
