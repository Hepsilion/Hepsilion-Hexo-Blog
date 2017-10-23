---
title: 01-SpringMVC入门与环境配置
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:41:29
tags: SpringMVC
categories: SpringMVC
description:
---

本页内容来自：http://www.cnblogs.com/best/p/5653916.html，只是对其中部分内容重新组织，稍加修改。

<!--more-->

## 一、MVC概要

MVC是模型(Model)、视图(View)、控制器(Controller)的简写，是一种软件设计规范，用一种将业务逻辑、数据、显示分离的方式组织代码，MVC主要作用是降低了视图与业务逻辑间的双向偶合。MVC不是一种设计模式，而是一种架构模式。当然，不同的MVC之间存在差异。

<center>
<img src="SpringMVC-01/SpringMVC-01-01.png" width="30%"/>图 1
</center>

在早期的web开发中，通常采用的都是Model1模式。如图2所示，在Model1模式中，项目主要分为两层：视图层和模型层。Model1模式的实现比较简单，适用于快速开发小规模项目。Model1模式中的JSP页面身兼View和Controller两种角色，将控制逻辑和表现逻辑混杂在一起，导致代码的重用性非常低，增加了应用扩展和维护的难度。

<center>
<img src="SpringMVC-01/SpringMVC-01-02.png" width="50%"/>图 2
</center>

Model2模式消除了Model1模式的缺点。如图3所示，Model2模式把一个项目分成三部分：视图、控制、模型。这样不仅提高了代码的复用率与项目的扩展性，而且大大降低了项目的维护成本。

<center>
<img src="SpringMVC-01/SpringMVC-01-03.png" width="50%"/>图 3
</center>

常见的服务器端MVC框架有Struts、Spring MVC、ASP.NET MVC、Zend Framework、JSF等；

常见前端MVC框架有angularjs、reactjs、backbone等；

由MVC模式还演化出了其他一些模式如：MVP、MVVM。

## 二、Spring MVC简介

## 三、Spring MVC环境配置：第一个Spring MVC项目

### 1. 使用Maven新建一个Web项目

(1) 在Eclipse中新建Maven项目

<center>
<img src="SpringMVC-01/SpringMVC-01-04.png" width="55%"/>图 4
</center>

(2) 选择"Create a simple project"，创建一个简单项目，不选择模板

<center>
<img src="SpringMVC-01/SpringMVC-01-05.png" width="65%"/>图 5
</center>

(3) 填写Group Id，Artifact Id，Version和Packaging等信息

<center>
<img src="SpringMVC-01/SpringMVC-01-06.png" width="70%"/>图 6
</center>

(4) 创建好的Maven项目目录结构如图7所示

<center>
<img src="SpringMVC-01/SpringMVC-01-07.png" width="30%"/>图 7
</center>

(5) 修改层面信息，选择Dynamic Web Module版本为3.0，Java版本为1.8

<center>
<img src="SpringMVC-01/SpringMVC-01-08.png" width="100%"/>图 8
</center>

(6) 在/src/main/webapp目录下创建WEB-INF文件夹，如图9所示在其中创建web.xml文件，填入如下内容

	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns="http://java.sun.com/xml/ns/javaee"
		xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
		id="WebApp_ID" version="3.0">
	</web-app>

<center>
<img src="SpringMVC-01/SpringMVC-01-09.png" width="30%"/>图 9
</center>

### 2. 添加依赖的jar包

修改pom.xml文件，添加jar包的依赖，主要有：Spring框架核心库、Spring MVC、JSTL等

	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<modelVersion>4.0.0</modelVersion>
		<groupId>org.spring.mvc</groupId>
		<artifactId>spring-mvc</artifactId>
		<version>0.0.1</version>
		<packaging>war</packaging>
	
		<properties>
			<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
			<spring.version>4.3.0.RELEASE</spring.version>
		</properties>
	
		<dependencies>
			<!--Spring框架核心库 -->
			<dependency>
				<groupId>org.springframework</groupId>
				<artifactId>spring-context</artifactId>
				<version>${spring.version}</version>
			</dependency>
			<!-- Spring MVC -->
			<dependency>
				<groupId>org.springframework</groupId>
				<artifactId>spring-webmvc</artifactId>
				<version>${spring.version}</version>
			</dependency>
			<!-- JSTL -->
			<dependency>
				<groupId>javax.servlet</groupId>
				<artifactId>jstl</artifactId>
				<version>1.2</version>
			</dependency>
		</dependencies>
	</project>

