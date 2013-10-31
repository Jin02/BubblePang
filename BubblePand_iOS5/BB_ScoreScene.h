//
//  BB_ScoreScene.h
//  BubbleGame
//
//  Created by imac07 on 10. 03. 10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "RankingData.h"


@interface BB_ScoreScene : CCLayer <UITextFieldDelegate> {

	UITextField* nameField;
	
	CCLabelTTF *gameScore;
	CCLabelTTF *gameTotalPlayTime;
	CCLabelTTF *gameRemoveBubble;
	
	CCMenuItem *ButtonOK;
	CCMenuItem *ButtonNO;
	CCMenuItem *ClearData;
	
	RankingData *data;
	
	NSInteger rScore;
	NSInteger rTime;
	NSInteger rPop;
}

@property(nonatomic, retain)   RankingData *data;
@property(nonatomic, readonly) NSInteger rScore;
@property(nonatomic, readonly) NSInteger rTime;
@property(nonatomic, readonly) NSInteger rPop;

@property(nonatomic, retain)	CCMenuItem *ButtonOK;
@property(nonatomic, retain)	CCMenuItem *ButtonNO;
@property(nonatomic, retain)	CCMenuItem *ClearData;

@property(nonatomic, retain)	CCLabelTTF *gameTotalPlayTime;
@property(nonatomic, retain)	CCLabelTTF *gameRemoveBubble;
@property(nonatomic, retain)	CCLabelTTF *gameScore;

@property(nonatomic, retain)	UITextField* nameField;

-(void)GameResultPrint;
-(void)textFieldRemove;
-(void)ButtonActionOK:(id)sender;
-(void)ButtonActionNO:(id)sender;
-(void)MessageBox:(NSString*)context;
-(void)GotoMenu;
-(void)dealloc;

@end
