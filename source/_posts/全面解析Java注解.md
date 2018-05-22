---
title: 全面解析Java注解
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2018-05-22 16:51:54
tags: 慕课网
categories: Java其他
description:
---

<!--more-->

# 全面解析Java注解

## 一、  注解概述

#### 1. JDK自带注解

- @Override 告诉编译器该方法覆盖了父类的方法
- @Deprecated 表示该方法已经过时
- @Suppvisewarnings 表示忽略了"deprecation"警告

#### 2. 常见第三方注解

Spring中常见注解：@Autowired， @Service，@Repository

Mybatis中常见注解：@InsertProvider，@UpdataProvider，@Options

#### 3. Java注解的分类

- 按运行机制分类
	- 源码注解：注解只在源码中存在，编译成.class文件就不存在了。
	- 编译时注解：注解在源码和.class文件中都存在，如JDK自带注解。
	- 运行时注解：在运行阶段依然起作用，甚至会影响程序的运行逻辑。
- 按注解来源分类：
	- JDK自带注解
	- 第三方注解
	- 自定义注解

## 二、自定义注解

#### 1. 定义注解

##### 自定义注解的语法要求

- 使用@interface关键字定义注解，其中成员必须以无参无异常方式声明，同时可以用default为成员指定一个默认值；
- 自定义注解的成员类型是受限的，合法的类型包括原始类型、String、Class、Annotation和Enumeration；
- 如果注解只有一个成员，那么成员名必须取名为value()，并且在使用时可以忽略成员名和赋值号(=)；
- 注解类可以没有成员，没有成员的注解称为标识注解。

##### 元注解说明

- @Target： 指定注解的作用域：
	- CONSTRUCTOR，构造方法
	- FIELD，属性
	- LOCAL_VARIABLE,局部变量
	- METHOD，方法
	- PACKAGE，包
	- PARAMETER，参数
	- TYPE 类或接口
- @Retention： 指定注解的生命周期
	- SOURCE，源码级别，编译时丢失
	- CLASS，编译级别，运行时丢失
	- RUNTIME，运行级别，可以通过反射获取
- @Inherited： 标识注解允许子类继承
- @Documented： 指定生成javadoc时会包含注解

###### 例1： 自定义注解的实例：

	@Target({ElementType.METHOD, ElementType.Type})
	@Retention(RetentionPolicy.RUNTIME)
	@Inherited
	@Documented
	public @interface Description {
		String desc();
		String author();
		int age() default 18;
	}

### 2. 使用自定义注解

使用注解的语法： @<注解名>(<成员名1>=<成员值1>, <成员名2>=<成员值2>, ...)

###### 例2：使用自定义注解的实例

	@Description(desc="I am eyeColor", author="Mooc Boy", age=18)
	public String eyeColor() {
		return "red";
	}

## 三、解析注解

解析注解：通过反射获取类、函数或成员上的运行时注解信息，从而实现动态控制程序的运行逻辑。

###### 例1：下面通过实例演示解析注解的过程

(1) 定义使用自定义注解的父类

	@Description(desc = "I am annotation in parent class", author = "Parent")
	public class Parent {
	    @Description(desc = "I am annotation in parent method", author = "Parent")
	    public String name() {
	        return "name:parent";
	    }
	}

(2) 定义使用自定义注解的子类

	@Description(desc = "I am annotation in child class", author = "Child")
	public class Child extends Parent {
	    @Description(desc = "I am annotation in child method", author = "Child")
	    @Override
	    public String name() {
	        return "name:child";
	    }
	}

(3) 解析类和方法上的注解

	public class Analyzer {
	    public static void main(String[] args) {
	        try {
	            // 类注解解析方式
	            Class clazz = Class.forName("Child");
	            boolean exists = clazz.isAnnotationPresent(Description.class);
	            if(exists) {
	                Description description = (Description) clazz.getAnnotation(Description.class);
	                System.out.println(description.desc());
	            }
	
	            // 第一种方法注解解析方式
	            Method[] methods = clazz.getMethods();
	            for(Method method : methods) {
	                exists = method.isAnnotationPresent(Description.class);
	                if(exists) {
	                    Description description = method.getAnnotation(Description.class);
	                    System.out.println(description.desc());
	                }
	            }
	
	            // 第二种方法注解解析方法
	            for(Method method:methods) {
	                Annotation[] annotations = method.getAnnotations();
	                for(Annotation annotation:annotations) {
	                    if(annotation instanceof Description) {
	                        Description description = (Description) annotation;
	                        System.out.println(description.desc());
	                    }
	                }
	            }
	        } catch (ClassNotFoundException e) {
	            e.printStackTrace();
	        }
	    }
	}

解析结果如下：

	I am annotation in child class
	I am annotation in child method
	I am annotation in child method

注意：

- @Inherited只能实现类上注解的继承，而无法实现接口上注解的继承，即接口的注解无法影响到实现接口的类上面。
- 父类方法的注解也无法被子类继承。

###### 例2：修改注解如下：

	@Target({ElementType.METHOD, ElementType.TYPE})
	@Retention(RetentionPolicy.CLASS)
	@Inherited
	@Documented
	public @interface Description {
	    String desc();
	    String author();
	    int age() default 18;
	}

此时解析结果没有输出，说明该注解只作用于编译阶段，运行时注解丢失	

###### 例3：修改子类如下

	public class Child extends Parent {
	    @Override
	    public String name() {
	        return "name:child";
	    }
	}

此时解析结果如下，说明父类方法的注解无法被子类方法继承：

	I am annotation in parent class

