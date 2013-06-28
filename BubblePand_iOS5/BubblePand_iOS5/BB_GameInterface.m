//
//  BB_GameInterface.m
//  BubbleGame
//
//  Created by imac07 on 10. 03. 10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BB_GameInterface.h"
#import "BB_Enum.h"
#import "BB_PlayGame.h"
#import "CCGrid.h"


#define W_Char_posy 180

@implementation BB_GameInterface


@synthesize scoreLabel;
@synthesize W_sprite, W_Animate;
@synthesize W_dangerAnimate, W_dangerSprite;
@synthesize C_sprite, C_Animate;
@synthesize timeGageBar, timeGageBack;
@synthesize warnningGageBar, warnningGageBack;
@synthesize emitter;
@synthesize comboSprite;
@synthesize ParticleGravity;
@synthesize StageSprite;
@synthesize warnning;
@synthesize MaxPang;
@synthesize ClearButton;

-(id) initWithGameScene:(BB_PlayGame*)scene
{
	if( (self = [super init]) )
	{
		self.isTouchEnabled = YES;
		Game = scene;
		
		[self createSprite];
		
		score = 0;
		warnning = 0;
		normalDanger = NO;
		touchLimit = NO;
		comboAniMation = NO;
		MaxPang = NO;
		ParticleGravity = ccp(0,-50);
		
		m_Shake = [[CCSprite alloc] initWithFile:@"shake.png"];
		[m_Shake setPosition:ccp(160, 170)];
	
		[self addChild:m_Shake];
		[m_Shake setVisible:NO];
		

		[self createLabel];
		
		[self createWarnningAnimation];
		[self createClockAnimation];
		
		[self go_wAni];
		[self go_cClockAni];
		
		[self CharWarnning];
		[self NextStage];
		[self performSelector:@selector(Shaking) withObject:nil afterDelay:2.5f];
	}
	
	return self;
}

-(void)Shakingdealloc
{
	[m_Shake release];
}

-(void)Shaking
{
	[m_Shake setVisible:YES];
	
	/*
	 쉐이크 액션은
	 
	 동시에(spawn) 2개의 일을 처리하고
	 한 액션은 순서로(sequence) 각도를(CCRotate) 20,-20,30,-30 으로 조정 시켜주고
	 한 액션은 순서로(sequence) 0.5초간 페이드인(CCFadeIn), 페이드아웃(CCFadeOut) 해준다.
	 
	 */
	
	[m_Shake runAction:
	 [CCSpawn actions:
	 [CCSequence actions:
	  [CCRotateTo actionWithDuration:0.25f angle:20], [CCRotateTo actionWithDuration:0.25f angle:-20],
	  [CCRotateTo actionWithDuration:0.25f angle:30], [CCRotateTo actionWithDuration:0.25f angle:-30]
	  ,nil],
	  [CCSequence actions:[CCFadeIn actionWithDuration:0.5f],[CCFadeOut actionWithDuration:0.5f],nil],nil]];
}

-(void)TestButton:(id)sender
{	[Game BubbleSummon];	}

-(void)InterfaceDataClear
{
	warnning = 0;
	normalDanger = YES;
	touchLimit = NO;
	comboAniMation = NO;
	[self WarnningPointDisplay:warnning];
}

