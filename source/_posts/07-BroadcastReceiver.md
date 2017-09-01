---
title: 第七章 广播接收者
thumbnail: 'https://cdn.pixabay.com/photo/2017/01/11/08/31/icon-1971128__340.png'
date: 2017-03-07 20:44:40
tags: [Android]
categories: Android基础
description:
---

- 创建广播接收者
- 自定义广播
- 有序广播和无序广播
- 常用广播接收者(如开机启动、短信接收)的使用

<!--more-->

在Android系统中，广播(Broadcast)是一种在应用程序之间传递消息的机制，广播接收者(BroadcaseReceiver)是用来接收、过滤并响应广播的一类组件。通过广播接收者可以监听系统中的广播消息，在不同组件之间进行通信。

## 一、广播接收者入门
在Android系统中内置了很多系统级别的广播，例如，手机开机完成后会发送一条广播，电池电量不足时也会发送一条广播等。为了监听这些广播事件，Android提供了一个BroadcastReceiver组件，该组件可以监听来自系统或者应用程序的广播。

当Android系统产生一个广播事件时，可以有多个对应的BroadcastReceiver接收并进行处理。

### 1. 广播接收者创建与注册
要使用广播接收者接收其他应用程序发出的广播，先要在本应用中创建一个广播接收者类继承自BroadcastReceiver类，然后在清单文件中或者代码中进行注册并指定要接收的广播事件，最后重写广播接收者类的onReceive()方法，在方法中进行处理广播事件即可。

注册广播接收者有两种方式，常驻型广播和非常驻型广播。

**(1) 创建广播接收者**

要对监听到的广播事件进行处理，需要创建一个类继承自BroadcastReceiver，然后重写onReceive()方法。
 
	public class OutCallReceiver extends BroadcastReceiver {
	    @Override
	    public void onReceive(Context context, Intent intent) {
	    }
	}

当监听到有广播发出时，就会调用onReceive()方法，在onReceive()方法中可以对事件进行处理。

**(2) 注册常驻型广播接收者**

常驻型广播接收者是当应用程序关闭后，如果接收到其他应用程序发出的广播，那么该程序会自动重新启动。常驻型广播接收者需要在清单文件中进行注册。

**示例代码**

	<receiver android:name="learning.android.it.org.demo0701.OutCallReceiver" >
        <intent-filter android:priority="20">
            <action android:name="android.intent.action.NEW_OUTGOING_CALL" />
        </intent-filter>
    </receiver>

上述代码是在清单文件中注册的监听系统拨打电话的广播。

- android:name="learning.android.it.org.demo0701.OutCallReceiver"是创建的广播接收者的全路径名；
- 与定义隐式意图一样，广播接收者也需要注册一个`<intent-filter>`，在过滤器中指定要接收的广播事件；
- android:name="android.intent.action.NEW\_OUTGOING_CALL"是系统内部定义的拨打电话的广播事件；
- android:priority="20"是该广播的优先级，这个值越大代表接收的优先级越高。

**(3) 注册非常驻型广播接收者**

非常驻型广播接收者依赖于注册广播的组件的生命周期，例如在Activity中注册广播接收者，当Activity销毁后，广播也随之被移除。这种广播接收者需要在代码中注册。

**示例代码**

	MyBroadcastReceiver receiver=new MyBroadcastReceiver();
	// 实例化过滤器并设置要过滤的广播
	String action="android.intent.action.NEW_OUTGOING_CALL";
	IntentFilter intentFilter=new IntentFilter(action);
	// 注册广播接收者
	registerReceiver(receiver, intentFilter);

与清单文件中注册一样，代码注册广播接收者同样需要进行过滤，IntentFilter接收的是监听的广播事件，最后用registerReceiver方法进行注册。

与清单文件注册不同的是，代码有注册也有移除，比如在Activity的onCreate()中注册广播接收者，就要在onDestroy()方法中进行解除广播。
	
	unregisterReceiver(receiver);

**需要注意的是，常驻型广播接收者在应用程序关闭后，接收到广播会重新自动创建。非常驻型广播接收者则依赖于注册广播组件的生命周期和调用unregisterReceiver()方法手动移除。**

**(4) 案例：Demo0701，IP拨号器，当拨打长途电话时，广播接收者就会监听到这个广播事件，自动在电话号码前加上几个数字，如17911、17951等。**

注意：在Android4.0一下的系统中，当进程不存在时，只要有响应广播发出，进程就会自动创建并接收广播进行处理。Google工程师认为这样不安全，为了保护用户隐私，在Android4.0以上系统中，当在任务管理器界面强行停止进程后，再有广播发出也不会打开进程进行接收了。

## 二、自定义广播

Android系统中自带了很多广播，如果需要监听某个广播，只需要创建对应的广播接收者即可。在实际开发中，当这些系统级广播事件不能满足实际需求时，还可以自定义广播。需要注意的是，自定义广播需要由对应的广播接收者去接收，否则这个广播是无意义的。

**案例：Demo0702，电台与收音机**

创建广播：创建一个Intent对象，然后通过Intent.setAction()语句指定广播事件，最后通过sendBroadcast(intent)发送广播。

	Intent intent = new Intent();
    // 定义广播的事件类型
    intent.setAction("www.baidu.com");
    // 发送广播
    sendBroadcast(intent);

接收广播：和接收系统广播事件一样，创建一个广播接收者类继承自BroadcastReceiver类，然后在清单文件中或者代码中进行注册并指定要接收的广播事件，最后重写广播接收者类的onReceive()方法，在方法中进行处理广播事件即可。**需要注意的是，自定义的广播事件与广播接收者在清单文件中注册的事件要一致，否则无法接收广播**

	<receiver android:name="learning.android.it.org.demo0702.MyBroadcastReceiver" >
        <intent-filter>
            <action android:name="www.baidu.com" />
        </intent-filter>
    </receiver>

