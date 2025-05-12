# Git 清理仓库大文件

参考
- [How can I find/identify large commits in Git history? - Stack Overflow](https://stackoverflow.com/questions/10622179/how-can-i-find-identify-large-commits-in-git-history)
- [BFG Repo-Cleaner by rtyley](https://rtyley.github.io/bfg-repo-cleaner/)
    注意使用 JRE 11

## 执行

```sh
# clone repo
git clone https://github.com/inkydragon/inkydragon.github.io.git
# 删除上游 origin
git remote rm origin
$ git branch --all
* main
$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
$ git count-objects -v
count: 0
size: 0
in-pack: 3227
packs: 1
size-pack: 15629
prune-packable: 0
garbage: 0
size-garbage: 0


## 检查大文件
inkydragon.github.io$ git rev-list --objects --all --missing=print |   git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |   sed -n 's/^blob //p' |   sort --numeric-sort --key=2 |   cut -c 1-12,41- |   $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest | tail -n30
6f6c221dbb72  139KiB node_modules/hexo-deployer-git/node_modules/swig/node_modules/uglify-js/tools/domprops.json
d6356c19cab2  141KiB node_modules/hexo-deployer-git/node_modules/swig/dist/swig.js
68fe62285cac  144KiB hexo/themes/even/source/image/reward/wechat.png
a63dcc57cf86  158KiB posts/Win-10-下编译带-GPU-支持的-Tensorflow/vc_redist.x64-error.png
e301af350244  165KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/locales.min.js
0d9834e6bea3  169KiB node_modules/hexo-cli/node_modules/bluebird/js/browser/bluebird.js
969dc52ac8f1  181KiB Hexo/package-lock.json
a3277daf79c9  182KiB Hexo/package-lock.json
411aa1fedae8  194KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/docs/img/bunyan.browserify.png
45fdf3383012  197KiB Hexo/themes/landscape/source/css/fonts/fontawesome-webfont.svg
a03850f44d0c  214KiB posts/UNet-语义分割/toy-1.jpg
fe557f216c17  216KiB posts/某-CTF-Group-的入群考核试题/5-py.png
b963e0641c41  219KiB Hexo/themes/landscape/source/css/images/banner.jpg
edffa0c1f0a5  220KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/moment-with-locales.min.js
16de99e08948  222KiB posts/texlive2016-更新问题/err1.jpg
c1bd998f77b1  240KiB Hexo/themes/landscape-plus/source/css/images/banner.jpg
0226a677edcd  243KiB posts/某-CTF-Group-的入群考核试题/0-flag.png
d9a8a6706ac8  274KiB posts/OpenStack-Fuel-9-0-单机部署小记/keystone-timeout.png
e8902cadbaa2  276KiB posts/0ops-0CTF-2017/3-KONAMI.png
d907b25ae60e  280KiB Hexo/themes/landscape-plus/source/css/fonts/fontawesome-webfont.svg
a5c104455097  281KiB Hexo/themes/landscape-plus/source/css/fonts/fontawesome-webfont.svg
31b4097dc78e  311KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/locales.js
b0e638da7ab0  334KiB posts/0ops-0CTF-2017/5-konami.png
d87050f9a577  393KiB posts/OpenStack-Fuel-9-0-单机部署小记/horizon_dashboard.png
1f4eb8108357  432KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/moment-with-locales.js
fb3821d26e57  458KiB posts/编程七日-周-谈/haskell.png
8084a4c319ac  569KiB posts/Matlab-memo/Matlab-memo-GIF_testAnimated.gif
997cc2c6a7c1  659KiB site/package-lock.json
c2d3a4d7a124  1.7MiB site/blog/2016/08-25-Legal-High-第一季观后感/ligohi1.png
745975a92a76  2.4MiB posts/0ops-0CTF-2017/4-konami.gif


## ---- 预备删除大图片
# 备份并移除大图片
inkydragon.github.io$ mkdir ../inkytmp/
inkydragon.github.io$ mv posts/0ops-0CTF-2017/4-konami.gif site/blog/2016/08-25-Legal-High-第一季观后感/ligohi1.png posts/Matlab-memo/Matlab-memo-GIF_testAnimated.gif posts/编程七日-周-谈/haskell.png  posts/OpenStack-Fuel-9-0-单机部署小记/horizon_dashboard.png posts/0ops-0CTF-2017/5-konami.png  ../inkytmp/
inkydragon.github.io$ ll -h ../inkytmp/
total 5.8M
drwxrwxrwx 1 cyhan cyhan 4.0K May 12 11:22 ./
drwxrwxrwx 1 cyhan cyhan 4.0K May 12 11:21 ../
-rwxrwxrwx 1 cyhan cyhan 2.4M May 12 11:16 4-konami.gif*
-rwxrwxrwx 1 cyhan cyhan 335K May 12 11:16 5-konami.png*
-rwxrwxrwx 1 cyhan cyhan 458K May 12 11:16 haskell.png*
-rwxrwxrwx 1 cyhan cyhan 393K May 12 11:16 horizon_dashboard.png*
-rwxrwxrwx 1 cyhan cyhan 1.7M May 12 11:16 ligohi1.png*
-rwxrwxrwx 1 cyhan cyhan 569K May 12 11:16 Matlab-memo-GIF_testAnimated.gif*

# 提交修改
git add -A
git commit -m "git: remove large images"

# 提交空 HEAD 占位修改
git commit --allow-empty -m "git: placeholder for empty HEAD commit"


## ---- 开始清理 git 历史
# 删除大文件
java -jar /mnt/t/bfg.jar  --delete-files 4-konami.gif inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-files ligohi1.png inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-files Matlab-memo-GIF_testAnimated.gif inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-files haskell.png inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-files horizon_dashboard.png inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-files 5-konami.png inkydragon.github.io
# NOTE: 注意检查是否有脏文件，未被删除

inkydragon.github.io$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
Enumerating objects: 3222, done.
Counting objects: 100% (3222/3222), done.
Delta compression using up to 32 threads
Compressing objects: 100% (3071/3071), done.
Writing objects: 100% (3222/3222), done.
Total 3222 (delta 1042), reused 2027 (delta 0), pack-reused 0
inkydragon.github.io$ git count-objects -v
count: 0
size: 0
in-pack: 3222
packs: 1
size-pack: 9812
prune-packable: 0
garbage: 0
size-garbage: 0

# 复查大文件
inkydragon.github.io$ git rev-list --objects --all --missing=print |   git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |   sed -n 's/^blob //p' |   sort --numeric-sort --key=2 |   cut -c 1-12,41- |   $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest | tail -n30
9c4a9f0d0d88  134KiB posts/Matlab-memo/Matlab-memo-contourZlevel.png
5eda7ff37061  134KiB posts/Matlab-memo/Matlab-memo-contour-specific_height.png
714b4c441ac3  136KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/moment.js
af0f44b146a0  137KiB site/blog/2016/08-25-Legal-High-第一季观后感/ligohi2.png
a4552b488069  138KiB posts/某-CTF-Group-的入群考核试题/2-key.png
cb3ea00c045a  138KiB posts/easyCTF2017/Let_Me_Be_Frank-wm.png
6f6c221dbb72  139KiB node_modules/hexo-deployer-git/node_modules/swig/node_modules/uglify-js/tools/domprops.json
d6356c19cab2  141KiB node_modules/hexo-deployer-git/node_modules/swig/dist/swig.js
68fe62285cac  144KiB hexo/themes/even/source/image/reward/wechat.png
a63dcc57cf86  158KiB posts/Win-10-下编译带-GPU-支持的-Tensorflow/vc_redist.x64-error.png
e301af350244  165KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/locales.min.js
0d9834e6bea3  169KiB node_modules/hexo-cli/node_modules/bluebird/js/browser/bluebird.js
969dc52ac8f1  181KiB Hexo/package-lock.json
a3277daf79c9  182KiB Hexo/package-lock.json
411aa1fedae8  194KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/docs/img/bunyan.browserify.png
45fdf3383012  197KiB Hexo/themes/landscape/source/css/fonts/fontawesome-webfont.svg
a03850f44d0c  214KiB posts/UNet-语义分割/toy-1.jpg
fe557f216c17  216KiB posts/某-CTF-Group-的入群考核试题/5-py.png
b963e0641c41  219KiB Hexo/themes/landscape/source/css/images/banner.jpg
edffa0c1f0a5  220KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/moment-with-locales.min.js
16de99e08948  222KiB posts/texlive2016-更新问题/err1.jpg
c1bd998f77b1  240KiB Hexo/themes/landscape-plus/source/css/images/banner.jpg
0226a677edcd  243KiB posts/某-CTF-Group-的入群考核试题/0-flag.png
d9a8a6706ac8  274KiB posts/OpenStack-Fuel-9-0-单机部署小记/keystone-timeout.png
e8902cadbaa2  276KiB posts/0ops-0CTF-2017/3-KONAMI.png
d907b25ae60e  280KiB Hexo/themes/landscape-plus/source/css/fonts/fontawesome-webfont.svg
a5c104455097  281KiB Hexo/themes/landscape-plus/source/css/fonts/fontawesome-webfont.svg
31b4097dc78e  311KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/locales.js
1f4eb8108357  432KiB node_modules/hexo-cli/node_modules/hexo-log/node_modules/bunyan/node_modules/moment/min/moment-with-locales.js
997cc2c6a7c1  659KiB site/package-lock.json


# 删除文件夹
java -jar /mnt/t/bfg.jar  --delete-folders node_modules  inkydragon.github.io
java -jar /mnt/t/bfg.jar  --delete-folders themes  inkydragon.github.io

inkydragon.github.io$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
Enumerating objects: 921, done.
Counting objects: 100% (921/921), done.
Delta compression using up to 32 threads
Compressing objects: 100% (876/876), done.
Writing objects: 100% (921/921), done.
Total 921 (delta 418), reused 377 (delta 0), pack-reused 0
Removing duplicate objects: 100% (256/256), done.
inkydragon.github.io$ git count-objects -v
count: 0
size: 0
in-pack: 921
packs: 1
size-pack: 6240
prune-packable: 0
garbage: 0
size-garbage: 0


## ---- 推送
inkydragon.github.io$ git remote add origin https://github.com/inkydragon/inkydragon.github.io.git
$ git remote -v
origin  https://github.com/inkydragon/inkydragon.github.io.git (fetch)
origin  https://github.com/inkydragon/inkydragon.github.io.git (push)
$ git fetch
remote: Enumerating objects: 4375, done.
remote: Counting objects: 100% (437/437), done.
remote: Compressing objects: 100% (277/277), done.
remote: Total 4375 (delta 179), reused 328 (delta 147), pack-reused 3938 (from 1)
Receiving objects: 100% (4375/4375), 15.99 MiB | 10.45 MiB/s, done.
Resolving deltas: 100% (1444/1444), done.
From https://github.com/inkydragon/inkydragon.github.io
 * [new branch]      gh-pages   -> origin/gh-pages
 * [new branch]      main       -> origin/main
 * [new branch]      master     -> origin/master


$ git push -u -f origin main
Enumerating objects: 918, done.
Counting objects: 100% (918/918), done.
Delta compression using up to 32 threads
Compressing objects: 100% (454/454), done.
Writing objects: 100% (916/916), 6.07 MiB | 3.95 MiB/s, done.
Total 916 (delta 418), reused 916 (delta 418), pack-reused 0
remote: Resolving deltas: 100% (418/418), done.
To https://github.com/inkydragon/inkydragon.github.io.git
 + 0cdc027...cc74f39 main -> main (forced update)
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

## smms 图床

```md
![5-konami.png](https://cdn.sa.net/2025/05/12/WPOujx8EQKqwboG.png)
![horizon_dashboard.png](https://cdn.sa.net/2025/05/12/rLQOWhZtoG783kS.png)
![haskell.png](https://cdn.sa.net/2025/05/12/gBY8325QFVvtqZ4.png)
![Matlab-memo-GIF_testAnimated.gif](https://cdn.sa.net/2025/05/12/8fHjLvmdYMx6G5O.gif)
![ligohi1.png](https://cdn.sa.net/2025/05/12/kRF5I8u6fcdVQjD.png)
![4-konami.gif](https://cdn.sa.net/2025/05/12/io5Cj87YTEBgcsI.gif)
```
