---
title: 第六章 ContentProvider
thumbnail: 'https://cdn.pixabay.com/photo/2017/01/11/08/31/icon-1971128__340.png'
date: 2017-03-06 20:43:55
tags: [Android]
categories: Android基础
description:
---

- 了解ContentProvider
- 使用ContentProvider
- 使用ContentResolver操作其他应用的数据
- 使用ContentObserver观察其他应用的数据变化

<!--more-->

在Android开发中，经常需要访问其他应用程序的数据。例如，使用支付宝转账时需要填写收款人的电话号码，此时就需要获取到系统联系人的信息。为了实现这种跨程序共享数据的功能，Android系统提供了一个组件：ContentProvider。

## 一、ContentProvider简介
ContentProvider是Android系统四大组件之一，用于保存和检索数据，是Android系统中不同应用程序之间共享数据的接口。

在Android系统中，应用程序之间是相互独立的，分别运行在自己的进程中，相互之间没有数据交换。若应用程序之间需要共享数据，就需要用到ContentProvider。

ContentProvider是不同应用程序之间进行数据交换的标准API，它以Uri的形式对外提供数据，允许其他应用操作本应用数据。其他应用则使用ContentResolver，并根据ContentProvider提供的Uri操作指定数据。

**ContentProvider的工作原理**

<center>
<img src="./06-ContentProvider/Pic6-1.jpg" width="60%"/>图6-1
</center>

如图6-1所示，A应用需要使用ContentProvider暴露数据，才能被其他应用操作。B应用必须通过ContentResolver操作A应用暴露出来的数据，而A应用会将操作结果返回给ContentResolver，然后ContentResolver再将操作结果返回给B应用。

## 二、创建ContentProvider

### 1. 创建ContentProvider
**(1) 创建ContentProvider，暴露数据的增、删、改、查方法**

在创建一个ContentProvider时，首先需要定义一个类继承android.content包下的ContentProvider类。ContentProvider类是一个抽象类，在使用该类时，需要重写它的onCreate()、delete()、getType()、insert()、query()和update()这几个抽象方法。

	public class PersonDBProvider extends ContentProvider {
	    //当ContentProvider被创建的时候调用，适合数据的初始化
	    @Override
	    public boolean onCreate() {
	        helper=new PersonSQLiteOpenHelper(getContext());
	        return false;
	    }
	
	    //根据传入的Uri查询指定条件下的数据
	    @Nullable
	    @Override
	    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
	        //匹配查询的Uri路径
	        if(matcher.match(uri)==QUERY){
	            SQLiteDatabase db=helper.getReadableDatabase();
	            Cursor cursor=db.query("person", projection, selection, selectionArgs, null, null, sortOrder);
	            return cursor;
	        }else if(matcher.match(uri)==QUERYONE){
	            long id= ContentUris.parseId(uri);//匹配成功,根据id查询数据
	            SQLiteDatabase db=helper.getReadableDatabase();
	            Cursor cursor=db.query("", projection, "id=?", new String[]{id+""}, null, null, sortOrder);
	            return cursor;
	        }else{
	            throw new IllegalArgumentException("路径不匹配，不能执行查询操作");
	        }
	    }
	
	    // 用于返回指定Uri代表的数据MIME类型，如.jpg和.txt。
		// 如果指定数据的类型属于集合型(多条数据)，getType()方法返回的字符串应该以"vnd.android.cursor.dir/"开头；
		// 如果属于非集合型(单条数据)，则返回的字符串以"vnd.android.cursor.item/"开头。
	    @Nullable
	    @Override
	    public String getType(Uri uri) {
	        if(matcher.match(uri)==QUERY){
	            return "vnd.android.cursor.dir/person";// 返回查询的结果集
	        }else if(matcher.match(uri)==QUERYONE){
	            return "vnd.android.cursor.item/person";
	        }
	        return null;
	    }
	
	    //根据传入的Uri插入数据
	    @Nullable
	    @Override
	    public Uri insert(Uri uri, ContentValues values) {
	        if(matcher.match(uri)==INSERT){
	            SQLiteDatabase db=helper.getWritableDatabase();
	            db.insert("person", null, values);
	        }else{
	            throw new IllegalArgumentException("路径不匹配，不能执行插入操作");
	        }
	        return null;
	    }
	
	    //根据传入的Uri删除指定条件下的数据
	    @Override
	    public int delete(Uri uri, String selection, String[] selectionArgs) {
	        if(matcher.match(uri)==DELETE){
	            SQLiteDatabase db=helper.getWritableDatabase();
	            db.delete("person", selection, selectionArgs);
	        }else{
	            throw new IllegalArgumentException("路径不匹配，不能执行删除操作");
	        }
	        return 0;
	    }
	
	    //根据传入的Uri更新指定条件下的数据
	    @Override
	    public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
	        if(matcher.match(uri)==UPDATE){
	            SQLiteDatabase db=helper.getWritableDatabase();
	            db.update("person", values, selection, selectionArgs);
	        }else{
	            throw new IllegalArgumentException("路径不匹配，不能执行修改操作");
	        }
	        return 0;
	    }
	}

