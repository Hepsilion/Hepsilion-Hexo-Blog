---
title: 第三章 Activity
thumbnail: 'https://cdn.pixabay.com/photo/2017/01/11/08/31/icon-1971128__340.png'
date: 2017-03-03 20:40:47
tags: [Android]
categories: Android基础
description:
---

- Activity的生命周期
- Activity的4种启动模式
- 隐式意图和显式意图的使用
- 使用Intent传递数据

<!--more-->

## 一、Activity入门
### 1. Activity简介
Activity是Android应用程序的四大组件之一，它负责管理Android应用程序的用户界面。

一个应用程序一般会包含若干个Activity，每一个Activity组件负责一个用户界面的展现。

Activity是通过调用setContentView()方法来显示指定组件的，setContentView()方法既可以接收View对象为参数，也可以接受布局文件对应的id为参数。

在应用程序中，Activity就像一个界面管理员，用户在界面上的操作是通过Activity管理的。

### 2. Activity的创建

(1) 定义一个类继承自android.app.Activity或者其子类；

(2) 在res/layout目录中创建一个xml布局文件，用于创建Activity的布局；

(3) 在AndroidManifest.xml文件中注册Activity；

    <activity android:name=".MainActivity">
        <intent-filter>
            <action android:name="android.intent.action.MAIN" /> <!--表示将当前Activity设置为程序最先启动的Activity-->
            <category android:name="android.intent.category.LAUNCHER" /> <!--表示让当前Activity在桌面上创建图标-->
        </intent-filter>
    </activity>

(4) 重写Activity的onCreate()方法，并在该方法中使用setContentView()加载指定的布局文件。

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

**案例：Demo0301，演示Activity的按键按下、按键松开、点击屏幕事件**

### 3. Activity的生命周期
Activity的生命周期是指Activity从创建到销毁的过程，Activity的生命周期中存在三种状态：运行状态、暂停状态和停止状态。

- **运行状态**：当Activity在屏幕的最前端时，它是可见的、有焦点的，可以用来处理用户的常见操作，如点击、双击、长按事件等，这种状态称为运行状态。
- **暂停状态**：在某些情况下，Activity对用户来说仍然是可见的，但它不再拥有焦点，即用户对它的操作是没有实际意义的。例如，当最上面的Activity没有完全覆盖屏幕或者是透明的，被覆盖的Activity仍然对用户可见，并且存活(它保留着所有的状态和成员信息并保持与Activity管理器的连接)。但当内存不足时，这个暂停状态的Activity可能会被杀死。
- **停止状态**：当Activity完全不可见时，它就处于停止状态，但仍然保留着当前状态和成员信息。然而这些对用户来说都是不可见的，当系统内存不足时，这个Activity很容易被杀死。

Activity从一种状态转变到另一种状态时会触发一些事件，执行一些回调函数来通知状态的变化：

- onCreate()  当Activity被创建的时候调用的方法
- onStart()   当Activity变成用户可见的时候调用的方法
- onResume()  当Activity获取到焦点的时候调用的方法
- onPause()   当Activity失去焦点的时候调用的方法
- onStop()    当Activity变成用户不可见的时候调用的方法
- onDestroy() 当Activity被销毁的时候调用的方法
- onRestart() 当Activity重新回到前台，再次可见时调用的方法。

<center>
<img src="./03-Activity/Pic3-1.JPG" width="50%"/>图 3-1
</center>

图3-1所示是一个Activity的生命周期模型，当Activity从启动到关闭时，会依次执行：

onCreate() -> onStart() -> onResume() -> onPause() -> onStop() -> onDestroy()方法。

- 当Activity执行到onPause()方法失去焦点时，重新回到前台会执行onResume()方法。
- 当Activity执行到onStop()方法变成用户不可见时，再次回到前台会执行onRestart()方法、onStart()方法和onResume()方法。
- 如果进程被杀死，Activity重新回到前台时会重新执行onCreate()方法。

**案例：Demo0302，使用两个Activity之间的跳转演示Activity生命周期方法变化的过程**

### 4. 横竖屏切换时的生命周期

现实生活中，使用手机时会根据不同情况进行横竖屏切换。默认情况下，当手机横竖屏切换时，Activity会销毁重建。

这种情况对实际开发肯定会有影响，如果不希望在横竖屏切换时Activity被销毁重建，可以在AndroidManifest.xml文件中设置Activity的android:configChanges的属性，这样无论怎样切换Activity都不会销毁重建：
	
	android:configChanges="orientation|keyboardHidden|screenSize"

如果希望某一个界面一直处于竖屏或者横屏状态，不随手机的晃动而改变，同样可以在清单文件中通过设置Activity的参数来完成：
	
	竖屏： android:screenOrientation="portrait"
	横屏： android:screenOrientation="landscape"

## 二、Activity的启动模式

Android采用任务栈的方式来管理Activity的实例。

当启动一个应用时，Android就会为之创建一个任务栈，先启动的Activity压在栈底，后启动的Activity放在栈顶，通过启动模式可以控制Activity在任务栈中的加载情况。

