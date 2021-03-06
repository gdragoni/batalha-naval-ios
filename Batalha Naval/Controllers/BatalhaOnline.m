//
//  BatalhaOnline.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/14/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "BatalhaOnline.h"
#import "WebService.h"
#import "LoadingView.h"
#import "RKUtil.h"
#import "ImageUtil.h"
#import "ModelosOnline.h"
#import "Alert.h"
#import "Sound.h"

@implementation BatalhaOnline{
    IBOutlet UICollectionView  *collectionView_;
    IBOutlet UILabel           *labelLog;
    IBOutlet UILabel           *labelDestruction;
    IBOutlet UILabel           *labelTurn;
    PlayerField                *playerFieldMain, *playerFieldOne, *playerFieldTwo;
    Player                     *playerOne, *playerTwo;
    Game                       *game_;
    Shot                       *lastShotOne;
    Fire                       *fire;
    WebService                 *rk;
    LoadingView                *loading, *loadingTwoShot;
    Sound                      *sound;
    NSTimer                    *timer;
    NSInteger                  time, gameId;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [collectionView_ registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self initialSettings];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                  target:self
                                                                                  action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:myBackButton];
    UICollectionViewFlowLayout *layout;
    layout = (id) collectionView_.collectionViewLayout;
    float width   = (collectionView_.frame.size.width-10)/10;
    float height    =  (collectionView_.frame.size.height-10)/10;
    layout.minimumInteritemSpacing  = 0.5;
    layout.minimumLineSpacing       = 1;
    CGSize c        = CGSizeMake(width, height);
    layout.itemSize = c;
    labelLog.layer.masksToBounds = YES;
    labelDestruction.layer.masksToBounds = YES;
    labelTurn.layer.masksToBounds = YES;
    labelLog.layer.cornerRadius = 8;
    labelDestruction.layer.cornerRadius = 8;
    labelTurn.layer.cornerRadius = 8;
    collectionView_.backgroundView.backgroundColor = [UIColor clearColor];
    collectionView_.backgroundColor = [UIColor clearColor];
    collectionView_.scrollEnabled = NO;
}

-(void)initialSettings{
    game_           = self.game;
    playerOne       = game_.gamePlayerOne;
    playerTwo       = game_.gamePlayerTwo;
    gameId          = game_.gameId;
    loading         = [[LoadingView alloc]initWithController:self];
    loadingTwoShot  = [[LoadingView new]initWithController:self andNewTitle:@"Aguardando jogada"];
    rk              = [[WebService alloc]initWithDelegate:self];
    if ([self isPlayerTurn:playerOne inGame:game_]) {
    [self callPlayerFieldTwo];
    collectionView_.userInteractionEnabled = YES;
    }
    else{
        [self callPlayerFieldOne];
    collectionView_.userInteractionEnabled = NO;
    }
    [self timeToPlay:@selector(initialTimer)];
}

#pragma mark - BackButton

-(void)goBack{
    UIAlertView *alertBack = [[UIAlertView alloc]initWithTitle:@"Encerrar batalha"
                                                              message:@"Deseja sair do jogo?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Sim"
                                                    otherButtonTitles:@"Não", nil];
    alertBack.tag = 1;
    [alertBack show];
}

#pragma mark - Metodos

-(void)playerOneTurnConfig{
    labelTurn.text = [NSString stringWithFormat:@"Turno: %@", playerOne.playerName];
    labelDestruction.text = [NSString stringWithFormat:@"Destruição: %li%%", [self calculateDestruction:playerFieldTwo]];
    labelDestruction.textColor = [self calculateDestruction:playerFieldTwo] >= 90 ? [UIColor redColor] : [UIColor whiteColor];
}
-(void)playerTwoTurnConfig{
    labelTurn.text = [NSString stringWithFormat:@"Turno: %@", playerTwo.playerName];
    labelDestruction.text = [NSString stringWithFormat:@"Destruição: %li%%", [self calculateDestruction:playerFieldOne]];
    labelDestruction.textColor = [self calculateDestruction:playerFieldOne] >= 90 ? [UIColor redColor] : [UIColor whiteColor];
}

-(void)exchangePlayerField:(PlayerField *)playerField{
    playerField = [self checkSunkenShip:playerField];
    playerFieldMain = playerField;
    [collectionView_ reloadData];
    [collectionView_ layoutIfNeeded];
    [self showSunkenShip:playerField];
    playerFieldOne = nil;
    playerFieldTwo = nil;
}

