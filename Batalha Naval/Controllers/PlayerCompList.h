//
//  ListaDeJogadoresController.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/8/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCompList : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *buttonDeletePlayer;

@end