**(2) 注册ContentProvider**

ContentProvider是Android的四大组件之一，因此需要和Activity一样在清单文件中注册。

	<provider
        android:authorities="learning.android.it.org.demo0601.PersonDBProvider"
        android:name="learning.android.it.org.demo0601.PersonDBProvider"/>

注册provider时指定了android:name和android:authorities两个属性。

- android:name代表继承于ContentProvider类的全路径名
- android:authorities代表了访问本provider的路径，**这里的路径必须要唯一**。

### 2. Uri简介
在ContentProvider的几个抽象方法中，都有一个参数Uri uri，它代表了数据的操作方法。

Uri是由scheme、authorities、path三部分组成。

<center>
<img src="./06-ContentProvider/Pic6-2.JPG" width="60%"/>图6-2
</center>

图6-2是一个Uri的实例。

- scheme部分**content://**是一个标准的前缀，表明这个数据被ContentProvider所控制，它不会被修改。
- authorities部分**learning.android.it.org.demo0601.PersonDBProvider**是在清单文件中指定的android:authorities属性值，该值必须唯一，它代表了当前的ContentProvider。
- path部分**/query**代表资源(或者数据)，当访问者需要操作不同数据时，这部分是动态改变的。

Uri.parse(String str)方法可以将字符串转化为Uri对象。为了解析Uri对象，Android系统提供了一个辅助工具类UriMatcher用于匹配Uri。

- **public UriMatcher(int code)**  创建UriMatcher对象时调用，参数通常使用*UriMatcher.NO_MATCH*，表示路径不满足时返回-1
- **public void addURI(String authority, String path, int code)** 添加一组匹配规则，*authority* 即Uri的authority部分，*path* 即Uri的path部分
- **public int match(Uri uri)**  匹配Uri与addURI方法相对应，匹配成功则返回*addURI*方法中传入的参数code值

使用UriMatcher匹配Uri的实例代码：

在暴露数据的增、删、改、查方法之前，首先需要添加一组用于请求数据操作的Uri，然后在相应的增删改查方法中匹配Uri，匹配成功才能对数据进行操作。

	// 定义一个uri的匹配器，用于匹配uri，如果路径不满足条件，则返回 -1
    private static UriMatcher matcher = new UriMatcher(UriMatcher.NO_MATCH);
    private static final int INSERT = 1;   //添加数据Uri路径匹配成功时返回码
    private static final int DELETE = 2;   //删除数据Uri路径匹配成功时返回码
    private static final int UPDATE = 3;   //更改数据Uri路径匹配成功时返回码
    private static final int QUERY = 4;    //查询数据Uri路径匹配成功时返回码
    private static final int QUERYONE = 5; //查询一条数据Uri路径匹配成功时返回码
    // 添加一组匹配规则
    static{
        matcher.addURI("learning.android.it.org.demo0601.PersonDBProvider", "insert", INSERT);
        matcher.addURI("learning.android.it.org.demo0601.PersonDBProvider", "delete", DELETE);
        matcher.addURI("learning.android.it.org.demo0601.PersonDBProvider", "update", UPDATE);
        matcher.addURI("learning.android.it.org.demo0601.PersonDBProvider", "query", QUERY);
        //这里的"#"号为通配符，凡是符合"query/"，皆返回QUERYONE的返回码
        matcher.addURI("learning.android.it.org.demo0601.PersonDBProvider", "query/#", QUERYONE);
    }

**案例：Demo0601，本案例实现了查询应用自己暴露的数据，并将数据捆绑到ListView控件中的功能。**

## 三、访问ContentProvider
在Android系统中，ContentResolver充当着一个中介的角色。应用程序使用ContentProvider暴露自己的数据，通过ContentResolver可以对应用程序暴露的数据进行操作。

### 1. ContentResolver的基本用法
由于在使用ContentProvider暴露数据时指定了相应数据的Uri，因此在访问现有ContentProvider时需要指定相应的Uri，然后通过ContentResolver对象来实现数据的操作。

**示例代码**

	//利用ContentResolver对象查询使用ContentProvider暴露的数据
    private void getPersons(){
		//首先要获取查询的uri
        String path="content://learning.android.it.org.demo0601.PersonDBProvider/query";
        Uri uri= Uri.parse(path);

        //获取ContentResolver对象
        ContentResolver resolver = getContentResolver();
        //利用ContentResolver对象查询数据,得到一个Cursor对象
        Cursor cursor=contentResolver.query(uri, null, null, null, null, null);
        persons=new ArrayList<>();
        //如果cursor为空立即结束该方法
        if(cursor==null){
            return;
        }
        while(cursor.moveToNext()){
            int id=cursor.getInt(cursor.getColumnIndex("id"));
            String name=cursor.getString(cursor.getColumnIndex("name"));
            String number=cursor.getString(cursor.getColumnIndex("number"));
            Person p=new Person(id, name, number);
            persons.add(p);
        }
        //需要注意的是，使用完Cursor之后，一定要关闭，否则会造成内存泄露
        cursor.close();
	}
