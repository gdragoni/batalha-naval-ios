//
//  ShipCompDistributorViewController.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 5/13/16.
//  Copyright © 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "ShipCompDistributor.h"
#import "ConfigurationComp.h"
#import "UserDefault.h"
#import "ShipComp.h"
#import "TestField.h"
#import "ShipGenerator.h"
#import "Sound.h"

@implementation ShipCompDistributor{
    IBOutlet UICollectionView *collectionView_;
    ConfigurationComp *configuration;
    Sound *sound;
    NSMutableArray <ShipComp *> *arrayShips;
    NSMutableArray *usedFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    configuration = [UserDefault getConfiguration];
    [self putShipsInArray];
    [self playSonar];
    collectionView_.dataSource = self;
    collectionView_.delegate = self;
    [collectionView_ registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [collectionView_ registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    UICollectionViewFlowLayout *aFlowLayout = (UICollectionViewFlowLayout *)collectionView_.collectionViewLayout;
    float width     = (collectionView_.frame.size.width-10)/configuration.tableSize;
    float height    =  (collectionView_.frame.size.height-10)/configuration.tableSize;
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

-(void)putShipsInArray{
    if (!arrayShips) arrayShips = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        NSInteger amuntOfShipsType = i == 0 ? configuration.amountPortaAvioes : i == 1 ? configuration.amountEncouracado : i == 2 ? configuration.amountCruiser : i == 3 ? configuration.amountDestroyer : configuration.amountSubmarino;
        ShipType type = i == 0 ? PortaAvioes : i == 1 ? Encouracado : i == 2 ? Cruiser : i == 3 ? Destroyer : Submarino;
        for (int i = 0; i < amuntOfShipsType; i++) {
            ShipComp *ship = [[ShipComp alloc]initShipType:type];
            [arrayShips addObject:ship];
        }
    }
}

-(void)didSwipe:(UISwipeGestureRecognizer *)sender{
    if ([self currentShip].type == Submarino) return;
    ShipComp *currentShip = [self currentShip];
    collectionView_.userInteractionEnabled = NO;
    CGPoint location             = [sender locationInView:collectionView_];
    NSIndexPath *swipedIndexPath = [collectionView_ indexPathForItemAtPoint:location];
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:swipedIndexPath.row+1];
    NSMutableArray *arrayFields = [NSMutableArray new];
    if (!usedFields) usedFields = [NSMutableArray new];
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        for (int i = 0; i < currentShip.size; i++) {
            [arrayFields addObject:@(cell.tag-i != 0 ? cell.tag-i : -1)];
        }
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        for (int i = 0; i < currentShip.size; i++) {
            [arrayFields addObject:@(cell.tag+i)];
        }
    }else if (sender.direction == UISwipeGestureRecognizerDirectionUp){
        for (int i = 0; i < currentShip.size; i++) {
            [arrayFields addObject:@(cell.tag-i*configuration.tableSize != 0 ? cell.tag-i*configuration.tableSize : -1)];
        }
    }else if (sender.direction == UISwipeGestureRecognizerDirectionDown){
        for (int i = 0; i < currentShip.size; i++) {
            [arrayFields addObject:@(cell.tag+i*configuration.tableSize)];
        }
    }
    if (([TestField testHorizontalField:arrayFields tableSize:configuration.tableSize] || [TestField testVerticalField:arrayFields tableSize:configuration.tableSize]) && ![TestField testRepeatedField:arrayFields usedFields:usedFields]) {
        [UIView animateWithDuration:0.2 animations:^{
            for (NSNumber *field in arrayFields) {
                UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView_ viewWithTag:field.integerValue];
                cell.backgroundColor = [UIColor greenColor];
                cell.backgroundColor = [UIColor blueColor];
            }
        } completion:^(BOOL completion){
            [self markCell:arrayFields];
            collectionView_.userInteractionEnabled = YES;
        }];
        currentShip.positions = arrayFields;
        [usedFields addObjectsFromArray:arrayFields];
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

-(ShipComp *)currentShip{
    for (ShipComp *ship in arrayShips) {
        if (!ship.positions) {
            return ship;
        }
    }
    return nil;
}

-(void)markCell:(NSArray *)arrayFields{
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

-(void)initBattle{
    self.sender.game.shipPlayer = arrayShips;
    self.sender.game.shipOpponent = [[ShipGenerator new] arrayWithConfiguration:configuration];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.sender.collectionView reloadData];
        [self.sender.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }];
}

#pragma mark - Collectionview datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return configuration.numberOfFields;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
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

#pragma mark - Collectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView viewWithTag:indexPath.row+1];
    if ([self currentShip].type != Submarino) return;
    NSMutableArray *fields = [NSMutableArray new];
    [fields addObject:@(cell.tag)];
    if ([TestField testRepeatedField:fields usedFields:usedFields]) {
        [UIView animateWithDuration:0.2 animations:^{
            UIColor *initialColor = cell.backgroundColor;
            cell.backgroundColor = [UIColor redColor];
            cell.backgroundColor = initialColor;
        }completion:^(BOOL completion){
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            cell.backgroundColor = [UIColor greenColor];
            cell.backgroundColor = [UIColor blueColor];
        }completion:^(BOOL completion){
            cell.backgroundColor = [UIColor yellowColor];
        }];
        [self currentShip].positions = fields;
        [usedFields addObjectsFromArray:fields];
    }
    if(![self currentShip]) [self initBattle];
}

@end
