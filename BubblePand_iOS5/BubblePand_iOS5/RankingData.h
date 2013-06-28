//
//  RankingData.h
//  WishBubble
//
//  Created by imac07 on 10. 03. 15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RankingData : NSObject {
	
}

-(BOOL)RankingDataSave_Name:(NSString *)name playerscore:(NSInteger)playerscore playTime:(NSInteger)playTime pop:(NSInteger)pop;
-(NSMutableArray*)RankingDataLoad;
-(void)dataClear;

@end
