# Gzip
##  数据请求 GZip数据压缩和解压缩问题
### 主要使用了官方的libz.1.2.3.dylib库
#### I recently had to write a utility for compressing data in memory using the gzip format.
Thankfully, there’s a C library called zlib you can use to do the actual compression 
(and thankfully you can link to libz.dylib on the iPhone). Using the library is not trivial, 
however, so I had to spend a day reading the zlib headers/documentation and also searching 
for examples from other developers (one example shared by Robbie Hanson was particularly helpful).
While Robbie’s example is great,I wanted something a bit more robust and easier to “plug in” to 
any existing project. As part of making it “plug ‘n play,”I also wanted to make it developer-friendly:
if something goes wrong,the utility should be helpful in solving the problem instead of just exiting 
with a cryptic error code.That means adding a healthy amount of documentation and descriptive error message logging 
so that like me Developer–who just wanted to copy and paste the utility into his project and move on–can quickly 
understand the code and the error message if problems come up.

#### 整体客户端-服务端数据压缩解压流程：（
客户端生成request,设置header允许使用压缩("Accept-Encoding","gzip")，
即是告诉服务器，客户端支持压缩，但凡可以实现压缩的，服务器当收到这个header，
如果它支持压缩，可以通过压缩方式输出数据，然后再写入response的header("Content-Encoding","gzip")

|Author|cuishengxi|
|---|---
|E-mail|1300000608@qq.com

[新浪博客](http://blog.sina.com.cn/cuishengxisvip)
============================

主要代码：
```objective-c
使用时#import "GzipUtil.h"

// 数据压缩

+ (NSData *)compressData:(NSData*)uncompressedData;

// 数据解压缩

+ (NSData *)decompressData:(NSData *)compressedData;


```