当依赖添加成功后，项目会加载的jar包如图10所示

<center>
<img src="SpringMVC-01/SpringMVC-01-10.png" width="30%"/>图 10
</center>

### 3. 注册中心控制器DispatcherServlet

和许多其他MVC框架一样，Spring MVC框架也是请求驱动的，使用一个中心控制器(DispatcherServlet，它继承自HttpServlet)分派请求及提供其他功能。

如图11所示，当前端控制器拦截到用户发送的请求时，会根据请求参数生成代理请求，找到请求对应的实际控制器，由该控制器处理请求：创建数据模型、访问数据库、将模型响应给前端控制器，前端控制器使用模型与视图渲染视图结果，再将结果返回给请求者。

<center>
<img src="SpringMVC-01/SpringMVC-01-11.png" width="55%"/>图 11
</center>

<center>
<img src="SpringMVC-01/SpringMVC-01-12.jpg" width="65%"/>图 12
</center>

修改web.xml文件注册该Servlet，修改后的web.xml文件如下

	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns="http://java.sun.com/xml/ns/javaee"
		xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
		id="WebApp_ID" version="3.0">
		<servlet>
	        <!--名称 -->
	        <servlet-name>springmvc</servlet-name>
	        <!-- Servlet类 -->
	        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	        <init-param>
	            <!--SpringMVC配置参数文件的位置 -->
	            <param-name>contextConfigLocation</param-name>
	            <!--默认名称为ServletName-servlet.xml -->
	            <param-value>classpath*:springmvc-servlet.xml</param-value>
	        </init-param>
	        <!-- 启动顺序，数字越小，启动越早 -->
	        <load-on-startup>1</load-on-startup>
	    </servlet>
	
	    <!--所有请求都会被springmvc拦截 -->
	    <servlet-mapping>
	        <servlet-name>springmvc</servlet-name>
	        <url-pattern>/</url-pattern>
	    </servlet-mapping>
	</web-app>

### 4. 添加Spring MVC配置文件

在/src/main/resources目录下添加Spring MVC配置文件springmvc-servlet.xml，配置的形式与Spring容器配置基本类似，具体配置信息如下：

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns:context="http://www.springframework.org/schema/context"
		xmlns:mvc="http://www.springframework.org/schema/mvc"
		xsi:schemaLocation="http://www.springframework.org/schema/beans 
	        http://www.springframework.org/schema/beans/spring-beans.xsd
	        http://www.springframework.org/schema/context 
	        http://www.springframework.org/schema/context/spring-context-4.3.xsd
	        http://www.springframework.org/schema/mvc 
	        http://www.springframework.org/schema/mvc/spring-mvc-4.3.xsd">
	
		<!-- 自动扫描包，实现支持注解的IOC -->
		<context:component-scan base-package="org.spring.mvc" />
	
		<!-- Spring MVC不处理静态资源 -->
		<mvc:default-servlet-handler />
	
		<!-- 支持mvc注解驱动 -->
		<mvc:annotation-driven />
	
		<!-- 视图解析器 -->
		<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="internalResourceViewResolver">
			<!-- 前缀 -->
			<property name="prefix" value="/WEB-INF/view/" />
			<!-- 后缀 -->
			<property name="suffix" value=".jsp" />
		</bean>
	</beans>

- 为了支持基于注解的IOC，设置了自动扫描包的功能；
- 在视图解析中，我们把所有的视图都存放在`/WEB-INF`目录下，因为客户端不能直接访问这个目录，这样可以保证视图安全。在该项目中，我们把视图放在view目录下。

### 5. 创建HelloWorld控制器

在src/main/java源代码目录下创建包org.spring.mvc.controller，在包中创建一个普通的类：HelloWorldController，具体代码如下：

	package org.spring.mvc.controller;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.RequestMapping;
	
	@Controller
	@RequestMapping("/HelloWorld")
	public class HelloWorldController {
		@RequestMapping("/helloworld")
	    public String helloworld(Model model) {
	        model.addAttribute("message", "Hello Spring MVC!");
	        return "helloworld";
	    }
	}

- 使用@Controller注解让Spring IOC容器在初始化时可以自动扫描到该控制器；
- 使用@RequestMapping注解注册映射请求路径，因为这里的类与方法 (Action) 上都有@RequestMapping，所以访问路径应该是/HelloWorld/helloworld；
- 方法中声明Model类型的参数是为了让控制器把Action中的数据带到视图中；
- 方法返回的结果是视图的名称：helloworld。

