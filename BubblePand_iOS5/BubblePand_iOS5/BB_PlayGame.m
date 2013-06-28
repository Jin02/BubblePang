#import "BB_PlayGame.h"
#import "BB_Enum.h"
#import "BB_GameInterface.h"
#import "BB_ScoreScene.h"
#import "CCGrid.h"


#define SLIDE_TIME_IN_SECOND 0.2

static void eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		[sprite setPosition: body->p];
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

@implementation BB_PlayGame


@synthesize touchBeginTime;
@synthesize touchBubble;
@synthesize interface;
@synthesize backGround;
@synthesize comboTime;

-(void) addBubbleX: (float)x y:(float)y bubbleTag:(int)value
{	
	CGRect ImageRect;
	cpFloat m = 0;
	cpFloat r1 = 0;
	
	switch (value) {
		case kind_SmallOrangeBubble:
			ImageRect = CGRectMake(2, 2, 46, 46);
			m = 5.0f;
			r1 = 23.0f;
			[interface WarnningPointDisplay:1+BubblePoint];
			break;
			
		case kind_SmallGreenBubble:
			ImageRect = CGRectMake(101, 2, 46, 46);
			m = 8.0f;
			r1 = 23.0f;			
			[interface WarnningPointDisplay:2+BubblePoint];
			break;
			
		case kind_SmallYellowBubble:
			ImageRect = CGRectMake(51, 2, 46, 46);
			m = 15.0f;
			r1 = 23.0f;	
			[interface WarnningPointDisplay:1+BubblePoint];
			break;
			
		case kind_SmallSkyBlueBubble:
			ImageRect = CGRectMake(201, 2, 46, 46);
			m = 5.0f;
			r1 = 23.0f;
			[interface WarnningPointDisplay:2+BubblePoint];
			break;
			
		case kind_BigGreenBubble:
			ImageRect = CGRectMake(145, 52, 68, 68);
			m = 20.0f;
			r1 = 34.0f;
			[interface WarnningPointDisplay:4+BubblePoint];
			break;
			
		case kind_BigOrangeBubble:
			ImageRect = CGRectMake(2, 52, 68, 68);
			m = 20.0f;
			r1 = 34.0f;			
			[interface WarnningPointDisplay:2+BubblePoint];
			break;
			
		case kind_BigYellowBubble:
			ImageRect = CGRectMake(73, 52, 68, 68);
			m = 23.0f;
			r1 = 34.0f;			
			[interface WarnningPointDisplay:4+BubblePoint];
			break;
			
		case kind_BigSkyBlueBubble:
			ImageRect = CGRectMake(290, 52, 68, 68);
			m = 27.0f;
			r1 = 34.0f;
			[interface WarnningPointDisplay:5+BubblePoint];
			break;

		case kind_SmallBlackBubble:
			ImageRect = CGRectMake(151, 2, 46, 46);
			m = 10.0f;
			r1 = 23.0f;
			[interface WarnningPointDisplay:3+BubblePoint];
			break;
		
		case kind_BigBlackBubble:
			ImageRect = CGRectMake(217, 52, 68, 68);
			m = 10.0f;
			r1 = 34.0f;
			[interface WarnningPointDisplay:5+BubblePoint];
			break;
		
		case kind_ItemBombBubble:
			ImageRect = CGRectMake(2, 125, 56, 56);		
			break;

		case kind_ItemRandomBubble:
			ImageRect = CGRectMake(124, 125, 56, 56);		
			break;
		
		case kind_ItemNeedleBubble:
			ImageRect = CGRectMake(64, 125, 56, 56);
			break;
			
		case kind_ItemGravity:
			ImageRect = CGRectMake(256, 125, 57, 56);
			break;
			
		case kind_ItemTime:
			ImageRect = CGRectMake(190, 125, 56, 56);
			break;
	}
	
	
	//아이템의 크기와 질량은 같으니깐 이렇게 묶음
	if( kind_ItemBombBubble <= value && value <= kind_ItemTime )
	{	
		m  = 10.0f;
		r1 = 28.0f;
		[interface WarnningPointDisplay:2+BubblePoint];	
	}
	
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode*) [self getChildByTag:BB_SpriteSheet];
	
	NSLog(@"테스트 거품추가");
	
    CCSprite *sprite = [CCSprite spriteWithTexture:sheet.texture rect:ImageRect];
	[sheet addChild:sprite z:0 tag:value];
	
	sprite.position = ccp(x, y);
	[sprite setOpacity:200]; 
	
	cpBody *body = cpBodyNew(1.0f, cpMomentForCircle(m, r1, 0, cpvzero));
	
	body->p = ccp(x, y);
	cpSpaceAddBody(space, body);
	
	cpShape* shape = cpCircleShapeNew(body, r1, cpvzero);
	shape->e = 1.f;
	shape->u = 1.f;
	shape->data = sprite;
	cpSpaceAddShape(space, shape);
	
	SpriteData.cpShapeSave[SpriteData.ArrayCount++] = shape;
	[interface ScoreDisPlay:-1];

	if(value == kind_SmallBlackBubble || value == kind_BigBlackBubble)
		[interface ScoreDisPlay:-50];
}