**案例：Demo0602，本案例实现了使用ContentResolver操作Android系统短信应用暴露的数据，将系统短信的会话内容备份到本地XML文件的功能。**

## 四、内容观察者的使用
前面介绍的是当使用ContentProvider将数据共享出来时，可以使用ContentResolver查询ContentProvider共享出来的数据。

如果应用程序需要实时监听ContentProvider共享的数据是否发生变化，可以使用Android系统提供的ContentObserver来实现。

### 1. 什么是ContentObserver

ContentObserver用来观察指定Uri所代表的数据。当ContentObserver观察到指定Uri代表的数据发生变化时，就会触发ContentObserver的onChange()方法，此时，在onChange()方法里使用ContentResolver可以查询到变化的数据。

**ContentObserver的工作原理：**

<center>
<img src="./06-ContentProvider/Pic6-3.JPG" width="60%"/>图6-3
</center>

如图6-3所示，使用ContentObserver观察A应用的数据时，首先要在A应用的ContentProvider中调用ContentResolver的notifyChange()方法。调用了这个方法之后，当数据发生变化时，它就会向"消息中心"发送数据变化的消息。然后C应用观察到"消息中心"有数据变化，就会触发ContentObserver的onChange()方法。

ContentObserver的几个方法：

- **public void Observer(Handler handler)** ContentObserver的派生类都需要调用该构造方法。参数可以是主线程Handler(可以更新UI)，也可以是任何Handler对象
- **public void onChange(boolean selfChange)** 当观察到Uri代表的数据发生变化时，会触发该方法 

### 2. 使用ContentObserver

如果要使用ContentObserver观察数据变化，就必须在ContentProvider中的delete()、insert()、update()方法中调用ContentResolver的notifyChange()方法。

**示例代码：**

	public Uri insert(Uri uri, ContentValues values) {
        if(matcher.match(uri)==INSERT){
            SQLiteDatabase db=helper.getWritableDatabase();
            db.insert("person", null, values);
            getContext().getContentResolver().notifyChange(Uri.parse("learning.android.it.org.demo0601.PersonDBProvider"), null);
        }else{
            throw new IllegalArgumentException("路径不匹配，不能执行插入操作");
        }
        return null;
    }

上面代码通过调用ContentResolver的notifyChange()方法将数据变化的消息发送至"消息中心"。notifyChange(Uri uri, ContentObserver observer)方法中的observer参数表示指定具体的观察者接收数据发生变化的消息。如果不指定具体的观察者则传入null即可。

接下来在应用中注册ContentObserver监听数据变化。

**示例代码：**

	public class MainActivity extends AppCompatActivity {
	    private TextView mSmsTv;
	
	    @Override
	    protected void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        setContentView(R.layout.activity_main);
	
	        mSmsTv = (TextView) findViewById(R.id.sms_tv);
	
	        ContentResolver resolver = getContentResolver();
	        Uri uri = Uri.parse("content://sms/");
	        // 注册内容观察者
	        resolver.registerContentObserver(uri, true, new MyObserver(new Handler()));
	    }
	
	    // 自定义的内容观察者
	    private class MyObserver extends ContentObserver {
	        public MyObserver(Handler handler) {
	            super(handler);
	        }
	
	        // 当ContentObserver观察到是数据库的内容变化了，调用这个方法
	        // 观察到消息邮箱里面有一条数据库内容变化的通知.
	        public void onChange(boolean selfChange) {
	            super.onChange(selfChange);
	
	            Toast.makeText(MainActivity.this, "数据库的内容变化了.", Toast.LENGTH_SHORT).show();
	
	            Uri uri = Uri.parse("content://sms/");
	            // 获取ContentResolver对象
	            ContentResolver resolver = getContentResolver();
	            // 查询变化的数据
	            Cursor cursor = resolver.query(uri, new String[] { "address", "date", "type", "body" }, null, null, null);
	            // 因为短信是倒序排列 因此获取最新一条就是第一个
	            cursor.moveToFirst();
	            String address = cursor.getString(0);
	            String body = cursor.getString(3);
	            // 更改UI界面
	            mSmsTv.setText("短信内容：" + body + "\n" + "短信地址：" + address);
	            cursor.close();
	        }
	    }
	}

**案例：Demo0603，本案例实现了接收系统短信并将收到的短信显示在界面上的功能**
