#import "cocos2d.h"
#import "chipmunk.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#import "BB_Definision.h"

#define BubblePoint 1

@class BB_GameInterface;

int tmp_Score;
int TotalBubblepop;
float TotalPlayGameTime;

struct BB_SpriteData {
	cpShape *cpShapeSave[150];
	unsigned int ArrayCount;
};

@interface BB_PlayGame : CCLayer
{
	cpSpace				*space;					 //물리공간 설정
	CGSize				wins;					 //사이즈
	NSDate				*touchBeginTime;			 //터치한 시간
	struct BB_SpriteData SpriteData; //shape 데이터

	CCSprite			*touchBubble;			// 터지한 방울기억
	BB_GameInterface	*interface;				// 게임의 인터폐이스
	
	NSInteger			Stage;
	
	CGPoint				beganTouchBubblePos;    //터치한 포인트
	CCSprite			*backGround;			//배경
	
	BOOL				Playing;
	BOOL				Needle;					//방울을 찔렀나
	BOOL				TimeCheck;				//시간체크
	BOOL				SummonCheck;
	float				playTime;				//총 플레이 시간
	
	NSDate				*comboTime;				// 콤보체크
	NSInteger			count;					// 뭐더라? 콤보 갯수였나?
	
	BOOL				GravityItem;
	
//	NSMutableArray		*RemoveData;			//공이 지워질때마다 이곳에 스프라이트 객체들이 들어가고
												//일정갯수가되면 객체를 청소시켜준다.
}

@property (nonatomic, retain) NSDate *touchBeginTime;
@property (nonatomic, retain) CCSprite *touchBubble;
@property (nonatomic, retain) BB_GameInterface *interface;
@property (nonatomic, retain) CCSprite *backGround;
@property (nonatomic, retain) NSDate	  *comboTime;


-(void)PT;
-(void) addBubbleX: (float)x y:(float)y bubbleTag:(int)value;
-(id) init;
-(void)BubbleSummon;
-(void)BubbleRemove:(CCSprite*)RemoveSprite;
-(void)BubbleUnionTag:(int)Tag point:(CGPoint)point;
-(void)BubbleTagDisplayPoint:(int)Tag;

-(void)BubbleClear;

//따로 뺄 생각을 하자
-(BOOL)CircleCrashCheck_X:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2 r:(float)r;
//인터폐이스도 따로 뺼 생각하고 -> 버튼이나 점수판 이런거 ㅇㅇ...

-(void)initShape;
-(void)ItemBubbleEvent:(CGPoint)point;
-(void)SpriteDataShapeSoft_Index:(unsigned int)index;
-(void)DifferentBubbleTagEvent:(CCSprite*)TouchedSprite BeganTouchSprite:(CCSprite*)BeganTouchSprite point:(CGPoint)point;
-(void)onEnter;
-(void)onExit;
-(void) step: (ccTime) delta;
//-(void)BubbleUnionTag:(int)Tag;
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesCancelles:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;
-(void)comboSystem:(CGPoint)point;
-(NSInteger)GetCombo;
-(NSInteger)GetStage;
-(cpSpace*)GetSpace;
-(void)isClearStage;

/* 아이템 */
//나중에 시간 좀 남으면 따로빼서 관리 하든가 해야할듯 싶은데 시간이 1주밖에 없잖아 ㅋ?
//-(void)GravityReverse;
//-(void)GravityNormal;

-(void)TimeStop;
-(void)TimeReStart;

-(void)GameOverScene;

@end
