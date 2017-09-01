---
title: 12-JDBC
thumbnail: 'https://cdn.pixabay.com/photo/2014/04/03/11/08/tea-311844__340.png'
date: 2017-02-24 18:27:20
tags: [Java]
categories: Java基础
description:
---

JDBC

<!--more-->

### 问：什么是JDBC？

JDBC是一套面向对象的应用程序接口(API)，制定了访问各类关系数据库的统一标准接口，为访问各个数据库厂商的关系数据库提供了标准的实现，它由一组用Java语言编写的类和接口组成。JDBC允许开发者用Java编写访问数据库的应用程序，而不需要关心底层特定数据库的细节。

### 问：JDBC访问数据库的步骤
	
	// 1. 加载JDBC驱动
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		// Class.forName("com.mysql.jdbc.driver"); //Mysql
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}

	// 2. 连接Oracle数据库
	String url = "jdbc:oracle:thin:@localhost:1521:DataBaseName";
	// String url="jdbc:mysql://localhost:1521/DataBaseName"; // Mysql
	String username = "admin";
	String password = "root";
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		conn = DriverManager.getConnection(url, username, password);

		// 3. 利用JDBC检索出表中的数据
		ps = conn.prepareStatement("select * from users;");
		rs = ps.executeQuery();
		while (rs.next()) {
			rs.getString(1); // 或rs.getString("name")
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		// 4. 关闭连接
		try {
			if (rs != null)
				rs.close();
			if (ps != null)
				ps.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

#### 问：Class.forName()方法有什么作用？

通过反射机制初始化参数指定的类，并且返回此类对应的Class对象。这个方法可以用来载入并注册跟数据库建立连接的驱动。

#### 问：解释下驱动(Driver)在JDBC中的角色。

JDBC驱动提供了特定厂商对JDBC API接口类的实现，驱动必须要提供java.sql包下面这些类的实现：Connection, Statement, PreparedStatement,CallableStatement, ResultSet和Driver。

加载驱动的几种方法：

> (1) 调用Class.forName()方法注册：Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
>
> (2) 通过添加jdbc.drivers系统属性注册：System.setProperty("jdbc.drivers", "com.mysql.jdbc.Driver");
>
> (3) 通过registerDriver方法注册：DriverManager.registerDriver(new com.mysql.jdbc.Driver());

### 问：Statement、PreparedSatement和CallableStatement

<center>
<img src="./12-JDBC/JDBC-Statement.JPG" width="46%"/>
</center>

### 问：PreparedStatement比Statement有什么优势？

PreparedStatement接口继承自Statement

(1) 使用Statement的方式：

	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery("select * from book;");

(2) 使用PreparedStatement的方式：

	PreparedStatement pstmt=conn.prepareStatement("select * from book;");
	ResultSet rs=pstmt.executeQuery();

(3) PreparedStatement比Statement的对比

- PreparedStatement实例包含预编译的SQL语句，可以减少SQL的编译错误，执行速度要快于Statement对象，因此，性能会更好。
- PreparedStatements是预编译的，可以避免不良用户直接敲sql语句产生sql注入攻击，安全性更强。
- PreparedStatement中的SQL语句是可以带参数的，对于不同的查询参数值，PreparedStatement可以重用。
- 当批量处理SQL或频繁执行相同的查询时，PreparedStatement有明显的性能上的优势，由于数据库可以将编译优化后的SQL语句缓存起来，下次执行相同结构的语句时就会很快（不用再次编译和生成执行计划）

<a href="https://www.nowcoder.com/profile/7404313/test/8004321/25808?onlyWrong=0" title="Title">例1</a>，<a href="https://www.nowcoder.com/profile/7404313/test/8088719/22471?onlyWrong=0" title="Title">例2</a>

#### 问：什么时候使用CallableStatement？用来准备CallableStatement的方法是什么？

CallableStatement接口继承自PreparedStatement

CallableStatement用来执行存储过程。存储过程是由数据库存储和提供的。存储过程可以接受输入参数，也可以有返回结果。如果有输出参数要注册说明是输出参数。非常鼓励使用存储过程，因为它提供了安全性和模块化。

准备一个CallableStatement的方法是：Connection.prepareCall()，实例代码如下：

	CallableStatement cs=conn.prepareCall("{call getCustomerName(?,?)}");
	cs.setString(1, "1");
	cs.registerOutParameter(2, java.sql.Types.VARCHAR);
	cs.execute();
	cs.getString(2);

#### 问：数据库连接池是什么意思？

像打开、关闭数据库连接这种和数据库的交互是很费时间的，尤其是当客户端数量增加的时候，会消耗大量的资源，成本非常高。

可以在应用服务器启动的时候建立很多个数据库连接并维护在一个池中。连接请求由池中的连接提供服务。在连接使用完毕以后，把连接归还到池中，以用于满足将来更多的请求。

### 问：ResultSet

<a href="https://www.nowcoder.com/profile/7404313/test/8078128/3223?onlyWrong=0" title="Title">例1</a>

例2：使用JDBC操作数据库时，如何提升读取数据的性能？如何提升更新数据的性能？ 

要提升读取数据的性能，可以指定通过结果集(ResultSet)对象的setFetchSize()方法指定每次抓取的记录数(典型的空间换时间策略)；

要提升更新数据的性能，可以使用PreparedStatement语句构建批处理，将若干SQL语句置于一个批处理中执行。

### 问：事务的ACID

- 原子性(Atomic)：事务中各项操作，要么全做要么全不做，任何一项操作的失败都会导致整个事务的失败； 
- 一致性(Consistent)：事务结束后系统状态是一致的； 
- 隔离性(Isolated)：并发执行的事务彼此无法看到对方的中间状态； 
- 持久性(Durable)：事务完成后所做的改动都会被持久化，即使发生灾难性的失败。通过日志和同步备份可以在故障发生后重建数据。

### 事务处理的问题

在并发数据访问时需要做事务处理。当多个事务访问同一数据时，可能会存在5类问题，包括3类数据读取问题（脏读、不可重复读和幻读）和2类数据更新问题（第1类丢失更新和第2类丢失更新）。

(1) 脏读（Dirty Read）：A事务读取B事务尚未提交的数据并在此基础上操作，而B事务执行回滚，那么A读取到的数据就是脏数据。

(2) 不可重复读（Unrepeatable Read）：事务A重新读取前面读取过的数据，发现该数据已经被另一个已提交的事务B修改过了。

(3) 幻读（Phantom Read）：事务A重新执行一个查询，返回一系列符合查询条件的行，发现其中插入了被事务B提交的行。

(1) 第1类丢失更新：事务A撤销时，把已经提交的事务B的更新数据覆盖了。

(2) 第2类丢失更新：事务A覆盖事务B已经提交的数据，造成事务B所做的操作丢失。

### 问：JDBC如何做事务处理？

Connection提供了事务处理的方法，通过调用setAutoCommit(false)可以设置手动提交事务；当事务完成后用commit()显式提交事务；如果在事务处理过程中发生异常则通过rollback()进行事务回滚。除此之外，从JDBC 3.0中还引入了Savepoint（保存点）的概念，允许通过代码设置保存点并让事务回滚到指定的保存点。 

<center>
<img src="./12-JDBC/transaction.jpg" width="405"/>
</center>

	conn.setAutoCommit(false)
	conn.commit();
	conn.rollback();
	conn.setAutoCommit(true)

### 问：数据库连接池

由于创建连接和释放连接都有很大的开销（尤其是数据库服务器不在本地时，每次建立连接都需要进行TCP的三次握手，释放连接需要进行TCP四次握手，造成的开销是不可忽视的），为了提升系统访问数据库的性能，可以事先创建若干连接置于连接池中，需要时直接从连接池获取，使用结束时归还连接池而不必关闭连接，从而避免频繁创建和释放连接所造成的开销，这是典型的用空间换取时间的策略（浪费了空间存储连接，但节省了创建和释放连接的时间）。

池化技术在Java开发中是很常见的，在使用线程时创建线程池的道理与此相同。

基于Java的开源数据库连接池主要有：C3P0、Proxool、DBCP、BoneCP、Druid等。

### 问：什么是DAO模式

DAO(Data Access Object)顾名思义是一个为数据库或其他持久化机制提供了抽象接口的对象，在不暴露底层持久化方案实现细节的前提下提供了各种数据访问操作。在实际的开发中，应该将所有对数据源的访问操作进行抽象化后封装在一个公共API中。用程序设计语言来说，就是建立一个接口，接口中定义了此应用程序中将会用到的所有事务方法。在这个应用程序中，当需要和数据源进行交互的时候则使用这个接口，并且编写一个单独的类来实现这个接口，在逻辑上该类对应一个特定的数据存储。DAO模式实际上包含了两个模式，一是Data Accessor（数据访问器），二是Data Object（数据对象），前者要解决如何访问数据的问题，而后者要解决的是如何用对象封装数据。

### 问：JDBC能否处理Blob和Clob

Blob是指二进制大对象（Binary Large Object），而Clob是指大字符对象（Character Large Objec），因此其中Blob是为存储大的二进制数据而设计的，而Clob是为存储大的文本数据而设计的。JDBC的PreparedStatement和ResultSet都提供了相应的方法来支持Blob和Clob操作。

下面的代码展示了如何使用JDBC操作LOB：

以MySQL数据库为例，创建一个张有三个字段的用户表，包括编号(id)、姓名(name)和照片(photo)，建表语句如下：

	create table tb_user(
		id int primary key auto_increment,
		name varchar(20) unique not null,
		photo longblob
	);

编程向数据库中插入一条记录：

	public static void main(String[] args) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test", "root", "123456");
			PreparedStatement ps = conn.prepareStatement("insert into tb_user values (default, ?, ?)");
			ps.setString(1, "骆昊");
			try (InputStream in = new FileInputStream("head.jpg")) {// Java 7的TWR
				ps.setBinaryStream(2, in); // 将SQL语句中第二个占位符换成二进制流
				System.out.println(ps.executeUpdate() == 1 ? "插入成功" : "插入失败");
			} catch (IOException e) {
				System.out.println("读取照片失败!");
			}
		} catch (ClassNotFoundException | SQLException e) {// Java 7的多异常捕获
			e.printStackTrace();
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
					conn = null; // 指示垃圾回收器可以回收该对象
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

### 问：Jdo是什么？(没用过)

JDO是Java对象持久化的新的规范，为java data object的简称，也是一个用于存取某种数据仓库中的对象的标准化API。JDO提供了透明的对象存储，因此对开发人员来说，存储数据对象完全不需要额外的代码（如JDBC API的使用）。这些繁琐的例行工作已经转移到JDO产品提供商身上，使开发人员解脱出来，从而集中时间和精力在业务逻辑上。另外，JDO很灵活，因为它可以在任何数据底层上运行。JDBC只是面向关系数据库（RDBMS)JDO更通用，提供到任何数据底层的存储功能，比如关系数据库、文件、XML以及对象数据库（ODBMS）等等，使得应用可移植性更强。(o/rMapping工具集合处理)

### 问：在ORACLE大数据量下的分页解决方法。(没用过)

	create or replace package myPack
	is
		type c_type is ref cursor;
		procedure getPage(v_sql varchar2,pageSize number,pageIndex number,c out c_type);
	end;
	
	create or replace  package  body myPack
	is
		procedure getPage(v_sql varchar2,pageSize number,pageIndex number,c out c_type)
	  is
	    pageTotal int:=0;
	    pageFirstRow int:=0;
	    pageLastRow int:=0;
	    rowTotal int:=0;
	  begin
	    execute immediate 'select count(*)  from ('||v_sql||')' into rowTotal;
	    pageTotal:=ceil(rowTotal/pageSize);
	    if(pageIndex<1) then
	           raise_application_error(-20001,'页数不能小于1');
	    end if;
	    if(pageIndex>pageTotal) then
	           raise_application_error(-20001,'页数太大，不能读取');
	    end if;
	    pageFirstRow:=(pageIndex-1)*pageIndex+1;
	    pageLastRow:=pageFirstRow+pageSize;
	    open c for ' select * from '||v_sql||' where rownum<'||
	         pageLastRow||'minus select * from '||v_sql
	         ||' where rownum<'||pageFirstRow;    
	  end;
	end;
