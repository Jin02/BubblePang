//
//  BB_GameInterface.h
//  BubbleGame
//
//  Created by imac07 on 10. 03. 10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BB_Enum.h"


@class BB_PlayGame;

@interface BB_GameInterface : CCLayer// <UIAccelerometerDelegate>
{
	BB_PlayGame* Game;
	CGPoint	  ParticleGravity;
	
	NSInteger score;
	NSInteger warnning;
	NSInteger MaxPang;
	
	
	
	CCSprite *m_Shake;
	
	CCLabelTTF *MaxPangLabel;
	CCLabelTTF *NowStageLabel;
	CCLabelTTF *scoreLabel;
	
	// W = warnning
	// C = Clock
	
	CCSprite	*comboSprite;
	
	CCSprite *W_sprite;
	CCAnimate *W_Animate;
	
	CCSprite *W_dangerSprite;
	CCAnimate *W_dangerAnimate;
	
	CCSprite  *C_sprite;
	CCAnimate *C_Animate;
	
	CCSprite *timeGageBar;
	CCSprite *timeGageBack;
	
	CCSprite *warnningGageBar;
	CCSprite *warnningGageBack;
	
	CCSprite *StageSprite;
		
	BOOL normalDanger;
	BOOL touchLimit;
	
	CCParticleSystem *emitter;
	
	BOOL comboAniMation;
}

@property(nonatomic, readwrite) NSInteger MaxPang;
@property(nonatomic, readwrite) NSInteger warnning;
@property(nonatomic, retain)	CCSprite *StageSprite;
@property(nonatomic, retain)	CCLabelTTF* scoreLabel;
@property(nonatomic, retain)	CCSprite *W_sprite;
@property(nonatomic, retain)	CCAnimate *W_Animate;
@property(nonatomic, retain)	CCAnimate *W_dangerAnimate;
@property(nonatomic, retain)	CCSprite *W_dangerSprite;
@property(nonatomic, retain)	CCSprite  *C_sprite;
@property(nonatomic, retain)	CCAnimate *C_Animate;
@property(nonatomic, retain)	CCSprite *timeGageBar;
@property(nonatomic, retain)	CCSprite *timeGageBack;
@property(nonatomic, retain)	CCSprite *warnningGageBar;
@property(nonatomic, retain)	CCSprite *warnningGageBack;
@property(nonatomic, retain)	CCParticleSystem *emitter;
@property(nonatomic, retain)	CCSprite *comboSprite;
@property(nonatomic, retain)	CCMenuItem *ClearButton;
@property(nonatomic, readwrite)	CGPoint	  ParticleGravity;

-(void)NextStage;
-(void)createWarnningAnimation;
-(void)W_GageBarSet:(int)Risk;
-(void)go_wAni;
-(void)createLabel;
-(void)end_wAni;
-(void)go_wDangerAni;
-(void)CharWarnning;
-(void)end_wDangerAni;
-(void)createClockAnimation;
-(void)createSprite;
-(void)timeGageBarSet:(int)TimeValue;
-(void)GridRelease;
-(void)shakeStartMotion;
-(void)liquidStartMotion;
-(void)FlipX3DStartMotion;
-(void)FlipX3DStopMotion;
-(BOOL)GetTouchLim;
-(void)bubbleParticlePos:(CGPoint)point;
-(void)bubbleStopParticle;
-(void)particleGalaxyStartPos:(CGPoint)point;
-(void)particleGalaxyStop;
-(void)comboAnimation:(CGPoint)point;
//-(void)comboSpriteRemove;
-(void)InterfaceDataClear;
-(id) initWithGameScene:(BB_PlayGame*)scene;
-(void)WarnningPointDisplay:(int)Value;
-(void)ScoreDisPlay:(int)Value;
-(NSInteger)getScore;
-(void)InterfaceMessage;
-(void)go_cClockAni;
-(void)end_cClockAni;
-(void)liquidStartMotion;
//-(void)liquidStopMotion;
-(void)StageClearEffect;
-(void)NowStageDisplay;
-(void)MaxPangDisplay;

@end
