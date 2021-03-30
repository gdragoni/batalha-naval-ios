//
//  Jogo.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/25/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipComp.h"

@interface GameComp : NSObject

@property (nonatomic, strong) NSArray <ShipComp *> *shipPlayer, *shipOpponent;
@property (nonatomic, strong) NSMutableArray *shotPlayer, *shotOpponent;
@property (nonatomic) NSInteger turnPlayerId;

-(GameComp *)initWithShipPlayer:(NSArray *)shipPlayer andShipOpponent:(NSArray *)shipOpponent;

@end