-(PlayerField *)checkSunkenShip:(PlayerField *)playerField{
    NSInteger shotFields;
    for (Ship *ship in playerField.playerFieldShips) {
        shotFields = 0;
        for (Position *posShip in ship.shipPositions) {
            for (Shot *shotsTaken in playerField.playerFieldShotsTaken) {
                if (posShip.positionTag == shotsTaken.shotPosition.positionTag) {
                    shotFields ++;
                    break;
                }
            }
        }
        ship.shipSunkenShip = shotFields == ship.shipPositions.count;
    }
    return playerField;
}

-(void)playSoundWithFire:(Fire *)fireSound{
    if (!sound) sound = [Sound new];
    if (fireSound.fireHit) {
        if (fireSound.fireSunkenShip) [sound playShipbell];
        else [sound playBomb];
    }else [sound playSplash];
}

-(void)showSunkenShip:(PlayerField *)playerField{
    for (Ship *ship in playerField.playerFieldShips) {
        UICollectionView *cell;
        if ([ship isSubmarine] && ship.shipSunkenShip) {
            cell = [collectionView_ viewWithTag:ship.shipPositions[0].positionTag];
            [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell addSubview:[ImageUtil imageViewWithImageNamed:@"submarino.png" size:cell.frame.size isHorizontal:YES]];
        }else if(ship.shipSunkenShip) {
            for (Position *pos in ship.shipPositions) {
                cell = [collectionView_ viewWithTag:pos.positionTag];
                [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [cell addSubview:[ImageUtil imageViewWithImageNamed:@"meioNavio.png" size:cell.frame.size isHorizontal:[ship isHorizontal]]];
            }
            cell = [collectionView_ viewWithTag:[ship isInvertedShip] ? ship.shipPositions.lastObject.positionTag : ship.shipPositions.firstObject.positionTag];
            [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell addSubview:[ImageUtil imageViewWithImageNamed:@"frenteNavio.png" size:cell.frame.size isHorizontal:[ship isHorizontal]]];
            cell = [collectionView_ viewWithTag:[ship isInvertedShip] ? ship.shipPositions.firstObject.positionTag : ship.shipPositions.lastObject.positionTag];
            [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell addSubview:[ImageUtil imageViewWithImageNamed:@"atrasNavio.png" size:cell.frame.size isHorizontal:[ship isHorizontal]]];
        }
    }
}

-(void)animateCellWithShot:(Shot *)shot{
    UICollectionViewCell *cell = [collectionView_ viewWithTag:shot.shotPosition.positionTag];
    [UIView animateWithDuration:1 animations:^{
        cell.backgroundColor = shot.shotHit
        ? [UIColor colorWithRed:0.8 green:0 blue:0.2 alpha:1]
        : [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
    }completion:nil];
}

-(void)labelLogWithMsg:(NSString *)msg{
    labelLog.text       = msg;
    labelLog.textColor  = [UIColor redColor];
    labelLog.hidden     = NO;
    labelLog.alpha      = 0;
    [UIView animateWithDuration:1.5 animations:^{
        labelLog.alpha = 1;
        labelLog.alpha = 0;
    }];
}

-(void)testsAfterShot{
    if (fire.fireRemaining == 0) {
        [self callPutGame];
        [self stopTimer];
        [self timeToPlay:@selector(timerForEndGame)];
    }
}

-(void)endBattle{
    BOOL isPlayerOneWinner  = game_.gameWinner == playerOne.playerID;
    NSString *title        = isPlayerOneWinner ? @"Venceu!": @"Perdeu!";
    NSString *msg           = isPlayerOneWinner ? @"Parabéns, afundou todos navios inimigos!" : @"Pratique mais.";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                              message:msg
                                                             delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
}

-(NSInteger)calculateDestruction:(PlayerField *)playerField{
    NSInteger shotsHit = 0;
    for (Shot *shot in playerField.playerFieldShotsTaken) {
        if (shot.shotHit) shotsHit++;
    }
    return 100*shotsHit/18;
}

-(BOOL)isPlayerTurn:(Player *)player inGame:(Game *)game{
    return game.gameTurnPlayerId == player.playerID;
}

#pragma mark - Temporizadores

-(void)timeToPlay:(SEL)selector{
    time = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:selector userInfo:nil repeats:YES];
}

-(void)initialTimer{
    if ([self isPlayerTurn:playerOne inGame:game_] && playerFieldTwo != nil) {
        [self playerOneTurnConfig];
        [self exchangePlayerField:playerFieldTwo];
        [self stopTimer];
    }else if ([self isPlayerTurn:playerTwo inGame:game_] && playerFieldOne != nil){
        [self stopTimer];
        [self timeToPlay:@selector(timerWaitPlayerTwoShot)];
    }
    game_ = nil;
}

-(void)timerAfterPlayerOneShot{
    if (fire != nil) {
        lastShotOne.shotHit = fire.fireHit;
        if (fire.fireSunkenShip != nil) [self labelLogWithMsg:[NSString stringWithFormat:@"%@ afundado!", fire.fireSunkenShip.capitalizedString]];
        [self animateCellWithShot:lastShotOne];
        [self testsAfterShot];
        [self playSoundWithFire:fire];
        fire = nil;
        time ++;
    }else if (fire == nil && time > 0){
        [self callPlayerFieldOne];
        [self stopTimer];
        [self timeToPlay:@selector(timerWaitPlayerTwoShot)];
    }
}

-(void)timerWaitPlayerTwoShot{
    [loadingTwoShot show];
    if (playerFieldOne != nil) {
        [self playerTwoTurnConfig];
        [self exchangePlayerField:playerFieldOne];
        game_ = nil;
        [self callGame];
    }else if (game_ != nil){
        if (game_.gameWinner != 0) {
            [self stopTimer];
            [self endBattle];
            return;
        }
        if ([self isPlayerTurn:playerOne inGame:game_]) {
            [self stopTimer];
            [self callPlayerFieldOne];
            [self timeToPlay:@selector(timerAfterPlayerTwoShot)];
        }else [self callGame];
        game_ = nil;
    }
}

-(void)timerAfterPlayerTwoShot{
    if (playerFieldOne != nil) {
        [loadingTwoShot hide];
        time++;
        [self exchangePlayerField:playerFieldOne];
        [self callPlayerFieldTwo];
    }else if(time > 0 && playerFieldTwo != nil){
        [self playerOneTurnConfig];
        [self exchangePlayerField:playerFieldTwo];
        [self stopTimer];
        collectionView_.userInteractionEnabled = YES;
    }
}

-(void)timerForEndGame{
    if (game_.gameWinner != 0) {
        [self endBattle];
        [self stopTimer];
    }
}

-(void)stopTimer{
    [timer invalidate];
    timer = nil;
}

#pragma mark - Chamadas

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (data == nil) return;
    if (type == GET_PLAYERFIELD_PLAYERONEID_GAMEID) {
        playerFieldOne = data;
    }else if (type == GET_PLAYERFIELD_PLAYERTWOID_GAMEID){
        playerFieldTwo = data;
    }else if (type == POST_FIRE){
        fire = data;
    }else if (type == GET_GAME_ID){
        game_ = data;
    }else if (type == PUT_GAME){
        game_ = data;
    }
}

