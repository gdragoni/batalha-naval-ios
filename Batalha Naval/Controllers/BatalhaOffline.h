//
//  BatalhaOffline.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/27/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameComp.h"

@interface BatalhaOffline : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) GameComp *game;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end
