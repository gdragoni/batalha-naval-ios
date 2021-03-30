//
//  ConfiguracoesController.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 12/30/15.
//  Copyright (c) 2015 Gabriel A. Dragoni. All rights reserved.
//

#import "ConfiguracoesController.h"
#import "UserDefault.h"

@implementation ConfiguracoesController{
    ConfigurationComp *config;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    config = [UserDefault getConfiguration];
    self.scrollViewConfig.contentSize = CGSizeMake(200, 450);
    [self atualizaCampos];
}

#pragma mark - Metodos

-(void)atualizaCampos{
    _tamTabField.text      = [NSString stringWithFormat:@"%li", config.tableSize];
    _portaAvioesField.text = [NSString stringWithFormat:@"%li", config.amountPortaAvioes];
    _encouracadoField.text = [NSString stringWithFormat:@"%li", config.amountEncouracado];
    _cruiserField.text     = [NSString stringWithFormat:@"%li", config.amountCruiser];
    _destroyerField.text   = [NSString stringWithFormat:@"%li", config.amountDestroyer];
    _submarinoField.text   = [NSString stringWithFormat:@"%li", config.amountSubmarino];
    _tentTurnoField.text   = [NSString stringWithFormat:@"%li", config.shotsPerTurn];
    _tentExtraField.text   = [NSString stringWithFormat:@"%li", config.extraShotPerHit];
    _stpTamTab.value       = config.tableSize;
    _stpPortaAvioes.value  = config.amountPortaAvioes;
    _stpEncouracado.value  = config.amountEncouracado;
    _stpCruiser.value      = config.amountCruiser;
    _stpDestroyer.value    = config.amountDestroyer;
    _stpSubmarino.value    = config.amountSubmarino;
    _stpTentTurno.value    = config.shotsPerTurn;
    _stpTentExtra.value    = config.extraShotPerHit;
}

-(NSInteger)quantityFieldsWithShips{
    return  _portaAvioesField.text.integerValue*5 +
            _encouracadoField.text.integerValue*4 +
            _cruiserField.text.integerValue*3     +
            _destroyerField.text.integerValue*2   +
            _submarinoField.text.integerValue*1;
}

#pragma mark - Action Button

- (IBAction)tamTabStepper:(id)sender {
    if ([self validateTableSize:_stpTamTab]) _tamTabField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpTamTab.value];
    else _stpTamTab.value = [_tamTabField.text integerValue];
}

- (IBAction)portaAvioesStepper:(id)sender {
    if (_stpPortaAvioes.value > _portaAvioesField.text.integerValue) {
        if ([self validateShip:sender withShipSize:5]) _portaAvioesField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpPortaAvioes.value];
        else _stpPortaAvioes.value = [_portaAvioesField.text integerValue];
    }else if (_stpPortaAvioes.value<=0) _stpPortaAvioes.value = 1;
    else _portaAvioesField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpPortaAvioes.value];
}

- (IBAction)encouracadoStepper:(id)sender {
    if (_stpEncouracado.value>_encouracadoField.text.integerValue) {
        if ([self validateShip:sender withShipSize:4]) _encouracadoField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpEncouracado.value];
        else _stpEncouracado.value = [_encouracadoField.text integerValue];
    }else if (_stpEncouracado.value<=0) _stpEncouracado.value = 1;
    else _encouracadoField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpEncouracado.value];
}

- (IBAction)cruiserStepper:(id)sender {
    if (_stpCruiser.value>_cruiserField.text.integerValue) {
        if ([self validateShip:sender withShipSize:3]) _cruiserField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpCruiser.value];
        else _stpCruiser.value = [_cruiserField.text integerValue];
    }else if (_stpCruiser.value<=0) _stpCruiser.value = 1;
    else _cruiserField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpCruiser.value];
}

