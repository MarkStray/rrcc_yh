//
//  ZZNetRequest.m
//  rrcc_yh
//
//  Created by user on 15/10/23.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "ZZNetRequest.h"

@interface ZZNetRequest () <NSURLConnectionDataDelegate>
{
    //专门存放 数据
    NSMutableData *_downloadData;
    
    void (^_completeCB) (CGSize size);
    
    CGSize _pngImageSize;
    CGSize _jpgImageSize;
    CGSize _gifImageSize;

}

@end

@implementation ZZNetRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _downloadData = [NSMutableData data];
    }
    return self;
}

#pragma mark - 获取图像size
/*
 图片就是文件，文件就有文件头，一般的文件头里面都会有文件的一些常规信息，可能也包括图片的大小。
 所以，我在数据请求的时候，第一次请求文件头的数据或是更精确的话得到图片大小所对应的字段的数据，
 那么整个包可能只需要很少的字节就能得到图片的大小，有了图片得大小，我们就能设置预览区域的大小
 
 还有一个问题，图片有很多种格式，所以文件头肯定是不一样的，没办法这里我是根据URL请求的后缀名进行区分的
 
 分析典型的三种图片格式:  png  jpg  gif
 */

/* 
 png的分析，png格式图片大小的字段是在16-23，所以请求的时候只需要请求8字节即可（是不是很小）
 */

- (void)downloadPngImageWithUrlString:(NSString *)urlStr complete:(void (^) (CGSize size))completeCB {
    
    _completeCB = completeCB;
    
    NSString *URLString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

- (CGSize)pngImageSizeWithHeaderData:(NSData *)data {
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    return CGSizeMake(w, h);
}

/*
 jpg格式比较复杂所以先得了解清楚具体个字段的意思
 
 因为图片大小所在的字段区域不确定，所以我们要扩大请求范围
 
 这里209字节里面应该就已经包含全了所有的数据（这里我查了一些资料，也看了几个不同jpg的文件头16进制信息）
 
 不一定就完全正确，但是分析微博的jpg图片大小暂时没有什么问题
 */

- (void)downloadJpgImageWithUrlString:(NSString *)urlStr complete:(void (^) (CGSize size))completeCB {
    _completeCB = completeCB;
    NSString *URLString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

- (CGSize)jpgImageSizeWithHeaderData:(NSData *)data {
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

/*
 gif的分析和png差不多，不过这里得到得应该是第一张图片的大小
 */

- (void)downloadGifImageWithUrlString:(NSString *)urlStr complete:(void (^) (CGSize size))completeCB {
    _completeCB = completeCB;
    NSString *URLString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
}

- (CGSize)gifImageSizeWithHeaderData:(NSData *)data {
    short w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    short w = w1 + (w2 << 8);
    short h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(2, 1)];
    [data getBytes:&h2 range:NSMakeRange(3, 1)];
    short h = h1 + (h2 << 8);
    return CGSizeMake(w, h);
}

#pragma mark - 协议的方法

//客户端 接受响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"1.接受数据");
    [_downloadData setLength:0];//清空原来的数据
}
//客户端 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"2.正在下载");
    [_downloadData appendData:data];
}
//下载完成 服务器发送数据完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"3.下载完成");
    _jpgImageSize = [self jpgImageSizeWithHeaderData:_downloadData];
    _pngImageSize = [self pngImageSizeWithHeaderData:_downloadData];
    _gifImageSize = [self gifImageSizeWithHeaderData:_downloadData];
    NSLog(@"%@",NSStringFromCGSize(_jpgImageSize));
    if (_completeCB) _completeCB(_jpgImageSize);
}

//下载异常
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"-.网络有异常");
}






@end
