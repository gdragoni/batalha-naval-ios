//
//  Game.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelosOnline.h"

@interface Game : NSObject

@property (nonatomic) Player*   gamePlayerOne, *gamePlayerTwo;
@property (nonatomic) NSInteger gameId, gameWinner, gameTurnPlayerId;
@property (nonatomic) NSString* gameStartDate, *gameEndDate;

-(Game *)gameWithDict:(NSDictionary *)data;
+(NSArray *)arrayGamesWithDict:(NSDictionary *)dict;

@end
