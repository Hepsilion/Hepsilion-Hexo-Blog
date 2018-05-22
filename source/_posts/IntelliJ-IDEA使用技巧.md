---
title: IntelliJ IDEA使用技巧
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2018-05-22 16:53:42
tags: 
categories: 工具使用
description:
---

<!--more-->

# IntelliJ IDEA使用技巧

## 一、高效定位代码

- 打开搜索框: `Ctrl+Shift+A`
- 查看所有快捷键： `Ctrl+Shift+A`打开搜索框，输入keymap
- 打开或关闭某个窗口，可以从View->Tool Window看到对应的命令： `Alt+数字`  

#### 1. 代码跳转

##### 项目之间跳转

- 切换到前一个项目/后一个项目：`Ctrl+Alt+左括号/右括号` 

##### 文件之间跳转

- 最近打开的文件：`Ctrl+E`
- 最近修改的文件：`Alt+Shift+C` 

##### 利用书签跳转

可以在搜索命令框搜索bookmark

- 显示书签： `Shift+F11`
- 设置无序书签： `F11`
- 设置有序书签： `Ctrl+F11，然后设置序号`
- 跳转到各个书签位置： `Ctrl+序号`，例如 Ctrl+1，Ctrl+3

##### 添加到收藏

使用 `Alt+2` 可以打开收藏视图

- 收藏类或类中的某个方法：将光标放在类名或方法名上，使用 `Alt+Shift+F` 收藏类或方法的代码

##### 代码编辑区和文件区跳转

- 跳转到文件区： `Alt+1` 
- 跳转到代码编辑区域： `Esc`

#### 2. 精准搜索

- 搜索类：`Ctrl+N`
- 搜索文件：`Ctrl+Shift+N`
- 搜索符号：`Ctrl+Shift+Ctrl+N`
- 搜索字符串：`Ctrl+Shift+F`

## 二、批处理操作

#### 1. 列操作

快捷键：

- 选中某个单词： `Ctrl+Shift+左右箭头`
- 跳转到前/后一个单词： `Ctrl+左右箭头`
- 将选中字符串全部转换为大写或小写： `Ctrl+Shift+U`
- 选中所有匹配的目标： `Ctrl+Shift+Alt+J`

例1：如何将下面左边内容快速地转换为右边内容

	# line1               # line1
	100: Aaaa             AAAA(100)
    200: BbB              BBB(200)
    300: cC               CC(300)

    # line2               # line2
    400: DDeeD            DDDDD(400)
    500: eE               EE(500)

    # line3               # line3
    600: FfFF             FFFF(600)
	700: Ggg              GGG(700)
	
具体做法：

- (1) 使用 `Ctrl+Shift+左右箭头` 选中某个统一的符号，例如 `：`，使用`Ctrl+Shift+Alt+J`选中所有行中统一的符号
- (2) 使用`Ctrl+Shift+左右箭头`选中所有数字并剪切至行尾，添加左右括号，统一删除`:`和空格
- (3) 使用`Ctrl+Shift+左右箭头`选中每一行中的单词，使用`Ctrl+Shift+U`转换大小写，剪切至数字前面

#### 2. 代码模板

使用`Ctrl+Shift+A` 搜索到 `Live Template`，在其中可以添加 `Live Template` 和 `Template Group`。

例1：可以定义template为`psvm`，描述为`public static void main`，具体内容为：

	public static void main(String[] args) {
	    $END$
	}

设置好应用场景。以后在输代码时，当输入`psvm`并按回车键，会自动出现上面代码块，并且光标停留在 `$END$` 区域。

例2：可以定义template为`psc`，描述为`public String `，具体内容为：

	private String $VAR1$; //$VAR2$
	$END$

设置好应用场景。以后在输代码时，当输入`psc`并按回车键，会自动出现上面代码块，并且光标会依次停留在 `$VAR1$`、`$END$` 区域。

#### 3. postfix

使用`Ctrl+Shift+A` 搜索到 `Postfix Completion`，在其中可以查看预设的postfix。

下面是常见的几种postfix：

- for： 输入`数字.for`后按回车键，会出现可供选择的postfix，选择其中一个后会自动填充代码

