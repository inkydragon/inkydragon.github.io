---
title: WordPress漏洞环境搭建与测试——REST API 内容注入漏洞
date: 2017-02-10 23:31:16
tags:
- WordPress
- Python
- PoC
---
研究了下翻译文章投稿的可能性，关注了一堆 [RSS](http://digg.com/user/49eababd06ea463b8d564225d876621e/diggs.rss),在 paper.seebug 上看见这篇 [WordPress REST API 内容注入漏洞分析](http://paper.seebug.org/208/) ，刚好又有几个新搭的 WordPress 站可以测试，于是趁机熟悉下Python、学一学POC的编写。

<!-- truncate -->
### PoC规范
【Seebug】[远程 PoC 开发文档](https://www.seebug.org/help/dev)          
【Github】[PoC 编写规范及要求说明](https://github.com/knownsec/Pocsuite/blob/master/docs/CODING.md)
 [Pocsuite 框架使用方法](https://github.com/knownsec/Pocsuite/blob/dev/docs/translations/USAGE-zh.md)


### Bug 参考
【Seebug】[WordPress REST API 内容注入漏洞](https://www.seebug.org/vuldb/ssvid-92637)       
【Paper.Seebug】[WordPress REST API 内容注入漏洞分析](http://paper.seebug.org/208/)

Bug原始出处：        
【EN-sucuri-blog】[Content Injection Vulnerability in WordPress](https://blog.sucuri.net/2017/02/content-injection-vulnerability-wordpress-rest-api.html)
> sucuri-blog 现已加入豪华午餐：[RSS订阅](http://digg.com/user/49eababd06ea463b8d564225d876621e/diggs.rss)

PoC：        
【EN-exploit-db】[WordPress 4.7.0/4.7.1 - Unauthenticated Content Injection (Python)](https://www.exploit-db.com/exploits/41223/)     
【EN-exploit-db】[WordPress 4.7.0/4.7.1 - Unauthenticated Content Injection (Ruby)](https://www.exploit-db.com/exploits/41224/)

修复/更新补丁：        
【EN-WordPress.org】[WordPress 4.7.2 Security Release](https://wordpress.org/news/2017/01/wordpress-4-7-2-security-release/)

### Bug详情



### Bug 利用
##### 垃圾exploit-db
Python 经典Unicode大坑，PoC并没有注意到这点，代码稍作修改
``` python
for post in posts:
    print(' - Post ID: {}, Title: {}, Url: {}'
          .format(post['id'],
                  post['title']['rendered'].encode('gbk'),
                  post['link'].encode('utf-8')))
```

其余均可正常运行
