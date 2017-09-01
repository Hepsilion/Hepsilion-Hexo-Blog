---
title: C plus plus
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-05-28 19:03:50
tags: [C++]
categories: C/C++
description:
---

C++

<!--more-->

## 一、概述

## 二、基础语法

### 整型

一般我们把short称为短整型，把int称为整型，把long称为长整型，把long long称为超长整型。以unsigned开头的那些整数类型统称为无符号整型。例如：我们称unsigned short为无符号短整型，以此类推。

### 问：

https://www.nowcoder.com/profile/7404313/test/8046125/55536?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8046125/23331?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8078490/15721?onlyWrong=0

### 问：求一个整数二进制表示中1的个数

	int fun(int x){
	    int countx = 0;
	    while(x){
	        countx++;
	        x = x & (x – 1);
	    }
	    return countx;
	｝

### 问：fork

https://www.nowcoder.com/profile/7404313/test/7993780/1023?onlyWrong=0

### 问：各种数据类型的大小(单位Bytes)

	          32位系统        64位系统
   
	char         1              1

	short        2              2

	int          4              4 

	指针         4              8

	long         4              8

	float        4              4

	double       8              8

	long long    8

### 问：一道题目的分析

(y^(x^y)&-(x<y))求取二者的最小值
        如果x<y;则根据运算规则有，-(x<y)为-1，计算机中都是用补码表示数字的，所以计算机中-1表示为全1；所以在下一步的运算中(x^y)&-(x<y)得到的结果为(x^y)；之后y^(x^y),根据异或运算的交换略，y^y^x结果为x；
        如果x>y;则根据运算规则有，-(x<y)为-1，计算机中补码表示也是全为0，所以(x^y)&-(x<y)得到的结果为0，之后y^0为y；
综上所述，所以这个式子返回的是x和y的最小值。
经过以上的分析，我们可以很快推导出使用这些位运算计算二者最大值的方法，即(y^(x^y)&(x<y-1))或者(x^(x^y)&-(x<y))；具体的推导过程和上面的一样。

### strlen()

https://www.nowcoder.com/profile/7404313/test/8067207/7593?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8067759/14367?onlyWrong=0

### sizeof()

https://www.nowcoder.com/profile/7404313/test/8129752/7509?onlyWrong=0

## 三、函数与编译预处理

https://www.nowcoder.com/profile/7404313/test/8067759/15583?onlyWrong=0

## 四、数组

https://www.nowcoder.com/profile/7404313/test/8073682/15675?onlyWrong=0

## 五、结构体、共同体和枚举类型

### 问：内存对齐问题

https://www.nowcoder.com/profile/7404313/test/7994191/15948?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8114642/1239?onlyWrong=0

### 问：sizeof和内存对齐问题


sizeof(A) 计算A数据类型在栈中占用存储空间的大小 

	在64位系统中，有如下类：
	class C
	{
	public:
	    char a;
	    static char b;
	    void *p;
	    static int *c;
	    virtual void func1();
	    virtual void func2();
	};
	那么sizeof(C)的数值是24。

	类的静态成员存储在全局区，不再sizeof计算范围之内 
	a是char类型，占用一个字节；p是指针，在64位系统中，指针占用8个字节；两个虚函数只需要一个虚函数表指针，占用8个字节 
	由于计算机存储对齐方式，char a对齐时后面需要7个字节，因此总共需要24个字节

https://www.nowcoder.com/profile/7404313/test/7920678/6853?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/7933591/7511?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/7962026/2239?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8078490/15955?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8100790/15979?onlyWrong=0

### 问：strcat

https://www.nowcoder.com/profile/7404313/test/7933591/7583?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/7972569/7596?onlyWrong=0

## 六、指针和引用


### 问：指针与数组

https://www.nowcoder.com/profile/7404313/test/8089088/7538?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/7977962/14465?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/7993925/1147?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8046849/55478

https://www.nowcoder.com/profile/7404313/test/8089088/50572?onlyWrong=0

https://www.nowcoder.com/profile/7404313/test/8129752/7742?onlyWrong=0

## 七、类和对象

## 八、构造函数和析构函数

## 九、继承和派生类

### 问：访问修饰符

https://www.nowcoder.com/profile/7404313/test/7977669/3252?onlyWrong=0

## 十、类的其他特性：友元函数、友元类、虚函数等

## 十一、运算符重载

## 十二、输入输出流库

### 问：feof()函数

从文件输入流读取数据，如果到达文件末尾(遇到文件结束符)，feof()函数值为非零值，否则为0

## 十三、 STL

### 问：C++ STL的底层实现(未验证)
- (1) vector  底层数据结构为数组 ，支持快速随机访问
- (2) list    底层数据结构为双向链表，支持快速增删
- (3) deque   底层数据结构为一个中央控制器和多个缓冲区，详细见STL源码剖析P146，支持首尾（中间不能）快速增删，也支持随机访问
- (4) stack   底层一般用23实现，封闭头部即可，不用vector的原因应该是容量大小有限制，扩容耗时
- (5) queue   底层一般用23实现，封闭头部即可，不用vector的原因应该是容量大小有限制，扩容耗时
	
	45是适配器,而不叫容器，因为是对容器的再封装
- (6) priority_queue 的底层数据结构一般为vector为底层容器，堆heap为处理规则来管理底层容器实现
- (7) set       底层数据结构为红黑树，有序，不重复
- (8) multiset  底层数据结构为红黑树，有序，可重复 
- (9) map      ﻿﻿﻿﻿底层数据结构为红黑树，有序，不重复
- (10) multimap 底层数据结构为红黑树，有序，可重复
- (11) hash_set ﻿﻿﻿﻿底层数据结构为hash表，无序，不重复
- (12) hash_multiset 底层数据结构为hash表，无序，可重复 
- (13) hash_map      ﻿﻿﻿﻿底层数据结构为hash表，无序，不重复
- (14) hash_multimap 底层数据结构为hash表，无序，可重复 


## qita

### 问：递归程序的优化手段

尾递归，迭代，循环

https://www.nowcoder.com/profile/7404313/test/8066549/25830?onlyWrong=0

### 问：new/delete和malloc/free的区别

https://www.nowcoder.com/profile/7404313/test/8073949/14565?onlyWrong=0




https://www.nowcoder.com/profile/7404313/test/8078490/4286?onlyWrong=0


### static

https://www.nowcoder.com/profile/7404313/test/8100790/14879?onlyWrong=0

### clone和fork

https://www.nowcoder.com/profile/7404313/test/8322129/14900?onlyWrong=0


