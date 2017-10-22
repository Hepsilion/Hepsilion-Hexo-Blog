---
title: SpringMVC-07 文件上传
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:55:13
tags:
categories:
description:
---

<!--more-->
# 文件上传

在Spring MVC中有两种实现上传文件的办法，第一种是Servlet3.0以下的版本通过commons-fileupload与commons-io完成的通用上传，第二种是Servlet3.0以上的版本通过Spring内置标准上传，不需借助第3方组件。通用上传也兼容Servlet3.0以上的版本。

## 一、Servlet3.0以下版本

### 1. 添加上传依赖包

因为需要借助第三方上传组件commons-fileupload与commons-io，所以要修改pom.xml文件添加依赖。

	<!--文件上传 -->
    <dependency>
        <groupId>commons-io</groupId>
        <artifactId>commons-io</artifactId>
        <version>2.4</version>
    </dependency>
    <dependency>
        <groupId>commons-fileupload</groupId>
        <artifactId>commons-fileupload</artifactId>
        <version>1.3.1</version>
    </dependency>

### 2. 新增上传页面upload1.jsp

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>上传文件</title>
		</head>
		<body>
			<h2>上传文件</h2>
			<form action="fileSave" method="post" enctype="multipart/form-data">
				<p>
					<label for="files">文件：</label> <input type="file" name="files" id="files" multiple="multiple" />
				</p>
				<p>
					<button>提交</button>
				</p>
				<p>${message}</p>
			</form>
		</body>
	</html>

需要注意的关键点：

- method的值必为Post；
- enctype必须为multipart/form-data，该类型的编码格式专门用于二进制数据类型；
- 上传表单元素必须拥有name属性；

### 3. 修改配置文件，增加上传配置

默认情总下Spring MVC对文件上传的视图内容是不能解析的，需要修改springmvc-servlet.xml配置文件配置一个CommonsMultipartResolver类型的解析器解析上传的内容。

	<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="defaultEncoding" value="utf-8" />
        <property name="maxUploadSize" value="10485760000" />
        <property name="maxInMemorySize" value="40960" />
    </bean>

其具有的各属性的意义如下：

- defaultEncoding：默认编码格式
- maxUploadSize：上传文件最大限制（字节byte）
- maxInMemorySize：缓冲区大小

	

当Spring的前置中心控制器接收到客户端发送的一个多分部请求，定义在上下文中的解析器将被激活并开始处理。解析器将当前的HttpServletRequest包装成一个支持多部分文件上传的MultipartHttpServletRequest对象，在控制器中可以获得上传的文件信息。

- CommonsMultipartResolver用于通用的文件上传，支持各种版本的Servlet。
- StandardServletMultipartResolver用于Servlet3.0以上的版本上传文件。

### 4. 增加控制器与Action

	package org.spring.mvc.controller;
	
	import java.io.File;
	
	import javax.servlet.http.HttpServletRequest;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.multipart.MultipartFile;
	
	@Controller
	@RequestMapping("/upload")
	public class FileUploadController {
		@RequestMapping("/file1")
		public String file1(Model model) {
			return "upload/upload1";
		}
	
		@RequestMapping(value = "/fileSave", method = RequestMethod.POST)
		public String fileSave(Model model, MultipartFile[] files, HttpServletRequest request) throws Exception {
			for (MultipartFile file : files) {
				System.out.println(file.getOriginalFilename());
				System.out.println(file.getSize());
				System.out.println("--------------------------");
				File tempFile = new File("D:/", file.getOriginalFilename());
				file.transferTo(tempFile);
			}
			return "upload/upload1";
		}
	}

注意这里定义的是一个MultipartFile数组，可以接受多个文件上传，如果单文件上传可以修改为MultipartFile类型；另外上传文件的细节在这里并没有花时间处理，比如文件重名的问题，路径问题，关于重名最简单的办法是重新命名为GUID文件名。

### 5. 测试运行

