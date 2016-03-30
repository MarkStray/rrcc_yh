

#import "Global.h"


@implementation Global

+(Global *)shareGlobal{
    static Global *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[Global alloc] init];
        }
    }
    return instance;
}


-(id)init{
    if (self = [super init]) {
    }
    return self;
}



-(NSString *)getDownloadChannel
{
    //IOS：91IOS、快用、APPstore、官网IOS
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = infoDictionary[@"CFBundleIdentifier"];
    if (bundleIdentifier)
    {
        if ([bundleIdentifier isEqualToString:@"com.huuhoo.MyStyle8"]) {
            return @"APPstore";
        }
    }
    return @"官网IOS";
}



-(void)disponse{
}
@end
