//
//  PaginaInicial.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 12/30/15.
//  Copyright (c) 2015 Gabriel A. Dragoni. All rights reserved.
//

#import "FirstScene.h"
#import "Sound.h"
#import "UserDefault.h"

@implementation FirstScene{
    Sound *sound;
    IBOutlet UISwitch *switchSound;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    switchSound.on = [UserDefault getConfiguration].enableSound;
}

-(void)playTheme{
    sound = [Sound sharedInstanceSound];
    [sound playTheme1];
}

- (IBAction)switchEnableSound:(UISwitch *)sender {
    ConfigurationComp *config = [UserDefault getConfiguration];
    config.enableSound = sender.on;
    [UserDefault setConfiguration:config];
    [self playTheme];
}

@end
