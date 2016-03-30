


#import <Foundation/Foundation.h>
@class RecommendView;
@class AudioPlayer;
@class HomePageView;
@class VegetableListView;

@interface Global : NSObject {
    
}

@property (nonatomic,weak) HomePageView *homeView;

@property (nonatomic,assign) SEL backSet;
//车载模式 mic关
@property (nonatomic,assign) BOOL isMicOpen;

@property (nonatomic,copy) NSString *recordId;
@property (nonatomic,assign) BOOL isMusicPlaying;

//缓存 礼物
@property (nonatomic,retain) NSMutableArray *giftTitleArr;
@property (atomic,retain) NSMutableArray *giftOptionArr;
@property (nonatomic,assign) BOOL isSendGiftReady;

@property (nonatomic,copy) NSString *topListCode;

@property (nonatomic,weak) VegetableListView *vgView;
@property (nonatomic,assign) BOOL isReceiveMemroryWarning;

+(Global *)shareGlobal;

-(void)disponse;


-(NSString *)getDownloadChannel;



@end
