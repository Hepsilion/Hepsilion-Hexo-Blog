---
title: 第八章 服务
thumbnail: 'https://cdn.pixabay.com/photo/2017/01/11/08/31/icon-1971128__340.png'
date: 2017-03-08 20:45:55
tags: [Android]
categories: Android基础
description:
---

- 服务的生命周期
- 服务的两种启动方式
- 本地服务通信
- 远程服务通信(调用其它应用的服务)

<!--more-->

服务(Service)和Activity一样，是Android中的四大组件之一，不同的是服务没有界面，是一个长期运行在后台的组件，即使启动服务的应用程序被切换掉，服务仍可以在后台正常运行。因此服务经常被用来处理一些耗时的任务，例如进行网络传输或者播放音乐等。

## 一、服务的创建

**1. 创建服务**

服务的创建方式与创建Activity类似，只需要继承Service类即可。

**示例代码：**
	
	public class MyService extends Service{
	    @Nullable
	    @Override
	    public IBinder onBind(Intent intent) {
	        return null;
	    }
	}

**2. 在清单文件中配置**

由于服务是Android四大组件中的一个，因此需要在Androidmanifest.xml文件中进行注册，否则服务是不生效的。

**示例代码：**

	<?xml version="1.0" encoding="utf-8"?>
	<manifest xmlns:android="http://schemas.android.com/apk/res/android"
	    package="learning.android.it.org.demo0801">
	
	    <application
	        android:allowBackup="true"
	        android:icon="@mipmap/ic_launcher"
	        android:label="@string/app_name"
	        android:supportsRtl="true"
	        android:theme="@style/AppTheme">
	        <activity android:name=".MainActivity">
	            <intent-filter>
	                <action android:name="android.intent.action.MAIN" />
	
	                <category android:name="android.intent.category.LAUNCHER" />
	            </intent-filter>
	        </activity>
			<!--注册服务-->
	        <service android:name=".MyService"/>
	    </application>
	</manifest>

## 二、服务的生命周期

与其他组件不同，Service不能自己主动运行，需要调用相应的方法来启动。启动服务的方法有两种，分别是Context.startService()和Context.bindService()。如图8-1所示，使用不同的方法启动服务，服务的生命周期也会不同。


<center>
<img src="./08-Service/Pic8-1.JPG" width="45%"/>图 8-1
</center>

**1. startService方式开启服务的生命周期**

当其他组件调用startService()方法时，服务会先执行onCreate()方法，接着执行onStartCommand()方法，此时服务处于运行状态，直到自身调用stopSelf()方法或者其他组件调用stopService()方法时服务停止，最终被系统销毁。

这种方式开启的服务会长期在后台运行，并且服务的状态与开启者的状态无关。

**2. bindService方式开启服务的生命周期**

当其他组件调用bindService()方法时，服务被创建，接着客户端通过Ibinder接口与服务通信。客户端通过unbindService()方法关闭连接，多个客户端能绑定到同一个服务上，并且当它们都解绑时，系统将直接销毁服务(服务不需要被停止)。

这种方法开启的服务与开启者的状态有关，当调用者销毁了，服务也会被销毁。

**3. 服务声明周期中的重要方法**

- onCreate() 服务被创建时执行的方法。
- onDestroy() 服务被销毁时执行的方法。
- onStartCommand() 客户端通过startService()显式启动服务时执行该方法。
- onBind() 客户端通过调用bindService()方法启动服务时执行该方法。
- onUnbind() 客户端调用unBindService()方法断开服务绑定时执行该方法。


## 三、服务的启动方式
前面讲过，启动服务有两种方式，分别是通过startService()方法启动服务和bindService()方法启动服务。

**1. start方式启动服务**

使用Context的startService()和stopService()方法来启动、关闭服务，Intent对象用于指定要启动或关闭的服务。

	Intent intent=new Intent(this, MyService.class);
    startService(intent); //开启服务
	stopService(intent);  //关闭服务

onCreate()方法只有在服务创建时执行，而onStartCommand()方法则是在每次启动服务时调用。

**需要注意的是，如果不调用stopService()或stopSelf()方法，这种方式开启的服务会长期运行在后台，除非用户强制停止服务。**

**案例：Demo0801，start方式启动服务**

**2. bind方式启动服务**

当程序使用startService()和stopService()启动、关闭服务时，服务与调用者之间基本不存在太多的关联，也无法与访问者进行通信、数据交互等。

