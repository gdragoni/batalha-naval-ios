//
//  SinkShips.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "SinkShips.h"
#import "ModelosOffline.h"
#import "UserDefault.h"
#import "PlayerCompDAO.h"
#import "ShipGenerator.h"
#import "ImageUtil.h"
#import "Sound.h"

@implementation SinkShips{
    IBOutlet UICollectionView *collectionView_;
    IBOutlet UILabel *labelTime;
    NSTimer *timer;
    PlayerComp *activePlayer;
    Sound *sound;
    UIBarButtonItem *barButtom;
    NSArray <ShipComp *> *arrayShips;
    NSMutableArray <ShotComp *> *arrayShots;
    NSInteger time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activePlayer = [UserDefault getActivePlayerComp];
    [collectionView_ registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    arrayShips = [[ShipGenerator new] arrayWithConfiguration:[[ConfigurationComp alloc] standardConfiguration]];
    arrayShots = [NSMutableArray new];
    [self initTimer];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [collectionView_ registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView_ setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    UICollectionViewFlowLayout *flow = (id)collectionView_.collectionViewLayout;
    flow.sectionInset = UIEdgeInsetsZero;
    float widht = (collectionView_.frame.size.width-10)/10;
    float height =  (collectionView_.frame.size.height-10)/10;
    flow.minimumInteritemSpacing = 0.5;
    flow.minimumLineSpacing = 1;
    CGSize size = CGSizeMake(widht, height);
    flow.itemSize = size;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(checkGoBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    barButtom = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(barButtomAction)];
    self.navigationItem.rightBarButtonItem = barButtom;
    barButtom.tag = 100;
    collectionView_.backgroundView.backgroundColor = [UIColor clearColor];
    collectionView_.backgroundColor = [UIColor clearColor];
    collectionView_.scrollEnabled = NO;
}

#pragma mark - Métodos

-(void)barButtomAction{
    if (barButtom.tag == 100) {
        barButtom = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(barButtomAction)];
        barButtom.tag = 101;
        self.navigationItem.rightBarButtonItem = barButtom;
        [self pauseTimer];
        collectionView_.userInteractionEnabled = NO;
    }else if (barButtom.tag == 101){
        barButtom = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(barButtomAction)];
        barButtom.tag = 100;
        self.navigationItem.rightBarButtonItem = barButtom;
        [self continueTimer];
        collectionView_.userInteractionEnabled = YES;
    }
}

-(void)checkGoBack{
    if (barButtom.tag == 100) [self barButtomAction];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Deseja sair do jogo?" message:nil delegate:self cancelButtonTitle:@"Sim" otherButtonTitles:@"Não", nil];
    alert.tag = 1;
    [alert show];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)testAllSunkenShips{
    for (ShipComp *ship in arrayShips) {
        if (!ship.sunkenShip) {
            return NO;
        }
    }
    return YES;
}

-(void)animateCell:(UICollectionViewCell *)cell withShot:(ShotComp *)shot{
    [UIView animateWithDuration:0.6 animations:^{
        cell.backgroundColor = shot.shotHit ? [UIColor redColor] : [UIColor blueColor];
    } completion:^(BOOL comp){
        [collectionView_ reloadData];
        collectionView_.userInteractionEnabled = YES;
        if ([self testAllSunkenShips]) {
            [self finishGameWithTime];
        }
    }];
}

-(void)playSoundWithShot:(ShotComp *)shot{
    if (!sound) sound = [Sound new];
    if (shot.shotHit) {
        if (shot.sunkenShip) {
            [sound playShipbell];
        }else [sound playBomb];
    }else [sound playSplash];
}

-(void)finishGameWithTime{
    PlayerCompDAO *pDAO = [PlayerCompDAO new];
    [pDAO addBestTimePlayer:activePlayer.name bestTime:time];
    [self stopTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Navios afundados!" message:[NSString stringWithFormat:@"Seu tempo foi %02li:%02li", time/60, time%60] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}

#pragma mark - Temporizador

-(void)initTimer{
    labelTime.text = @"Tempo: 00:00";
    time = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counter) userInfo:nil repeats:YES];
}

-(void)continueTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counter) userInfo:nil repeats:YES];
}

-(void)pauseTimer{
    [timer invalidate];
}

-(void)stopTimer{
    [timer invalidate];
    timer = nil;
}

-(void)counter{
    time++;
    labelTime.text = [NSString stringWithFormat:@"Tempo: %02li:%02li", time/60, time%60];
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CollectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row+1;
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    for (ShotComp *shot in arrayShots) {
        if (shot.shotTag == cell.tag) {
            cell.userInteractionEnabled = NO;
            cell.backgroundColor = [UIColor blueColor];
            if (shot.shotHit) {
                [cell addSubview:[ImageUtil imageViewWithImageNamed:@"explosion-153710_640.png" size:cell.frame.size isHorizontal:YES]];
                for (ShipComp *ship in arrayShips) {
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
            }
            break;
        }
    }
    return cell;
}

#pragma mark - CollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView_ viewWithTag:indexPath.row+1];
    collectionView.userInteractionEnabled = NO;
    ShotComp *shot = [[ShotComp alloc]initWithTag:indexPath.row+1 shotsPlayerArray:arrayShots andShipsOpponentArray:arrayShips];
    [arrayShots addObject:shot];
    [self playSoundWithShot:shot];
    [self animateCell:cell withShot:shot];
    [self testAllSunkenShips];
}

@end
