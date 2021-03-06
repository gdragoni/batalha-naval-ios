//
//  BatalhaOffline.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/27/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "BatalhaOffline.h"
#import "UserDefault.h"
#import "ShotComp.h"
#import "ShipComp.h"
#import "PlayerCompDAO.h"
#import "ShipCompDistributor.h"
#import "ImageUtil.h"
#import "Sound.h"

@implementation BatalhaOffline{
    IBOutlet UILabel *labelTurn;
    IBOutlet UILabel *labelDestruction;
    IBOutlet UILabel *labelLog;
    ConfigurationComp *config;
    GameComp *game_;
    Sound *sound;
    NSArray *arrayPlayerShips, *arrayOpponentShips, *shipsInField, *shotsInField;
    NSMutableArray *arrayPlayerShots, *arrayOpponentShots;
    NSInteger time, attempts;
    NSTimer *timer;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    config              = [UserDefault getConfiguration];
    game_               = self.game;
    arrayPlayerShips    = game_.shipPlayer;
    arrayOpponentShips  = game_.shipOpponent;
    arrayPlayerShots    = game_.shotPlayer;
    arrayOpponentShots  = game_.shotOpponent;
    attempts            = config.shotsPerTurn;[self showRemainingAttempts:config.shotsPerTurn];
    [self showLabelDestructionIsPlayer:game_.turnPlayerId == 1];
    [self showLabelTurnIsPlayer:game_.turnPlayerId == 1];
    _collectionView.userInteractionEnabled = game_.turnPlayerId == 1;
    _collectionView.scrollEnabled = NO;
    [self testDistributedShips];
}

-(void)testDistributedShips{
    if (!arrayPlayerShips) {
        ShipCompDistributor *sd = [ShipCompDistributor new];
        sd.sender = self;
        [self presentViewController:sd animated:YES completion:nil];
    }else if (!(game_.turnPlayerId == 1)) [self timeForPlay:@selector(timeForOpponentShot)];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    UICollectionViewFlowLayout *flow = (id)_collectionView.collectionViewLayout;
    flow.sectionInset               = UIEdgeInsetsZero;
    float width                     = (_collectionView.frame.size.width-10)/config.tableSize;
    float height                    = (_collectionView.frame.size.height-10)/config.tableSize;
    flow.minimumInteritemSpacing    = 0.5;
    flow.minimumLineSpacing         = 1;
    CGSize size                     = CGSizeMake(width, height);
    flow.itemSize                   = size;
    labelLog.layer.masksToBounds    = YES;
    labelDestruction.layer.masksToBounds = YES;
    labelTurn.layer.masksToBounds   = YES;
    labelLog.layer.cornerRadius     = 8;
    labelDestruction.layer.cornerRadius = 8;
    labelTurn.layer.cornerRadius    = 8;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(checkGoback)];
    self.navigationItem.leftBarButtonItem = backButton;
    _collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    _collectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - BackButton action

-(void)checkGoback{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Deseja sair do jogo?" message:nil delegate:self cancelButtonTitle:@"Sim" otherButtonTitles:@"Não", nil];
    alert.tag = 1;
    [alert show];
}

-(void)goBack{
    [self stopTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Metodos

-(void)finishBattleWithVictory:(BOOL)isVictory{
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    if (isVictory) [sound playWinSound];
    else [sound playSadTrambone];
    [pDAO addFinishedGame:[[UserDefault getActivePlayerComp]name] isWinner:isVictory];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: isVictory ? @"Parabéns!" : @"Você perdeu!" message: isVictory ? @"Afundou todos os navios adversário!" : @"Treine mais." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}

-(void)addExtraShot{
    attempts += config.extraShotPerHit;
    attempts = attempts > 5 ? 5 : attempts;
}

-(NSInteger)calculatePercentageWithShots:(NSArray *)arrayShots{
    NSInteger amountShotsHit = 0;
    for (ShotComp *shot in arrayShots) {
        if (shot.shotHit) {
            amountShotsHit++;
        }
    }
    return amountShotsHit*100/config.numberOfFieldsWithShip;
}

-(void)playSoundWithShot:(ShotComp *)shot{
    if (!sound) sound = [Sound new];
    if (shot.shotHit) {
        if (shot.sunkenShip) {
            [sound playShipbell];
        }else [sound playBomb];
    }else [sound playSplash];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self goBack];
    }
}

#pragma mark - Temporizadores

-(void)timeForPlay:(SEL)selector{
    time = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:selector userInfo:nil repeats:YES];
}

-(void)stopTimer{
    time = -10;
    [timer invalidate];
    timer = nil;
}

-(void)timeAfterPlayerShot{
    time++;
    if (time == 1) {
        [self showLabelDestructionIsPlayer:YES];
        [self changeFieldsWithShots:arrayPlayerShots andShips:arrayOpponentShips];
    }else if (time == 2){
        if ([self testAllSunkenShips:arrayOpponentShips]) {
            [self stopTimer];
            [self finishBattleWithVictory:YES];
        }else if(attempts == 0){
            [self showLabelTurnIsPlayer:NO];
            [self showLabelDestructionIsPlayer:NO];
            [self changeFieldsWithShots:arrayOpponentShots andShips:arrayPlayerShips];
        }
    }else{
        [self stopTimer];
        if (attempts == 0) {
            attempts = config.shotsPerTurn;
            [self showRemainingAttempts:attempts];
            [self timeForPlay:@selector(timeForOpponentShot)];
        }else{
            _collectionView.userInteractionEnabled = YES;
        }
    }
}