如果服务需要与调用者进行方法调用和数据交互时，应该使用bindService()和unbindService()方法启动、关闭服务。

使用bindService()方式启动服务的标准步骤：

	// 1. 创建MyConn类，用于实现连接服务
	private MyService.MyBinder myBinder;
	private class MyConn implements ServiceConnection{
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            myBinder= (MyService.MyBinder) service;
            Log.i("MainActivity", "服务成功绑定，内存地址为"+myBinder.toString());
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {

        }
    }
	MyConn myConn;

	// 2. 绑定服务
	Intent intent=new Intent(this, MyService.class);
    bindService(intent, myConn, BIND_AUTO_CREATE);

	// 3. 利用myBinder调用服务中的方法
	myBinder.callMethodInService();

	// 4. 解绑服务
	unbindService(myConn);

bindService()方法的完整方法名为public boolean bindService(Intent service, ServiceConnection conn, int flags)，该方法的参数解释如下：

- Intent对象用于指定要启动的Service
- ServiceConnection对象用于监听调用者与Service之间的连接状态。
	- 当调用者与Service连接成功时，将回调该对象的public void onServiceConnected(ComponentName name, IBinder service)方法；
	- 当调用者与Service断开连接时，将回调该对象的public void onServiceDisconnected(ComponentName name)方法。
- flags指定绑定时是否自动创建Service(如果Service还未创建)。该参数可指定为0即不自动创建，也可指定为BIND\_AUTO\_CREATE_即自动创建。

注意：ServiceConnection中的onServiceConnected()方法有一个参数IBinder service，这个参数是在服务的onBind()方法中返回的。

	public class MyService extends Service{
	    // 创建服务的代理，调用服务中的方法
	    class MyBinder extends Binder{
	        public void callMethodInService(){
	            methodInService();
	        }
	    }
	
	    public void methodInService(){
	        Log.i("BindService", "自定义方法methodInService");
	    }
	
	    @Nullable
	    @Override
	    public IBinder onBind(Intent intent) {
	        Log.i("BindService", "onBind");
	        return new MyBinder();
	    }
	
	    @Override
	    public boolean onUnbind(Intent intent) {
	        Log.i("BindService", "onUnbind");
	        return super.onUnbind(intent);
	    }
	
	    @Override
	    public void onCreate() {
	        super.onCreate();
	        Log.i("BindService", "onCreate");
	    }
	}

**案例：Demo0802，bind方式启动服务**






## 四、服务通信

在Android系统中，服务的通信方式有两种：一种是本地服务通信，另一种是远程服务通信。本地服务通信是指应用程序内部的通信，而远程服务通信是指两个应用程序之间的通信。使用这两种方式进行通信时必须满足一个前提，就是服务必须以绑定方式开启。

**1. 本地服务通信**

在使用服务进行本地通信时，首先需要开发一个Service类，该类会提供一个IBinder onBind(Intent intent)方法，onBind()方法返回的IBinder对象会作为参数传递给ServiceConnection类中onServiceConnected(ComponentName name, IBinder service)方法，这样访问者就可以通过IBinder对象与Service进行通信。

使用Ibinder对象进行本地服务通信：

<center>
<img src="./08-Service/Pic8-2.JPG" width="75%"/>图 8-2
</center>

如图8-2所示，服务在进行通信时实际上使用的就是IBinder对象，在ServiceConnection类中得到IBinder对象，通过该对象就可以获取到服务中定义的方法，执行具体的操作。


**案例：Demo0803，音乐播放器，演示如何使用服务进行通信**

**(1) MediaPlayer**

在Android中，播放音频文件一般都是使用MediaPlayer类来实现的。

- **setAudioStreamType()** 指定音频文件的类型必须在**prepare()**方法之前调用
- **setDataSource()** 设置要播放的音频文件的位置
- **prepare()** 在开始播放之前调用这个方法完成准备工作
- **start()** 开始或继续播放音频
- **pause()** 暂停播放音频
- **reset()** 将MediaPlayer对象重置到刚刚创建的状态
- **seekTo()** 从指定的位置开始播放音频
- **stop()** 停止播放音频，调用该方法后MediaPlayer对象就无法再播放音频
- **release()** 释放掉与MediaPlayer对象相关的资源
- **isPlaying()** 判断当前MediaPlayer是否正在播放音频
- **getDuration()** 获取载入音频文件的时长
- **getCurrentPosition()** 获取当前播放音频文件的位置

