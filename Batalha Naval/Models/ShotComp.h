//
//  Tiro.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/27/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShotComp : NSObject

@property (nonatomic) NSInteger shotTag;
@property (nonatomic) BOOL shotHit, sunkenShip;

-(ShotComp *)initWithTag:(NSInteger)tag shotsPlayerArray:(NSMutableArray *)shotsArray andShipsOpponentArray:(NSArray *)shipsArray;

@end