-(void)callPlayerFieldOne{
    [rk requestType:GET_PLAYERFIELD_PLAYERONEID_GAMEID
         withMethod:@"GET"
               path:[RKUtil pathForGetPlayerFieldWithPlayerId:playerOne.playerID
                                                    andGameID:gameId]
         parameters:nil];
    [loading show];
}

-(void)callPlayerFieldTwo{
    [rk requestType:GET_PLAYERFIELD_PLAYERTWOID_GAMEID
         withMethod:@"GET"
               path:[RKUtil pathForGetPlayerFieldWithPlayerId:playerTwo.playerID
                                                    andGameID:gameId]
         parameters:nil];
    [loading show];
}

-(void)callGame{
    [rk requestType:GET_GAME_ID
         withMethod:@"GET"
               path:[RKUtil pathForGetGameWithGameId:gameId]
         parameters:nil];
    [loading show];
}

-(void)callFire:(Position *)position{
    [rk requestType:POST_FIRE
         withMethod:@"POST"
               path:[RKUtil pathForPostFire]
         parameters:[RKUtil parameterForPostFireTarget:position
                                                gameId:gameId
                                        shootingPlayer:playerOne.playerID
                                       andTargetPlayer:playerTwo.playerID]];
    [loading show];
}

-(void)callPutGame{
    [rk requestType:PUT_GAME
         withMethod:@"PUT"
               path:[RKUtil pathForPutGame]
         parameters:[RKUtil parameterForPutGame:gameId
                                         Winner:playerOne.playerID]];
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self stopTimer];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 2) {
        [self stopTimer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Collection view Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row+1;
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    for (Shot *shot in playerFieldMain.playerFieldShotsTaken) {
        if (shot.shotPosition.positionTag == cell.tag) {
            cell.backgroundColor = [UIColor blueColor];
            if (shot.shotHit) {
                [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [cell addSubview:[ImageUtil imageViewWithImageNamed:@"explosion-153710_640" size:cell.frame.size isHorizontal:YES]];
            }
            cell.userInteractionEnabled = NO;
            break;
        }
    }
    return cell;
}

#pragma mark - Collection view Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionView_.userInteractionEnabled = NO;
    Position *position = [[Position alloc]positionWithTag:indexPath.row+1];
    lastShotOne = [Shot new];
    lastShotOne.shotPosition = position;
    [self callFire:position];
    [self timeToPlay:@selector(timerAfterPlayerOneShot)];
}

@end
