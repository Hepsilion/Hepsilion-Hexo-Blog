---
title: 01-Java概述
thumbnail: 'https://cdn.pixabay.com/photo/2014/04/03/11/08/tea-311844__340.png'
date: 2017-02-13 17:22:19
tags: [Java]
categories: Java基础
description:
---

Java概述

<!--more-->

推荐阅读：[近5年133个Java面试问题列表](http://www.codeceo.com/article/133-java-interview-5-years.html)

推荐阅读：[Java笔试面试题整理第一波](http://blog.csdn.net/shakespeare001/article/details/51151650)，[第二波](http://blog.csdn.net/shakespeare001/article/details/51200163)，[第三波](http://blog.csdn.net/shakespeare001/article/details/51247785)，[第四波](http://blog.csdn.net/shakespeare001/article/details/51274685)，[第五波](http://blog.csdn.net/shakespeare001/article/details/51321498)已包含大部分，[第六波（修正版）](http://blog.csdn.net/shakespeare001/article/details/51330745)线程池未包含，[第七波](http://blog.csdn.net/shakespeare001/article/details/51388516)NIO和IO未包含，[第八波](http://blog.csdn.net/shakespeare001/article/details/51669476)

### 问：什么是Java虚拟机？为什么Java被称作是“平台无关的编程语言”？

Java源文件被javac编译成能被Java虚拟机执行的.class字节码文件，Java虚拟机是一个可以执行Java字节码的虚拟机进程，它拥有自己完善的硬件架构，如堆栈、寄存器，还具有相应的指令系统。

Java虚拟机对开发者屏蔽了与具体操作系统平台相关的信息，使得Java源文件只需要被编译成可以在JVM上运行的字节码文件，就可以由**相应平台的虚拟机**在具体平台上解释运行，从而实现一次编译，处处执行。这样，Java被设计成允许应用程序可以运行在任意的平台上，而不需要程序员为每一个平台单独重写或者是重新编译。

### 问：动态语言和静态语言

动态语言：运行时执行类型检查，如PHP、Ruby、Python等。

静态语言：编译时执行类型检查，如C、C++、Java和C#等。

例1：比较一下Java和JavaSciprt

	Java和JavaScript最重要的区别是一个是静态语言，一个是动态语言

### 问：编译型语言和解释型语言

<a href="https://www.nowcoder.com/profile/7404313/test/8049404/3231?onlyWrong=0" title="Title">例1</a>

### 问：JDK和JRE的区别是什么？

Java运行时环境(JRE)包括Java虚拟机、Java核心类库和支持文件，JVM对Java字节码文件进行解释执行。只有JRE只能执行Java程序，不能进行java程序的开发。

Java开发工具包(JDK)是完整的Java软件开发包，包含了JRE，编译器和其他的工具(比如：JavaDoc，Java调试器)，可以让开发者开发、编译、执行Java应用程序。

<a href="https://www.nowcoder.com/profile/7404313/test/8078128/56325?onlyWrong=0" title="Title">例1：</a>

	JRE判断程序是否执行结束的标准是：所有的前台线程执行完毕

### 问：一个".java"源文件中是否可以包含多个类(不是内部类)？有什么限制？

一个".java"源文件中可以包含多个类，但最多只能有一个public类。如果某一个类的修饰符是public，其类名与文件名必须相同。

例1：Java代码查错

	Something类的文件名叫OtherThing.java，其中定义的代码如下：
	class Something {
		public static void main(String[] args) {
			System.out.println("Do something ...");
		}
	}

	正确。Java中Class名字不一定要和其文件名相同，但public class的名字必须和文件名相同。
	但是这里的main方法不是程序的入口，只能被Something对象调用。

### 问：javac

<a href="https://www.nowcoder.com/profile/7404313/test/8078128/973?onlyWrong=0" title="Title">例1：</a>下列说法正确的有哪些？

	A. 环境变量可在编译source code时指定
	B. 在编译程序时，所能指定的环境变量不包括class path
	C. javac一次可同时编译数个Java源文件
	D. javac.exe能指定编译结果要置于哪个目录（directory）

	答案：A C D

### 问：JAVA的事件委托机制和垃圾回收机制

Java事件委托机制：一个源产生一个事件并将它送到一个或多个监听器那里。在这种方案中，监听器简单的等待，直到它收到一个事件。一旦事件被接受，监听器将处理这个事件，然后返回。

垃圾回收机制：垃圾收集是将分配给对象但不再使用的内存回收或释放的过程。如果一个对象没有指向它的引用或者其赋值为null，则此对象适合进行垃圾回收。

### 问：assertion(断言)

assertion(断言)是软件开发中常用的一种调试方式，很多开发语言都支持这种机制。

在实现中，assertion就是在程序中的一条语句，它对一个boolean表达式进行检查，一个正确程序必须保证这个boolean表达式的值为true；如果该值为false，说明程序已经处于不正确的状态下，assert将给出警告或退出。

一般来说，assertion用于保证程序最基本、关键的正确性。assertion检查通常在开发和测试时开启；为了提高性能，在软件发布后，assertion检查通常是关闭的。

例1：

	public class Test {
		public static void main(String[] args) throws Exception {
			int i = 0;
			for (i = 0; i < 5; i++) {
				System.out.println(i);
			}
			// 假设程序不小心多了一句--i;
			--i;
			assert i == 5;
		}
	}

	运行：Run --> Run Configurations... --> 选择Arguments选项卡 --> 在VM arguments文本框中输入：-ea 
	注意：中间没有空格，如果输入 -da 表示禁止断言。
