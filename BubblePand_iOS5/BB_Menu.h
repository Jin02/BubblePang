//
//  BB_Menu.h
//  Bubbles
//
//  Created by imac07 on 10. 03. 05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

@interface BB_Menu : CCLayer {
	
	CCMenuItem		*GameStart;
	CCMenuItem		*Credit;
	CCMenuItem		*GameEnd;
	CCMenuItem		*Ranking;
	CCSprite		*CreditPeolple;
	
	CCSprite *backGround;
	ALuint	  backGroundMusicID;
	BOOL	  CreditClick;
}

@property (nonatomic, retain) CCSprite	 *CreditPeolple;
@property (nonatomic, retain) CCMenuItem *GameStart;
@property (nonatomic, retain) CCMenuItem *Credit;
@property (nonatomic, retain) CCMenuItem *GameEnd;
@property (nonatomic, retain) CCMenuItem *Ranking;

-(void)SoundLoadPath:(NSString*)path;
//-(void)BackGroundMusicPlay;

@end
