---
slug: omegat-install-and-config
title: OmegaT 翻译环境安装与配置
date: 2017-02-06T22:06:29
authors: cyhan
tags:
- Translation
---

又想填坑了，所以找了个开源的辅助翻译软件，记录下配置过程

<!-- truncate -->

## *0x00* 词典、术语集管理

[语帆术语宝](http://termbox.lingosail.com/console/extract)
双语对照 --> 术语表        
即从中英对照的整段翻译中提取词汇对照表，可在线保存 or 导出为 Excel(.xls)或(.tbx)

[在线对齐-Tmxmall](http://www.tmxmall.com/aligner)
对齐后可导出为 .tmx \\ .xlsx \\ .txt

### 术语下载
[下载 Microsoft 术语](https://www.microsoft.com/Language/zh-cn/Terminology.aspx)

### 词典下载
[zh_CN 简体中文词典 - StarDict Dictionaries -- 星际译王词库 词典下载](http://download.huzheng.org/zh_CN/)


## *0x01* OmegaT.ini 的配置

```ini
# OmegaT.exe runtime configuration
#
# To use a parameter, remove the '#' before the '-'

# Memory
-Xmx512M
# Language
-Duser.language=zh
# Country
-Duser.country=CN
# Settings to access the Internet behind a proxy
-Dhttp.proxyHost=127.0.0.1
-Dhttp.proxyPort=1080
# Google Translate v2 API key
#-Dgoogle.api.key=xxxxx
# Microsoft Translator credentials
#-Dmicrosoft.api.client_id=xxxxx
#-Dmicrosoft.api.client_secret=xxxxx
# MyMemory email
#-Dmymemory.api.email=xxxxx@xxxxx.xx
# TaaS user key
#-Dtaas.user.key=xxxxx
#-Dyandex.api.key=xxxxx
```

### Microsoft Translator 的配置

参考[Getting started using the Translator API](https://www.microsoft.com/en-us/translator/getstarted.aspx)

国内需要在 azure.cn 上登录\\注册账号
