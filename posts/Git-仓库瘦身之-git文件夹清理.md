---
title: Git 仓库瘦身之.git文件夹清理
date: 2017-04-01 19:27:35
tags:
  - Git
---
clone某汉化组的repo，本来有墙，结果repo竟然有31M，源码是一堆tex文件，图片也没几张最大的一个文件是PDF，然后我就感觉很奇怪，怎么这个repo这么大。

<!--more-->
ref：    
1. [为什么你的 Git 仓库变得如此臃肿](http://www.jianshu.com/p/7231b509c279)
2. [.git 文件太大时怎样处理](https://segmentfault.com/q/1010000000171057)
3. [寻找并删除Git记录中的大文件](http://harttle.github.io/2016/03/22/purge-large-files-in-gitrepo.html)
4. [记一次删除Git记录中的大文件的过程](http://www.hollischuang.com/archives/1708)


# 原因分析
先找了篇教程(第一篇)，知道了是因为`.git/objects`目录下缓存了过多的大文件。结合repo的原文件，可知是因为编译出的PDF文件每次都包含到repo中了，导致`.git`文件夹很大。

```
$ du -d 1 -h
27M     ./.git
356K    ./Chaps
1.0K    ./Parts
3.9M    ./Pictures
35M     .
```

# repo瘦身
## 临时解决方法
>ref:2

1. 在`.gitignore`里面加上要排除的PDF
2. clone repo时 使用`--depth`指定clone深度   
    `git clone git@github.com:torvalds/linux.git --depth 1`     

## 彻底解决方案

**WARNING!**
_如果你不是完全清楚你在做什么，那么_
**你正在作死**

>WARNING! The rewritten history will have different object names for all the objects and will not converge with the original branch. You will not be able to easily push and distribute the rewritten branch on top of the original branch. **Please do not use this command if you do not know the full implications, and avoid using it anyway**, if a simple single commit would suffice to fix your problem. 
>
>—— 
[Git - git-filter-branch Documentation](https://git-scm.com/docs/git-filter-branch)

后面会有命令，让git会遍历repo~所有分支~(所选分支)中所有的commit，删除大文件的记录。这极度危险，所以动手前请务必备份。

**进行危险操作前先备份**

### step 0 git clone
`git clone git@github.com:ChzRuan/CallenThermo.git`

### step 1 备份
首先备份
`git clone /i/GitHub/Callen-Thermo-CHS /i/backup`

然后再备份中先尝试操作，并观察结果，达到预期后，再次备份，并修改真正的repo

切换目录
`cd /i/backup/`

### step 2 查看空间占用
```
$ du -d 1 -h
27M     ./.git
356K    ./Chaps
1.0K    ./Parts
3.9M    ./Pictures
35M     .
```

进一步确认可知是`.git/objects`占了大头，源代码其实并不大

深究原因，最根本的在于git的存储方式

>Git与你熟悉的大部分版本控制系统的差别是很大的。也许你熟悉Subversion、CVS、Perforce、Mercurial 等等，他们使用 “增量文件系统” （Delta Storage systems）, 就是说它们存储每次提交(commit)之间的差异。Git正好与之相反，它会把你的每次提交的文件的全部内容（snapshot）都会记录下来。这会是在使用Git时的一个很重要的理念。
>
>——
[Git Book 中文版 - GIT对象模型](https://github.com/liuhui998/gitbook/blob/master/text_zh/02_Git_Object_Db_Basics/0_%20Git_Object_Db_Basics.markdown#与svn的区别)

当然为了保证传输效率，git会在碎片对象过多，或者你向远端服务器发起推送的时候，自动执行一次打包过程。在打包的过程中，git会使用增量编码方案（delta encoding），只保存对象的不同版本之间的差异，这会显著减小repo的大小。

对我们的目标repo，源文件中包含了编译产生的PDF文件，虽然git使用了增量编码来打包。但由于PDF文件是一个整体，git无法用增量编码来保存差异，而是每次都保存整个pdf文件，所以.git文件夹会越来越大。

找到了根本原因，下面就要着手解决一下。

-------
_上面没**备份**的，现在还有救_

### step 3 查找大文件
本例中已经确定大文件是 `CallenThermo.pdf` 可以直接进行下一步。
当然还要提一下通用的方法。

使用以下命令，查找排名前5的大文件

`git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"`

命令详解见 ref:3 

```
$ git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/\*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')"
dd351b9649360a24d890ba8df7cad2b16e2b914d CallenThermo.pdf
31b7802b6ac511e692be2a9ea6a3901d3c04b44d CallenThermo.pdf
0b5af57cea13227839e888f6ad7208355bc3bbe8 CallenThermo.pdf
592063e0dc668dede796a271528f96b872eef537 CallenThermo.pdf
9ac4277398fbfdb99be84a16f149745d728b4b2e CallenThermo.pdf
```

确认是`CallenThermo.pdf`的锅

### step 4 删除大文件

#### 删除单个大文件
使用以下命令，删除提交历史中所有的大文件记录：

```
git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch big-file-name' --prune-empty --tag-name-filter cat -- --all
```

命令中的 `big-file-name`请替换为大文件名，这里是`CallenThermo.pdf`.
执行命令后，你可以在输出中看见git正在遍历每一次commit，然后删除其中的大文件。

```
...
emaining 1 predicted)    rm 'CallenThermo.pdf'
Rewrite a9a3ca2ea17ac55b3a769e7eced60059d2de5dd4 (113/116) (43 seconds passed, remaining 1 predicted)    rm 'CallenThermo.pdf'
Rewrite cc30f6cabb8a9bc981767138567f79df2593e108 (113/116) (43 seconds passed, remaining 1 predicted)    rm 'CallenThermo.pdf'
Rewrite a0b3a37eb34e51b903befa9f3c481c986fcf6e2e (116/116) (45 seconds passed, remaining 0 predicted)
Ref 'refs/heads/dev-thin' was rewritten
Ref 'refs/heads/master' was rewritten
Ref 'refs/remotes/ChzRuan/master' was rewritten
Ref 'refs/remotes/origin/master' was rewritten
Ref 'refs/remotes/origin/dev' was rewritten
WARNING: Ref 'refs/remotes/origin/master' is unchanged
```

我本来为了‘安全’，建立了一个新的分支dev-thin。但从输出的最后几行可以出git修改了所有与repo相关的分支，这也是这个操作最危险的一点。


#### 删除多个大文件
取得单行的大文件名

```
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/\*.idx | sort -k 3 -n | tail -5 | awk '{print$1}')" | awk '{print $2}' | tr '\n' ' ' > large-file.txt
```

再执行，以下命令，删除大文件记录
```
git filter-branch -f --prune-empty --index-filter "git rm -rf --cached --ignore-unmatch `cat large-file.txt`" --tag-name-filter cat -- --all
```

### step 5 清理repo
一开始照着 ref：3 来操作时没有这一步，发现repo的大小几乎没变。
找了新的教程后，才成功给repo瘦身。

一次一行命令
```
rm -rf .git/refs/original/
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin

git reflog expire --expire=now --all

git gc --prune=now
```

### step 6 推送到远端
以强制覆盖的方式推送你的repo

```
git push origin --force --all
```

这里的`--all`会将所有分支都推送到origin上。当然你也可以只推送master分支： `git push origin master --force`。


# 效果

```
$ du -d 1 -h
7.2M    ./.git
356K    ./Chaps
1.0K    ./Parts
3.9M    ./Pictures
12M     .
```

35M -> 12M 缩减了约2/3，效果立竿见影