## 三、广播的类型
在Android系统中，根据广播被接收顺序的不同，可以将其分为有序广播和无序广播。

**1. 无序广播**

无序广播是一种完全异步被接收的广播，在广播发出去之后，所有监听了这个广播事件的广播接收者都会在同一时刻接收到这个广播，它们之间没有任何先后顺序可言，这种广播的效率会比较高，但同时意味着它是无法被截断的。

<center>
<img src="./07-BroadcastReceiver/Pic7-1.JPG" width="35%"/>图7-1
</center>

无序广播的工作流程如图7-1所示，当无序广播发送一条广播消息时，所有的广播接收者都可以接收到，不会被拦截。

**2. 有序广播**

有序广播是一种同步接收的广播，在广播发出之后，同一时刻只会有一个广播接收者能够接收到这条消息，当这个广播接收者中的逻辑执行完后，广播才会继续传递。所以，此时的广播接收者是有先后顺序的，并且可以被拦截。

<center>
<img src="./07-BroadcastReceiver/Pic7-2.JPG" width="60%"/>图7-2
</center>

有序广播的工作流程如图7-2所示，当有序广播发送一条消息后，高优先级的广播接收者先接收到广播，低优先级的广播接收者后接收到广播。

	Intent intent = new Intent();
    // 定义广播的事件类型
    intent.setAction("www.baidu.com");
    // 发送有序广播
    //第一个参数是指定的意图，设置要发送的广播事件；第二个参数指定接收者的权限，如果不想让所有的接收到看到，可以显示地指定接收者的权限，目前不关心，可以将其设置为null
    sendOrderedBroadcast(intent, null);

优先级是在清单文件中注册广播接收者时定义的android:priority=""参数，优先级的范围是-1000~1000之间。如果两个广播接收者的优先级相同，则先注册的组件优先接收到广播。如果两个应用程序监听了同一个广播事件并设置了优先级，则优先级高的应用优先接收到广播。

	<receiver android:name="learning.android.it.org.demo0703.MyBroadcastReceiver02" >
        <intent-filter android:priority="1000" >
            <action android:name="www.baidu.com" />
        </intent-filter>
    </receiver>
    <receiver android:name="learning.android.it.org.demo0703.MyBroadcastReceiver01" >
        <intent-filter android:priority="1000" >
            <action android:name="www.baidu.com" />
        </intent-filter>
    </receiver>
    <receiver android:name="learning.android.it.org.demo0703.MyBroadcastReceiver03" >
        <intent-filter android:priority="600" >
            <action android:name="www.baidu.com" />
        </intent-filter>
    </receiver>

如果高优先级的广播接收者将广播终止，则后面的广播接收者无法接收到广播。想要拦截一条广播不往下发送，可以使用abortBroadcast()方法。

	public class MyBroadcastReceiver02 extends BroadcastReceiver {
	    @Override
	    public void onReceive(Context context, Intent intent) {
	        Log.i("MyBroadcastReceiver02", "自定义的广播接收者02,接收到了自定义的广播事件");
	        Log.i("MyBroadcastReceiver02", "自定义的广播接收者02，接收到了广播事件");
	        abortBroadcast(); // 拦截有序广播，这句代码执行完后，广播事件将会被终止。
	        Log.i("MyBroadcastReceiver02", "我是广播接收者02，广播被我终结了");
	    }
	}

在实际开发中，还可能遇到这样的情况，当发出了一个有序广播，然后定义多个广播接收者接收这条广播。这些广播接收者的优先级有高有低，需要其中一个广播接收者无论如何都要接收到广播事件，哪怕它的优先级是最低的或者广播被优先级高的接收者强行终止。这时，就可以用一下sendOrderedBroadcast的重载方法，在第三个参数指定要接收的广播接收者。

    MyBroadcastReceiver03 receiver03 = new MyBroadcastReceiver03();
    sendOrderedBroadcast(intent, null, receiver03, null, 0, null, null);

**案例：Demo0704，拦截有序广播**

## 四、常用的广播接收者

**案例：Demo0704，短信拦截器，监听短信接收的广播事件**（拦截没起作用）

	<receiver android:name="learning.android.it.org.demo0704.MessageReceiver" >
        <intent-filter android:priority="1000" >
            <action android:name="android.provider.Telephony.SMS_RECEIVED" />
        </intent-filter>
    </receiver>

设置action为android.provider.Telephony.SMS_RECEIVED，接收短信的广播事件

在Windows系统中，有些软件一开机就自动启动，同样在Android系统中也可以实现这种功能，例如杀毒软件程序，每次手机开机便会自动启动，这种功能就是通过广播接收者监听开机启动的广播事件实现的。

**案例：Demo0705，杀毒软件，监听开机启动的广播事件**

	public class BootReceiver extends BroadcastReceiver {
	    @Override
	    public void onReceive(Context context, Intent intent) {
	        Intent i = new Intent(context, MainActivity.class);
	        // 由于Activity都是运行在任务栈中的，当开机启动时，任务栈还未创建成功，所以需要设置flag，显示地指定Activity在新的任务栈中运行
	        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	        context.startActivity(i);
	    }
	}

	<receiver android:name="learning.android.it.org.demo0705.BootReceiver" >
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED" />
        </intent-filter>
    </receiver>

设置action为android.intent.action.BOOT_COMPLETED，接收开机启动的广播事件

**需要注意的是，在Android3.0以后出现了一个安全机制，如果用户没有启动过这个程序，那么就算该程序注册了开机启动的广播接收者也无法接收到开机启动的广播事件。**
