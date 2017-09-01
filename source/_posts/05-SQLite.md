---
title: 第五章 SQLite数据库
thumbnail: 'https://cdn.pixabay.com/photo/2017/01/11/08/31/icon-1971128__340.png'
date: 2017-03-05 20:43:19
tags: [Android]
categories: Android基础
description:
---

- SQLite数据库的基本操作
- 使用sqlite3工具操作数据库
- 使用ListView控件展示数据

<!--more-->

## 一、SQLite数据库简介
SQLite是一个轻量级数据库，占用资源少，遵守ACID事务属性，同时还支持SQL语言、事务处理等功能。

SQLite没有服务器进程，它通过文件保存数据，该文件是跨平台的，可以放在其他平台中使用。

在保存数据时，支持NULL、Integer、Real(浮点型数字)、Text(字符串文本)和Blob(二进制对象)5种数据类型。但实际上SQLite也接收varchar(n)、char(n)、decimal(p, s)等数据类型，只不过在运算或保存时会转换成对应的5种数据类型。因此，可以将各种类型的数据保存到任何字段中，而不用关心字段声明的数据类型。这也是SQLite数据库的最大特点。

## 二、SQLite数据库的使用
### 1. SQLite操作API
为了方便使用SQLite数据库，Android SDK提供了一系列对数据库进行操作的类和接口。

(1) SQLiteOpenHelper类

SQLiteOpenHelper是一个抽象类，该类用于创建数据库和数据库版本更新。该类常用方法如图5-1所示

<center>
<img src="./05-SQLite/Pic5-1.JPG" width="90%"/>图 5-1
</center>

(2) SQLiteDatabase类

SQLiteDatabase是一个数据库访问类，该类封装了一系列数据库操作的API，可以对数据库进行增、删、改、查操作。该类的常用方法如图5-2所示。

<center>
<img src="./05-SQLite/Pic5-2.JPG" width="90%"/>图 5-2
</center>

(3) Cursor接口

Cursor是一个游标接口，在数据库操作中作为返回值，相当于结果集ResultSet。该类的常用方法如图5-3所示。

<center>
<img src="./05-SQLite/Pic5-3.JPG" width="70%"/>图 5-3
</center>

### 2. SQLite常用操作
**(1) 创建SQLite数据库**

Android系统推荐使用SQLiteOpenHelper的子类创建SQLite数据库，因此需要创建一个类继承自SQLiteOpenHelper，重写onCreate()方法，并在该方法中执行创建数据库的命令。

**示例代码**

	public class PersonSQLiteOpenHelper extends SQLiteOpenHelper{
		// 构造方法，用来定义数据库的名称，数据库查询的结果集，数据库的版本
		public PersonSQLiteOpenHelper(Context context){
			super(context, "person.db", null, 5);
		}

		// 数据库第一次被创建时调用该方法
		public void onCreate(){
			// 初始化数据库的表结构，执行一条建表的SQL语句
			db.execSQL("create table person (id integer primary key autoincrement, name varchar(20), number varchar(20))");
		}

		// 当数据库的版本号增加时调用，如果数据库的版本号不增加，该方法则不会调用
		public void onUpgrade(){
			db.execSQL("alter table person add account varchar(20)");
		}
	}
		
**值得注意的是，创建的数据库被放置在/data/data/packagename/databases目录下。**

**(2) 增**

**示例代码**：使用SQLiteDatabase对象向person表中插入一条数据

	public void add(String name, String number){
		// 获取一个可读写的SQLiteDatabase对象
		SQLiteDatabase db=helper.getWritableDatabase();

		// 创建一个ContentValues对象，将参数以key，value的形式添加进去
		ContentValues values=new ContentValues();
		values.put("name", name);
		values.put("number", number);

		// 插入一条数据到person表中
		long id=db.insert("person", null, values);

		// 关闭数据库
		db.close();
		return id;
	}

除了上述介绍的方法之外，还有一个方法可以实现该功能：

	db.execSQL("insert into person(name, number) values (?, ?)", new Object[]{name, number});

**需要注意的是，使用完SQLiteDatabase对象后一定要关闭，否则数据库连接会一直存在，不断消耗内存，并且会报出数据库未关闭异常，当系统内存不足时将获取不到SQLiteDatabase对象。**

**(3) 删**

**示例代码**：使用SQLiteDatabase对象的delete()方法删除person表中的数据

	public int delete(String name){
		// 获取一个可读写的SQLiteDatabase对象
		SQLiteDatabase db=helper.getWritableDatabase();
		
		// 删除数据
		int number=db.delete("person", "name=?", new String[]{name});

		// 关闭数据库
		db.close();
		return number;
	}

**(4) 改**