-(void)createSprite
{
	self.timeGageBar = [[CCSprite alloc] initWithFile:@"gage bar.png"];
	self.timeGageBar.anchorPoint = ccp(0,0);
	self.timeGageBar.position = ccp(28,3);
	
	self.timeGageBack = [[CCSprite alloc] initWithFile:@"gage bar2.png"];
	self.timeGageBack.anchorPoint = ccp(0,0);
	self.timeGageBack.position = self.timeGageBar.position;
	
	self.warnningGageBar = [[CCSprite alloc] initWithFile:@"gage bar.png"];
	self.warnningGageBar.anchorPoint = ccp(0, 0);
	self.warnningGageBar.position = ccp(63+50,22);
	
	self.warnningGageBack  = [[CCSprite alloc] initWithFile:@"gage bar2.png"];
	self.warnningGageBack.anchorPoint = ccp(0, 0);
	self.warnningGageBack.position = self.warnningGageBar.position;
	
	self.StageSprite = [[CCSprite alloc] initWithFile:@"stage.png"];
	self.StageSprite.anchorPoint = ccp(0,0);
	self.StageSprite.position = ccp(-150,280);
	
	CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"combo.png" capacity:10];
	
	[self addChild:StageSprite z:BB_StageNum tag:BB_StageNum];
	[self addChild:sheet z:BB_ComboSprite tag:BB_ComboSprite];
	[self addChild:timeGageBar z:BB_GageBar tag:BB_GageBar];
	[self addChild:timeGageBack z:BB_GageBack tag:BB_GageBack];
	[self addChild:warnningGageBar z:BB_GageBar tag:BB_GageBar];
	[self addChild:warnningGageBack z:BB_GageBack tag:BB_GageBack];	
}

-(void)createLabel
{
	CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Marker Felt" fontSize:22];
	self.scoreLabel = label;
	self.scoreLabel.anchorPoint = CGPointZero;
	self.scoreLabel.color = ccc3(0, 0, 0);
	self.scoreLabel.position = ccp(220,7+420);
	[self addChild:self.scoreLabel z:BB_Interface_Score tag:BB_Interface_Score];
	[label release];	
	
	CCLabelTTF* label2 = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Marker Felt" fontSize:22];
	MaxPangLabel = label2;
	MaxPangLabel.anchorPoint = CGPointZero;
	MaxPangLabel.position = ccp(120,427);
	MaxPangLabel.color = ccc3(0,0,0);
	[self addChild:MaxPangLabel z:BB_Interface_Score tag:BB_Interface_Score];
	
	[label2 release];
	
	CCLabelTTF* label3 = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Marker Felt" fontSize:22];
	NowStageLabel = label3;
	NowStageLabel.anchorPoint = CGPointZero;
	NowStageLabel.position = ccp(30,427);
	NowStageLabel.color = ccc3(0,0,0);
	[self addChild:NowStageLabel z:BB_Interface_Score tag:BB_Interface_Score];
	
	[label3 release];
}

#pragma mark 미구현

-(void)NowStageDisplay
{
	NSString *str = [[NSString alloc] initWithFormat:@"%d",[Game GetStage]];
	[NowStageLabel setString:str];
	[NowStageLabel runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5f scale:1.5f],[CCScaleTo actionWithDuration:0.5f scale:1.0f],nil]];
	[str release];
}

-(void)MaxPangDisplay
{
	NSString *str = [[NSString alloc] initWithFormat:@"%d",MaxPang];
	[MaxPangLabel setString:str];
	[MaxPangLabel runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5f scale:1.5f],[CCScaleTo actionWithDuration:0.5f scale:1.0f],nil]];
	[str release];
}

#pragma mark 미구현

-(void)ScoreDisPlay:(int)Value
{
	NSLog(@"으잌 점수");
	
	if( (score += Value + (Value*[Game GetCombo])) < 0 )
		score = 0;
	
	NSString *str = [[NSString alloc] initWithFormat:@"%d",score];
	[self.scoreLabel setString:str];
	
	if(Value>0)
		[self.scoreLabel runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5f scale:1.5f],[CCScaleTo actionWithDuration:0.5f scale:1.0f],nil]];
	
	[str release];
}

-(void)StageSpritePos
{
	NSLog(@"스프라이트 포지션 다시 셋팅");
	[self.StageSprite setPosition:ccp(-150,240)];
}

-(void)LabelatlasRemove:(CCNode*)node labelAtlas:(CCLabelAtlas*)label
{
	if(label != nil)
	{	[self removeChild:label cleanup:YES];	}
}