-(void)timeForOpponentShot{
    time++;
    if (time == 1) {
        NSInteger shotTag = 0;
        do{
            shotTag = rand() % config.numberOfFields+1;
        }while ([self testRepeatedShot:shotTag withShots:arrayOpponentShots]);
        ShotComp *shot = [[ShotComp alloc]initWithTag:shotTag shotsPlayerArray:arrayOpponentShots andShipsOpponentArray:arrayPlayerShips];
        attempts--;
        if (shot.shotHit) [self addExtraShot];
        [self playSoundWithShot:shot];
        [self showRemainingAttempts:attempts];
        [self animateCell:[_collectionView viewWithTag:shotTag] withShot:shot];
    }else if (time == 2){
        if ([self testAllSunkenShips:arrayPlayerShips]) {
            [self stopTimer];
            [self finishBattleWithVictory:NO];
        }else{
            [self showLabelDestructionIsPlayer:NO];
            [self changeFieldsWithShots:arrayOpponentShots andShips:arrayPlayerShips];
        }
    }else if (time == 3){
        [self stopTimer];
        if (attempts <= 0) {
            [self showLabelTurnIsPlayer:YES];
            [self showLabelDestructionIsPlayer:YES];
            attempts = config.shotsPerTurn;
            [self showRemainingAttempts:attempts];
            [self changeFieldsWithShots:arrayPlayerShots andShips:arrayOpponentShips];
            _collectionView.userInteractionEnabled = YES;
        }else{
            [self timeForPlay:@selector(timeForOpponentShot)];
        }
    }
}

#pragma mark - Testes

-(BOOL)testRepeatedShot:(NSInteger)shotTag withShots:(NSArray *)arrayShots{
    for (ShotComp *shot in arrayShots) {
        if (shot.shotTag == shotTag) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)testAllSunkenShips:(NSArray *)arrayShips{
    for (ShipComp *ship in arrayShips) {
        if (!ship.sunkenShip) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Action Views

-(void)changeFieldsWithShots:(NSArray*)arrayShots andShips:(NSArray *)arrayShips{
    shotsInField = arrayShots;
    shipsInField = arrayShips;
    [_collectionView reloadData];
}

-(void)animateCell:(UICollectionViewCell *)cell withShot:(ShotComp *)shot{
    [UIView animateWithDuration:0.4 animations:^{
        cell.backgroundColor = [UIColor orangeColor];
        cell.backgroundColor = shot.shotHit ? [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1] : [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    }];
}

-(void)showLabelLogWithMsg:(NSString *)msg{
    labelLog.text = msg;
}

-(void)showLabelTurnIsPlayer:(BOOL)isJogador{
    labelTurn.text = isJogador ? @"Vez do Jogador" : @"Vez do Computador";
}

-(void)showLabelDestructionIsPlayer:(BOOL)isPlayer{
    NSInteger percentOfDestruction = isPlayer ? [self calculatePercentageWithShots:arrayPlayerShots] : [self calculatePercentageWithShots:arrayOpponentShots];
    labelDestruction.text = [NSString stringWithFormat:@"Destruição: %li%%", (long)percentOfDestruction];
    labelDestruction.textColor = percentOfDestruction >= 90 ? [UIColor redColor] : [UIColor whiteColor];
}

-(void)showRemainingAttempts:(NSInteger)remainingAttempts{
    NSString *msg = [NSString stringWithFormat:@"Tentativas: %02li", (long)remainingAttempts];
    [self showLabelLogWithMsg:msg];
}

#pragma mark - Collection view data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return config.numberOfFields;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row+1;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    for (ShotComp *shot in shotsInField) {
        if (shot.shotTag == cell.tag) {
            cell.userInteractionEnabled = NO;
            cell.backgroundColor = [UIColor blueColor];
            if (shot.shotHit) [cell addSubview:[ImageUtil imageViewWithImageNamed:@"explosion-153710_640.png" size:cell.frame.size isHorizontal:YES]];
            for (ShipComp *ship in shipsInField) {
                for (NSNumber *pos in ship.positions) {
                    if (pos.integerValue == cell.tag) {
                        if (ship.sunkenShip) {
                            [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                            [cell addSubview:[ship imageInThePositionTag:cell.tag size:cell.frame.size]];
                        }
                        break;
                        break;
                    }
                }
            }
            break;
        }
    }
    return cell;
}

#pragma mark - Collection view delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView viewWithTag:indexPath.row+1];
    collectionView.userInteractionEnabled = NO;
    ShotComp *shot = [[ShotComp alloc]initWithTag:cell.tag shotsPlayerArray:arrayPlayerShots andShipsOpponentArray:arrayOpponentShips];
    attempts--;
    if (shot.shotHit) [self addExtraShot];
    [self playSoundWithShot:shot];
    [self animateCell:cell withShot:shot];
    [self showRemainingAttempts:attempts];
    [self timeForPlay:@selector(timeAfterPlayerShot)];
}

@end
