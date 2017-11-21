//
//  GzipUtil.h
//  GZipHandling
//
//  Created by mac on 2017/11/21.
//  Copyright © 2017年 ChengMengKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GzipUtil : NSObject
// 数据压缩

+ (NSData *)compressData:(NSData*)uncompressedData;

// 数据解压缩

+ (NSData *)decompressData:(NSData *)compressedData; 
@end
