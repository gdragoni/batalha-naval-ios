//
//  Game.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Game.h"
#import "DateUtil.h"

@implementation Game

-(Game *)gameWithDict:(NSDictionary *)dict{
    self.gameId = [dict[KEY_ID] integerValue];
    if (dict[KEY_STARTDATE] != (id)[NSNull null]) self.gameStartDate = [DateUtil transformDateWithString:dict[KEY_STARTDATE]];
    if (dict[KEY_ENDDATE] != (id)[NSNull null]) self.gameEndDate = [DateUtil transformDateWithString:dict[KEY_ENDDATE]];
    if (dict[KEY_WINNER] != (id)[NSNull null]) self.gameWinner = [dict[KEY_WINNER] integerValue];
    if (dict[KEY_TURNPLAYERID] != (id)[NSNull null]) self.gameTurnPlayerId = [dict[KEY_TURNPLAYERID]integerValue];
    if (dict[KEY_PLAYERONE] != (id)[NSNull null]) {
        Player *player1 = [Player new];
        self.gamePlayerOne = [player1 playerWithDict:dict[KEY_PLAYERONE]];
    }
    if (dict[KEY_PLAYERTWO] != (id)[NSNull null]) {
        Player *player2 = [Player new];
        self.gamePlayerTwo = [player2 playerWithDict:dict[KEY_PLAYERTWO]];
    }
    return self;
}

+(NSArray *)arrayGamesWithDict:(NSDictionary *)dict{
    NSMutableArray *arrayGames = [NSMutableArray new];
    for (NSDictionary *dictgame in dict[KEY_RESPONSEDATA]) {
        Game *game = [Game new];
        [game gameWithDict:dictgame];
        [arrayGames addObject:game];
    }
    return arrayGames;
}

@end