**示例代码**：使用SQLiteDatabase对象的update()方法修改person表中的数据

	public int update(String name, String newNumber) {
		// 获取一个可读写的SQLiteDatabase对象
		SQLiteDatabase db=helper.getWritableDatabase();

		// 创建一个ContentValues对象，将参数以key，value的形式添加进去
		ContentValues values=new ContentValues();
		values.put("number", newNumber);

		//执行修改
		int number=db.update("person", values, "name=?", new String[]{name});
		
		// 关闭数据库
		db.close();
		return number;
	}

**(5) 查**

SQLiteDatabase提供两个用于查询数据的方法，一个是rawQuery()方法，另一个是query()方法。

**示例代码**：使用SQLiteDatabase对象的query()方法查询person表中的数据

	public boolean find(String name){
		// 获取一个可读的SQLiteDatabase对象
		SQLiteDatabase db=helper.getReadableDatabase();

		// 查询数据库的操作
		// 参数1：表名；  参数2：查询的列名；  参数3：查询条件；
		// 参数4：查询参数值；  参数5：分组条件；  参数6：having条件；  参数7：排列方式
		Cursor cursor=db.query("", null, "", new String[]{name}, null, null, null);
		// 是否有下一个值
		boolean result=cursor.moveToNext();
		// 关闭游标
		cursor.close();

		// 关闭数据库
		db.close();
		return result;
	}

使用SQLiteDatabase对象的rawQuery()方法查询person表中的数据

	Cursor cursor=db.rawQuery("select * from person where name=?", new String[]{name});

**增、删、改操作都可以用execSQL()方法执行SQL语句，而查询却使用rawQuery()，这是因为查询数据库会返回一个结果集Cursor，而execSQL()方法没有返回值。**

**需要注意的是，在使用完Cursor对象时，一定要及时关闭，否则会造成内存泄露。**

### 3. SQLite事务操作

所谓的事务就是针对数据库的一组操作，它可以由一条或多条SQL语句组成，由于事务的操作具备原子性的特点，如果其中有一条语句无法执行，那么所有的语句都不会执行，也就是说，事务中的语句要么都执行，要么都不执行。

**示例代码**：使用SQLite的事务来模拟转账功能

首先得到一个SQLiteDatabase对象，然后开启事务执行事务操作，最后关闭事务。

	PersonSQLiteOpenHelper helper=new PersonSQLiteOpenHelper(getContext());
	// 获取一个可读写的SQLiteDatabase对象
	SQLiteDatabase db=helper.getWritableDatabase();
	// 开始数据库的事务
	db.beginTransaction();
	try{	
		//执行转出操作
		db.execSQL("update person set account=account-100 where name=?", new Object[]{"zhangsan"}); 
		//执行转入操作
		db.execSQL("update person set account=account+100 where name=?", new Object[]{"wangwu"}); 
		//标记数据库事物执行成功
		db.setTransactionSuccessful();
	}catch(Exception e){
		Log.i("事务处理失败", e.toString());
	}finally{
		db.endTransaction();  //关闭事务
		db.close();           //关闭数据库
	}

**需要注意的是，事务操作完成后，一定要使用endTransaction()方法关闭事务，当执行到endTransaction()方法时，首先会检查是否有事务执行成功的标记，有则提交数据，无则回滚数据。最后会关闭事务，如果不关闭事务，事务只有到超时才自动结束，会降低数据库并发效率。因此，通常情况下，该方法放在finally中执行。**

### 4. sqlite3工具

在Android开发中，使用真机进行测试无法进入data目录(只有获得root权限的手机可以进入data目录)，因此也无法直接操作应用程序下的数据库。
为了解决这个问题，SQLite数据库为开发者提供了一个sqlite3.exe工具，通过这个工具可以直接操作数据库。

sqlite3.exe是一个简单的SQLite数据库管理工具，位于Android sdk/tools目录下。由于Android在运行时集成了sqlite3.exe，因此在使用sqlite3.exe工具前必须要开启模拟器或者连接真实设备。

使用该工具时，需要在命令行，一次输入如下命令：

- adb shell (挂载到Linux的目录空间)
- cd data/data (进入data/data目录)
- cd packagename (进入应用程序包目录中)
- ls (列出当前文件夹下的文件)
- cd databases (进入databases文件夹)
- ls -l (列出当前文件夹所有文件的详细格式)
- sqlite3 person.db (使用sqlite3操作应用程序下的数据库)
- select * from person; (使用SQL语句查询person表中的信息)

## 三、ListView

在Android开发中，ListView是一个比较常用的控件。它以列表的形式展示具体数据内容，并且能够根据数据的长度自适应屏幕显示。

**1. ListView控件的使用**

ListView的常见属性如图5-4所示。