### 6. 创建视图

在WEB-INF/view目录中创建视图helloworld.jsp，该视图将展示从Action中返回的信息，具体内容如下：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>Hello Spring MVC!</title>
		</head>
		<body>
		    <h2>${message}</h2>
		</body>
	</html>

需要为jsp添加Servlet核心包

	<!-- Servlet核心包 -->
	<dependency>
		<groupId>javax.servlet</groupId>
		<artifactId>javax.servlet-api</artifactId>
		<version>3.0.1</version>
		<scope>provided</scope>
	</dependency>

### 7. 测试运行

启动Tomcat运行项目，注意查看启动信息，如果有异常应该先解决异常信息。运行成功后的结果如下所示：

<center>
<img src="SpringMVC-01/SpringMVC-01-13.png" width=80%"/>图 13
</center>

## 三、控制器定义

控制器提供了访问应用程序的行为，解析用户的请求并将其转换为一个模型，通常通过接口定义或注解定义两种方法实现。在Spring MVC中一个控制器可以包含多个Action（动作、方法）。

### 1. 实现Controller接口定义控制器

Controller是一个接口，位于包org.springframework.web.servlet.mvc中，接口中只有一个未实现的方法，如下所示：

	package org.springframework.web.servlet.mvc;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.web.servlet.ModelAndView;
	
	//实现该接口的类获得控制器功能与类型, 解析用户的请求并将其转换为一个模型
	public interface Controller {
	    //处理请求且返回一个模型与视图对象
	    ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception;
	}

(1) 定义一个名为Controller01的类，实现Controller接口，重写handleRequest方法，代码如下：

	package org.spring.mvc.controller;
	
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.Controller;
	
	/*
	 * 定义控制器
	 */
	public class Controller01 implements Controller{
		public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
			//返回一个模型视图对象，指定路径，指定模型的名称为message，值为一段字符串
	        return new ModelAndView("index", "message", "Hello，我是通过实现接口定义的一个控制器");
		}
	}

(2) 在WEB-INF/view目录下创建一个名为index.jsp的视图，内容如下：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>index</title>
		</head>
		<body>
			${message}
		</body>
	</html>

(3) 修改springmvc-servlet.xml配置文件，增加一个控制器bean的声明，基中name是访问路径，class是自定义的控制器的全名称。具体内容如下：

	<bean name="/controller01" class="org.spring.mvc.controller.Controller01"></bean>

(4) 运行结果如下：

<center>
<img src="SpringMVC-01/SpringMVC-01-14.png" width=80%"/>图 14
</center>

(5) 小结

实现Controller接口定义控制器是较老的办法，缺点是：一个控制器中只能有一个Action，如果要多个Action则需要定义多个Controller；定义的方式比较麻烦；Spring 2.5以后采用注解的方式定义解决这引起问题。

### 2. 使用注解@Controller定义控制器

org.springframework.stereotype.Controller注解类型用于声明Spring类的实例是一个控制器（在讲IOC时还提到了另外3个注解），Spring可以使用扫描机制来找到应用程序中所有基于注解的控制器类。

(1) 为了保证Spring能找到你的控制器，需要在配置文件中声明组件扫描，启用自动组件扫描功能，在beans中增加如下配置：

	<!-- 自动扫描包，实现支持注解的IOC -->
	<context:component-scan base-package="org.spring.mvc" />

base-package属性用于指定扫描的基础包，可以缩小扫描的范围。

(2) 定义为一个控制器类，类的具体实现如下：

	package org.spring.mvc.controller;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.RequestMapping;
	
	/**
	 * 定义控制器
	 * 
	 * Controller02类的实例是一个控制器，会自动添加到Spring上下文中
	 */
	@Controller
	public class Controller02 {
		 //映射访问路径
	    @RequestMapping("controller02")
	    public String index(Model model){
	        //Spring MVC会自动实例化一个Model对象用于向视图中传值
	        model.addAttribute("message", "Hello，我是通过注解定义的一个控制器");
	        //返回视图位置
	        return "index";
	    }
	}

(3) 运行结果如下：

<center>
<img src="SpringMVC-01/SpringMVC-01-15.png" width=80%"/>图 15
</center>

(4) 小结

从代码与运行结果可以看出Controller01与Controller02同时都指定了一个视图index.jsp，但是页面的结果是不一样的，从这里可以看出视图是被复用的，而控制器与视图之间是弱偶合关系。