-(void)NextStage
{	
	NSLog(@"%d", [Game GetStage]);
	NSString *StageNum = [[NSString alloc] initWithFormat:@"%d",[Game GetStage]];
	CCLabelAtlas *StageLabel = [CCLabelAtlas labelWithString:StageNum charMapFile:@"StageNum.png" itemWidth:29 itemHeight:42 startCharMap:'0'];

	[StageLabel setPosition:ccp(-100,230)];

	[self addChild:StageLabel z:BB_StageNum tag:BB_StageNum];

	[StageNum release];
	
	[self.StageSprite runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5f position:ccp(120,240)],
								 [CCMoveTo actionWithDuration:1.5f position:ccp(160,240)],
								 [CCMoveTo actionWithDuration:0.3f position:ccp(320,240)],
								 [CCCallFunc actionWithTarget:self selector:@selector(StageSpritePos)],nil]];
	
	[StageLabel runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.5f position:ccp(70,230)],
								 [CCMoveTo actionWithDuration:1.5f position:ccp(90,230)],
								 [CCMoveTo actionWithDuration:0.5f position:ccp(290,230)],
								 [CCCallFuncND actionWithTarget:self selector:@selector(labelRemove: labelAtlas:) data:(void*)StageLabel], nil]];

	[self NowStageDisplay];
}

-(void)WarnningPointDisplay:(int)Value
{
	NSLog(@"으잌 워링");
	
	warnning += Value;
	
	if(warnning >= 100)
		[Game GameOverScene];
	else
		[self W_GageBarSet:warnning];
	
}

-(NSInteger)getScore
{
	return score;
}

-(BOOL)GetTouchLim
{
	return touchLimit;
}

-(void)CharWarnning
{
	if( warnning < 70 )
	{
		if( normalDanger == YES )
		{
			[self go_wAni];
			[self end_wDangerAni];
		}
	}
	else
	{
		if( normalDanger == NO)
		{
			[self go_wDangerAni];
			[self end_wAni];
		}
	}
}

-(void)InterfaceMessage
{
	[self CharWarnning];
	//시계가 급해지는게 있다면 이곳에  추가할것
	//아직은 없으니까 이쪽은 워링만 체크하게 해둠 ㅇㅇ!
	
}

-(void)createClockAnimation
{
	CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"time.png"];
	[self addChild:sheet z:BB_AnimationSheet tag:BB_AnimationSheet];

	NSMutableArray *aniFrame = [NSMutableArray array];
	
	for(int i = 0; i < 3; i++)
	{
//		CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sheet.texture rect:CGRectMake(i*40, 0, 40, 50) offset:CGPointZero];
        
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sheet.texture rectInPixels:CGRectMake(i*40, 0, 40, 50) rotated:NO offset:CGPointZero originalSize:CGSizeMake(121, 55)];
        

		[aniFrame addObject:frame];
	}
		
//	CCAnimation *animation = [CCAnimation animationWithName:@"clock" delay:0.3f frames:aniFrame];
    CCAnimation *animation = [CCAnimation animationWithFrames:aniFrame delay:0.3f];
		
	CCAnimate *animate = [[CCAnimate alloc] initWithAnimation: animation restoreOriginalFrame:NO];
	
	self.C_Animate = animate;
	 
	[animate release];
	
	CCSprite *sprite= [CCSprite spriteWithSpriteFrame:(CCSpriteFrame*)[aniFrame	objectAtIndex:0]];
	
	self.C_sprite = sprite;
	self.C_sprite.anchorPoint = ccp(0, 0);
	self.C_sprite.position = ccp(-35,5);

	[self addChild:self.C_sprite z:BB_AnimationSheet tag:BB_AnimationSheet];
	
	
	[sprite release];	
}

-(void)StageClearBubbleParticle
{
	[self.emitter stopSystem];
	[self removeChildByTag:BB_Paricle cleanup:YES];
}

