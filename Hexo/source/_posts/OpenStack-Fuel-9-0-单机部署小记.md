---
title: OpenStack Fuel 9.0 单机部署小记
date: 2017-07-27 14:26:36
categories:
  - OpenStack
  - OpenStack Fuel
tags:
  - OpenStack
description:
  Mirantis 家的 OpenStack Fuel 套装单机部署踩坑记录
---
OpenStack Fuel 是Mirantis为OpenStack定制的自动部署软件(套装)，使用fuel配置OpenStack只需要配置master/主节点，并在主节点安装完成后在fuel dashboard/控制面板配置好整个OpenStack系统，即可通过fuel自动给个node/子节点部署系统(默认为Ubuntu)并安装、配置openstack。

<!--more-->




# Ref Links

**推荐阅读**
0. [Fuel | 深入理解OpenStack自动化部署](https://pom.nops.cloud/deployment_tool/fuel.html)
1. [漫漫求索Openstack之路---Fuel 9.0 详细安装步骤（排坑版）_Alove_新浪博客](http://blog.sina.com.cn/s/blog_936291410102wi29.html)
2. 【Fuel 9.2】[Mirantis Documentation: Introduction](https://docs.mirantis.com/openstack/fuel/fuel-9.2/quickstart-guide/qs-intro.html)
3. 【Fuel 11.0】[OpenStack Docs: Fuel Installation Guide](https://docs.openstack.org/fuel-docs/latest/userdocs/fuel-install-guide.html)

**网络规划/配置参考**

4. [Mirantis OpenStack 9.0 在 VirtualBox上的部署安装 - hchuchuan - CSDN博客](http://blog.csdn.net/hchuchuan/article/details/52225660)
5. [Fuel 30 分钟快速安装OpenStack - Yudar - 博客园](http://www.cnblogs.com/yudar/p/4630758.html)
6. [OPNFV在双网卡物理机群上的部署（FUEL） - 知乎专栏](https://zhuanlan.zhihu.com/p/21864362)
7. 【Ubuntu 镜像源修改】[部署安装Mirantis OpenStack Fuel 9.0 - Titan0427的专栏 - CSDN博客](http://blog.csdn.net/Titan0427/article/details/51982609)
8. 【MOS本地源配置】[Mirantis OpenStack Fuel—MOS本地源/bootstrap制作 - OpenStack知识库](http://lib.csdn.net/article/openstack/54517)

**Horizon 使用**

- [使用Fuel安装OpenStack juno之三使用OpenStack创建云主机和Volume - 天魂永恒 - 51CTO技术博客](http://tianhunyongheng.blog.51cto.com/1446947/1607676)
- [[原创]Mirantis OpenStack fuel web 安装 使用 - Architect - 畅享博客](http://blog.vsharing.com/wpskl/A1738986.html)


**错误处理**

- [ESXi服务器上利用Fuel部署Openstack错误解决 - lwyeluo的专栏 - CSDN博客](http://blog.csdn.net/lwyeluo/article/details/53102508?locationNum=12&fps=1)


# Fuel 配置概述

[翻译自ref-3]

## 虚拟机硬件配置

>**NOTE**: 这里只谈一般的配置，具体针对虚拟机的配置见后

**Master Node/主节点**:
安装fuel的节点，用于初始化设置，分发配置，PXE启动从节点并给从节点提供IP

主节点配置要求：[OpenStack Docs: Fuel Master node hardware requirements](https://docs.openstack.org/fuel-docs/latest/userdocs/fuel-install-guide/sysreq/sysreq_fuel_master_node_hw_requirements.html)

这里只看测试环境的：

- 双核 CPU
- 2G RAM
- 1000M 网卡 x1
- 50GB 硬盘


**Slave node/从节点**:
从节点是依赖于主节点的：控制节点、计算节点、储存节点等

有四种从节点：

- Controller nodes/控制节点
- Compute nodes/计算节点
- Storage nodes/储存节点
- Telemetry - MongoDB nodes/遥测节点

对于测试环境只需要前两个节点(各1个)即可

参考配置：

  - 双核 CPU
  - 2G 内存 (可以加到4G)
  - 1000M 网卡 x3
  - \>120G 硬盘 (or 64G x3)

## [Network requirements](https://docs.openstack.org/fuel-docs/latest/userdocs/fuel-install-guide/sysreq/sysreq_network_requirements.html)

>**NOTE** 以下配置均在Dashboard中进行


**带VLAN分隔的Neutron**

至少三张网卡：

| NIC  | for ...           |
| :--- | :---------------- |
| eth0 | 未标记的管理网络(PXE...)  |
| eth1 | > Public/Floating |
|      | > Management      |
|      | > Storage         |
| eth2 | Private network   |

**带隧道分隔的Neutron**

omitted

**对Public network/公有网络的要求**

- Floating IP/`浮动IP`地址范围必须和Public IP/`公有IP`一同配置
- 每个Controller node/`控制节点`都需要一个`公有IP`
  - 如果选中了 *`Assign public network to all nodes`* 选项
    则需要为每一个从节点分配一个`公有IP`
- 还需要预留3个IP给：
  - Virtual IP/`VIP` x2
  - default gateway/`默认网关` x1
- 如果打开了 Neutron DVR 选项，则每个计算节点还需要额外的一个IP
- 注意插件可能需要额外的IP

**对Storage and Management networks/储存、管理网络的要求**

- 这个网络为内网，因此需要内网IP段

**Neutron L2 和 L3**

- 每个project/项目所用的网络，需要独一无二的 `VLAN ID` (分隔ID)
- 处于安全原因，Admin project network/`管理网络` *孤立于* 其余网络(公有/私有网络)
- 包括Admin project/`管理项目`在内的每一个项目都需要一个`浮动IP`
- 虚拟机直连到外部网络需要一个`浮动IP`
- `浮动IP`地址不应与`公有网络`地址重合
- 如果不使用默认DNS服务器，则应指定guest OS DNS servers

## 主节点网络配置

- 主节点应该能正常联网，一遍下载、制作PXE启动镜像。
- 也可以在不联网的条件下，通过本地镜像制作PXE启动镜像。



# 安装步骤

安装可大致分为几类：

- 物理机安装
  比照虚拟机的安装，相应配置增加
- 虚拟机安装
  - VirtualBox
    - 手工安装 【见下】
    - 【官方推荐】Fuel 9.0 + VBox + 自动安装脚本
       [Mirantis Documentation: Install Mirantis OpenStack using the Mirantis VirtualBox scripts](https://docs.mirantis.com/openstack/fuel/fuel-9.2/quickstart-guide/qs-install-scripts.html)
  - [OpenStack Docs: Install Fuel on VMware vSphere](https://docs.openstack.org/fuel-docs/latest/userdocs/fuel-install-guide/vsphere_intro.html#vsphere-intro)
  - Hyper-V (教程较少)
    - [Hyper-V integration in OpenStack platform | Mirantis](https://www.mirantis.com/blog/hyper-v-integration-openstack-platform/)

【安装过程概述】
详细的过程建议参考ref部分-推荐阅读的教程


## Part 0 安装镜像的下载

- 【Fuel 9.0 ~ 9.2 有VBox自动安装脚本】[Download OpenStack Solutions](https://www.mirantis.com/software/openstack/download/)
- 【Fuel 11.0 & 12.0】[Fuel Community project - Deployment and Management Automation for OpenStack](https://www.fuel-infra.org/#fuelget)

选用第一种 Fuel 9.0 + VBox 并通过脚本安装时。
可能会遇到 `Failed to create the host-only adapter` 以及类似的的错误，
这个错误是一个已知的VBox Bug，在最新版中仍未修复，目前无直接解决办法，可以考虑绕过网络配置，详见【常见错误】的相关错误


## 【Part I】master/主节点的配置
### 1.1 网络的规划与配置

### 1.2 master 虚拟机的设置

### 1.3 master 的安装

### 1.4 bootstrap 镜像的制作

## 【Part II】node/子节点的建立
### 2.1 node 虚拟机的配置

### 2.2 fuel dashboard 的配置

### 2.3 配置分发/deploy

## 【Part III】horizon 平台的使用
### 3.1 openstack 健康检查

### 3.2 云主机实例的建立


# 注意事项

>**NOTE**: 针对易出错的地方单独列出checklist，以便于检查

- [ ] 虚拟机的选择
  注意虚拟机冲突
  VBox

- [ ] 虚拟网络(网卡/交换机)的配置
  各虚拟机网络配置方式不同，参数也有变化
  注意配置统一
  最好画图

- [ ] master 的配置
  硬盘》64G

- [ ] master 的安装
  一定要等待安装完成

- [ ] node 的配置
  硬盘>120G
  注意网卡down点的情况，手工拉起来

- [ ] 镜像的准备
  注意activate相关的bootstrap

- [ ] fuel dashboard
  检查各虚拟机网卡状态，down掉的网卡手动up

- [ ] 检查网络配置【之后不可更改】
  NTP服务器设为master
  注意ip段无冲突
  注意虚拟机重启后网卡状态


# 常见错误

- `error: Failed to create the host-only adapter`
  > VBox version 5.1.24 & 5.1.26

  使用官方自动安装、配置脚本时可能会遇到如下错误：
  {% asset_img VBox-HostOnly.png VBox-HostOnly %}
  ```
  Deleting old interfaces if exists...
  ...eting host-only interface: VirtualBox Host-Only Ethernet Adapter
  VBoxManage.exe: error: The host network interface named 'VirtualBox Host-Only Et' could not be found
  VBoxManage.exe: error: Details: code E_INVALIDARG (0x80070057), component HostWrap, interface IHost, callee IUnknown
  VBoxManage.exe: error: Context: "FindHostNetworkInterfaceByName(Bstr(pszName).raw(), hif.asOutParam())" at line 139 of file VBoxManageHostonly.cpp
  " was not removed. Aborting...x Host-Only Ethernet Adapter
  ```
  可能的解决方案：
  {% blockquote @Javed Mulani  https://stackoverflow.com/questions/31765581/the-host-network-interface-with-the-given-name-could-not-be-found —— vagrant - The host network interface with the given name could not be found - Stack Overflow %}
  Simple solution: **Delete the already created (default) Host only Ethernet Adapter** from VirtualBox Preferences and run sh launch.sh (if you received error while installing Mirantis Openstack package).
  {% endblockquote %}

  删除已有的网卡,
  再次运行脚本

  依旧报错

  {% asset_img NIC-not_found.png NIC-not_found %}

  ```
  Creating host-only interface...
  0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
  Fatal error. Interface VirtualBox Host-Only Ethernet Adapter does not exist after creation. Exiting
  ```

  根据以下链接，认为此bug为已知的、未修复的bug，

  可能的解决思路：

  注释掉`launch.sh`中的`./actions/create-interfaces.sh || exit 1`
  手工创建网络，然后执行安装脚本

  Bug 相关：

  - [virtualbox.org • View topic - try to use scripts to create VirtualBox Host-Only Ethernet Adapter does not exist after creation.](https://forums.virtualbox.org/viewtopic.php?f=6&t=82989)
  - [#15019 (Unable to create Host-Only Network in Windows 10) – Oracle VM VirtualBox](https://www.virtualbox.org/ticket/15019)

- 开虚拟机 蓝屏 0x0000003B
  虚拟机冲突,只留一个要用的虚拟机 (一般为 hyper-v 和其他虚拟机冲突)

- fuel-bootstrap list 结果为空
  在生成镜像后，镜像还放在`tmp`里，需要手工导入

- 连接不上 Fuel Web UI (10.20.0.2:8448)
  检查主节点及子节点网卡是否有`down`掉的(`ifconfig -a` 显示，而`ifconfig`不显示的)，
  如果有`ifconfig <enp0sx> up`起来(`<enp0sx>`为网卡名)

- Timeout waiting for host '10.109.6.1' status to become 'up' after 60 seconds!
  公有网关设置有误/网关不回应ICMP包(ping包)

  先对照的网络配置要求检查Fuel Web UI的配置是否有误，检查网络连通性。
  如果用本机做网关，则应在防火墙中打开ICMP回显。
  (可直接关闭防火墙/ **不推荐**)

- (/Stage[main]/Main/Exec[sync_time_shell]/returns) failed: /bin/bash "/etc/puppet/shell_manifests/sync_time_command.sh" Excuted failed
  NTP服务配置有误，务必设置为master的IP (默认为 `10.20.0.2`)

- Command: 'openstack [ .... ]' has been running for more then 20 seconds!
  一般是虚拟机性能不行。
  查看各虚拟机，资源占用情况(`top` or `htop`)
  若CPU/内存占用过大，务必关机后增加配置。

- `unable to establish connection to keystone endpoint`
  horizon_dashboard 登录不了

  {% asset_img horizon_dashboard.png %}

  简单方法，重启各虚拟机

  一般方法，检查master上的keystone服务是否正常运行，并查看各虚拟机，资源占用情况(`top` or `htop`)
  CPU/内存占用过大，务必关机后增加配置。



<div style="display: none;">
{% raw %}


{% blockquote [author[, source]][link] [source_link_title] %}
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
