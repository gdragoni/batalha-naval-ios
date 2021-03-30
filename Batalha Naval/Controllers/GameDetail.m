//
//  DetailGame.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/11/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "GameDetail.h"

@implementation GameDetail{
    IBOutlet UILabel *labelPlayerOne;
    IBOutlet UILabel *labelPlayerTwo;
    IBOutlet UILabel *labelStartDate;
    IBOutlet UILabel *labelEndDate;
    IBOutlet UILabel *labelPlayerWinner;
    IBOutlet UILabel *labelGameN;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Game *game              = self.game;
    Player *one             = game.gamePlayerOne;
    Player *two             = game.gamePlayerTwo;
    labelPlayerOne.text     = one.playerName;
    labelPlayerTwo.text     = two.playerName;
    labelGameN.text         = [NSString stringWithFormat:@"Game nº%li", game.gameId];
    labelStartDate.text     = [NSString stringWithFormat:@"Inicio: %@", game.gameStartDate];
    labelEndDate.text       = game.gameEndDate != nil ? [NSString stringWithFormat:@"Fim: %@", game.gameEndDate] : @"Em andamento";
    labelPlayerWinner.text  = game.gameWinner != 0 ? game.gameWinner == one.playerID ? [NSString stringWithFormat:@"Vencedor: %@", one.playerName] : [NSString stringWithFormat:@"Vencedor: %@", two.playerName] : @"Sem vencedores ainda.";
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
