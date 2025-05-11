---
title: UNet 语义分割
date: 2019-01-17 17:09:05
categories:
tags:
description:
---


<!--more-->

**links**
- [UNet@github - Search · unet](https://github.com/search?q=unet)

- [jakeret/tf_unet: Generic U-Net Tensorflow implementation for image segmentation](https://github.com/jakeret/tf_unet)
- [zhixuhao/unet: unet for image segmentation](https://github.com/zhixuhao/unet)
- [milesial/Pytorch-UNet: Pytorch implementation of the U-Net for image semantic segmentation, with dense CRF post-processing](https://github.com/milesial/Pytorch-UNet)


## tf_unet

### 安装
直接下载 zip 然后 `python setup.py install`

### test
先试试 demo

1. [toy problem](https://github.com/jakeret/tf_unet/blob/master/demo/demo_toy_problem.ipynb)


`In  [9]`: 训练输出
```
2019-01-17 16:22:51,042 Removing 'C:\tf-tools\notebooks\tf_unet-demo\prediction'
2019-01-17 16:22:51,042 Removing 'C:\tf-tools\notebooks\tf_unet-demo\unet_trained'
2019-01-17 16:22:51,042 Allocating 'C:\tf-tools\notebooks\tf_unet-demo\prediction'
2019-01-17 16:22:51,042 Allocating 'C:\tf-tools\notebooks\tf_unet-demo\unet_trained'
2019-01-17 16:22:55,601 Verification error= 83.6%, loss= 0.7306
2019-01-17 16:22:56,329 Start optimization
2019-01-17 16:22:59,739 Iter 0, Minibatch Loss= 0.6512, Training Accuracy= 0.8080, Minibatch error= 19.2%
2019-01-17 16:23:05,081 Iter 2, Minibatch Loss= 0.5293, Training Accuracy= 0.8856, Minibatch error= 11.4%
2019-01-17 16:23:10,418 Iter 4, Minibatch Loss= 0.5252, Training Accuracy= 0.8146, Minibatch error= 18.5%
2019-01-17 16:23:15,751 Iter 6, Minibatch Loss= 0.4352, Training Accuracy= 0.8623, Minibatch error= 13.8%
2019-01-17 16:23:21,046 Iter 8, Minibatch Loss= 0.4165, Training Accuracy= 0.8612, Minibatch error= 13.9%
2019-01-17 16:23:26,416 Iter 10, Minibatch Loss= 0.5086, Training Accuracy= 0.7926, Minibatch error= 20.7%
2019-01-17 16:23:31,710 Iter 12, Minibatch Loss= 0.4523, Training Accuracy= 0.8283, Minibatch error= 17.2%
2019-01-17 16:23:37,024 Iter 14, Minibatch Loss= 0.4277, Training Accuracy= 0.8386, Minibatch error= 16.1%
2019-01-17 16:23:42,305 Iter 16, Minibatch Loss= 0.4164, Training Accuracy= 0.8418, Minibatch error= 15.8%
2019-01-17 16:23:47,600 Iter 18, Minibatch Loss= 0.4820, Training Accuracy= 0.7907, Minibatch error= 20.9%
2019-01-17 16:23:52,896 Iter 20, Minibatch Loss= 0.4282, Training Accuracy= 0.8052, Minibatch error= 19.5%
2019-01-17 16:23:58,186 Iter 22, Minibatch Loss= 0.3110, Training Accuracy= 0.8684, Minibatch error= 13.2%
2019-01-17 16:24:03,460 Iter 24, Minibatch Loss= 0.3316, Training Accuracy= 0.8389, Minibatch error= 16.1%
2019-01-17 16:24:08,755 Iter 26, Minibatch Loss= 0.3921, Training Accuracy= 0.7702, Minibatch error= 23.0%
2019-01-17 16:24:13,996 Iter 28, Minibatch Loss= 0.2517, Training Accuracy= 0.8531, Minibatch error= 14.7%
2019-01-17 16:24:19,298 Iter 30, Minibatch Loss= 0.2652, Training Accuracy= 0.8384, Minibatch error= 16.2%
2019-01-17 16:24:21,582 Epoch 0, Average loss: 0.4484, learning rate: 0.2000
2019-01-17 16:24:25,771 Verification error= 16.4%, loss= 0.2707
2019-01-17 16:24:29,473 Iter 32, Minibatch Loss= 0.3241, Training Accuracy= 0.8262, Minibatch error= 17.4%
2019-01-17 16:24:34,822 Iter 34, Minibatch Loss= 0.2910, Training Accuracy= 0.8377, Minibatch error= 16.2%
2019-01-17 16:24:40,111 Iter 36, Minibatch Loss= 0.2190, Training Accuracy= 0.8473, Minibatch error= 15.3%
2019-01-17 16:24:45,426 Iter 38, Minibatch Loss= 0.2349, Training Accuracy= 0.8109, Minibatch error= 18.9%
2019-01-17 16:24:50,710 Iter 40, Minibatch Loss= 0.1724, Training Accuracy= 0.9142, Minibatch error= 8.6%
2019-01-17 16:24:56,041 Iter 42, Minibatch Loss= 0.3241, Training Accuracy= 0.9870, Minibatch error= 1.3%
2019-01-17 16:25:01,328 Iter 44, Minibatch Loss= 0.5105, Training Accuracy= 0.8000, Minibatch error= 20.0%
2019-01-17 16:25:06,634 Iter 46, Minibatch Loss= 0.5155, Training Accuracy= 0.8191, Minibatch error= 18.1%
2019-01-17 16:25:11,941 Iter 48, Minibatch Loss= 0.4319, Training Accuracy= 0.8362, Minibatch error= 16.4%
2019-01-17 16:25:17,206 Iter 50, Minibatch Loss= 0.3709, Training Accuracy= 0.8343, Minibatch error= 16.6%
2019-01-17 16:25:22,498 Iter 52, Minibatch Loss= 0.2181, Training Accuracy= 0.8612, Minibatch error= 13.9%
2019-01-17 16:25:27,942 Iter 54, Minibatch Loss= 0.2650, Training Accuracy= 0.8012, Minibatch error= 19.9%
2019-01-17 16:25:33,267 Iter 56, Minibatch Loss= 0.1242, Training Accuracy= 0.9555, Minibatch error= 4.5%
2019-01-17 16:25:38,621 Iter 58, Minibatch Loss= 0.1178, Training Accuracy= 0.9903, Minibatch error= 1.0%
2019-01-17 16:25:43,918 Iter 60, Minibatch Loss= 0.1130, Training Accuracy= 0.9714, Minibatch error= 2.9%
2019-01-17 16:25:49,217 Iter 62, Minibatch Loss= 0.1626, Training Accuracy= 0.9634, Minibatch error= 3.7%
2019-01-17 16:25:51,532 Epoch 1, Average loss: 0.3612, learning rate: 0.1900
2019-01-17 16:25:55,679 Verification error= 2.4%, loss= 0.1147
2019-01-17 16:25:59,290 Iter 64, Minibatch Loss= 0.0840, Training Accuracy= 0.9861, Minibatch error= 1.4%
2019-01-17 16:26:04,594 Iter 66, Minibatch Loss= 0.0518, Training Accuracy= 0.9930, Minibatch error= 0.7%
2019-01-17 16:26:09,847 Iter 68, Minibatch Loss= 1.1384, Training Accuracy= 0.8162, Minibatch error= 18.4%
2019-01-17 16:26:15,093 Iter 70, Minibatch Loss= 0.3287, Training Accuracy= 0.8507, Minibatch error= 14.9%
2019-01-17 16:26:20,364 Iter 72, Minibatch Loss= 0.3342, Training Accuracy= 0.8384, Minibatch error= 16.2%
2019-01-17 16:26:25,651 Iter 74, Minibatch Loss= 0.2682, Training Accuracy= 0.8325, Minibatch error= 16.8%
2019-01-17 16:26:30,919 Iter 76, Minibatch Loss= 0.2397, Training Accuracy= 0.8986, Minibatch error= 10.1%
2019-01-17 16:26:36,186 Iter 78, Minibatch Loss= 0.1391, Training Accuracy= 0.9542, Minibatch error= 4.6%
2019-01-17 16:26:41,468 Iter 80, Minibatch Loss= 0.1729, Training Accuracy= 0.9653, Minibatch error= 3.5%
2019-01-17 16:26:46,741 Iter 82, Minibatch Loss= 0.1837, Training Accuracy= 0.9620, Minibatch error= 3.8%
2019-01-17 16:26:52,055 Iter 84, Minibatch Loss= 0.1260, Training Accuracy= 0.9795, Minibatch error= 2.1%
2019-01-17 16:26:57,332 Iter 86, Minibatch Loss= 0.0863, Training Accuracy= 0.9818, Minibatch error= 1.8%
2019-01-17 16:27:02,617 Iter 88, Minibatch Loss= 0.0652, Training Accuracy= 0.9909, Minibatch error= 0.9%
2019-01-17 16:27:07,903 Iter 90, Minibatch Loss= 0.0740, Training Accuracy= 0.9816, Minibatch error= 1.8%
2019-01-17 16:27:13,156 Iter 92, Minibatch Loss= 0.0507, Training Accuracy= 0.9912, Minibatch error= 0.9%
2019-01-17 16:27:18,405 Iter 94, Minibatch Loss= 0.0964, Training Accuracy= 0.9741, Minibatch error= 2.6%
2019-01-17 16:27:20,733 Epoch 2, Average loss: 0.2562, learning rate: 0.1805
2019-01-17 16:27:24,875 Verification error= 2.5%, loss= 0.0924
2019-01-17 16:27:28,556 Iter 96, Minibatch Loss= 0.0784, Training Accuracy= 0.9854, Minibatch error= 1.5%
2019-01-17 16:27:33,853 Iter 98, Minibatch Loss= 0.0456, Training Accuracy= 0.9832, Minibatch error= 1.7%
2019-01-17 16:27:39,133 Iter 100, Minibatch Loss= 0.0267, Training Accuracy= 0.9925, Minibatch error= 0.7%
2019-01-17 16:27:44,408 Iter 102, Minibatch Loss= 0.3735, Training Accuracy= 0.9380, Minibatch error= 6.2%
2019-01-17 16:27:49,640 Iter 104, Minibatch Loss= 0.2342, Training Accuracy= 0.9374, Minibatch error= 6.3%
2019-01-17 16:27:54,910 Iter 106, Minibatch Loss= 0.0630, Training Accuracy= 0.9861, Minibatch error= 1.4%
2019-01-17 16:28:00,208 Iter 108, Minibatch Loss= 0.1137, Training Accuracy= 0.9665, Minibatch error= 3.3%
2019-01-17 16:28:05,474 Iter 110, Minibatch Loss= 0.0305, Training Accuracy= 0.9939, Minibatch error= 0.6%
2019-01-17 16:28:10,781 Iter 112, Minibatch Loss= 0.0730, Training Accuracy= 0.9821, Minibatch error= 1.8%
2019-01-17 16:28:16,082 Iter 114, Minibatch Loss= 0.1063, Training Accuracy= 0.9686, Minibatch error= 3.1%
2019-01-17 16:28:21,382 Iter 116, Minibatch Loss= 0.0299, Training Accuracy= 0.9926, Minibatch error= 0.7%
2019-01-17 16:28:26,684 Iter 118, Minibatch Loss= 0.0460, Training Accuracy= 0.9887, Minibatch error= 1.1%
2019-01-17 16:28:31,972 Iter 120, Minibatch Loss= 0.0254, Training Accuracy= 0.9921, Minibatch error= 0.8%
2019-01-17 16:28:37,204 Iter 122, Minibatch Loss= 0.1169, Training Accuracy= 0.9667, Minibatch error= 3.3%
2019-01-17 16:28:42,492 Iter 124, Minibatch Loss= 0.0874, Training Accuracy= 0.9725, Minibatch error= 2.7%
2019-01-17 16:28:47,743 Iter 126, Minibatch Loss= 0.5020, Training Accuracy= 0.8702, Minibatch error= 13.0%
2019-01-17 16:28:50,009 Epoch 3, Average loss: 0.2336, learning rate: 0.1715
2019-01-17 16:28:54,170 Verification error= 16.4%, loss= 0.5567
2019-01-17 16:28:57,815 Iter 128, Minibatch Loss= 0.5226, Training Accuracy= 0.8638, Minibatch error= 13.6%
2019-01-17 16:29:03,097 Iter 130, Minibatch Loss= 0.5033, Training Accuracy= 0.8408, Minibatch error= 15.9%
2019-01-17 16:29:08,406 Iter 132, Minibatch Loss= 0.4949, Training Accuracy= 0.8030, Minibatch error= 19.7%
2019-01-17 16:29:13,673 Iter 134, Minibatch Loss= 0.5114, Training Accuracy= 0.7627, Minibatch error= 23.7%
2019-01-17 16:29:18,954 Iter 136, Minibatch Loss= 0.4883, Training Accuracy= 0.7718, Minibatch error= 22.8%
2019-01-17 16:29:24,255 Iter 138, Minibatch Loss= 0.3982, Training Accuracy= 0.8319, Minibatch error= 16.8%
2019-01-17 16:29:29,572 Iter 140, Minibatch Loss= 0.3953, Training Accuracy= 0.8387, Minibatch error= 16.1%
2019-01-17 16:29:34,835 Iter 142, Minibatch Loss= 0.3645, Training Accuracy= 0.8506, Minibatch error= 14.9%
2019-01-17 16:29:40,087 Iter 144, Minibatch Loss= 0.3818, Training Accuracy= 0.8297, Minibatch error= 17.0%
2019-01-17 16:29:45,389 Iter 146, Minibatch Loss= 0.4327, Training Accuracy= 0.7944, Minibatch error= 20.6%
2019-01-17 16:29:50,685 Iter 148, Minibatch Loss= 0.3011, Training Accuracy= 0.8759, Minibatch error= 12.4%
2019-01-17 16:29:55,981 Iter 150, Minibatch Loss= 0.3775, Training Accuracy= 0.8108, Minibatch error= 18.9%
2019-01-17 16:30:01,255 Iter 152, Minibatch Loss= 0.3941, Training Accuracy= 0.8139, Minibatch error= 18.6%
2019-01-17 16:30:06,572 Iter 154, Minibatch Loss= 0.2709, Training Accuracy= 0.8662, Minibatch error= 13.4%
2019-01-17 16:30:11,890 Iter 156, Minibatch Loss= 0.3435, Training Accuracy= 0.8219, Minibatch error= 17.8%
2019-01-17 16:30:17,197 Iter 158, Minibatch Loss= 0.3827, Training Accuracy= 0.7782, Minibatch error= 22.2%
2019-01-17 16:30:19,526 Epoch 4, Average loss: 0.4181, learning rate: 0.1629
2019-01-17 16:30:23,652 Verification error= 16.4%, loss= 0.3178
2019-01-17 16:30:27,286 Iter 160, Minibatch Loss= 0.2966, Training Accuracy= 0.8347, Minibatch error= 16.5%
2019-01-17 16:30:32,566 Iter 162, Minibatch Loss= 0.2189, Training Accuracy= 0.8726, Minibatch error= 12.7%
2019-01-17 16:30:37,883 Iter 164, Minibatch Loss= 0.2557, Training Accuracy= 0.8495, Minibatch error= 15.0%
2019-01-17 16:30:43,206 Iter 166, Minibatch Loss= 0.3402, Training Accuracy= 0.8823, Minibatch error= 11.8%
2019-01-17 16:30:48,496 Iter 168, Minibatch Loss= 0.1480, Training Accuracy= 0.9679, Minibatch error= 3.2%
2019-01-17 16:30:53,810 Iter 170, Minibatch Loss= 0.2154, Training Accuracy= 0.9359, Minibatch error= 6.4%
2019-01-17 16:30:59,104 Iter 172, Minibatch Loss= 0.1586, Training Accuracy= 0.9586, Minibatch error= 4.1%
2019-01-17 16:31:04,395 Iter 174, Minibatch Loss= 0.1019, Training Accuracy= 0.9815, Minibatch error= 1.8%
2019-01-17 16:31:09,650 Iter 176, Minibatch Loss= 0.1003, Training Accuracy= 0.9767, Minibatch error= 2.3%
2019-01-17 16:31:14,932 Iter 178, Minibatch Loss= 0.1826, Training Accuracy= 0.9438, Minibatch error= 5.6%
2019-01-17 16:31:20,194 Iter 180, Minibatch Loss= 0.1051, Training Accuracy= 0.9870, Minibatch error= 1.3%
2019-01-17 16:31:25,477 Iter 182, Minibatch Loss= 0.0799, Training Accuracy= 0.9843, Minibatch error= 1.6%
2019-01-17 16:31:30,782 Iter 184, Minibatch Loss= 0.0405, Training Accuracy= 0.9948, Minibatch error= 0.5%
2019-01-17 16:31:36,059 Iter 186, Minibatch Loss= 0.1315, Training Accuracy= 0.9689, Minibatch error= 3.1%
2019-01-17 16:31:41,344 Iter 188, Minibatch Loss= 0.3805, Training Accuracy= 0.8188, Minibatch error= 18.1%
2019-01-17 16:31:46,630 Iter 190, Minibatch Loss= 0.1696, Training Accuracy= 0.9477, Minibatch error= 5.2%
2019-01-17 16:31:48,961 Epoch 5, Average loss: 0.2408, learning rate: 0.1548
2019-01-17 16:31:53,119 Verification error= 5.9%, loss= 0.1899
2019-01-17 16:31:56,803 Iter 192, Minibatch Loss= 0.1079, Training Accuracy= 0.9774, Minibatch error= 2.3%
2019-01-17 16:32:02,117 Iter 194, Minibatch Loss= 0.2702, Training Accuracy= 0.9145, Minibatch error= 8.6%
2019-01-17 16:32:07,449 Iter 196, Minibatch Loss= 0.2199, Training Accuracy= 0.9271, Minibatch error= 7.3%
2019-01-17 16:32:12,688 Iter 198, Minibatch Loss= 0.1953, Training Accuracy= 0.9491, Minibatch error= 5.1%
2019-01-17 16:32:17,990 Iter 200, Minibatch Loss= 0.0888, Training Accuracy= 0.9800, Minibatch error= 2.0%
2019-01-17 16:32:23,256 Iter 202, Minibatch Loss= 0.0490, Training Accuracy= 0.9910, Minibatch error= 0.9%
2019-01-17 16:32:28,571 Iter 204, Minibatch Loss= 0.0813, Training Accuracy= 0.9833, Minibatch error= 1.7%
2019-01-17 16:32:33,892 Iter 206, Minibatch Loss= 0.0951, Training Accuracy= 0.9790, Minibatch error= 2.1%
2019-01-17 16:32:39,194 Iter 208, Minibatch Loss= 0.0246, Training Accuracy= 0.9950, Minibatch error= 0.5%
2019-01-17 16:32:44,505 Iter 210, Minibatch Loss= 0.0316, Training Accuracy= 0.9942, Minibatch error= 0.6%
2019-01-17 16:32:49,744 Iter 212, Minibatch Loss= 0.0196, Training Accuracy= 0.9966, Minibatch error= 0.3%
2019-01-17 16:32:55,049 Iter 214, Minibatch Loss= 0.0507, Training Accuracy= 0.9858, Minibatch error= 1.4%
2019-01-17 16:33:00,326 Iter 216, Minibatch Loss= 0.0650, Training Accuracy= 0.9848, Minibatch error= 1.5%
2019-01-17 16:33:05,638 Iter 218, Minibatch Loss= 0.0714, Training Accuracy= 0.9790, Minibatch error= 2.1%
2019-01-17 16:33:10,936 Iter 220, Minibatch Loss= 0.0555, Training Accuracy= 0.9828, Minibatch error= 1.7%
2019-01-17 16:33:16,242 Iter 222, Minibatch Loss= 0.0308, Training Accuracy= 0.9921, Minibatch error= 0.8%
2019-01-17 16:33:18,558 Epoch 6, Average loss: 0.1296, learning rate: 0.1470
2019-01-17 16:33:22,700 Verification error= 2.1%, loss= 0.0722
2019-01-17 16:33:26,331 Iter 224, Minibatch Loss= 0.1549, Training Accuracy= 0.9671, Minibatch error= 3.3%
2019-01-17 16:33:31,614 Iter 226, Minibatch Loss= 0.1257, Training Accuracy= 0.9534, Minibatch error= 4.7%
2019-01-17 16:33:36,926 Iter 228, Minibatch Loss= 0.1351, Training Accuracy= 0.9588, Minibatch error= 4.1%
2019-01-17 16:33:42,226 Iter 230, Minibatch Loss= 0.0934, Training Accuracy= 0.9698, Minibatch error= 3.0%
2019-01-17 16:33:47,525 Iter 232, Minibatch Loss= 0.0634, Training Accuracy= 0.9869, Minibatch error= 1.3%
2019-01-17 16:33:52,812 Iter 234, Minibatch Loss= 0.0370, Training Accuracy= 0.9931, Minibatch error= 0.7%
2019-01-17 16:33:58,115 Iter 236, Minibatch Loss= 0.1251, Training Accuracy= 0.9645, Minibatch error= 3.5%
2019-01-17 16:34:03,421 Iter 238, Minibatch Loss= 0.1112, Training Accuracy= 0.9585, Minibatch error= 4.1%
2019-01-17 16:34:08,747 Iter 240, Minibatch Loss= 0.0808, Training Accuracy= 0.9774, Minibatch error= 2.3%
2019-01-17 16:34:14,034 Iter 242, Minibatch Loss= 0.0967, Training Accuracy= 0.9825, Minibatch error= 1.8%
2019-01-17 16:34:19,307 Iter 244, Minibatch Loss= 0.7343, Training Accuracy= 0.1848, Minibatch error= 81.5%
2019-01-17 16:34:24,555 Iter 246, Minibatch Loss= 0.6752, Training Accuracy= 0.7614, Minibatch error= 23.9%
2019-01-17 16:34:29,859 Iter 248, Minibatch Loss= 0.6029, Training Accuracy= 0.8163, Minibatch error= 18.4%
2019-01-17 16:34:35,109 Iter 250, Minibatch Loss= 0.4280, Training Accuracy= 0.8306, Minibatch error= 16.9%
2019-01-17 16:34:40,388 Iter 252, Minibatch Loss= 0.3900, Training Accuracy= 0.8003, Minibatch error= 20.0%
2019-01-17 16:34:45,648 Iter 254, Minibatch Loss= 0.3311, Training Accuracy= 0.8494, Minibatch error= 15.1%
2019-01-17 16:34:47,961 Epoch 7, Average loss: 0.4247, learning rate: 0.1397
2019-01-17 16:34:52,103 Verification error= 16.4%, loss= 0.3835
2019-01-17 16:34:55,751 Iter 256, Minibatch Loss= 0.3205, Training Accuracy= 0.8524, Minibatch error= 14.8%
2019-01-17 16:35:01,023 Iter 258, Minibatch Loss= 0.3582, Training Accuracy= 0.8260, Minibatch error= 17.4%
2019-01-17 16:35:06,244 Iter 260, Minibatch Loss= 0.4102, Training Accuracy= 0.7881, Minibatch error= 21.2%
2019-01-17 16:35:11,511 Iter 262, Minibatch Loss= 0.3563, Training Accuracy= 0.8399, Minibatch error= 16.0%
2019-01-17 16:35:16,794 Iter 264, Minibatch Loss= 0.2400, Training Accuracy= 0.8644, Minibatch error= 13.6%
2019-01-17 16:35:21,995 Iter 266, Minibatch Loss= 0.3194, Training Accuracy= 0.8486, Minibatch error= 15.1%
2019-01-17 16:35:27,248 Iter 268, Minibatch Loss= 0.3416, Training Accuracy= 0.8125, Minibatch error= 18.7%
2019-01-17 16:35:32,515 Iter 270, Minibatch Loss= 0.3628, Training Accuracy= 0.7980, Minibatch error= 20.2%
2019-01-17 16:35:37,797 Iter 272, Minibatch Loss= 0.3280, Training Accuracy= 0.8537, Minibatch error= 14.6%
2019-01-17 16:35:43,082 Iter 274, Minibatch Loss= 0.2479, Training Accuracy= 0.9185, Minibatch error= 8.1%
2019-01-17 16:35:48,379 Iter 276, Minibatch Loss= 0.1780, Training Accuracy= 0.9370, Minibatch error= 6.3%
2019-01-17 16:35:53,658 Iter 278, Minibatch Loss= 0.2258, Training Accuracy= 0.9344, Minibatch error= 6.6%
2019-01-17 16:35:58,926 Iter 280, Minibatch Loss= 0.2368, Training Accuracy= 0.9337, Minibatch error= 6.6%
2019-01-17 16:36:04,237 Iter 282, Minibatch Loss= 0.2266, Training Accuracy= 0.9692, Minibatch error= 3.1%
2019-01-17 16:36:09,499 Iter 284, Minibatch Loss= 0.2171, Training Accuracy= 0.9249, Minibatch error= 7.5%
2019-01-17 16:36:14,763 Iter 286, Minibatch Loss= 0.1827, Training Accuracy= 0.9695, Minibatch error= 3.1%
2019-01-17 16:36:17,070 Epoch 8, Average loss: 0.3494, learning rate: 0.1327
2019-01-17 16:36:21,228 Verification error= 3.7%, loss= 0.1582
2019-01-17 16:36:24,904 Iter 288, Minibatch Loss= 0.1065, Training Accuracy= 0.9821, Minibatch error= 1.8%
2019-01-17 16:36:30,149 Iter 290, Minibatch Loss= 0.1325, Training Accuracy= 0.9680, Minibatch error= 3.2%
2019-01-17 16:36:35,465 Iter 292, Minibatch Loss= 0.1703, Training Accuracy= 0.9527, Minibatch error= 4.7%
2019-01-17 16:36:40,763 Iter 294, Minibatch Loss= 0.2358, Training Accuracy= 0.9333, Minibatch error= 6.7%
2019-01-17 16:36:46,005 Iter 296, Minibatch Loss= 0.0860, Training Accuracy= 0.9825, Minibatch error= 1.8%
2019-01-17 16:36:51,315 Iter 298, Minibatch Loss= 0.2047, Training Accuracy= 0.9538, Minibatch error= 4.6%
2019-01-17 16:36:56,592 Iter 300, Minibatch Loss= 0.0490, Training Accuracy= 0.9927, Minibatch error= 0.7%
2019-01-17 16:37:01,871 Iter 302, Minibatch Loss= 0.1494, Training Accuracy= 0.9607, Minibatch error= 3.9%
2019-01-17 16:37:07,120 Iter 304, Minibatch Loss= 0.1179, Training Accuracy= 0.9698, Minibatch error= 3.0%
2019-01-17 16:37:12,388 Iter 306, Minibatch Loss= 0.0784, Training Accuracy= 0.9743, Minibatch error= 2.6%
2019-01-17 16:37:17,732 Iter 308, Minibatch Loss= 0.0344, Training Accuracy= 0.9943, Minibatch error= 0.6%
2019-01-17 16:37:23,017 Iter 310, Minibatch Loss= 0.0657, Training Accuracy= 0.9804, Minibatch error= 2.0%
2019-01-17 16:37:28,270 Iter 312, Minibatch Loss= 0.0557, Training Accuracy= 0.9842, Minibatch error= 1.6%
2019-01-17 16:37:33,513 Iter 314, Minibatch Loss= 0.1459, Training Accuracy= 0.9552, Minibatch error= 4.5%
2019-01-17 16:37:38,809 Iter 316, Minibatch Loss= 0.4844, Training Accuracy= 0.7741, Minibatch error= 22.6%
2019-01-17 16:37:44,076 Iter 318, Minibatch Loss= 0.2755, Training Accuracy= 0.8480, Minibatch error= 15.2%
2019-01-17 16:37:46,373 Epoch 9, Average loss: 0.2401, learning rate: 0.1260
2019-01-17 16:37:50,500 Verification error= 16.4%, loss= 0.2895
2019-01-17 16:37:51,202 Optimization Finished!
```

最后测试的时候输出全黑。有问题。
把第四句改成 `mask = prediction[0,...,1] > 0.1` 最后的阈值改成 0.1 才有像样的输出。
暂未找到原因

![](toy-1.png)


2. [Radio Frequency Interference mitigation](https://github.com/jakeret/tf_unet/blob/master/demo/demo_radio_data.ipynb)
