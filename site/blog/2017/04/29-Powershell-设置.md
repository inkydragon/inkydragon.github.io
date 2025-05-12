---
slug: powershell-setting
title: Powershell 设置
date: 2017-04-29 12:04:20
authors: cyhan
tags:
- Powershell
---
Win10 右键+Shift 默认的命令行改成了 Powershell，略作设置方便使用

<!-- truncate -->

ref:
- [powershell配置(win10)](http://kaimingwan.com/post/gong-ju/powershellpei-zhi-win10)

## 设置常用函数
通过 `$PROFILE` 可以查看配置文件路径
``` ps
Import-Module PSColor;

## hexo' server
function hexo-web {
    cd I:\GitHub\inkydragon.github.io\hexo;
    hexo s --debug;
}

## atom + hexo
function hexo-write {
    atom I:\GitHub\inkydragon.github.io\hexo;
}
```

### File-Hash
自带的 `Get-FileHash` 不是很好用，每次只能计算一种hash，有了各种hash碰撞.
只用一种不安全，于是自己改了一个，支持多文件，多种hash计算的ps脚本。

>用的时候在 `$PROFILE` 里 `Import-Module` 一下脚本的绝对路径。
若权限受限参看 [about_Execution_Policies](https://technet.microsoft.com/zh-cn/library/347708dc-1515-4d74-978b-8334603472e6)

``` ps 计算文件Hash
##requires -version 4.0
 
##Hash.ps1
##计算文件Hash
 
[cmdletbinding()]
Param(
[Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
[ValidateScript({Test-Path $_})]
[Alias("PSPath")]
[string]$Path = '.\')
 
Process {
    Write-verbose "Testing hashing with $(Convert-Path $Path)"
    $filesize = (Get-item $path).Length
 
    $algorithms = "MD5","SHA1","SHA256"
 
    foreach ($item in $algorithms) {
    (Get-FileHash -Path $Path -Algorithm $item)
    } #foreach
 
} #process
```

效果对比
``` 
PS I:\Desktop\TeX\TEST> Get-FileHash .\zh-font.*

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
SHA256          3345A075A22FB3BBC04567A1E5660ED0240D53F5881F458A2234DCD42A78D335       I:\Desktop\TeX\TEST\zh-font.aux
SHA256          B73FA579D08F1C8CCADB697E59A3A9850D7BF699DB6B41E158C73F74A25617F7       I:\Desktop\TeX\TEST\zh-font.log
SHA256          57F9FE61DCC291DF186D8BB063D57D9B839AF38E0F14E4DAA4B999F66D09112C       I:\Desktop\TeX\TEST\zh-font.pdf
SHA256          F4F465B8FFDC66371E425EB56B615C8B7394911D158F98E164AC5710667217EE       I:\Desktop\TeX\TEST\zh-font....
SHA256          EC14B68DEF8A03326E0C25A8480277E5CD1B71D682F4B413636D59BC0D23E57C       I:\Desktop\TeX\TEST\zh-font.tex



PS I:\Desktop\TeX\TEST> Hash .\zh-font.*

Algorithm       Hash                                                                   Path
---------       ----                                                                   ----
MD5             A94A2480D3289E625EEA47CD1B285758                                       I:\Desktop\TeX\TEST\zh-font.aux
MD5             B265D25275C14CC0A034805094089ABB                                       I:\Desktop\TeX\TEST\zh-font.log
MD5             D0A9E55C056F0182D2AA1DBD3E9EA61D                                       I:\Desktop\TeX\TEST\zh-font.pdf
MD5             4FD3009012737CBA9228A9C4CE17DBCF                                       I:\Desktop\TeX\TEST\zh-font....
MD5             DB28CC20930A6148099491D569BA3F08                                       I:\Desktop\TeX\TEST\zh-font.tex
SHA1            6B43E311DFAE9A1BB7E75DBD93F9EFC541355DB7                               I:\Desktop\TeX\TEST\zh-font.aux
SHA1            EC10912DDBF134498EA514D8DF538FC81303F475                               I:\Desktop\TeX\TEST\zh-font.log
SHA1            67F6C8BA17D7657175236967DE5A9D741829A533                               I:\Desktop\TeX\TEST\zh-font.pdf
SHA1            2466E90627C4E9AFC6C30BA23938C51F629E3FE4                               I:\Desktop\TeX\TEST\zh-font....
SHA1            EF900DD76A0C0EC3190DF68EF577DAF0747C9B73                               I:\Desktop\TeX\TEST\zh-font.tex
SHA256          3345A075A22FB3BBC04567A1E5660ED0240D53F5881F458A2234DCD42A78D335       I:\Desktop\TeX\TEST\zh-font.aux
SHA256          B73FA579D08F1C8CCADB697E59A3A9850D7BF699DB6B41E158C73F74A25617F7       I:\Desktop\TeX\TEST\zh-font.log
SHA256          57F9FE61DCC291DF186D8BB063D57D9B839AF38E0F14E4DAA4B999F66D09112C       I:\Desktop\TeX\TEST\zh-font.pdf
SHA256          F4F465B8FFDC66371E425EB56B615C8B7394911D158F98E164AC5710667217EE       I:\Desktop\TeX\TEST\zh-font....
SHA256          EC14B68DEF8A03326E0C25A8480277E5CD1B71D682F4B413636D59BC0D23E57C       I:\Desktop\TeX\TEST\zh-font.tex
```