访问路径：[http://localhost:8080/spring-mvc/upload/file1](http://localhost:8080/spring-mvc/upload/file1)，运行结果如图1所示：

<center>
<img src="SpringMVC-07/SpringMVC-07-01.png" width="70%"/>图 1
</center>

选择三个文件file1.txt，file2.txt，file3.txt，点击提交。

<center>
<img src="SpringMVC-07/SpringMVC-07-02.png" width="70%"/>图 2
</center>

控制台输出：

	file1.txt
	15
	--------------------------
	file2.txt
	15
	--------------------------
	file3.txt
	15
	--------------------------

<center>
<img src="SpringMVC-07/SpringMVC-07-03.png" width="60%"/>图 3
</center>

## 二、Servlet3.0以上版本

Servlet3.0以上的版本不再需要第三方组件Commons.io和commons-fileupload，上传的方式与4.1提到基本一样，但配置稍有区别，可以使用@MultipartConfig注解在Servlet上进行配置上传，也可以在web.xml上进行配置。

### 1. 修改web.xml配置上传参数

	<!--Servlet3.0以上文件上传配置 -->
    <multipart-config>
        <max-file-size>5242880</max-file-size><!--上传单个文件的最大限制5MB -->
        <max-request-size>20971520</max-request-size><!--请求的最大限制20MB，一次上传多个文件时一共的大小 -->
        <file-size-threshold>0</file-size-threshold><!--当文件的大小超过临界值时将写入磁盘 -->
    </multipart-config>

multipart-config的各参数含义如下：

- file-size-threshold：数字类型，当文件大小超过指定的大小后将写入到硬盘上。默认是0，表示所有大小的文件上传后都会作为一个临时文件写入到硬盘上。
- location：指定上传文件存放的目录。当我们指定了location后，我们在调用Part的write(String fileName)方法把文件写入到硬盘的时候可以，文件名称可以不用带路径，但是如果fileName带了绝对路径，那将以fileName所带路径为准把文件写入磁盘，不建议指定。
- max-file-size：数值类型，表示单个文件的最大大小。默认为-1，表示不限制。当有单个文件的大小超过了max-file-size指定的值时将抛出IllegalStateException异常。
- max-request-size：数值类型，表示一次上传文件的最大大小。默认为-1，表示不限制。当上传时所有文件的大小超过了max-request-size时也将抛出IllegalStateException异常。

### 2. 修改pom.xml依赖信息

删除pom.xml中对文件上传第三方的依赖。

### 3. 修改springmvc-servlet.xml配置信息

将原有的文件上传通用解析器更换为标准解析器：

	<!--文件上传解析器 -->
    <bean id="multipartResolver"
        class="org.springframework.web.multipart.support.StandardServletMultipartResolver">
    </bean>

### 4. 定义视图

在view/up/下定义名称为upload2.jsp文件:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>上传文件 - Servlet3.0</title>
		</head>
		<body>
			<h2>上传文件 - Servlet3.0</h2>
			<form action="file3Save" method="post" enctype="multipart/form-data">
				<p>
					<label for="files">文件：</label> <input type="file" name="files" id="files" multiple="multiple" />
				</p>
				<p>
					<button>提交</button>
				</p>
				<p>${message}</p>
			</form>
		</body>
	</html>

### 5. 定义Action

	@RequestMapping("/file2")
    public String file2(Model model){
        return "upload/upload2";
    }
	
	@RequestMapping(value="/file3Save", method=RequestMethod.POST)
    public String file3Save(Model model,MultipartFile[] files, HttpServletRequest request) throws Exception{
        for (MultipartFile file : files) {
        	System.out.println(file.getOriginalFilename());
			System.out.println(file.getSize());
			System.out.println("--------------------------");
            File tempFile=new File(file.getOriginalFilename());
            file.transferTo(tempFile);
        }
        return "upload/upload2";
    }

### 6. 测试运行

访问路径：[http://localhost:8080/spring-mvc/upload/file2](http://localhost:8080/spring-mvc/upload/file2)