###### 例4：修改父类如下

	@Description(desc = "I am annotation in parent interface", author = "Parent")
	public interface Parent {
	    String name();
	}

修改子类如下：

	public class Child implements Parent {
	    @Override
	    public String name() {
	        return "name:child";
	    }
	}

此时解析结果没有输出，说明接口的注解无法影响到实现接口的类。

## 四、项目实战

定义类：

	public class User {
	    private int id;
	    private String username;
	    private String nickname;
	    private int age;
	    private String city;
	    private String email;
	    private String mobile;
	
	    public int getId() {
	        return id;
	    }
	    public void setId(int id) {
	        this.id = id;
	    }
	    public String getUsername() {
	        return username;
	    }
	    public void setUsername(String username) {
	        this.username = username;
	    }
	    public String getNickname() {
	        return nickname;
	    }
	    public void setNickname(String nickname) {
	        this.nickname = nickname;
	    }
	    public int getAge() {
	        return age;
	    }
	    public void setAge(int age) {
	        this.age = age;
	    }
	    public String getCity() {
	        return city;
	    }
	    public void setCity(String city) {
	        this.city = city;
	    }
	    public String getEmail() {
	        return email;
	    }
	    public void setEmail(String email) {
	        this.email = email;
	    }
	    public String getMobile() {
	        return mobile;
	    }
	    public void setMobile(String mobile) {
	        this.mobile = mobile;
	    }
	}


需求：给定上面展示的实体类及设置了相关属性的对象，实现实体对象对应的SQL查询语句

	public static void main(String[] args) {
		// 查询id为10的用户信息
        User user1 = new User();
        user1.setId(10);

		// 查询username为"lucy"的用户信息
        User user2 = new User();
        user2.setUsername("lucy");

		// 查询email在"liu@sina.com,zh@163.com,777@qq.com"中的用户信息
        User user3 = new User();
        user3.setEmail("liu@sina.com,zh@163.com,777@qq.com");

        String sql1 = query(user1);
        String sql2 = query(user2);
        String sql3 = query(user3);

        System.out.println(sql1);
        System.out.println(sql2);
        System.out.println(sql3);
    }

实现：通过自定义注解和注解解析实现SQL转化过程

(1) 定义注解Table

	@Target({ElementType.TYPE})
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Table {
	    String value();
	}

(2) 定义注解Column

	@Target({ElementType.FIELD})
	@Retention(RetentionPolicy.RUNTIME)
	public @interface Column {
	    String value();
	}

(3) 给实体类添加注解

	@Table("user")
	public class User {
	    @Column("id")
	    private int id;
	    @Column("username")
	    private String username;
	    @Column("nickname")
	    private String nickname;
	    @Column("age")
	    private int age;
	    @Column("city")
	    private String city;
	    @Column("email")
	    private String email;
	    @Column("mobile")
	    private String mobile;
	
	    public int getId() {
	        return id;
	    }
	    public void setId(int id) {
	        this.id = id;
	    }
	    public String getUsername() {
	        return username;
	    }
	    public void setUsername(String username) {
	        this.username = username;
	    }
	    public String getNickname() {
	        return nickname;
	    }
	    public void setNickname(String nickname) {
	        this.nickname = nickname;
	    }
	    public int getAge() {
	        return age;
	    }
	    public void setAge(int age) {
	        this.age = age;
	    }
	    public String getCity() {
	        return city;
	    }
	    public void setCity(String city) {
	        this.city = city;
	    }
	    public String getEmail() {
	        return email;
	    }
	    public void setEmail(String email) {
	        this.email = email;
	    }
	    public String getMobile() {
	        return mobile;
	    }
	    public void setMobile(String mobile) {
	        this.mobile = mobile;
	    }
	}

(4) 通过注解解析实现转化过程

	private static String query(User user) {
        StringBuilder sb = new StringBuilder();

        Class clazz = user.getClass();
        boolean exists = clazz.isAnnotationPresent(Table.class);
        if(!exists)
            return null;
        Table table = (Table) clazz.getAnnotation(Table.class);
        String tableName = table.value();
        sb.append("select * from ").append(tableName).append(" where 1=1");

        Field[] fields = clazz.getDeclaredFields();
        for(Field field:fields) {
            exists = field.isAnnotationPresent(Column.class);
            if(!exists)
                continue;
            Column column = field.getAnnotation(Column.class);
            String fieldName = field.getName();
            String methodName = "get"+fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
            Object fieldValue=null;
            try {
                Method method = clazz.getMethod(methodName);
                fieldValue = method.invoke(user);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if(fieldValue==null || (fieldValue instanceof Integer && (Integer)fieldValue==0)){
                continue;
            }
            sb.append(" and ").append(fieldName);
            if(fieldValue instanceof String) {
                if(((String)fieldValue).contains(",")) {
                    String[] values = ((String)fieldValue).split(",");
                    sb.append(" in (");
                    for(String value: values) {
                        sb.append("'").append(value).append("'").append(",");
                    }
                    sb.deleteCharAt(sb.length()-1);
                    sb.append(")");
                }else {
                    sb.append("=").append("'").append(fieldValue).append("'");
                }
            }else {
                sb.append("=").append(fieldValue);
            }
        }
        return sb.toString();
    }

(4) 测试输出结果：

	select * from user where 1=1 and id=10
	select * from user where 1=1 and username='lucy'
	select * from user where 1=1 and email in ('liu@sina.com','zh@163.com','777@qq.com')
