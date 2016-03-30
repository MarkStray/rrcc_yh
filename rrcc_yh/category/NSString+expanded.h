//
//  StringRef.h
//  beta1
//
typedef enum {
    imageSmallType,
    imageMiddlType,
    imageBigType,
}imageType;

#import <Foundation/Foundation.h>

@interface NSString(expanded) 

-(NSString*)replaceControlString;

-(NSString*)imagePathType:(imageType)__type;


- (CGFloat)getHeightByWidth:(NSInteger)_width font:(UIFont *)_font;
//- (NSString *)indentString:(NSString*)_string font:(UIFont *)_font;
- (NSString *)indentLength:(CGFloat)_len font:(UIFont *)_font;
- (BOOL)notEmptyOrNull;
+ (NSString *)replaceEmptyOrNull:(NSString *)checkString;
-(NSString*)replaceTime;
-(NSString*)replaceStoreKey;
- (NSString*)soapMessage:(NSString *)key,...;

//md5 encode
- (NSString *)md5;
//sha1 encode
- (NSString*) sha1;

@end