-(void)StageClearEffect
{
	self.emitter = [[CCParticleFlower alloc] initWithTotalParticles:2000];
	self.emitter.tangentialAccel = 200;
	self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"Particle.png"];
	self.emitter.position = ccp(160,240);
	
	[self addChild:emitter z:BB_Paricle tag:BB_Paricle];
	
	[self setEmitter:self.emitter];
	[self.emitter release];
	
//	[self performSelector:@selector(StageClearBubbleParticle) withObject:nil afterDelay:(4) ];
//	[self runAction:[CCDelayTime actionWithDuration:4.0f]
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:4.0f],[CCCallFunc actionWithTarget:self selector:@selector(StageClearBubbleParticle)],nil]];
}

-(void)bubbleParticlePos:(CGPoint)point
{
	if(self.emitter.active)
		[self bubbleStopParticle];
	
	self.emitter = [[CCParticleFlower alloc] initWithTotalParticles:150];
	
	[self addChild:emitter z:BB_Paricle tag:BB_Paricle];
	
	self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"Particle.png"];
	self.emitter.position = point;
//	self.emitter.startColor = ccc<#const GLubyte b#>)

	[self.emitter setGravity:ParticleGravity];
	
	[self setEmitter:self.emitter];
	
	[self.emitter release];
	
//	[self performSelector:@selector(bubbleStopParticle) withObject:nil afterDelay:(0.3f) ];
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3f],[CCCallFunc actionWithTarget:self selector:@selector(bubbleStopParticle)],nil]];
}

-(void)particleGalaxyStartPos:(CGPoint)point
{
	NSLog(@"갤럭시 파티클");

	if(self.emitter.active)
		[self bubbleStopParticle];
	
	self.emitter = [[CCParticleGalaxy alloc] initWithTotalParticles:1000];
	[self addChild:emitter z:BB_Paricle];
	self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"Particle.png"];
	self.emitter.position = point;
	
	[self setEmitter:self.emitter];
	[self.emitter release];
	
//	[self performSelector:@selector(particleGalaxyStop) withObject:nil afterDelay:(0.2) ];
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2f],[CCCallFunc actionWithTarget:self selector:@selector(particleGalaxyStop)],nil]];
}

-(void)particleGalaxyStop
{
	[self.emitter stopSystem];
}

-(void)bubbleStopParticle
{
	[self.emitter stopSystem];
}

-(void)go_cClockAni
{
	[self.C_sprite runAction:[CCRepeatForever actionWithAction:self.C_Animate]];
}

-(void)end_cClockAni
{
	[self.C_sprite stopAllActions];
}

-(void)createWarnningAnimation
{
	CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"danger.png"];
	[self addChild:sheet z:BB_AnimationSheet tag:BB_AnimationSheet];

	NSMutableArray *aniFrame[2];
	aniFrame[0] = [NSMutableArray array];
	aniFrame[1] = [NSMutableArray array];

	//일반 위험
	for(int i = 0; i < 2; i++)
	{
//		CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sheet.texture rect:CGRectMake(i*40, 0, 40, 50) offset:CGPointZero];
        
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:sheet.texture rectInPixels:CGRectMake(i*40, 0, 40, 50) rotated:NO offset:CGPointZero originalSize:CGSizeMake(206, 50)];
        
		[aniFrame[0] addObject:frame];
	}
	//끝
	
	
	//많이 위험
	for(int j = 0; j < 2; j++)
	{
//		CCSprite *frame = [CCSpriteFrame frameWithTexture:sheet.texture rect:CGRectMake(95 + (j*63), 0, 40, 50) offset:CGPointZero];
        
        CCSprite *frame = [CCSpriteFrame frameWithTexture:sheet.texture rectInPixels:CGRectMake(95 + (j*63), 0, 40, 50) rotated:NO offset:CGPointZero originalSize:CGSizeMake(206, 50)];
        
		[aniFrame[1] addObject:frame];
	}
	//끝
	
	CCAnimation *animation[2];