-(id) init
{
	if( (self=[super init])) {
		
		NSLog(@"게임 시작 들어옴");
		
		//터치 사용 , 가속계 사용
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		Stage = 1;
		
		//화면 사이즈 구함
		wins = [[CCDirector sharedDirector] winSize];
		
		NSLog(@"게임 시작 들어옴1");
		
		//Chipmunk 초기화
		cpInitChipmunk();
		
		//쉐이프 초기화
		[self initShape];
		
		backGround = [CCSprite spriteWithFile:@"GameBG.png"];
		
		NSLog(@"게임 시작 들어옴2");
		
		backGround.anchorPoint = CGPointZero;
		backGround.position = ccp(0,0);
		
		[self addChild:backGround z:BB_backGround tag:BB_backGround];
		
		NSLog(@"게임 시작 들어옴3");
		
		//방울 이미지 파일을 sheet에서 넣음
		CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:@"Bubbles.png" capacity:150];
		[self addChild:sheet z:BB_SpriteSheet tag:BB_SpriteSheet];
		
		memset(&SpriteData,0,sizeof(SpriteData));
		
		self.touchBeginTime = [NSDate date];
		self.touchBubble = nil;
		
		//인터폐이스 생성
		BB_GameInterface* temp = [[BB_GameInterface alloc] initWithGameScene:self];
		self.interface = temp;
		[self addChild:interface z:BB_menu tag:BB_menu];
		[temp release];
		
		//RemoveData = [[NSMutableArray alloc] initWithCapacity:35];
		
		//[interface.emitter setGravity: ccp(0, 50)];
		
		//방울 아이템 쓰지않음, 플레이 시간 초기화
		Needle = NO;
		playTime = 0;
		count = 0;
		Playing = YES;
		
		TimeCheck = NO;
		[self schedule:@selector(step:)];
		[self schedule:@selector(PT) interval:0.25f];
		[self schedule:@selector(backGroundMusic) interval: 5.0f];
		[self schedule:@selector(summontest) interval:5.0f];
	}

	return self;
}

-(void)summontest
{
	[self BubbleSummon];

}

-(void)initShape
{
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
	space = cpSpaceNew();
	cpSpaceResizeStaticHash(space, 400.0f, 40); 
	cpSpaceResizeActiveHash(space, 100, 600);

	//정밀도와 중력 설정
	space->iterations = 1;
	space->gravity = ccp(0, 50);
	space->elasticIterations = space->iterations;
	
	cpShape *shape;
	
	//화면 사이즈만큼 공간을 잡아줌
#define InterfaceSizeH 60
	
	// bottom
	shape = cpSegmentShapeNew(staticBody, ccp(0,InterfaceSizeH), ccp(wins.width,+InterfaceSizeH), 0.0f);
	shape->e = .5f; shape->u = .5f;
	cpSpaceAddStaticShape(space, shape);
	
	// top
	shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height-InterfaceSizeH), ccp(wins.width,wins.height-InterfaceSizeH), 0.0f);
	shape->e = .5f; shape->u = .5f;
	cpSpaceAddStaticShape(space, shape);
	
	// left
	shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
	shape->e = .5f; shape->u = .5f;
	cpSpaceAddStaticShape(space, shape);
	
	// right
	shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
	shape->e = .5f; shape->u = .5f;
	cpSpaceAddStaticShape(space, shape);
	
}

