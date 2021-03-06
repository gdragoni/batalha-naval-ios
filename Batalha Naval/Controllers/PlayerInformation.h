//
//  PerfilJogadorController.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/19/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerInformation : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *labelFinishedGames;
@property (weak, nonatomic) IBOutlet UILabel *labelWins;
@property (weak, nonatomic) IBOutlet UILabel *labelPercentOfSuccess;

@end