**(2) SeekBar**

SeekBar与ProgressBar十分类似，它是通过滑块的位置来表示数值的。SeekBar允许用户拖动滑块改变SeekBar的值，例如手机的音量调节，同时SeekBar还允许用户改变滑块外观。

SeekBar的常用方法属性：

- **属性 android:thumb** 指定一个Drawable对象，该对象将作为自定义滑块
- **监听器OnSeekBarChangeListener** 监听滑块位置的改变
- **方法setProgress()** 用来设置SeekBar的当前值
- **方法setMax()** 设置SeekBar的最大值

**2. 远程通信服务**

在Android系统中，各个应用程序都运行在自己的进程中，进程之间一般无法直接进行通信，如果想要完成不同进程之间的通信，就需要使用远程服务通信。

远程服务通信是通过AIDL(Android Interface Definition Language)实现的，它是一种接口定义语言，其语法格式简单，与Java中接口定义类似，但存在几点差异：

- AIDL定义接口的源代码文件必须以.aidl结尾
- AIDL接口中用到的数据类型，除了基本数据类型、String、List、Map、CharSequence
之外，其他类型全部都需要导入包，即使它们在同一个包中。

开发人员定义的AIDL接口只是定义了进程之间的通信接口，服务端、客户端都需要使用Android SDK安装目录下的platform-tools子目录下的aidl.exe工具为该接口提供实现。

远程服务调用的实例：

**应用A**

(1) 定义AIDL接口

	package learning.android.it.org.demo0804;

	interface IService {
    	void callAlipayService();
	}

AIDL接口定义的方式与Java接口的定义方式类似，都需要包名、接口名以及自定义的方法。不同的是，AIDL没有类型修饰符，在编写ADIL文件时，不能加上类型修饰符，因为它本身就是公有的，例如写为public interface IService是不正确的，正确的写法应该为interface IService。定义好AIDL接口之后，aidl.exe会为IService自动生成实现类IService.Stub。

(2) 创建Service

接着需要在应用程序中创建Service的子类，该Service的onBind()方法所返回的IBinder对象应该是aidl.exe所生成的IService.Stub的子类对象。

	public class AlipayService extends Service {
	    private class MyBinder extends IService.Stub {
	        @Override
	        public void callAlipayService() throws RemoteException {
	            methodInService();
	        }
	    }
	
	    private void methodInService() {
	        Log.v(TAG, "开始付费，购买装备");
	    }
	
	    @Nullable
	    @Override
	    public IBinder onBind(Intent intent) {
	        Log.v(TAG, "绑定支付宝，准备付费");
	        return new MyBinder();
	    }
	}

(3) 注册Service

由于该Service需要被其他应用调用，因此需要在注册服务时设置一个action，当其他应用使用隐式Intent调用该服务时，就可以通过这个action匹配上该服务。

	<service android:name=".AlipayService" >
        <intent-filter>
            <action android:name="www.baidu.com" />
        </intent-filter>
    </service>

**应用B**

(1) 复制应用A的AIDL接口文件

(2) 绑定Service

现在在另一个应用绑定上面应用的服务。注意在调用bindService()方法绑定服务时，使用的Intent设置的action需要和上面应用中服务注册的action一致。

	private MyConn conn;

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //这里Action需要与Demo04在清单文件中服务注册的Action要一致
        service = new Intent();
        service.setAction("www.baidu.com");
    }

    public void bind(View view) {
        conn = new MyConn();
        bindService(service, conn, BIND_AUTO_CREATE);
    }

	private class MyConn implements ServiceConnection {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            iService = IService.Stub.asInterface(service);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
        }
    }

(3) 调用应用A的服务

最后在应用B中调用第一个应用的服务提供的方法

	public void call(View view) {
        try {
            if (iService != null) {
                iService.callAlipayService();
            }
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

注意：在调用本地方法时，在onServiceConnected()方法中是通过强制转换将service转换为MyBinder的；但在远程服务调用中，需要通过IService.Stub.asInterface(service)方法转换。IService就是应用A中定义的AIDL接口，需要将这个接口文件复制到应用B相同目录下。

**案例：Demo0804与Demo0805，模拟小游戏Demo0805远程调用支付宝Demo0804，演示如何绑定并使用远程服务**

**注意：两个应用程序中的ADIL文件所在的包名要一致。**
