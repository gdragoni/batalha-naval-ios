//
//  RestKitParameters.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "RKUtil.h"
#import "DateUtil.h"

@implementation RKUtil

+(NSDictionary *)parameterForPostPlayer:(NSString *)player{
    return @{@"name" : player};
}

+(NSDictionary *)parameterForPostGameShip:(NSArray<Ship *> *)ships playerId:(NSInteger)playerId andGameId:(NSInteger)gameId{
    NSMutableDictionary *dictGameShip = [NSMutableDictionary new];
    dictGameShip[KEY_GAMEID] = @(gameId);
    dictGameShip[KEY_PLAYERID] = @(playerId);
    NSMutableArray *arrayDeShips = [NSMutableArray new];
    for (Ship *ship in ships) {
        NSMutableDictionary *dictNavio = [NSMutableDictionary new];
        dictNavio[KEY_SHIPID] = @(ship.shipId);
        NSMutableArray *arrayPositions = [NSMutableArray new];
        for (Position *pos in ship.shipPositions) {
            NSDictionary *posXY = @{KEY_POSITION_X : @(pos.positionX), KEY_POSITION_Y : @(pos.positionY)};
            [arrayPositions addObject:posXY];
        }
        dictNavio[KEY_POSITIONS] = arrayPositions;
        [arrayDeShips addObject:dictNavio];
    }
    dictGameShip[KEY_SHIPS] = arrayDeShips;
    return dictGameShip;
}

+(NSDictionary *)parameterForPostFireTarget:(Position *)target gameId:(NSInteger)gameId shootingPlayer:(NSInteger)shootingPlayer andTargetPlayer:(NSInteger)targetPlayer{
    NSMutableDictionary *dictFire = [NSMutableDictionary new];
    dictFire[KEY_GAMEID] = @(gameId);
    dictFire[KEY_SHOOTINGPLAYER] = @(shootingPlayer);
    dictFire[KEY_TARGETPLAYER] = @(targetPlayer);
    dictFire[KEY_TARGETX] = @(target.positionX);
    dictFire[KEY_TARGETY] = @(target.positionY);
    return dictFire;
}

+(NSDictionary *)parameterForPostGameWithPlayerOne:(NSInteger)PlayerOneId Player2:(NSInteger)playerTwoId{
    NSMutableDictionary *dictGame = [NSMutableDictionary new];
    dictGame[KEY_PLAYERONE] = @(PlayerOneId);
    dictGame[KEY_PLAYERTWO] = @(playerTwoId);
    return dictGame;
}

+(NSDictionary *)parameterForPutGame:(NSInteger)gameId Winner:(NSInteger)winnerId{
    NSMutableDictionary *dictGame = [NSMutableDictionary new];
    dictGame[KEY_ID] = @(gameId);
    dictGame[KEY_ENDDATE] = [DateUtil getCurrentDate];
    dictGame[KEY_WINNER] = @(winnerId);
    dictGame[KEY_TURNPLAYERID] = @(0);
    return dictGame;
}

+(NSString *)pathForGetPlayerFieldWithPlayerId:(NSInteger)playerId andGameID:(NSInteger)gameId{
    return [NSString stringWithFormat:@"%@PlayerField/%li/%li", BNSERVER, playerId, gameId];
}

+(NSString *)pathForGetPlayer{
    return [NSString stringWithFormat:@"%@Player", BNSERVER];
}

+(NSString *)pathForPostPlayer{
    return [self pathForGetPlayer];
}

+(NSString *)pathForGetPlayerWithPlayerID:(NSInteger)playerId{
    return [NSString stringWithFormat:@"%@Player/%li", BNSERVER, playerId];
}

+(NSString *)pathForPostGameShip{
    return [NSString stringWithFormat:@"%@GameShip",BNSERVER];
}

+(NSString *)pathForGetGameWithGameId:(NSInteger)gameId{
    return [NSString stringWithFormat:@"%@Game/%li",BNSERVER , gameId];
}

+(NSString *)pathForPostGame{
    return [self pathForPutGame];
}

+(NSString *)pathForPutGame{
    return [NSString stringWithFormat:@"%@Game", BNSERVER];
}

+(NSString *)pathForGetListPlayerGamesWithPlayerId:(NSInteger)playerId{
    return [NSString stringWithFormat:@"%@ListPlayerGames/%li", BNSERVER, playerId];
}

+(NSString *)pathForPostFire{
    return [NSString stringWithFormat:@"%@Fire", BNSERVER];
}

@end
