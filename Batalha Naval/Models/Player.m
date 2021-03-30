//
//  Player.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 2/11/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Player.h"

@implementation Player

-(Player *)playerWithName:(NSString *)nome andId:(NSInteger)playerId {
        self.playerName = nome;
        self.playerID   = playerId;
    return self;
}

-(Player *)playerWithDict:(NSDictionary *)dict{
    self.playerID   = [dict[KEY_ID] integerValue];
    self.playerName = dict[KEY_NAME];
    return self;
}

-(NSDictionary *)dict{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[KEY_NAME]  = self.playerName;
    dict[KEY_ID]    = @(self.playerID);
    return dict;
}

+(NSArray *)arrayPlayersWithDict:(NSDictionary *)dict{
    NSMutableArray *arrayPlayers = [NSMutableArray new];
    for (NSDictionary *dictPlayer in dict[KEY_RESPONSEDATA]) {
        Player *player = [Player new];
        [player playerWithDict:dictPlayer];
        [arrayPlayers addObject:player];
    }
    return arrayPlayers;
}

@end
