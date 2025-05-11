---
title: LAMMPS 的安装与配置
date: 2017-04-27 16:33:53
categories:
tags:
description:
  分子模拟开坑，我只是路过。
---


<!-- truncate -->
先基于腾讯云尝试一下。

# Install
## doc
先看文档 [2.2.1. Read this first — LAMMPS documentation](http://lammps.sandia.gov/doc/Section_start.html#start-2-1)

>**If you want to avoid building LAMMPS yourself**, read the preceding section about options available for downloading and installing executables. Details are discussed on the [download page](http://lammps.sandia.gov/download.html).


## Add Yum Repository
先看 [Configuring the LAMMPS-ICMS Snapshot Repository](http://rpm.lammps.org/install.html)装一下源 

**Command Line Setup for Fedora, CentOS/RHEL with Yum**

- Enabling the repository for Fedora 19, 20, and 21:  
    `su -c 'yum localinstall --nogpgcheck http://git.icms.temple.edu/rpm/fedora/lammps-fedora-repo-1-2.noarch.rpm'`
- Enabling the repository for CentOS or RedHat Enterprise Linux 6.6 and later:  
    `su -c 'yum localinstall --nogpgcheck http://git.icms.temple.edu/rpm/centos/lammps-centos-rhel-repo-1-2.noarch.rpm'`

## LAMMPS-ICMS RPM Repository
>The LAMMPS distribution is split into multiple sub-packages and you only need to install the ones that you need. 

到这里[LAMMPS-ICMS RPM Repository](http://rpm.lammps.org/) 挑选需要的sub-packages

我装了这几个：

- lammps    
- lammps-python    
- lammps-common    

``` bash
yum install lammps lammps-python lammps-common 
```

剩余的 `lammps-doc` 是PDF格式的没必要装在服务器上，`lammps-openmpi`和`lammps-mpich` 是并行化用的，目前只是试一试，暂时用不上。

# Hello world
ref:

- [[Lammps] LAMMPS学习资源整理](http://bbs.keinsci.com/forum.php?mod=viewthread&tid=73&extra=page%3D1%26filter%3Dtypeid%26typeid%3D29)
- [lammps分子动力学模拟菜鸟入门求助](http://muchong.com/html/201312/6725835.html)
- [Internal LAMMPS tutorials](https://icme.hpc.msstate.edu/mediawiki/index.php/LAMMPS_tutorials)

## AL

1. 下载[Al99.eam.alloy](http://www.ctcms.nist.gov/potentials/Download/Al-YM/Al99.eam.alloy)
2. 新建文件`vim calc_fcc.in`
    ``` plain
    # Find minimum energy fcc configuration
    # Mark Tschopp, 2010

    # ---------- Initialize Simulation --------------------- 
    clear 
    units metal 
    dimension 3 
    boundary p p p 
    atom_style atomic 
    atom_modify map array

    # ---------- Create Atoms --------------------- 
    lattice 	fcc 4
    region	box block 0 1 0 1 0 1 units lattice
    create_box	1 box

    lattice	fcc 4 orient x 1 0 0 orient y 0 1 0 orient z 0 0 1  
    create_atoms 1 box
    replicate 1 1 1

    # ---------- Define Interatomic Potential --------------------- 
    pair_style eam/alloy 
    pair_coeff * * Al99.eam.alloy Al
    neighbor 2.0 bin 
    neigh_modify delay 10 check yes 
     
    # ---------- Define Settings --------------------- 
    compute eng all pe/atom 
    compute eatoms all reduce sum c_eng 

    # ---------- Run Minimization --------------------- 
    reset_timestep 0 
    fix 1 all box/relax iso 0.0 vmax 0.001
    thermo 10 
    thermo_style custom step pe lx ly lz press pxx pyy pzz c_eatoms 
    min_style cg 
    minimize 1e-25 1e-25 5000 10000 

    variable natoms equal "count(all)" 
    variable teng equal "c_eatoms"
    variable length equal "lx"
    variable ecoh equal "v_teng/v_natoms"

    print "Total energy (eV) = ${teng};"
    print "Number of atoms = ${natoms};"
    print "Lattice constant (Angstoms) = ${length};"
    print "Cohesive energy (eV) = ${ecoh};"

    print "All done!" 
    ```
3. 跑起来 `lmp_g++ < calc_fcc.in`
4. 输出
    ``` plain
    Total energy (eV) = -13.4399999527351;
    Number of atoms = 4;
    Lattice constant (Angstoms) = 4.05000466178543;
    Cohesive energy (eV) = -3.35999998818377;
    All done!
    Total wall time: 0:00:00
    ```

FIN    
    
    
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

![[title]](slug)


{% endraw %}
</div>
