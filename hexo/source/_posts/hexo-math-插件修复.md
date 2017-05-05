---
title: hexo-math 插件修复
date: 2017-04-30 11:49:38
categories:
tags:
  - hexo
description:
  想增加一下LaTeX的支持，但是hexo-math插件被弃坑了，只好自己动手、丰衣足食了。
---
>学习也是没有办法的事情

<!--more-->
粗略的的看一下用了 gulp + es6
大概还得研究下 [coffeescript](http://coffee-script.org/)

ref:

**Hexo 插件相关**
- [Hexo高级教程之插件开发](http://www.ieclipse.cn/en/2016/07/18/Web/Hexo-dev-plugin/)

**JS 语法&环境相关**

【ECMAScript 6】
- [ECMAScript 6 入门](http://es6.ruanyifeng.com/)
- [ECMAScript6 教程（一）](http://www.ituring.com.cn/article/201561)
- [ECMAScript 6 — New Features: Overview & Comparison](http://es6-features.org)


【gulp】
- [gulp API docs](https://github.com/gulpjs/gulp/blob/master/docs/API.md)
- [gulp 入门指南](https://github.com/nimojs/gulp-book)
- [Gulp入门教程](http://www.jianshu.com/p/fbf9871dc47a)
- [手记：gulp 入门](https://www.zybuluo.com/EncyKe/note/658462)
- [Gulp 入门指南](http://wiki.jikexueyuan.com/project/gulp-book/)


【Coffeescript】
- [coffeescript](http://coffee-script.org/)
- [CoffeeScript 实用手册](http://wiki.jikexueyuan.com/project/coffeescript/)

- [Chrome 开发工具指南](http://wiki.jikexueyuan.com/project/chrome-devtools/)


----

# 配置
``` plain
math:
  engine: 'mathjax' # or 'katex'
  mathjax:
    src: https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/config/TeX-AMS-MML_HTMLorMML.js
    config:
      # MathJax config
        
  katex:
    css: https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.css
    js: https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.js # not used
    config:
      # KaTeX config
```

真是服气，把配置都删了就好使了。不过处理时还是有报错

{% asset_img ex1.png %}

``` plain err
11:44:41.160 INFO  [hexo-math] Using engine 'mathjax'
11:44:41.160 DEBUG Plugin loaded: hexo-math
11:44:41.175 DEBUG Plugin loaded: hexo-renderer-ejs
11:44:41.175 DEBUG Plugin loaded: hexo-renderer-marked
11:44:41.175 DEBUG Plugin loaded: hexo-renderer-stylus
11:44:41.269 DEBUG Plugin loaded: hexo-server
11:44:41.285 DEBUG Plugin loaded: hexo-renderer-scss
11:44:41.285 DEBUG [hexo-inject] firing inject_ready
11:44:41.300 DEBUG Loading database.
11:44:41.316 DEBUG [hexo-inject] SKIP: undefined
11:44:41.316 DEBUG Incomplete document
Error: Incomplete document
    at Inject._transform (I:\GitHub\inkydragon.github.io\hexo\node_modules\hexo-inject\lib\mixin\transform.js:29:34)
    at Hexo.tryCatcher (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\util.js:16:23)
    at Hexo.<anonymous> (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\method.js:15:34)
    at I:\GitHub\inkydragon.github.io\hexo\node_modules\hexo\lib\extend\filter.js:68:35
    at tryCatcher (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\util.js:16:23)
    at Object.gotValue (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\reduce.js:155:18)
    at Object.gotAccum (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\reduce.js:144:25)
    at Object.tryCatcher (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\util.js:16:23)
    at Promise._settlePromiseFromHandler (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\promise.js:512:31)
    at Promise._settlePromise (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\promise.js:569:18)
    at Promise._settlePromiseCtx (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\promise.js:606:10)
    at Async._drainQueue (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\async.js:138:12)
    at Async._drainQueues (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\async.js:143:10)
    at Immediate.Async.drainQueues (I:\GitHub\inkydragon.github.io\hexo\node_modules\bluebird\js\release\async.js:17:14)
    at runCallback (timers.js:672:20)
    at tryOnImmediate (timers.js:645:5)
    at processImmediate [as _immediateCallback] (timers.js:617:5)
```




<div style="display: none;">
{% raw %}


{% blockquote [author[, source]] [link] [source_link_title] %}
content
{% endblockquote %}


{% codeblock [title] [lang:language] [url] [link text] %}
code snippet
{% endcodeblock %}

``` [language] [title] [url] [link text] 
code snippet 
```


{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}

{% asset_img slug [title] %}


{% endraw %}
</div>
