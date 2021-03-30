//
//  BatalhaOnline.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/14/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "RestKitCallBack.h"

@interface BatalhaOnline : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, RestKitCallBack>

@property (nonatomic, strong) Game *game;

@end
