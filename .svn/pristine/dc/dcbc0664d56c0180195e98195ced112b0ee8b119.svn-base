//
//  Soms.m
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 1/21/16.
//  Copyright (c) 2016 Gabriel A. Dragoni. All rights reserved.
//

#import "Sound.h"
#import "UserDefault.h"

Sound *sharedSound;

@implementation Sound {
    AVAudioPlayer *audioPlayer;
}

-(void)playSound:(NSString *)soundName soundType:(NSString *)type volume:(float)volume{
    audioPlayer = [self setupAudioPlayerWithFile:soundName type:type];
    [audioPlayer setVolume:volume];
    [audioPlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == audioPlayer) {
        if (rand()%2 == 0) [self playTheme1];
        else [self playTheme2];
    }
}

-(void)stopSound{
    [audioPlayer stop];
}

-(void)playTheme1{
    [self playSound:@"temaInicio" soundType:@"mp3" volume:0.3];
}

-(void)playSonar{
    [self playSound:@"oldSonar" soundType:@"wav" volume:0.3];
}

-(void)playBomb{
    [self playSound:@"bombaLancada" soundType:@"wav" volume:0.3];
}

-(void)playSplash{
    [self playSound:@"splash" soundType:@"wav" volume:0.3];
}

-(void)playShipbell{
    [self playSound:@"shipBell" soundType:@"wav" volume:0.3];
}

-(void)playSadTrambone{
    [self playSound:@"sadTrambone" soundType:@"wav" volume:0.3];
}

-(void)playWinSound{
    [self playSound:@"TaDa" soundType:@"wav" volume:0.3];
}

-(void)playTheme2{
    [self playSound:@"soundTemaOnline" soundType:@"mp3" volume:0.3];
}

-(AVAudioPlayer *)setupAudioPlayerWithFile: (NSString*) file type: (NSString*) type{
    ConfigurationComp *config = [UserDefault getConfiguration];
    if (config.enableSound) {
        NSString *path = [[NSBundle mainBundle]pathForResource:file ofType:type];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        AVAudioPlayer *audio = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if(!audio){
            NSLog(@"Sound error: %@", [error description]);
        }
        audio.delegate = sharedSound;
        return audio;
    }
    return nil;
}

+(Sound *)sharedInstanceSound{
    if (sharedSound == nil) {
        sharedSound = [Sound new];
    }
    return sharedSound;
}

@end