- (IBAction)destroyerStepper:(id)sender {
    if (_stpDestroyer.value>_destroyerField.text.integerValue) {
        if ([self validateShip:sender withShipSize:2]) _destroyerField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpDestroyer.value];
        else _stpDestroyer.value = [_destroyerField.text integerValue];
    }else if (_stpDestroyer.value<=0) _stpDestroyer.value = 1;
    else _destroyerField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpDestroyer.value];
}

- (IBAction)submarinoStepper:(id)sender {
    if (_stpSubmarino.value>_submarinoField.text.integerValue) {
        if ([self validateShip:sender withShipSize:1]) _submarinoField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpSubmarino.value];
        else _stpSubmarino.value = [_submarinoField.text integerValue];
    }else if (_stpSubmarino.value<=0) _stpSubmarino.value = 1;
    else _submarinoField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpSubmarino.value];
}

- (IBAction)tentTurnoStepper:(id)sender {
    if ([self validateShotPerTurn:sender]) _tentTurnoField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpTentTurno.value];
    else _stpTentTurno.value = [_tentTurnoField.text integerValue];
}

- (IBAction)tentExtraStepper:(id)sender {
    if ([self validateExtraShot:sender]) _tentExtraField.text = [NSString stringWithFormat:@"%li", (NSInteger)_stpTentExtra.value];
    else _stpTentExtra.value = [_tentExtraField.text integerValue];
}

- (IBAction)actionButtonSave:(id)sender {
    ConfigurationComp *configuration            = [ConfigurationComp new];
    configuration.tableSize                     = _tamTabField.text.integerValue;
    configuration.amountPortaAvioes             = _portaAvioesField.text.integerValue;
    configuration.amountEncouracado             = _encouracadoField.text.integerValue;
    configuration.amountCruiser                 = _cruiserField.text.integerValue;
    configuration.amountDestroyer               = _destroyerField.text.integerValue;
    configuration.amountSubmarino               = _submarinoField.text.integerValue;
    configuration.extraShotPerHit               = _tentExtraField.text.integerValue;
    configuration.shotsPerTurn                  = _tentTurnoField.text.integerValue;
    [UserDefault setConfiguration:configuration];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)actionButtonStandard:(id)sender {
    _tamTabField.text       = [NSString stringWithFormat:@"%i", 10];
    _stpTamTab.value        = 10;
    _portaAvioesField.text  = [NSString stringWithFormat:@"%i", 1];
    _stpPortaAvioes.value   = 1;
    _encouracadoField.text  = [NSString stringWithFormat:@"%i", 1];
    _stpEncouracado.value   = 1;
    _cruiserField.text      = [NSString stringWithFormat:@"%i", 1];
    _stpCruiser.value       = 1;
    _destroyerField.text    = [NSString stringWithFormat:@"%i", 2];
    _stpDestroyer.value     = 2;
    _submarinoField.text    = [NSString stringWithFormat:@"%i", 2];
    _stpSubmarino.value     = 2;
    _tentTurnoField.text    = [NSString stringWithFormat:@"%i", 1];
    _stpTentTurno.value     = 1;
    _tentExtraField.text    = [NSString stringWithFormat:@"%i", 0];
    _stpTentExtra.value     = 0;
    [self actionButtonSave:sender];
}

#pragma mark - Testes

-(BOOL)validateTableSize:(UIStepper*)sender{
    return !(sender.value > 12 || sender.value < 5 || sender.value * sender.value < [self quantityFieldsWithShips] * 1.5);
}

-(BOOL)validateShip:(UIStepper*)sender withShipSize:(NSInteger)shipSize{
    return !(_tamTabField.text.integerValue * _tamTabField.text.integerValue < ([self quantityFieldsWithShips]+shipSize)*1.5);
}

-(BOOL)validateShotPerTurn:(UIStepper*)sender{
    return !(sender.value <= 0 || sender.value > 5);
}

-(BOOL)validateExtraShot:(UIStepper*)sender{
    return !(sender.value>5);
}

@end
