//
//  DistribuirNavios.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 4/12/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ShipDistributor.h"
#import "WebService.h"
#import "RKUtil.h"
#import "LoadingView.h"
#import "Alert.h"
#import "ConfigurationComp.h"
#import "TestField.h"
#import "Sound.h"
#import "ActiveGames.h"

@implementation ShipDistributor{
    IBOutlet UICollectionView *collectionView_;
    WebService *rk;
    LoadingView *loading;
    Sound *sound;
    NSMutableArray<Ship *> *arrayShips;
    NSInteger shipId;
    NSMutableArray *usedFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    shipId = 0;
    arrayShips = [NSMutableArray new];
    [self playSonar];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [collectionView_ registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    UICollectionViewFlowLayout *aFlowLayout = (UICollectionViewFlowLayout *)collectionView_.collectionViewLayout;
    float width   = (collectionView_.frame.size.width-10)/10;
    float height    =  (collectionView_.frame.size.height-10)/10;
    aFlowLayout.minimumInteritemSpacing  = 0.5;
    aFlowLayout.minimumLineSpacing       = 1;
    CGSize c        = CGSizeMake(width, height);
    aFlowLayout.itemSize = c;
    collectionView_.scrollEnabled = NO;
    collectionView_.backgroundColor = [UIColor clearColor];
    collectionView_.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Metodos

-(void)playSonar{
    if (!sound) sound = [Sound new];
    [sound playSonar];
}

-(void)didSwipe:(UISwipeGestureRecognizer *)sender{
    if (shipId > 4) return;
    collectionView_.userInteractionEnabled = NO;
    NSInteger size = 0;
    switch (shipId) {
        case 0:
            size = 5;
            break;
        case 1:
            size = 4;
            break;
        case 2:
            size = 3;
            break;
        case 3:
        case 4:
            size = 2;
            break;
    }
    CGPoint location             = [sender locationInView:collectionView_];
    NSIndexPath *swipedIndexPath = [collectionView_ indexPathForItemAtPoint:location];
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:swipedIndexPath.row+1];
    NSMutableArray *arrayFields = [NSMutableArray new];
    usedFields = !usedFields ? [NSMutableArray new] : usedFields;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) for (int i = 0; i < size; i++) [arrayFields addObject:@(cell.tag-i != 0 ? cell.tag-i : -1)];
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) for (int i = 0; i < size; i++) [arrayFields addObject:@(cell.tag+i)];
    else if (sender.direction == UISwipeGestureRecognizerDirectionUp) for (int i = 0; i < size; i++) [arrayFields addObject:@(cell.tag-i*10 != 0 ? cell.tag-i*10 : -1)];
    else if (sender.direction == UISwipeGestureRecognizerDirectionDown) for (int i = 0; i < size; i++) [arrayFields addObject:@(cell.tag+i*10)];
    if (([TestField testHorizontalField:arrayFields tableSize:10] || [TestField testVerticalField:arrayFields tableSize:10]) && ![TestField testRepeatedField:arrayFields usedFields:usedFields]) {
        [UIView animateWithDuration:0.2 animations:^{
            for (NSNumber *field in arrayFields) {
                UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:field.integerValue];
                cell.backgroundColor = [UIColor greenColor];
                cell.backgroundColor = [UIColor blueColor];
            }
        } completion:^(BOOL completion){
            [self markCells:arrayFields];
            collectionView_.userInteractionEnabled = YES;
        }];
        Ship *ship = [[Ship alloc]shipWithPositionsTag:arrayFields andId:shipId];
        [arrayShips addObject:ship];
        [usedFields addObjectsFromArray:arrayFields];
        shipId++;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            for (NSNumber *field in arrayFields) {
                UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:field.integerValue];
                UIColor *initialColor = cell.backgroundColor;
                cell.backgroundColor = [UIColor redColor];
                cell.backgroundColor = initialColor;
            }
        } completion:^(BOOL completion){
            collectionView_.userInteractionEnabled = YES;
        }];
    }
}

-(void)createShips{
    loading = [[LoadingView alloc]initWithController:self andNewTitle:@"Criando navios"];
    [loading show];
    rk = [[WebService alloc]initWithDelegate:self];
    [rk         requestType:POST_GAMESHIP withMethod:@"POST"
                       path:[RKUtil pathForPostGameShip]
                 parameters:[RKUtil
                             parameterForPostGameShip:arrayShips playerId: self.game.gamePlayerOne.playerID
                             andGameId:self.game.gameId]];
}

-(void)markCells:(NSArray *)arrayFields{
    UIColor *color;
    switch (arrayFields.count) {
        case 5:
            color = [UIColor cyanColor];
            break;
        case 4:
            color = [UIColor purpleColor];
            break;
        case 3:
            color = [UIColor orangeColor];
            break;
        case 2:
            color = [UIColor grayColor];
            break;
    }
    for (NSNumber *field in arrayFields) {
        UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:field.integerValue];
        cell.backgroundColor = color;
    }
}

#pragma mark - Retorno chamado

-(void)callBackType:(CallType)type withdata:(id)data{
    [loading hide];
    if (type == POST_GAMESHIP) [self dismissViewControllerAnimated:YES completion:^{
        if ([self.sender class] == [ActiveGames class]) {
            [((ActiveGames *)self.sender).tableView reloadData];
        }else{
            [self.sender.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row+1;
    UISwipeGestureRecognizer *swipeLeftOn, *swipeRightOn, *swipeUpOn, *swipeDownOn;
    swipeLeftOn     = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeRightOn    = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeUpOn       = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeDownOn     = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeLeftOn.direction   = UISwipeGestureRecognizerDirectionLeft;
    swipeRightOn.direction  = UISwipeGestureRecognizerDirectionRight;
    swipeUpOn.direction     = UISwipeGestureRecognizerDirectionUp;
    swipeDownOn.direction   = UISwipeGestureRecognizerDirectionDown;
    [cell addGestureRecognizer:swipeLeftOn];
    [cell addGestureRecognizer:swipeRightOn];
    [cell addGestureRecognizer:swipeDownOn];
    [cell addGestureRecognizer:swipeUpOn];
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
    return cell;
}

#pragma mark - Collection view delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:indexPath.row+1];
    if (shipId < 5) return;
    collectionView_.userInteractionEnabled = NO;
    NSMutableArray *field = [NSMutableArray new];
    [field addObject:@(cell.tag)];
    if ([TestField testRepeatedField:field usedFields:usedFields]) {
        [UIView animateWithDuration:0.2 animations:^{
            UIColor *initialColor = cell.backgroundColor;
            cell.backgroundColor = [UIColor redColor];
            cell.backgroundColor = initialColor;
        }completion:^(BOOL completion){
            collectionView_.userInteractionEnabled = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            cell.backgroundColor = [UIColor greenColor];
            cell.backgroundColor = [UIColor blueColor];
        }completion:^(BOOL completion){
            cell.backgroundColor = [UIColor yellowColor];
            collectionView_.userInteractionEnabled = YES;
        }];
        Ship *ship = [[Ship alloc]shipWithPositionsTag:field andId:shipId];
        [arrayShips addObject:ship];
        [usedFields addObjectsFromArray:field];
        shipId ++;
    }
    if(shipId > 6) [self createShips];
}

@end
