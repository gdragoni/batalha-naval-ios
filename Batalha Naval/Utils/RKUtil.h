//
//  RestKitParameters.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/7/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelosOnline.h"

#define KEY_RESPONSEDATA   @"responseData"
#define KEY_STATUS         @"status"
#define KEY_NAME           @"name"
#define KEY_ID             @"id"
#define KEY_PLAYERONE      @"playerOne"
#define KEY_PLAYERTWO      @"playerTwo"
#define KEY_STARTDATE      @"startDate"
#define KEY_ENDDATE        @"endDate"
#define KEY_WINNER         @"winner"
#define KEY_TURNPLAYERID   @"turnPlayerId"
#define KEY_SHOTSTAKEN     @"shotsTaken"
#define KEY_SHOTSFIRED     @"shotsFired"
#define KEY_SHIPS          @"ships"
#define KEY_SHIPID         @"shipId"
#define KEY_POSITIONS      @"positions"
#define KEY_POSITION_X     @"positionX"
#define KEY_POSITION_Y     @"positionY"
#define KEY_HIT            @"hit"
#define KEY_REMAINING      @"remaining"
#define KEY_SUNKENSHIP     @"sunkenShip"
#define KEY_PLAYERID       @"playerId"
#define KEY_GAMEID         @"gameId"
#define KEY_SHOOTINGPLAYER @"shootingPlayer"
#define KEY_TARGETPLAYER   @"targetPlayer"
#define KEY_TARGETX        @"targetX"
#define KEY_TARGETY        @"targetY"
#define BNSERVER           @"http://iisprod.luxfacta.com.br/BNServer/api/"

@class Ship, Position;
@interface RKUtil : NSObject

+(NSDictionary *)parameterForPostPlayer:(NSString *)player;
+(NSDictionary *)parameterForPostGameShip:(NSArray<Ship *> *)ships playerId:(NSInteger)playerId andGameId:(NSInteger)gameId;
+(NSDictionary *)parameterForPostFireTarget:(Position *)target gameId:(NSInteger)gameId shootingPlayer:(NSInteger)shootingPlayer andTargetPlayer:(NSInteger)targetPlayer;
+(NSDictionary *)parameterForPostGameWithPlayerOne:(NSInteger)PlayerOneId Player2:(NSInteger)playerTwoId;
+(NSDictionary *)parameterForPutGame:(NSInteger)gameId Winner:(NSInteger)winnerId;
+(NSString *)pathForGetPlayerFieldWithPlayerId:(NSInteger)playerId andGameID:(NSInteger)gameId;
+(NSString *)pathForGetPlayer;
+(NSString *)pathForPostPlayer;
+(NSString *)pathForGetPlayerWithPlayerID:(NSInteger)playerId;
+(NSString *)pathForPostGameShip;
+(NSString *)pathForGetGameWithGameId:(NSInteger)gameId;
+(NSString *)pathForPutGame;
+(NSString *)pathForPostGame;
+(NSString *)pathForGetListPlayerGamesWithPlayerId:(NSInteger)playerId;
+(NSString *)pathForPostFire;

@end