//	animation[0] = [CCAnimation animationWithName:@"normal_danger" delay:0.3f frames:aniFrame[0]];
//	animation[1] = [CCAnimation animationWithName:@"danger_danger" delay:0.05f frames:aniFrame[1]];
    
    animation[0] = [CCAnimation animationWithFrames:aniFrame[0] delay:0.3f];
	animation[1] = [CCAnimation animationWithFrames:aniFrame[1] delay:0.05f];

	
	CCAnimate *animate[2];
	
	for(int i = 0; i < 2; i++)
	    animate[i] = [[CCAnimate alloc] initWithAnimation: animation[i] restoreOriginalFrame:NO];
	
	self.W_Animate = animate[0];
	self.W_dangerAnimate = animate[1];

	for(int i = 0; i < 2; i++)
    	[animate[i] release];
	
	CCSprite *sprite[2];

	for(int i = 0; i < 2; i++)
		sprite[i]= [CCSprite spriteWithSpriteFrame:(CCSpriteFrame*)[aniFrame[i]	objectAtIndex:0]];
	
	//스프라이트가 2개가 되어야함.
	self.W_sprite = sprite[0];
	self.W_dangerSprite = sprite[1];
	
    self.W_sprite.anchorPoint = ccp(0, 0);
	self.W_sprite.position = ccp(10,0);
	
	self.W_dangerSprite.anchorPoint = ccp(0, 0);
	self.W_dangerSprite.position = ccp(-100,-100);//일단 저 멀리 보내버리자
    
	[self addChild:self.W_sprite z:BB_AnimationSheet tag:BB_AnimationSheet];
	[self addChild:self.W_dangerSprite z:BB_AnimationSheet tag:BB_AnimationSheet];	
		
	for(int i = 0; i < 2; i++)
		[sprite[i] release];
}

#pragma mark 게이지바

-(void)W_GageBarSet:(int)Risk
{
	//self.warnningGageBar.position = ccp(126 + (Risk*1.53), self.warnningGageBar.position.y);
	//[self.warnningGageBar setScaleX: 1 - (Risk*0.01)];
	[self.warnningGageBar runAction:
	 [CCSpawn actions: [CCMoveTo actionWithDuration:0.23f position:ccp(113 + (Risk*1.53), self.warnningGageBar.position.y)],
	  [CCScaleTo actionWithDuration:0.23f scaleX:1-(Risk*0.01) scaleY:1],nil]];
}

-(void)timeGageBarSet:(int)TimeValue
{	
	//[self.timeGageBar setScaleX: 1 - (TimeValue*0.01)];
	[self.timeGageBar runAction:[CCScaleTo actionWithDuration:0.23f scaleX:1 - (TimeValue*0.01) scaleY:1]];
}

#pragma mark 게이지바

-(void)go_wDangerAni
{
	self.W_dangerSprite.position = ccp(W_Char_posy, 0);
	[self.W_dangerSprite runAction:[CCRepeatForever actionWithAction:self.W_dangerAnimate]];
}

-(void)end_wDangerAni
{
	self.W_dangerSprite.position = ccp(-100, -100);
	[self.W_dangerSprite stopAllActions];
}

-(void)go_wAni
{
	normalDanger = NO;
	self.W_sprite.position = ccp(W_Char_posy, 0);
	[self.W_sprite runAction:[CCRepeatForever actionWithAction:self.W_Animate]];
}

-(void)end_wAni
{	
	normalDanger = YES;
	self.W_sprite.position = ccp(-100,-100);
	[self.W_sprite stopAllActions];
}

-(void)GridRelease
{
//	CCGridBase *temp = [[CCGridBase alloc] initWithSize:ccg(0,0)];
	//	[self unschedule:@selector(shakeStopMotion)];
    CCGrid3D *tmp = [[CCGrid3D alloc] initWithSize:ccg(0, 0)];
	NSLog(@"왔어 왔어");
	[Game stopAllActions];
	[Game setGrid:tmp];
	[tmp release];
}