**1. Android下的任务栈**

在开发Android应用时，经常会涉及一些消耗大量系统内存的情况，例如视频播放、大量图片或者程序中开启多个Activity没有及时关闭等，会导致程序出现错误。为了避免这种问题，Google提供了一套完整的机制让开发人员控制Android中的任务栈。

<center>
<img src="./03-Activity/Pic3-2.JPG" width="20%"/>图 3-2
</center>

Android中的任务栈，类似于一个容器，用于管理所有的Activity实例。在存放Activity时，满足"先进后出"的原则。如图3-2所示，先加入任务栈中的Activity会处于容器下面，后加入的处于容器上面，而从任务栈中取出的Activity是从最顶端先取出，最后取出的是最底端的Activity。


**2. Activity的4种启动模式**

在实际开发中，应根据特定的需求为Activity指定恰当的启动模式。

- Android的启动模式有4种，分别是standard、singleTop、singleTask和singleInstance。
- 在AndroidManifest.xml中，通过< activity>标签的android:launchMode属性可以设置启动模式.

**(1) standard模式**  

standard是Activity默认的启动模式，在不指定Activity启动模式的情况下，所有Activity使用的都是standard模式。

在standard模式下，每当启动一个新的Activity，它就会进入任务栈，并处于栈顶的位置，对于使用standard模式的Activity，系统不会判断该Activity在栈中是否存在，每次启动都会创建一个新的实例。

<center>
<img src="./03-Activity/Pic3-3.JPG" width="35%"/>图 3-3
</center>

如图3-3所示，在standard启动模式下，Activity01最先进栈，其次是Activity02，最后是Activity03；出栈时，Activity03最先出栈，其次是Activity02，最后是Activity01，满足"先进后出"原则。

**(2) singleTop模式**  

singleTop模式与standard类似，不同的是，当启动的Activity已经位于栈顶时，则直接使用它而不创建新的实例。如果启动的Activity没有位于栈顶时，则创建一个新的实例位于栈顶。

<center>
<img src="./03-Activity/Pic3-4.JPG" width="36%"/>图 3-4
</center>

如图3-4所示，当前栈顶的元素是Activity03，如果再次启动的界面还是Activity03，则复用当前栈顶的Activity实例，如果再次启动的界面没有位于栈顶，则会重新创建一个实例。

**(3) singleTask模式**  

如果希望Activity在整个应用程序中只存在一个实例，可以使用singleTask模式。

当Activity的启动模式指定为singleTask，每次启动该Activity时，系统首先会查找栈中是否存在该Activity的实例，如果发现已经存在则直接使用该实例，并将当前Activity之上的所有Activity出栈，如果没有发现则创建一个新的实例。

<center>
<img src="./03-Activity/Pic3-5.JPG" width="40%"/>图 3-5
</center>

如图3-5所示，当再次启动Activity02时，并没有创建Activity02的新实例，而是将Activity03实例移除，复用Activity02实例，这就是singleTask模式，让某个Activity在当前栈中只存在一个实例。

**(4) singleInstance模式** 

在程序开发中，如果需要Activity在整个系统中都只有一个实例，这时就需要用到singleInstance模式。不同于上述模式，指定为singleInstance模式的Acitivity会启动一个新的任务栈来管理这个Activity。

singleInstance模式加载Activity时，无论从哪个任务栈中启动该Activity，只会创建一个Activity实例，并且会使用一个全新的任务栈来装载该Activity实例。

采用这种模式启动Activity会分为以下两种情况：

第一种：如果要启动的Activity不存在，系统会先创建一个新的任务栈，再创建该Activity的实例，并把该Activity加入栈顶，如图3-6所示。

第二种：如果要启动的Activity已经存在，无论位于哪个应用程序或者哪个任务栈中，系统都会把该Activity所在的任务栈转到前台，从而使该Activity显示出来。

<center>
<img src="./03-Activity/Pic3-6.JPG" width="55%"/>图 3-6
</center>

## 三、在Activity中使用Intent
### 1. Intent介绍
Android系统常使用Intent绑定应用程序组件，并在应用程序之间完成通信功能。

Intent一般用于启动Activity、启动服务、发送广播等，承担了Android应用程序三大核心组件间的通信功能。

<center>
<img src="./03-Activity/Pic3-7.JPG" width="65%"/>图 3-7
</center>

图3-7列举了通过Intent来开启不同组件的常用方法。**需要注意的是，使用Intent开启Activity和开启Service只有两个方法，而开启BroadcastReceiver有多个方法，这里只列举了三个常用的方法。**

### 2. 显式意图和隐式意图
Android中Intent寻找目标组件的方式分为两种，一种是显式意图，另一种是隐式意图。

**(1) 显式意图**：在通过Intent启动Activity时，明确指定激活组件的名称
	
第一种方式

	//指定目标组件的包名、全路径名
	Intent intent=new Intent();
    intent.setClassName("learning.android.it.org.demo0303", "learning.android.it.org.demo0303.Activity02");
    startActivity(intent);
	
