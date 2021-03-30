//
//  Jogador.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/7/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlayerComp.h"

@interface PlayerCompDAO : NSObject <NSFetchedResultsControllerDelegate>

-(NSArray *)arrayPlayersOrganizedBy:(NSString *)property;
-(NSArray *)getPlayersOnDataBase;
-(NSInteger)recordBestTime;
-(NSInteger)bestTimePlayer:(NSString *)playerName;
-(void)createNewPlayer:(NSString*)playerName;
-(void)deletePlayer:(PlayerComp *)player;
-(void)addBestTimePlayer:(NSString *)playerName bestTime:(NSInteger)time;
-(void)addFinishedGame:(NSString *)playerName isWinner:(BOOL)winner;

@end
