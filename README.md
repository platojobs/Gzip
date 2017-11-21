# Gzip
数据请求 GZip数据压缩和解压缩问题

I recently had to write a utility for compressing data in memory using the gzip format.
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
