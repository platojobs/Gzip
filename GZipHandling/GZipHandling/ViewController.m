//
//  ViewController.m
//  GZipHandling
//
//  Created by mac on 2017/11/21.
//  Copyright © 2017年 ChengMengKeJi. All rights reserved.
//

#import "ViewController.h"
#import "GzipUtil.h"
@interface ViewController ()
@property(nonatomic,copy) NSString*toBecompressedObj;
@property(nonatomic,copy) NSData*gzipData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //转为gzip数据
    NSData * gZip = [GzipUtil compressData:[_toBecompressedObj dataUsingEncoding:NSUTF8StringEncoding]];
    //解压缩
    NSData*unGzip=[GzipUtil decompressData:_gzipData];
    
    //下一步进行相关的数据解析操作
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
