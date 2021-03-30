//
//  ShipCompDistributorViewController.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatalhaOffline.h"

@interface ShipCompDistributor : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) BatalhaOffline *sender;

@end
