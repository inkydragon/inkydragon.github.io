---
slug: heelo-haskell
title: Hello Haskell!
date: 2017-04-02 21:25:20
authors: cyhan
---

本来我只是去知乎上找一个大佬 [@雾雨魔理沙](https://www.zhihu.com/people/marisa.moe) 的Github

然后吃了安利(其实很早就吃了

>“大事化小，小事化无，以无事取天下”。把很小的东西，一个一个组合起来就可以得到一个非常非常复杂的程序。视频最后他说到IO的定义，IO以真实世界的状态为参数，返回真实世界新的状态跟一个类型为a的值，你会产生幻觉，以为真实世界不过是函数里的一个参数。Haskell的目的就是要观察这个世界，要改变这个世界，创造新的价值。
>
>—— [阅千人而惜知己](https://www.zhihu.com/question/27355585/answer/36405568)

<!-- truncate -->


>禅宗haskell
学习haskell更多时候并不是学语法学库而是进行一种哲学思考。所谓禅。
学习haskell时更多的思考方式是是什么。当python 以 import anti-gravity 翱翔青空时，haskeller 盘坐在地思考何为飞翔、何可谓飞翔。这大概就是飞机与歼星舰的命运岔口。
>
>初见IO定义（newtype IO a = IO (State# RealWorld -> (# State# RealWorld, a #)) ），鲜有人不为所动。何为IO、何为世界、何为IO之界限、若以人为机器何为IO、人意识的边界何在、我何以为我、人何以为人、多线程之间之IO、远程脑部内存共享的双子。恍惚间仿佛坐在菩提树下。
Free 与 Cofree 初见并无感。当思考着越来越多是什么的问题、而不是如何做的问题时，便时常有些闪光似的顿悟。DSL 与 Interpreter 、Rose tree与Tree、Behavior 与 Event，皆为一组Cofree 与 Free。
当js、java之流亦挂FRP于嘴边时，Haskeller 在思考着何为FRP？FRP根据定义就是以随时间改变的量为primitive 进行编程。可，何所谓时间？时间仅仅是像库中所写的是正实数吗？时间可数吗？对于平行宇宙（非线性时间）来说FRP又意味着什么？于是这时回首读情态逻辑时态逻辑。突然光着身子从浴缸里跳出来，在纸上写道、Behavior a = Cofree Next a ; Event a = Free Next a。会当临绝顶般。所谓时间、不同模型间的差别、也就是Next这个Functor的差别。
抽象、洞悉着世界、时间与我。
学习Haskell、正如放下了锄头、仰望着浩渺星河。
>
>—— [凉宫礼](https://www.zhihu.com/question/28284139/answer/86748228)


-----


>haskell想开始还是很容易的，但是想知道如何“学得差不多该收手了”就不是太容易了。在此我特别给出一个判断标准——一旦你弄懂了monad lifting，我觉得你就可以开始学别的了
>
>—— [vczh](http://zhihu.com/question/20193745/answer/22484139)


ref:

- [精通 Haskell 是一种怎样的体验？](https://www.zhihu.com/question/27355585)
- [如何学习 Haskell ？](https://www.zhihu.com/question/20193745)
- [Introduction to Functional Programming](https://www.edx.org/course/introduction-functional-programming-delftx-fp101x-0)
- [函數程式設計的商業應用](https://hackpad.com/ep/pad/static/PoPV1V9wVse)
- [这是我推荐的学习Haskell之路](https://github.com/bitemyapp/learnhaskell/blob/master/guide-zh_CN.md)

WTF?

- [如何解释 Haskell 中的单子？](https://www.zhihu.com/question/22291305)     
  简单的说单子(Monad)就是自函子范畴上的一个幺半群。
  - [Functor, Applicative, 以及 Monad 的图片阐释](http://jiyinyiyong.github.io/monads-in-pictures/)


你大概需要一点数学：

**范畴论**

- [怎样学范畴论？](https://www.zhihu.com/question/20448295)