-(void)BubbleSummon
{	
	int itemrandom = random()%100+1;
	
	//기본 방울 3개씩 뿌림
	for(int i = 0; i < 3; i++)
		[self addBubbleX:(float)(wins.width/2.0f)+random()%30 y:(float)(wins.height/2.0f)+random()%30 bubbleTag:random()%4];
	
	//아이템 랜덤 / 일반공과 함께 나옴
	if( itemrandom > 10 && itemrandom < 20 )
		[self addBubbleX:(float)(wins.width/2.0f)+random()%30 y:(float)(wins.height/2.0f)+random()%30 bubbleTag:kind_ItemRandomBubble];
	else if( itemrandom > 30 && itemrandom < 40 )
		[self addBubbleX:(float)(wins.width/2.0f)+random()%30 y:(float)(wins.height/2.0f)+random()%30 bubbleTag:kind_ItemGravity];
	
	//방울나올때 사운드효과
	[[SimpleAudioEngine sharedEngine] playEffect:@"BubbleSummon.wav"];
	[interface InterfaceMessage];
}

-(void)onEnter
{
	[super onEnter];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
	
}

-(void)backGroundMusic
{	[[SimpleAudioEngine sharedEngine] playEffect:@"Bogol.wav"];	 }

-(void) PT
{
	playTime+=(1+(Stage*0.1))/4;
	
	if(!TimeCheck)
	{
		if(playTime <= 5)
			return;
		else
		{
			TimeCheck = YES;
			playTime = 0;
		}
	}
	else
	{
		TotalPlayGameTime+=0.25;
		SummonCheck = NO;

		if(playTime < 0)
			playTime = 0;
		else if(playTime >= 100)
		[self GameOverScene];
		else
			[interface timeGageBarSet:playTime];
	}
}

-(void) step: (ccTime) delta
{
	int steps = 5;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
}

//Shape데이터 정리
-(void)SpriteDataShapeSoft_Index:(unsigned int)index
{
	for(unsigned int loop = index; loop < 150; loop++)
	{
		if( SpriteData.cpShapeSave[loop+1] != nil )
			SpriteData.cpShapeSave[loop] = SpriteData.cpShapeSave[loop+1];
	}
}

#pragma mark Touch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	
	//touch좌표를 받고 opengl형태로 좌표를 바꿈
	
	//누른 방울 초기화
	self.touchBubble = nil;
	beganTouchBubblePos = ccp(-100,-100);
	//초기화 끝

	//sheet에 BB_SpriteSheet에 있는 스프라이트를 담음
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode *)[self getChildByTag:BB_SpriteSheet];
	
	for(CCSprite *BubbleSprite in [sheet children])
	{
		//반지름을 구함
		CGFloat CircleRadius  = BubbleSprite.contentSize.width  / 2.0f;
		
		//충돌체크
		if( [self CircleCrashCheck_X:convertedLocation.x x2:BubbleSprite.position.x y1:convertedLocation.y y2:BubbleSprite.position.y r:CircleRadius] )
		{
			//아이템 사용했나 확인
			if(Needle)
			{
				[self BubbleRemove:BubbleSprite];
				[[SimpleAudioEngine sharedEngine] playEffect:@"Needle.wav"];
				Needle = NO;
			}
			else{
				//터치한 방울의 스프라이트와 좌표를 기억함
				self.touchBubble = BubbleSprite;
				beganTouchBubblePos = ccp(touchBubble.position.x, touchBubble.position.y);
				self.touchBeginTime = [NSDate date];
			}
			break;
		}
			
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	int twoPointDistance = (int)sqrt( pow( (double)convertedLocation.x - touchBubble.position.x, 2 )  + pow( (double)convertedLocation.y - touchBubble.position.y, 2) );
	
	if(twoPointDistance < 20)
		[self ItemBubbleEvent:convertedLocation];	
	
	touchBubble = nil;		
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(touchBubble != nil)
	{
		//좌표 변환
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
		
		//두점 사이 거리 구함
		int twoPointDistance = (int)sqrt( pow( (double)convertedLocation.x - touchBubble.position.x, 2 )  + pow( (double)convertedLocation.y - touchBubble.position.y, 2) );
		
		//다른 방울까지 닿았는지 확인함
		if(twoPointDistance <= 55 && twoPointDistance > 30)
		{
			NSTimeInterval elaspedTime = 0 - [self.touchBeginTime timeIntervalSinceNow];
			
			if(elaspedTime <= 2.5f)
			{
				CCSpriteBatchNode* sheet = (CCSpriteBatchNode*)[self getChildByTag:BB_SpriteSheet];
				
				for(CCSprite *BubbleSprite in [sheet children])
				{
					CGFloat CircleRadius  = BubbleSprite.contentSize.width  / 2.0f;
					
					if( [self CircleCrashCheck_X:convertedLocation.x x2:BubbleSprite.position.x y1:convertedLocation.y y2:BubbleSprite.position.y r:CircleRadius])
					{
						if( (touchBubble.tag >= kind_BigOrangeBubble) && (BubbleSprite.tag >= kind_BigOrangeBubble) )
							if( twoPointDistance < 50 )
								break;
						
						if(touchBubble.tag == BubbleSprite.tag)
						{
							
							CGPoint temp[2];
							
							temp[0] = CGPointMake(BubbleSprite.position.x, BubbleSprite.position.y);
							temp[1] = CGPointMake(touchBubble.position.x, touchBubble.position.y);
							
							[self BubbleRemove:BubbleSprite];
							[self BubbleRemove:touchBubble];
							//beganTouchBubblePos = ccp(-100,-100);
							
							[self BubbleUnionTag:touchBubble.tag point:ccp( ( temp[0].x + temp[1].x)/2.0f,
																		   ( temp[0].y + temp[1].y)/2.0f )];
							
							[interface bubbleParticlePos:ccp( ( temp[0].x + temp[1].x)/2.0f,
															 ( temp[0].y + temp[1].y)/2.0f )];
							
							[self comboSystem: ccp( ( temp[0].x + temp[1].x)/2.0f,
												   ( temp[0].y + temp[1].y)/2.0f )];
						}
						else
							[self DifferentBubbleTagEvent:BubbleSprite BeganTouchSprite:touchBubble point: convertedLocation];
						
						touchBubble = nil;
						[self isClearStage];
						[interface InterfaceMessage];						
						break;
					}
				}
			}
			
		}		
	}
}