<center>
<img src="./05-SQLite/Pic5-4.JPG" width="60%"/>图 5-4
</center>

使用ListView的**示例代码**：

	<?xml version="1.0" encoding="utf-8"?>
	<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
	    xmlns:tools="http://schemas.android.com/tools"
	    android:id="@+id/ll_root"
	    android:layout_width="match_parent"
	    android:layout_height="match_parent"
	    android:orientation="vertical"
	    tools:context=".MainActivity">
	    <ListView
	        android:id="@+id/lv"
	        android:layout_width="match_parent"
	        android:layout_height="wrap_content"/>
	</LinearLayout>

<center>
<img src="./05-SQLite/Pic5_5.png" width="30%"/>图5-5
</center>

图形化界面如图5-5所示，ListView是一个列表视图，由很多Item组成，每一个Item的布局都是一样的。需要注意的是，在布局文件中指定了ListView的id之后，ListView才会在图形化视图中显示出来。同时如果不对ListView进行数据适配，那么就无法在界面上看到布局文件中创建的ListView。

**2. 常用数据适配器**

在使用ListView时，需要对其进行数据适配。为了实现这个功能，Android系统提供了一系列的适配器(Adapter)对ListView进行数据适配。可以将适配器理解为界面数据绑定，适配器就像显示器，把复杂的数据按人们易于接受的方式来展示。

**(1) BaseAdapter**

它是一个抽象类，该类拥有4个抽象方法。在Android开发中，开发者在适配数据到ListView时，需要创建一个类继承BaseAdapter并重写这4个抽象方法，Android系统再根据这几个抽象方法对ListView进行数据适配。

- public int getCount(); 得到ListView中Item的总数
- public Object getItem(int position); 根据position得到某个Item对象
- public long getItemId(int position); 根据position得到某个Item对象的id
- public View getView(int position, View convertView, ViewGroup parent); 得到position位置对应的Item视图

**(2) SimpleAdapter**

SimpleAdapter继承自BaseAdapter，实现了BaseAdapter的4个抽象方法。因此，开发者只需在创建SimpleAdapter实例时，在构造方法中传入相应的参数即可。

SimpleAdapter的构造方法：

	public SimpleAdapter(Context context, List<? extends Map<String, ?> data, int resource, String[] from, int[] to);

构造方法的参数介绍如下：

- Context context：Context对象，getView()方法中需要用到Context将布局转换成View对象
- List<? extends Map<String, ?>> data：数据集合，SimpleAdapter已经在getCount()放啊中实现了将数据集合大小返回。
- int resource：Item布局的资源id
- String[] from：Map集合里面的key
- int[] to：Item布局对应的空间id

需要注意的是，SimpleAdapter只能适配Checkable、TextView、ImageView，其中Checkable是一个接口，CheckBox控件就实现了该接口，TextView是显示文本的控件，ImageView是显示图片的空间。**如果int[] to所代表的控件不是这三种类型则会报IllegalStateException。**


**(3) ArrayAdapter**

ArrayAdapter也是BaseAdapter的子类，与SimpleAdapter类似，开发者只需要在构造方法里面传入相应的参数即可适配数据。

	// 需要适配的数据
    private String[] names = { "京东商城", "QQ", "QQ斗地主", "新浪微博", "天猫", "UC浏览器", "微信" };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // 初始化ListView控件
        mListView = (ListView) findViewById(R.id.lv);

        // ArrayAdapter
		mListView.setAdapter(new ArrayAdapter<String>(this, R.layout.list_item, R.id.tv_list, names));
	}

ArrayAdapter通常用于适配TextView控件，例如Android系统中的Setting。

ArrayAdapter的构造方法如下所示：**public ArrayAdapter(Context context, int resource, int textViewResourceId, T[] objects);**

构造方法的参数介绍如下：

- Context context：Context对象
- int resource：Item布局资源的id
- int textViewResourceId：Item布局相应的TextView控件的id
- T[] objects：需要适配的数据数组

**案例**：Demo0501，Android应用市场，演示如何使用ListView以及如何对其进行数据适配。本案例要实现的是将一个字符数组和一组图片资源绑定到ListView上显示。

**案例**：Demo0502，商品展示，结合ListView和SQLite来实现在界面上操作数据库。

ListView的几个方法：

- setOnItemClickListener()方法：该方法用于监听Item的点击事件，在使用该方法时需要传入一个OnItemClickListener的实现类对象，并且需要实现onItemClick方法。当点击ListView的Item时就会触发Item的点击事件然后回调onItemClick()方法。
- setSelection()方法：该方法用于设置当前选中的条目。
- notifyDataSetChange()方法：当数据适配器中的内容发生变化时会调用该方法，重新执行Adapter的getView()方法。

	
