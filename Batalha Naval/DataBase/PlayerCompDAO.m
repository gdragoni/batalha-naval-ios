//
//  Jogador.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/7/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "PlayerCompDAO.h"
#import "AppDelegate.h"
#import "UserDefault.h"

#define KEY_ENTITY_PLAYER @"PlayerComp"

NSManagedObjectContext *playerContext;

@implementation PlayerCompDAO

-(void)createNewPlayer:(NSString *)playerName{
    NSManagedObjectContext *context = [[AppDelegate sharedInstance] managedObjectContext];
    NSEntityDescription *descr = [NSEntityDescription entityForName:KEY_ENTITY_PLAYER inManagedObjectContext:context];
    playerName              = [playerName capitalizedString];
    PlayerComp *newPlayer   = [[PlayerComp alloc] initWithEntity:descr insertIntoManagedObjectContext:context];
    newPlayer.name          = playerName;
    newPlayer.wins          = nil;
    newPlayer.finishedGames = nil;
    newPlayer.bestTime      = @9999;
    [context insertObject:newPlayer];
    NSError *erro;
    [context save:&erro];
    [UserDefault setActivePlayerComp:newPlayer];
}

-(void)deletePlayer:(PlayerComp *)player{
    playerContext = !playerContext ? [[AppDelegate sharedInstance] managedObjectContext] : playerContext;
    [playerContext deleteObject:player];
    NSError *erro;
    [playerContext save:&erro];
}

-(void)addBestTimePlayer:(NSString *)playerName bestTime:(NSInteger)time{
    NSMutableArray *arrayPlayers = [[NSMutableArray alloc]initWithArray:[self getPlayersOnDataBase]];
    for (PlayerComp* player in arrayPlayers) {
        if ([player.name isEqualToString: playerName]) {
            if (time < [player.bestTime integerValue]|| player.bestTime==nil) {
            player.bestTime = [NSNumber numberWithInteger:time];
            NSError *erro;
            playerContext = !playerContext ? [[AppDelegate sharedInstance] managedObjectContext] : playerContext;
            [playerContext save:&erro];
            [UserDefault setActivePlayerComp:player];
            }
        }
    }
}

-(void)addFinishedGame:(NSString *)playerName isWinner:(BOOL)winner{
    NSMutableArray *arrayPlayers = [[NSMutableArray alloc]initWithArray:[self getPlayersOnDataBase]];
    for (PlayerComp* player in arrayPlayers) {
        if ([player.name isEqualToString:playerName]) {
            player.finishedGames = [NSNumber numberWithInteger:player.finishedGames.integerValue+1];
            if (winner) {
                player.wins = [NSNumber numberWithInteger:player.wins.integerValue+1];
                [UserDefault setActivePlayerComp:player];
            }
            NSError* erro;
            [playerContext save:&erro];
        }
    }
}

-(NSArray *)arrayPlayersOrganizedBy:(NSString *)property{
    NSMutableArray *arrayPlayers = [[NSMutableArray alloc]initWithArray:[self getPlayersOnDataBase]];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:property ascending:YES];
    [arrayPlayers sortUsingDescriptors:@[descriptor]];
    return arrayPlayers;
}

-(NSArray *)getPlayersOnDataBase{
    playerContext = !playerContext ? [[AppDelegate sharedInstance] managedObjectContext] : playerContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:KEY_ENTITY_PLAYER];
    return [[playerContext executeFetchRequest:request error:nil] mutableCopy];
}

-(NSInteger)bestTimePlayer:(NSString *)playerName{
    NSArray *arrayPlayers = [self getPlayersOnDataBase];
    for (PlayerComp *player in arrayPlayers) {
        if ([player.name isEqualToString:playerName]) {
            return player.bestTime.integerValue;
        }
    }
    return 0;
}

-(NSInteger)recordBestTime{
    NSMutableArray *arrayPlayer = [[NSMutableArray alloc]initWithArray:[self arrayPlayersOrganizedBy:@"bestTime"]];
    PlayerComp *player = arrayPlayer[0];
    if ([[arrayPlayer[0] bestTime] integerValue] == 9999) {
        return 0;
    }
    return player.bestTime.integerValue;
}

@end