-(void)ccTouchesCancelles:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark Touch

-(void)BubbleTagDisplayPoint:(int)Tag
{
	switch (Tag) {
		case kind_SmallOrangeBubble:
			[interface ScoreDisPlay:3];
			[interface WarnningPointDisplay:-1-BubblePoint];
			break;
			
		case kind_SmallGreenBubble:
			[interface ScoreDisPlay:8];
			[interface WarnningPointDisplay:-2-BubblePoint];
			break;
			
		case kind_SmallYellowBubble:
			[interface ScoreDisPlay:3];
			[interface WarnningPointDisplay:-1-BubblePoint];
			break;
			
		case kind_SmallSkyBlueBubble:
			[interface ScoreDisPlay:5];
			[interface WarnningPointDisplay:-2-BubblePoint];
			break;
			
		case kind_BigGreenBubble:
			[interface ScoreDisPlay:18];
			[interface WarnningPointDisplay:-4-BubblePoint];
			break;
			
		case kind_BigOrangeBubble:
			[interface ScoreDisPlay:15];
			[interface WarnningPointDisplay:-2-BubblePoint];
			break;
			
		case kind_BigYellowBubble:
			[interface ScoreDisPlay:35];
			[interface WarnningPointDisplay:-4-BubblePoint];
			break;
			
		case kind_BigSkyBlueBubble:
			[interface ScoreDisPlay:25];
			[interface WarnningPointDisplay:-5-BubblePoint];
			break;
			
		case kind_SmallBlackBubble:
			[interface WarnningPointDisplay:-3-BubblePoint];
			break;
			
		case kind_BigBlackBubble:
			[interface ScoreDisPlay:55];
			[interface WarnningPointDisplay:-5-BubblePoint];
			break;
	}
	
	if( kind_ItemBombBubble <= Tag && Tag <= kind_ItemTime )
	{		[interface WarnningPointDisplay:-2-BubblePoint];	}
	
}


-(void)BombParticleStop
{	[interface.emitter stopSystem];		}

-(void)GravityItemInit
{
	GravityItem = NO;
}