第二种方式

	//第一个参数Content要求提供一个启动Activity的上下文，第二个参数Class则是指定要启动的目标Activity
	Intent intent=new Intent(MainActivity.this, Activity02.class);
    startActivity(intent);



**(2) 隐式意图**：没有明确指定组件名的Intent成为隐式意图。

Android系统会根据隐式意图中设置的动作(action)、类别(category)、数据(Uri和数据类型)找到最合适的组件

	<activity android:name=".Activity02">
        <intent-filter>
            <action android:name="android.media.action.IMAGE_CAPTURE"/>
            <category android:name="android.intent.category.DEFAULT"/>
        </intent-filter>
    </activity>

	//使用隐式意图开启Activity，只有当action和category的内容同时匹配时，Activity才会被开启
	Intent intent = new Intent();
    intent.setAction("android.media.action.IMAGE_CAPTURE");
    intent.addCategory("android.intent.category.DEFAULT");
    startActivity(intent); 

**案例：Demo0303，打开系统照相机，演示如果使用隐式意图**

显式意图和隐式意图的比较：

- 显式意图开启组件时，必须要指定组件的名称，一般只在本应用程序切换组件时使用。
- 隐式意图的功能要比显式意图强大，不仅可以开启本应用的组件，还可以开启其他应用的组件，例如打开系统自带的照相机、浏览器等。
	

## 四、Activity中的数据传递

### 1. 数据传递方式

在Android开发中，经常要在Activity之间传递数据，这个功能可以通过Intent来实现。

使用Intent传递数据只需调用putExtra()方法将想要传递的数据存在Intent中，当启动了另一个Activity后，再把这些数据从Intent中取出即可。

方法一：
	
	// Activity01通过Intent使用putExtra将数据传递到Activity02
	String str="Data from Activity01 to Activity02";
	Intent intent=new Intent(this, Activity02.class);
	intent.putExtra("data", data);   //第一个参数是key，第二个参数是value
	startActivity(intent);

	// Activity02取出Activity01传递过来的数据
	Intent intent=getIntent();
	String str=intent.getStringExtra("data"); //通过key获取value
	
方法二：
	
	// Activity01通过Intent使用putExtras将数据传递到Activity02
	Bundle bundle=new Bundle();
	bundle.putString("name", "Linda");
	bundle.putInt("age", 20);
	Intent intent=new Intent(this, Activity02.class);
	intent.putExtras(bundle);
	startActivity(intent);

	// Activity02取出Activity01传递过来的数据
	Intent intent=getIntent();
	Bundle bundle=intent.getExtras();
	String name=bundle.getString("name");
	int age=bundle.getInt("age");

**案例：Demo0304，用户注册，演示Activity中的数据传递**

### 2. 回传数据

Android提供了一个startActivityForResult()方法，来实现Activity之间的回传数据。

(1) Activity01使用startActivityForResult(intent, requestCode)启动Activity02 
	
	Intent intent=new Intent(this, Activity02.class);
	startActivityForResult(intent, 1);

startActivityForResult()方法接收两个参数，第一个参数是Intent；第二个参数是请求码，用于在Activity02中判断数据的来源。

(2) 在Activity02中使用setResult(resultCode, data)添加要返回的数据，并销毁当前Activity

	Intent intent=new Intent();
	intent.putExtra("key", "Hello");
	setResult(1, intent);
	finish();

setResult()方法接收两个参数，第一个参数resultCode结果码，一般使用0或1；第二个参数则是把带有数据的Intent传递回去

(3) 由于Activity01使用startActivityForResult方法启动Activity02，当Activity02销毁并返回时，会回调Activity01中的onActivityResult()方法，因此需要在Activity01中重写onActivityResult(requestCode, resultCode, data)方法获取Activity02返回的数据

	protected void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		if(resultCode==1){
			String value=data.getStringExtra("key");
		}
	}

onActivityResult()方法有三个参数：

- 第一个参数requestCode表示在启动Activity02时传递的请求码；
- 第二个参数resultCode表示在返回数据时传入的结果码；
- 第三个参数data表示携带返回数据的Intent。

> 注意：在一个Activity中很可能调用startActivityForResult()方法启动多个Activity，每一个Activity返回的数据都会回调到onActivityResult()方法中，因此，首先要做的是通过检查requestCode的值来判断数据来源，确定数据是从Activity02返回的，然后再通过resultCode的值来判断数据处理结果是否成功，最后再把数据从data中取出。

**案例：Demo0305，装备选择，演示Activity之间的数据回传**

**小知识：ProgressBar进度条**

ProgressBar通常用于访问网络展示Loading对话框以及下载文件时显示的进度。

它有两种表现形式，一种是水平的，另一种是环形的。它的表现形式是由style属性控制的，ProgressBar的几个常用属性如下所示：

- style属性：控制ProgressBar的表现形式。

> 水平进度条的style属性值为"?android:attr/progressBarStyleHorizontal"
> 
> 环形进度条的style属性值为"?android:attr/progressBarStyleLarge"

- setMax()方法：设置进度条的最大值
- setProgress()方法：设置当前进度
- getProgress()方法：获取当前进度
