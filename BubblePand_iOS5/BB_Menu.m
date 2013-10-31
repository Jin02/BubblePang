//
//  BB_Menu.m
//  Bubbles
//
//  Created by imac07 on 10. 03. 05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BB_Menu.h"
#import "BB_Enum.h"
#import "BB_PlayGame.h"
#import "BB_Ranking.h"
#import "BB_Help.h"

@implementation BB_Menu

@synthesize GameStart;
@synthesize Credit;
@synthesize GameEnd;
@synthesize Ranking;
@synthesize CreditPeolple;

-(id)init
{
	if( (self=[super init]))
	{
		NSLog(@"메뉴 초기화 시작");
		
		self.isTouchEnabled = YES;
		
		backGround = [CCSprite spriteWithFile:@"3.png"];
		
		backGround.anchorPoint = CGPointZero;
		backGround.position = ccp(0,0);
		backGround.opacity = 0;
		CreditClick = YES;
		
		NSLog(@"메뉴 초기화 중1");
		[self addChild:backGround z:BB_backGround tag:BB_backGround];
		
		NSLog(@"메뉴 초기화 중2");
		
		self.GameStart = [CCMenuItemImage itemFromNormalImage:@"start.png" selectedImage:@"startclick.png" target:self selector:@selector(GameStartCallBack:)];
	
		NSLog(@"메뉴초기화 중간");
		self.Credit = [CCMenuItemImage itemFromNormalImage:@"credit.png" selectedImage:@"creditclick.png" target:self selector:@selector(GameCreditButton:)];
		self.GameEnd = [CCMenuItemImage itemFromNormalImage:@"Help.png" selectedImage:@"HelpClick.png" target:self selector:@selector(GameHelp:)];
		self.Ranking = [CCMenuItemImage itemFromNormalImage:@"Ranking.png" selectedImage:@"RankingClick.png" target:self selector:@selector(RankingCallBack:)];
		
		self.CreditPeolple = [[CCSprite alloc] initWithFile:@"CreditPeople.png"];
		self.CreditPeolple.anchorPoint = CGPointZero;
		self.CreditPeolple.position = ccp(20,-400);		
		[self addChild:self.CreditPeolple z:BB_menu+1 tag:BB_menu];
		
		CCMenu *menu = [CCMenu menuWithItems:self.GameStart, self.Ranking,self.Credit,self.GameEnd, nil];
		[menu alignItemsHorizontally];
		
		[self.GameEnd setPosition:ccp(-70,-400)];
		[self.Credit setPosition:ccp(-80,-400)];
		[self.GameStart setPosition:ccp(100,-400)];
		[self.Ranking setPosition:ccp(10,-400)];
				
		[self SoundLoadPath:@"BubbleSummon.wav"];
		[self SoundLoadPath:@"Big union.wav"];
		[self SoundLoadPath:@"Button.wav"];
		[self SoundLoadPath:@"Timeover.wav"];
		[self SoundLoadPath:@"Union.wav"];
		[self SoundLoadPath:@"Time.wav"];
		[self SoundLoadPath:@"Random.wav"];
		[self SoundLoadPath:@"Clear.wav"];
		[self SoundLoadPath:@"Bomb.wav"];
		[self SoundLoadPath:@"Gravity.wav"];
		[self SoundLoadPath:@"Bogol.wav"];
		[self SoundLoadPath:@"Needle.wav"];
		[self SoundLoadPath:@"BlackBubble.wav"];
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BackGroundMusic.mp3"];

		[self addChild:menu z:BB_menu tag:BB_menu];
		
		[self schedule:@selector(BackGroundGradation)];
	}
	
	return self;
	
}

-(void)BackGroundGradation
{
	static int Opacity = 0;
	
	if(Opacity +25 <255)
		[backGround setOpacity:Opacity+=25];
	else {
		[self unschedule:@selector(BackGroundGradation)];

		[self.GameStart runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(100,180)]];
		[self.Credit runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(-80,45)]];
		[self.GameEnd runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(-70,150)]];
		[self.Ranking runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(10,-60)]];
	}

}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(!CreditClick)
	{
		[self.CreditPeolple runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(20,-400)]];
		CreditClick = YES;
	}
}

-(void)GameCreditButton:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"Bogol.wav"];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	[self.CreditPeolple runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(20,100)]];
	CreditClick = NO;
}

-(void)GameHelp:(id)sender
{
	if(!CreditClick) return;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	
	BB_Help *NextScene = [BB_Help node];
	[[CCDirector sharedDirector] pushScene:(CCScene*)NextScene];
}

-(void)SoundLoadPath:(NSString*)path
{
	ALuint EffectValue = [[SimpleAudioEngine sharedEngine] playEffect:path];
	[[SimpleAudioEngine sharedEngine] stopEffect:EffectValue];
}

-(void)RankingCallBack: (id)sender
{
	if(!CreditClick) return;
	
	BB_Ranking *NextScene = [BB_Ranking node];
	[[CCDirector sharedDirector] pushScene:(CCScene*)NextScene];
}

-(void)GameStartCallBack: (id)sender
{
	if(!CreditClick) return;
	
	NSLog(@"게임시작 버튼 누름");
	[[SimpleAudioEngine sharedEngine] playEffect:@"Button.wav"];
	[[SimpleAudioEngine sharedEngine] stopEffect:backGroundMusicID];

	BB_PlayGame *NextScene = [BB_PlayGame node];
	[[CCDirector sharedDirector] pushScene:(CCScene*)NextScene];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) dealloc
{
	NSLog(@"ㅇㅇ");
	
//	[GameStart release];
//	[Credit release];
//	[CreditPeolple release];
//	[backGround release];
	
//	[GameEnd release];
//	[Ranking release];
	
	[self removeAllChildrenWithCleanup:YES];
	
	[super dealloc];
}

@end