-(void)ItemBubbleEvent:(CGPoint)point
{
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode *)[self getChildByTag:BB_SpriteSheet];
	NSInteger	   randItem = 0;
	
	for(CCSprite *BubbleSprite in [sheet children])
	{	
		if( [self CircleCrashCheck_X:point.x x2:BubbleSprite.position.x y1:point.y y2:BubbleSprite.position.y r:25.0f] )
		{
			switch (BubbleSprite.tag)
			{
				case kind_ItemBombBubble:
					[self BubbleClear];
					[[SimpleAudioEngine sharedEngine] playEffect:@"Bomb.wav"];
					[interface StageClearEffect];
					[self performSelector:@selector(BombParticleStop) withObject:nil afterDelay:0.5];
					return;
					
				case kind_ItemGravity:
					[[SimpleAudioEngine sharedEngine] playEffect:@"Gravity.wav"];
					[self BubbleRemove:BubbleSprite];
					[interface particleGalaxyStartPos:point];
					GravityItem = YES;
					[self performSelector:@selector(GravityItemInit) withObject:nil afterDelay:5];
					return;
					
				case kind_ItemTime:
					[self TimeStop];
					[self BubbleRemove:BubbleSprite];
					[[SimpleAudioEngine sharedEngine] playEffect:@"Time.wav"];
					[interface particleGalaxyStartPos:point];
					return;

				case kind_ItemRandomBubble:
					[self BubbleRemove:BubbleSprite];
					
					randItem = random()%kind_ItemTime;
					
					if( !(random()%5) )
						randItem = kind_ItemTime;
					
					[self addBubbleX:point.x y:point.y bubbleTag:randItem];
					
//					[interface shakeStartMotion];
					[interface liquidStartMotion];
					[[SimpleAudioEngine sharedEngine] playEffect:@"Random.wav"];
					return;
					
				case kind_ItemNeedleBubble:
					Needle = YES;
					[self BubbleRemove:BubbleSprite];
					[[SimpleAudioEngine sharedEngine] playEffect:@"Needle.wav"];
					return;
			}
		}
	}
}

-(void)BubbleUnionTag:(int)Tag point:(CGPoint)point
{	
	if( Tag <= kind_SmallBlackBubble && Tag >= kind_SmallOrangeBubble )
	{
		[self addBubbleX:point.x y:point.y bubbleTag:Tag+5];
		[[SimpleAudioEngine sharedEngine] playEffect:@"Union.wav"];
		playTime--;
	}
	else
	{
		[self addBubbleX:point.x y:point.y bubbleTag:Tag-5];
		[[SimpleAudioEngine sharedEngine] playEffect:@"Big union.wav"];
		playTime-=5;
	}
}

-(void)DifferentBubbleTagEvent:(CCSprite*)TouchedSprite BeganTouchSprite:(CCSprite*)BeganTouchSprite point:(CGPoint)point
{
	
	if(TouchedSprite.tag < kind_BigOrangeBubble && BeganTouchSprite.tag < kind_BigOrangeBubble)
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"BlackBubble.wav"];
		[self addBubbleX:160 y:240 bubbleTag:kind_SmallBlackBubble];
		count = -1;
		playTime+=2;
		[interface ScoreDisPlay:-20];
		return;
	}
	
	if( !((TouchedSprite.tag + 5 == BeganTouchSprite.tag) ||(TouchedSprite.tag == BeganTouchSprite.tag+5)) )
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"BlackBubble.wav"];
		[self addBubbleX:160 y:240 bubbleTag:kind_SmallBlackBubble];
		[interface ScoreDisPlay:-40];
		count = -1;
		playTime += 5;
		return;
	}
	else
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"Union.wav"];
		[interface ScoreDisPlay:60];
		playTime -= 4;
		[self comboSystem:ccp( (point.x + beganTouchBubblePos.x)/2.0f,
							  (point.y + beganTouchBubblePos.y)/2.0f )];
	}
	
	[self BubbleRemove:TouchedSprite];
	[self BubbleRemove:BeganTouchSprite];
	
	[interface bubbleParticlePos:ccp( (point.x + beganTouchBubblePos.x)/2.0f,
									 (point.y + beganTouchBubblePos.y)/2.0f )];
}

-(void)BubbleSpriteRemove:(NSInteger)Num
{	
	NSInteger Tag;
	
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode *)[self getChildByTag:BB_SpriteSheet];
	cpShape* tempShape;
	
	tempShape = SpriteData.cpShapeSave[Num];
	CCSprite* Remove = tempShape->data;
	Tag = Remove.tag;
	[sheet removeChild:Remove cleanup:YES];
	
	cpBodyFree(tempShape->body);
	cpShapeFree(tempShape);
	cpSpaceRemoveBody(space, tempShape->body);
	cpSpaceRemoveShape(space, tempShape);
	
	[self SpriteDataShapeSoft_Index:Num];
	SpriteData.ArrayCount--;	TotalBubblepop++;
	
	[self BubbleTagDisplayPoint:Tag];
}

-(void)BubbleRemove:(CCSprite*)RemoveSprite
{
	for(int loop = 0; loop < SpriteData.ArrayCount; loop++)
	{
		if( RemoveSprite == SpriteData.cpShapeSave[loop]->data )
		{
			[self BubbleSpriteRemove:loop];
			break;			
		}
	}
	
	RemoveSprite = nil;
}

