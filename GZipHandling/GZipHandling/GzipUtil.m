//
//  GzipUtil.m
//  GZipHandling
//
//  Created by mac on 2017/11/21.
//  Copyright © 2017年 ChengMengKeJi. All rights reserved.
//

#import "GzipUtil.h"
#import "zlib.h"
@implementation GzipUtil

+(NSData*) compressData: (NSData*)uncompressedData  {
    
    if (!uncompressedData || [uncompressedData length] == 0)  {
        
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        
        return nil;
           }
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in  =(uInt) [uncompressedData length];
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
    if (initError != Z_OK)
    {
         NSString *errorMsg = nil;
        
        switch (initError)
        
        {
                
            case Z_STREAM_ERROR:
                
                errorMsg = @"Invalid parameter passed in to function.";
                
                break;
                
            case Z_MEM_ERROR:
                
                errorMsg = @"Insufficient memory.";
                
                break;
                
            case Z_VERSION_ERROR:
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                
                break;
                
            default:
                
                errorMsg = @"Unknown error code.";
                
                break;
                
        }
        
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        return nil;
        
    }
    NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    int deflateStatus;
    do
    {
        
        // Store location where next byte should be put in next_out
        
        zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        zlibStreamStruct.avail_out =(uInt) ([compressedData length] - zlibStreamStruct.total_out);
        
        deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
               
        
    } while ( deflateStatus == Z_OK );
    
    
    // Check for zlib error and convert code to usable error message if appropriate
    
    if (deflateStatus != Z_STREAM_END)
        
    {
        
        NSString *errorMsg = nil;
        
        switch (deflateStatus)
        
        {
                
            case Z_ERRNO:
                
                errorMsg = @"Error occured while reading file.";
                
                break;
                
            case Z_STREAM_ERROR:
                
                errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
                
                break;
                
            case Z_DATA_ERROR:
                
                errorMsg = @"The deflate data was invalid or incomplete.";
                
                break;
                
            case Z_MEM_ERROR:
                
                errorMsg = @"Memory could not be allocated for processing.";
                
                break;
                
            case Z_BUF_ERROR:
                
                errorMsg = @"Ran out of output buffer for writing compressed bytes.";
                
                break;
                
            case Z_VERSION_ERROR:
                
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                
                break;
                
            default:
                
                errorMsg = @"Unknown error code.";
                
                break;
                
        }
        
        NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
        
        
        
        
        // Free data structures that were dynamically created for the stream.
        
        deflateEnd(&zlibStreamStruct);
        
        
        
        return nil;
        
    }
    
    
    
    // Free data structures that were dynamically created for the stream.
    
    deflateEnd(&zlibStreamStruct);
    
    
    
    [compressedData setLength: zlibStreamStruct.total_out];
    
    
    
    return compressedData;
    
}


+ (NSData *)decompressData:(NSData *)compressedData {
    
    z_stream zStream;
    
    zStream.zalloc = Z_NULL;
    zStream.zfree = Z_NULL;
    zStream.opaque = Z_NULL;
    zStream.avail_in = 0;
    zStream.next_in = 0;
    int status = inflateInit2(&zStream, (15+32));
    
    if (status != Z_OK) {
        return nil;
    }
    
    Bytef *bytes = (Bytef *)[compressedData bytes];
    NSUInteger length = [compressedData length];
    NSUInteger halfLength = length/2;
    NSMutableData *uncompressedData = [NSMutableData dataWithLength:length+halfLength];
    zStream.next_in = bytes;
    zStream.avail_in = (unsigned int)length;
    zStream.avail_out = 0;
    NSInteger bytesProcessedAlready = zStream.total_out;
    
    while (zStream.avail_in != 0) {
           if (zStream.total_out - bytesProcessedAlready >= [uncompressedData length]) {
            
            [uncompressedData increaseLengthBy:halfLength];
            
        }
        zStream.next_out = (Bytef*)[uncompressedData mutableBytes] + zStream.total_out-bytesProcessedAlready;
        zStream.avail_out = (unsigned int)([uncompressedData length] - (zStream.total_out-bytesProcessedAlready));
        status = inflate(&zStream, Z_NO_FLUSH);
        
        if (status == Z_STREAM_END) {
            break;
            
        } else if (status != Z_OK) {
            return nil;
        }
    }
    status = inflateEnd(&zStream);
    if (status != Z_OK) {
        return nil;
    }
    
    [uncompressedData setLength: zStream.total_out-bytesProcessedAlready];  // Set real length
    
    return uncompressedData;
    
}


@end
