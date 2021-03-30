//
//  DistribuirNavios.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/12/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "RestKitCallBack.h"

@interface ShipDistributor : UIViewController <RestKitCallBack>

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) UIViewController *sender;

@end