例如输入 `100.for` ，选择 `fori` 并按回车键后，会自动填充如下代码： 

	for (int i = 0; i < 100; i++) {
            
    }

- sout： 输入 `XXX.sout`后按回车键会自动填充代码

例如输入 `new Date().sout`并按回车键后，会自动填充如下代码：

	System.out.println(new Date());

- return： 输入`XXX.r`，选择`return`并按回车，会自动填充代码

例如输入 `user.r`，选择`return`并按回车键后，会自动填充如下代码：

	return user;

- nn: 输入`XXX.nn`按回车键会自动填充代码

例如输入 `user.nn`并按回车键后，会自动填充如下代码：

	if (user != null) {
            
    }

#### 4. alter+enter，自动提示

- 自动创建函数
- list replace
- 字符串format或build
- 实现接口
- 单词拼写
- 导入包

## 三、编写高质量的代码

#### 1. 重构

- 重构变量/变量重命名： `Shift+F6`

如果在编写代码的过程中，想要修改某个变量的变量名以及该变量所有出现位置的名称，可以使用`Shift+F6`实现全部修改。

- 重构方法/修改方法签名： `Ctrl+F6`

如果在修改代码的过程中，想要修改某个被调用方法的方法签名，可以使用`Ctrl+F6`实现参数的删除、增加或修改。

#### 2. 抽取

- 抽取局部变量： `Ctrl+Alt+V`

例1：有如下一段代码，我们想要将字符串"123"抽取出来定义成一个变量，我们可以在某个字符串"123"上使用`Ctrl+Alt+V`将其定义为变量。

	public void fun() {
		System.out.println("123");
	    System.out.println("123");
	    System.out.println("123");
	    System.out.println("123");
	    System.out.println("123");
	}

最终抽取结果如下：

	public void fun() {
		String var = "123";
	    System.out.println(var);
	    System.out.println(var);
	    System.out.println(var);
	    System.out.println(var);
	    System.out.println(var);
	}

- 抽取静态变量： `Ctrl+Alt+C`
- 抽取成员变量： `Ctrl+Alt+F`
- 抽取方法参数： `Ctrl+Alt+P`

例2：假设有如下一段代码，我们想要将局部变量x抽取为方法参数，我们可以在x上使用`Ctrl+Alt+P`将其抽取为方法参数

    public void fun() {
        String x = "abc";
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
    }

最终抽取结果如下：

    public void fun(String x) {
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
    }

- 抽取方法： `Ctrl+Alt+M`

例3：假设有如下一段代码，我们想将其抽取为三个函数调用，我们可以在一个代码块上使用`Ctrl+Alt+M`将其抽取为一个方法

    public void fun(String x) {
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
        System.out.println(x);
    }

最终抽取结果如下：

	public void fun(String x) {
        fun1(x);
        fun2(x);
        fun3(x);
    }

    private void fun3(String x) {
        System.out.println(x);
        System.out.println(x);
    }

    private void fun2(String x) {
        System.out.println(x);
    }

    private void fun1(String x) {
        System.out.println(x);
        System.out.println(x);
    }

## 四、寻找修改轨迹

#### 1. git集成

- 查看代码记录：annotate
- 查看所有修改：`Ctrl+Alt+Shift+上下箭头`
- 撤销(某一块、某一个文件、某一个项目的)修改：`Ctrl+Alt+Z`

#### 2. local history

当项目不受版本控制时，我们可以通过local history查看代码的修改记录

## 五、关联一切

#### 1. 关联Spring

File -> Project Structure -> Facets -> Add -> Spring -> 将配置文件选中后，将可以让IDEA帮助管理Spring代码

#### 2. 关联数据库

View -> Tool Window -> Database -> Add -> Data Source -> 选择具体的数据库，填入相关信息，便可以在IDEA中方便的使用数据库的信息。

## 六、调试程序

## 七、其他操作

- 查看类中所有方法和属性： `Ctrl+F12` 
- 查看Maven依赖结构： `Ctrl+Alt+Shift+U`
- 产看类图及继承关系： `Ctrl+Alt+Shift+U`
- 查看类继承层次结构：`Ctrl+H`
- 查看方法调度层次结构： `Ctrl+Alt+H`




