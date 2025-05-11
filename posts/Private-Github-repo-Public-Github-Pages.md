---
title: Private Github repo & Public Github Pages
date: 2017-02-08 17:49:24
tags:
- Github
---
弄了个 Student Developer Pack 可以使用 Private repo ，我就想，如果把 Github Pages 设为 Private 会怎么样。

Google 一下，发现设为私有后 Github Pages 仍然可用
{% blockquote kashyap http://stackoverflow.com/a/11007746 Private pages for a private Github repo %}
I had raised a support ticket against Github and got a response confirming the fact that ALL pages are public. I've now requested them to add a note to help.github.com/pages.
{% endblockquote %}

{% blockquote Joel Glovier http://stackoverflow.com/a/19058071 Private pages for a private Github repo %}
All project repositories are ready to use the generator for publishing. **However, please note that private repositories will publish pages that are public.**
{% endblockquote %}

于是索性把repo 设为私有，这样还可以把源md文件传上去备份，挺好的。

### 关于付费账户到期时私有项目问题
~~只是需要注意repo公开时，源md文件泄露的问题。~~
{% blockquote VinkyQ https://www.zhihu.com/question/23200523/answer/23899098 github停止付费后，对私有项目如何处理？ %}
停止付费后，私有项目会继续出现在"Your repositories"的"Private"选项卡中，前面显示一个lock的图标。            
此时你无法进入或操作此项目，除非你重新付费。
{% endblockquote %}
