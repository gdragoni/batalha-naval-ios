//
//  Jogadores.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/7/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PlayerComp : NSManagedObject

@property (nonatomic, retain) NSNumber *idPlayer;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *finishedGames;
@property (nonatomic, retain) NSNumber *wins;
@property (nonatomic, retain) NSNumber *bestTime;

@end
