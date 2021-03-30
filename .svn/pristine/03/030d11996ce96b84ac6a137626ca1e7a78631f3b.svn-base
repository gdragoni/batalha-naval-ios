//
//  Tiro.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/27/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ShotComp.h"
#import "ShipComp.h"

@implementation ShotComp

-(ShotComp *)initWithTag:(NSInteger)tag shotsPlayerArray:(NSMutableArray *)shotsArray andShipsOpponentArray:(NSArray *)shipsArray{
    self.shotTag    = tag;
    self.shotHit    = NO;
    self.sunkenShip = NO;
    [shotsArray addObject:self];
    for (ShipComp *ship in shipsArray) {
        for (NSNumber *pos in ship.positions) {
            if (pos.integerValue == tag) {
                self.shotHit = YES;
                NSInteger shotsHit = 0;
                for (NSNumber *pos in ship.positions) {
                    for (ShotComp *shot in shotsArray) {
                        if (pos.integerValue == shot.shotTag) {
                            shotsHit++;
                            break;
                        }
                    }
                }
                self.sunkenShip = shotsHit == ship.size;
                ship.sunkenShip = shotsHit == ship.size;
                break;
                break;
            }
        }
    }
    return self;
}

@end