-(void)shakeStartMotion
{
	id shaky = [CCShaky3D actionWithRange:4 shakeZ:NO grid:ccg(15,10) duration:3];
	//[backGround runAction: [CCRepeatForever actionWithAction: shaky]];
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(GridRelease)],nil]];
	[Game runAction:shaky];
}

-(void)liquidStartMotion
{
	id liquid = [CCLiquid actionWithWaves:6 amplitude:20 grid:ccg(15,10) duration:3];
	[Game runAction:[CCRepeatForever actionWithAction:liquid]];
//	[self performSelector:@selector(GridRelease) withObject:nil afterDelay:(1.0) ];
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(GridRelease)],nil]];
}

-(void)FlipX3DStartMotion
{
	id FlipX3D = [CCFlipX3D actionWithDuration:0.3];
	touchLimit = YES;
	[Game runAction:FlipX3D];
	[self performSelector:@selector(FlipX3DStopMotion) withObject:nil afterDelay:0.3f];
}

-(void)FlipX3DStopMotion
{
	[Game stopAllActions];
}

-(void)labelRemove:(CCNode*)node labelAtlas:(CCLabelAtlas*)label
{
	if(label != nil)
		[self removeChild:label cleanup:YES];
}

-(void)comboSpriteRemove:(CCNode*)node sprite:(CCSprite*)sprite
{
	if( sprite != nil )
	{
		CCSpriteBatchNode *sheet = (CCSpriteBatchNode*)[self getChildByTag:BB_ComboSprite];
		[sheet removeChild:sprite cleanup:YES];
	}
}

-(void)comboAnimation:(CGPoint)point
{	
	if( [Game GetCombo] <= 0 )	return;
	
	NSString *combo = [[NSString alloc] initWithFormat:@"%d",[Game GetCombo]];
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode*) [self getChildByTag:BB_ComboSprite];
    CCSprite *sprite = [CCSprite spriteWithTexture:sheet.texture rect:CGRectMake(0, 0, 139, 43)];
	
	CCLabelAtlas *comboLabel = [CCLabelAtlas labelWithString:combo charMapFile:@"number.png" itemWidth:25 itemHeight:25 startCharMap:'0'];
	
	[sheet addChild:sprite z:BB_ComboSprite tag:BB_ComboSprite];
    [self addChild:comboLabel z:BB_NumberSprite tag:BB_NumberSprite];
	
	[sprite setPosition:ccp(point.x+35, point.y)];
	[comboLabel setPosition:ccp(point.x-12,point.y-25)]; //임시
	
	[comboLabel runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccp(comboLabel.position.x, comboLabel.position.y - 40)], 
						   [CCCallFuncND actionWithTarget:self selector:@selector(labelRemove: labelAtlas:) data:(void*)comboLabel],nil]];
	
	[sprite runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccp(sprite.position.x, sprite.position.y - 40)],
					   [CCCallFuncND actionWithTarget:self selector:@selector(comboSpriteRemove: sprite:) data:(void*)sprite],nil]];
	
	[combo release];
}


-(void)dealloc
{
	//[self BubbleClear];
		/*
	NSLog(@"인터페이스 해제 1");

	[MaxPangLabel release];
	[NowStageLabel release];
	
	[scoreLabel release];
//	[W_sprite release];
	[W_Animate release];
	
	NSLog(@"인터페이스 해제 2");
	
	//[W_dangerSprite release];
	[W_dangerAnimate release];

	NSLog(@"인터페이스 해제 3");
	
	//[C_sprite release];
	[C_Animate release];
	
	NSLog(@"인터페이스 해제 4");
	
	[timeGageBar release];
	[timeGageBack release];
	
	NSLog(@"인터페이스 해제 5");
	
	[warnningGageBar release];
	[warnningGageBack release];
	[StageSprite release];
	
	NSLog(@"인터페이스 해제 6");
	
	[comboSprite release];
	
	[emitter release];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	
	NSLog(@"인터페이스 해제 7");
	*/
	
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}



@end
