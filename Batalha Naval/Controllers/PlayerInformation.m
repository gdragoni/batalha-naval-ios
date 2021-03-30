//
//  PerfilJogadorController.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/19/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "PlayerInformation.h"
#import "UserDefault.h"
#import "PlayerComp.h"

@implementation PlayerInformation{
    PlayerComp *activePlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activePlayer                = [UserDefault getActivePlayerComp];
    NSString *office            = [self playerOffice:activePlayer];
    NSInteger finishedGames     = activePlayer.finishedGames.integerValue;
    NSInteger wins              = activePlayer.wins.integerValue;
    NSInteger percentOfSuccess  = [self calculatePercentageWithParcial:wins andTotal:finishedGames];
    self.labelPlayerName.text = [NSString stringWithFormat:@"%@ %@", office, activePlayer.name];
    self.labelWins.text = [NSString stringWithFormat:@"Vitórias: %li", wins];
    self.labelFinishedGames.text = [NSString stringWithFormat:@"Batalhas jogadas: %li", finishedGames];
    self.labelPercentOfSuccess.text = [NSString stringWithFormat:@"Aproveitamento: %li%%", percentOfSuccess];
    self.navigationItem.backBarButtonItem.enabled = YES;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClose)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}

-(void)swipeClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)playerOffice:(PlayerComp*)player{
    NSString* firstOfficce;
    NSString* secondOffice;
    NSInteger finishedGames = player.finishedGames.integerValue;
    NSInteger wins = player.wins.integerValue;
    NSInteger percentOfSuccess = [self calculatePercentageWithParcial:wins andTotal:finishedGames];
    if (finishedGames < 40) {
        secondOffice = @"Inexperiente";
        if (percentOfSuccess < 40) {
            firstOfficce = @"Marinheiro";
        }else if (percentOfSuccess < 70){
            firstOfficce = @"Cabo";
        }else{
            firstOfficce = @"Soldado";
        }
    }else if(finishedGames < 80){
        secondOffice = @"Experiente";
        if (percentOfSuccess < 40) {
            firstOfficce = @"Fuzileiro";
        }else if (percentOfSuccess < 70){
            firstOfficce = @"Sargento";
        }else{
            firstOfficce = @"Tenente";
        }
    }else{
        secondOffice = @"Sênior";
        if (percentOfSuccess < 40) {
            firstOfficce = @"Capitão";
        }else if (percentOfSuccess < 70){
            firstOfficce = @"Almirante";
        }else firstOfficce = @"Ministro";
    }
    return [NSString stringWithFormat:@"%@ %@", firstOfficce, secondOffice];
}

-(NSInteger)calculatePercentageWithParcial:(NSInteger)parcial andTotal:(NSInteger)total{
    if (parcial == 0 || total == 0) return 0;
    return (NSInteger)((CGFloat)parcial/(CGFloat)total*100);
}
@end
