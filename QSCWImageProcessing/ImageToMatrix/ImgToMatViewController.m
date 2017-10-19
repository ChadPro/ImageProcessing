//
//  ImgToMatViewController.m
//  QSCWImageProcessing
//
//  Created by candela on 2017/10/19.
//  Copyright © 2017年 Qscw. All rights reserved.
//

#import "ImgToMatViewController.h"

@interface ImgToMatViewController ()

@end

@implementation ImgToMatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self create];
}

//由图形创造相应需求的点阵
- (void)create{
    
    /** ss用于缓存我们得到的点阵
     ** 数组ss[] : 2个字节*16 = 16*16点阵
     ** [16*52] : 52个字母，前26个为大写，后26个为小写
     ** [16*10] : 十个数字
     **/
    unsigned short ss[16*10];
    
    for(int allCount=0;allCount<16*52;allCount++){  //缓存数组清零
        ss[allCount] = 0x00;
    }
    
    //位操作key
    unsigned short key[16] = {
        0x8000,0x4000,0x2000,0x1000,0x0800,0x0400,0x0200,0x0100,0x0080, 0x0040, 0x0020, 0x0010, 0x0008, 0x0004, 0x0002, 0x0001
    };
    
    //循环赋值->ss[]数组
    for(int count=0;count<10;count++){
        UILabel *testLabel_a = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, [UIScreen mainScreen].bounds.size.height/2-40, 140, 140)];
        
        /**52个英文字符-大小写 count<52**/
//        char word = 0;
//        if(count<26){
//            word = 65 + count;
//        }else{
//            word = 97 + count - 26;
//        }
//        testLabel_a.text = [NSString stringWithFormat:@"%c",word];
        
        /**10个数字 count<10**/
        testLabel_a.text = [NSString stringWithFormat:@"%d", count];
        
        testLabel_a.backgroundColor = [UIColor blackColor];
        testLabel_a.textColor = [UIColor whiteColor];
        testLabel_a.font = [UIFont boldSystemFontOfSize:140];
        testLabel_a.textAlignment = NSTextAlignmentCenter;
        
        UIGraphicsBeginImageContext(testLabel_a.bounds.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [testLabel_a.layer renderInContext:ctx];
        UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        for(int x=0;x<15;x++){
            for(int y=0;y<15;y++){
                UIColor *pointColor = [self getRGBAsFromImage:tImage atX:(10*y) andY:(10*x) count:1].firstObject;
                
                CGFloat R,G,B,A;
                CGColorRef colorRef = [pointColor CGColor];
                unsigned long numComponents = CGColorGetNumberOfComponents(colorRef);
                if(numComponents == 4){
                    const CGFloat *components = CGColorGetComponents(colorRef);
                    R = components[0];
                    G = components[1];
                    B = components[2];
                    A = components[3];
                    
                    if((R>200)&(G>200)&(B>200)&(A>0)){
                        ss[x+16*count] = ss[x+16*count] | key[y];
                    }else{
                    }
                }
            }
        }
    }
    
    //文件路径
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *fileName = @"QSNumMatric16_16.txt";
    tmpPath = [tmpPath stringByAppendingPathComponent:fileName];   //这个方法会监测是否用加'/',用来合成path
    
    /**创建文件、保存文件**/
//     NSFileManager *fileManager = [NSFileManager defaultManager];
//     if(![fileManager fileExistsAtPath:tmpPath]){     //判断下文件是否已经存在
//     BOOL flag = [fileManager createFileAtPath:tmpPath contents:nil attributes:nil];
//     if(flag){
//     NSLog(@"文件创建成功");
//     }else{
//     NSLog(@"文件创建失败");
//     }
//     }
//
//     NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:tmpPath];  //根据路径初始化handle
//
//     NSData *writeData = [NSData dataWithBytes:ss length:2*16*10];
//
//     [fileHandle writeData:writeData];   //写数据
//
//     [fileHandle closeFile];    //用完之后一定要关闭文件
    
    
    /**测试保存的文件，输出点阵是否符合要求**/
    NSFileHandle *fileHandle2 = [NSFileHandle fileHandleForReadingAtPath:tmpPath];;

    NSData * data3 = [fileHandle2 readDataOfLength:16*52*2];  //读取指定长度的文件

    const void *sssss = [data3 bytes];
    unsigned short bufferr[16*10];

    memmove(bufferr, sssss, 2*16*10);

    for(int count=0;count<10;count++){
        for(int xx=0;xx<15;xx++){
            for(int yy=0;yy<15;yy++){
                (bufferr[xx+count*16] & key[yy])?printf("@"):printf(" ");
            }
            printf("\n");
        }
    }

    NSLog(@"file output_path : %@", tmpPath);
    [fileHandle2 closeFile];
}

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    //    CGContextRelease(context);
    return result;
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