-(BOOL)CircleCrashCheck_X:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2 r:(float)r
{
	if( !(x1 > (x2 + r) ||  x1 < (x2 - r) || y1 > (y2 + r) || y1 < (y2 - r)) )
		return YES;
	
	return NO;
}

-(NSInteger)GetCombo
{
	return count;
}

-(cpSpace*)GetSpace
{	return space;	}

-(void)TimeStop
{
	[self unschedule:@selector(PT)];
	[self performSelector:@selector(TimeReStart) withObject:nil afterDelay:(5.0) ];
}

-(void)TimeReStart
{	[self schedule:@selector(PT) interval : 0.25f];	}

-(void)comboSystem:(CGPoint)point
{
	if( count == 0)
	{
		count++;
		self.comboTime = [NSDate date];
		return;
	}
	
	if( (-[self.comboTime  timeIntervalSinceNow] <= 2.0f) )
	{
		count++;
		
		if(interface.MaxPang < count)
			interface.MaxPang = count;
		
		[interface comboAnimation:point];
		self.comboTime = [NSDate date];
		
		[interface MaxPangDisplay];
	}
	else
		count = 0;

	
	
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	if(!TimeCheck) return;
	
	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	int GrvityValue = 100;
	
	if(GravityItem)
		GrvityValue = -800;
	
	space->gravity = ccpMult(v, -GrvityValue);
	//interface.ParticleGravity = ccpMult(v, GrvityValue/2);
	
	if((fabsf(acceleration.x) > 1.7 || fabsf(acceleration.y) > 1.7 || fabsf(acceleration.z) > 1.7)  && !SummonCheck)
	{
		NSLog(@"흔들림");
		[self BubbleSummon];
		SummonCheck = YES;
	}
}

-(void)isClearStage
{	
	if( [interface getScore] >= (Stage*1500)+((Stage-1) * 500) )
	{
		playTime = 0;
		[interface InterfaceDataClear];
		[self BubbleClear];
		Stage++;
		TimeCheck = NO;
		
		[interface bubbleStopParticle];
		[interface NextStage];
		[interface StageClearEffect];
		[[SimpleAudioEngine sharedEngine] playEffect:@"Clear.wav"];
	}
}

-(void)BubbleClear
{
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode*)[self getChildByTag:BB_SpriteSheet];
	[sheet removeAllChildrenWithCleanup:NO];
		
	for( int i = 0; i < SpriteData.ArrayCount; i++)
	{
		cpSpaceRemoveBody(space, SpriteData.cpShapeSave[i]->body);
		cpSpaceRemoveShape(space, SpriteData.cpShapeSave[i]);
		SpriteData.cpShapeSave[i] = nil;
	}	
	SpriteData.ArrayCount = 0;

	interface.warnning = 0;
	[interface WarnningPointDisplay:0];
}

-(NSInteger)GetStage
{
	return Stage;
}

-(void)NextScene
{
	[[CCDirector sharedDirector] popScene];
	BB_ScoreScene *NextScene = [BB_ScoreScene node];
	[[CCDirector sharedDirector] pushScene:(CCScene*)NextScene];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];	
}

-(void)GameOverScene
{
	if(!Playing)
		return;
	
	Playing = NO;
	[self unschedule:@selector(step)];
	[self unschedule:@selector(PT)];
	[self unschedule:@selector(backGroundMusic)];
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"Timeover.wav"];
	
	id JumpTiles3D = [CCJumpTiles3D actionWithJumps:2 amplitude:3 grid:ccg(15,10) duration:3];
	[self runAction:JumpTiles3D];
	
	tmp_Score = [interface getScore];
	[self performSelector:@selector(NextScene) withObject:nil afterDelay:(3) ];	
}

-(void)onExit
{
	[super onExit];
}

#pragma mark Memory Release

-(void)dealloc
{
	NSLog(@"해제 0");
	
	[self unschedule:@selector(step)];
	[self unschedule:@selector(PT)];
	
	NSLog(@"해제 1");
	
/*	[touchBeginTime release];
	touchBubble = nil;
	[touchBubble release];
	touchBubble = nil;
	[interface release];
	interface = nil;
	[comboTime release];
	comboTime = nil;
*/
	NSLog(@"해제 3");
	
	cpSpaceFreeChildren(space);
	cpSpaceFree(space);
	
	space = nil;
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	

	[self removeAllChildrenWithCleanup:YES];
	
	NSLog(@"해제 4");
	[super dealloc];
	NSLog(@"해제 5");
}


@end
