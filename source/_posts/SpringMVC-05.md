---
title: 05-SpringMVC视图解析器
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:51:31
tags: SpringMVC
categories: SpringMVC
description:
---

<!--more-->
# 视图解析器

多数MVC框架都为Web应用程序提供一种它自己处理视图的办法，Spring MVC 提供视图解析器，它使用ViewResolver进行视图解析，让用户在浏览器中渲染模型。ViewResolver是一种开箱即用的技术，能够解析JSP、Velocity模板、FreeMarker模板和XSLT等多种视图。

Spring处理视图最重要的两个接口是ViewResolver和View。ViewResolver接口在视图名称和真正的视图之间提供映射关系； 而View接口则处理请求将真正的视图呈现给用户。

<center>
<img src="SpringMVC-05/SpringMVC-05-01.png" width="80%"/>图 1
</center>

## 一、ViewResolver视图解析器

在Spring MVC控制器中，所有的请求处理方法（Action）必须解析出一个逻辑视图名称，无论是显式的（返回String，View或ModelAndView）还是隐式的（基于约定的，如视图名就是方法名）。Spring中由视图解析器处理这个逻辑视图名称，Spring常用的视图解析器有如下几种：

<center>
<img src="SpringMVC-05/SpringMVC-05-02.png" width="70%"/>图 2
</center>

### 1. AbstractCachingViewResolver

用来缓存视图的抽象视图解析器。通常情况下，视图在使用前就准备好了。继承该解析器就能够使用视图缓存。这是一个抽象类，这种视图解析器会把它曾经解析过的视图缓存起来，然后每次要解析视图的时候先从缓存里面找，如果找到了对应的视图就直接返回，如果没有就创建一个新的视图对象，然后把它放到一个用于缓存的map中，接着再把新建的视图返回。使用这种视图缓存的方式可以把解析视图的性能问题降到最低。

### 2. XmlViewResolver

XML视图解析器。它实现了ViewResolver接口，接受相同DTD定义的XML配置文件作为Spring的XML bean工厂。它继承自AbstractCachingViewResolver抽象类，所以它也是支持视图缓存的。通俗来说就是通过xml指定逻辑名称与真实视图间的关系，示例如下：

	<bean class="org.springframework.web.servlet.view.XmlViewResolver">
       <property name="location" value="/WEB-INF/views.xml"/>
       <property name="order" value="2"/>
    </bean>

views.xml是逻辑名与真实视图名的映射文件，order是定义多个视图时的优先级，可以这样定义：

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
	    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	    xsi:schemaLocation="http://www.springframework.org/schema/beans
	     					http://www.springframework.org/schema/beans/spring-beans-4.3.xsd">
	    <bean id="index" class="org.springframework.web.servlet.view.InternalResourceView">
	        <property name="url" value="/index.jsp" />
	    </bean>
	</beans>

id就是逻辑名称，在使用时可以在请求处理方法中这样指定：

	@RequestMapping("/index")
    public String index() {
       return "index";
    }

从配置可以看出最终还是使用InternalResourceView完成了视图解析。

### 3. ResourceBundleViewResolver

它使用了ResourceBundle定义下的bean，实现了ViewResolver接口，指定了绑定包的名称。通常情况下，配置文件会定义在classpath下的properties文件中，默认的文件名字是views.properties。

### 4. UrlBasedViewResolver

它简单实现了ViewResolver接口，不用显式定义，直接影响逻辑视图到URL的映射。它让你不用任何映射就能通过逻辑视图名称访问资源。它是对ViewResolver的一种简单实现，而且继承了AbstractCachingViewResolver，主要就是提供的一种拼接URL的方式来解析视图，它可以让我们通过prefix属性指定一个指定的前缀，通过suffix属性指定一个指定的后缀，然后把返回的逻辑视图名称加上指定的前缀和后缀就是指定的视图URL了。如prefix=/WEB-INF/views/，suffix=.jsp，返回的视图名称viewName=bar/index，则UrlBasedViewResolver解析出来的视图URL就是/WEB-INF/views/bar/index.jsp。redirect:前缀表示重定向，forword:前缀表示转发。使用UrlBasedViewResolver的时候必须指定属性viewClass，表示解析成哪种视图，一般使用较多的就是InternalResourceView，利用它来展现jsp，但是当我们使用JSTL的时候我们必须使用org.springframework.web.servlet.view.JstlView。

### 5. InternalResourceViewResolver

内部视图解析器。它是URLBasedViewResolver的子类，所以URLBasedViewResolver支持的特性它都支持。它在实际应用中使用的最广泛的一个视图解析器。

	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="internalResourceViewResolver">
        <!-- 前缀 -->
        <property name="prefix" value="/WEB-INF/views/" />
        <!-- 后缀 -->
        <property name="suffix" value=".jsp" />
    </bean>

在JSP视图技术中，Spring MVC经常会使用UrlBasedViewResolver视图解析器，该解析器会将视图名称翻译成URL并通过RequestDispatcher处理请求后渲染视图。修改springmvc-servlet.xml配置文件，增加如下视图解析器：

	<bean id="viewResolver" class="org.springframework.web.servlet.view.UrlBasedViewResolver">
	    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
	    <property name="prefix" value="/WEB-INF/jsp/"/>
	    <property name="suffix" value=".jsp"/>
	</bean>

### 6. VelocityViewResolver

Velocity视图解析器，UrlBasedViewResolver的子类，VelocityViewResolver会把返回的逻辑视图解析为VelocityView。

### 7. FreeMarkerViewResolver

FreeMarker视图解析器，UrlBasedViewResolver的子类，FreeMarkerViewResolver会把Controller处理方法返回的逻辑视图解析为FreeMarkerView，使用FreeMarkerViewResolver的时候不需要我们指定其viewClass，因为FreeMarkerViewResolver中已经把viewClass为FreeMarkerView了。Spring本身支持了对Freemarker的集成。只需要配置一个针对Freemarker的视图解析器即可。

### 8. ContentNegotiatingViewResolver

内容协商视图解析器，这个视图解析器允许你用同样的内容数据来呈现不同的view，在RESTful服务中可用。

## 二、链式视图解析器

Spring支持同时配置多个视图解析器，也就是链式视图解析器。这样，在某些情况下，就能够重写某些视图。如果我们配置了多个视图解析器，并想要给视图解析器排序的话，设定order属性就可以指定解析器执行的顺序。order的值越高，解析器执行的顺序越晚，当一个ViewResolver在进行视图解析后返回的View对象是null的话就表示该ViewResolver不能解析该视图，这个时候如果还存在其他order值比它大的ViewResolver就会调用剩余的ViewResolver中的order值最小的那个来解析该视图，依此类推。InternalResourceViewResolver这种能解析所有的视图，即永远能返回一个非空View对象的ViewResolver，一定要把它放在ViewResolver链的最后面。

	<bean
		class="org.springframework.web.servlet.view.InternalResourceViewResolver"
		id="internalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/view/" />
		<property name="suffix" value=".jsp" />
		<property name="viewClass" value="org.springframework.web.servlet.view.JstlView" />
		<property name="contentType" value="text/html;charset=UTF-8" />
		<property name="order" value="2" />
	</bean>
	<bean id="viewResolver"
		class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">
		<property name="cache" value="true" />
		<property name="prefix" value="" />
		<property name="suffix" value=".html" />
		<property name="viewClass" value="org.springframework.web.servlet.view.freemarker.FreeMarkerView" />
		<property name="exposeSpringMacroHelpers" value="true" />
		<property name="exposeRequestAttributes" value="true" />
		<property name="exposeSessionAttributes" value="true" />
		<property name="requestContextAttribute" value="rc" />
		<property name="contentType" value="text/html;charset=UTF-8" />
		<property name="order" value="1" />
	</bean>

viewClass指定了视图渲染类，viewNames指定视图名称匹配规则如名称以html开头或结束，contentType支持了页面头部信息匹配规则。

## 三、FreeMarker与多视图解析示例

### 1. 新增两个视图解析器

修改Spring MVC配置文件springmvc-servlet.xml，在beans结点中增加两个视图解析器，一个为内部解析器用于解析jsp与JSTL，另一个为解析FreeMaker格式。修改后的配置文件如下所示：

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
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
		<mvc:annotation-driven enable-matrix-variables="true" />
	
		<!-- 视图解析器 -->
		<bean
			class="org.springframework.web.servlet.view.InternalResourceViewResolver"
			id="internalResourceViewResolver">
			<!-- 前缀 -->
			<property name="prefix" value="/WEB-INF/view/" />
			<!-- 后缀 -->
			<property name="suffix" value=".jsp" />
			<!--指定视图渲染类 -->
			<property name="viewClass"
				value="org.springframework.web.servlet.view.JstlView" />
			<!--设置所有视图的内容类型，如果视图本身设置内容类型视图类可以忽略 -->
			<property name="contentType" value="text/html;charset=UTF-8" />
			<!-- 优先级，越小越前 -->
			<property name="order" value="2" />
		</bean>
	
		<!-- FreeMarker视图解析器与属性配置 -->
		<bean id="viewResolver"
			class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">
			<!--是否启用缓存 -->
			<property name="cache" value="true" />
			<!--自动添加到路径中的前缀 -->
			<property name="prefix" value="" />
			<!--自动添加到路径中的后缀 -->
			<property name="suffix" value=".html" />
			<!--指定视图渲染类 -->
			<property name="viewClass"
				value="org.springframework.web.servlet.view.freemarker.FreeMarkerView" />
			<!-- 设置是否暴露Spring的macro辅助类库，默认为true -->
			<property name="exposeSpringMacroHelpers" value="true" />
			<!-- 是否应将所有request属性添加到与模板合并之前的模型。默认为false。 -->
			<property name="exposeRequestAttributes" value="true" />
			<!-- 是否应将所有session属性添加到与模板合并之前的模型。默认为false。 -->
			<property name="exposeSessionAttributes" value="true" />
			<!-- 在页面中使用${rc.contextPath}就可获得contextPath -->
			<property name="requestContextAttribute" value="rc" />
			<!--设置所有视图的内容类型，如果视图本身设置内容类型视图类可以忽略 -->
			<property name="contentType" value="text/html;charset=UTF-8" />
			<!-- 优先级，越小越前 -->
			<property name="order" value="1" />
		</bean>
		<!-- 配置FreeMarker细节 -->
		<bean id="freemarkerConfig"
			class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">
			<!-- 模板路径 -->
			<property name="templateLoaderPath" value="/WEB-INF/htmlviews" />
			<property name="freemarkerSettings">
				<props>
					<!-- 刷新模板的周期，单位为秒 -->
					<prop key="template_update_delay">5</prop>
					<!--模板的编码格式 -->
					<prop key="defaultEncoding">UTF-8</prop>
					<!--url编码格式 -->
					<prop key="url_escaping_charset">UTF-8</prop>
					<!--此属性可以防止模板解析空值时的错误 -->
					<prop key="classic_compatible">true</prop>
					<!--该模板所使用的国际化语言环境选项 -->
					<prop key="locale">zh_CN</prop>
					<!--布尔值格式 -->
					<prop key="boolean_format">true,false</prop>
					<!--日期时间格式 -->
					<prop key="datetime_format">yyyy-MM-dd HH:mm:ss</prop>
					<!--时间格式 -->
					<prop key="time_format">HH:mm:ss</prop>
					<!--数字格式 -->
					<prop key="number_format">0.######</prop>
					<!--自动开启/关闭空白移除，默认为true -->
					<prop key="whitespace_stripping">true</prop>
				</props>
			</property>
		</bean>
	
		<!-- 配置映射媒体类型的策略 -->
		<bean
			class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping">
			<property name="removeSemicolonContent" value="false" />
		</bean>
	
		<bean name="/controller01" class="org.spring.mvc.controller.Controller01"></bean>
	</beans>

需要注意的是视图解析器的order越小，解析优先级越高。在视图解析的过程中，如果order为1的视图解析器不能正确解析视图的话，会将结果交给order为2的视图解析器，这里为2的视图解析器是InternalResourceViewResolver，它总是会生成一个视图的，所以一般InternalResourceViewResolver在放在视图解析链的末尾，万一没有找到对应的视图，它还会生成一个404的view并返回。

### 2. 修改pom.xml，添加依赖

为了使用FreeMarker，需要引用spring-context-support与FreeMarker的jar包。修改后的pom.xml配置文件如下：

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
			<dependency>
	            <groupId>org.springframework</groupId>
	            <artifactId>spring-context-support</artifactId>
	            <version>${spring.version}</version>
	        </dependency>
			<!-- JSTL -->
			<dependency>
				<groupId>javax.servlet</groupId>
				<artifactId>jstl</artifactId>
				<version>1.2</version>
			</dependency>
			<!-- Servlet核心包 -->
			<dependency>
				<groupId>javax.servlet</groupId>
				<artifactId>javax.servlet-api</artifactId>
				<version>3.0.1</version>
				<scope>provided</scope>
			</dependency>
			 <!--JSP应用程序接口 -->
	        <dependency>
	            <groupId>javax.servlet.jsp</groupId>
	            <artifactId>jsp-api</artifactId>
	            <version>2.1</version>
	            <scope>provided</scope>
	        </dependency>
			<!-- jackson -->
		    <dependency>
		        <groupId>com.fasterxml.jackson.core</groupId>
		        <artifactId>jackson-core</artifactId>
		        <version>2.5.2</version>
		    </dependency>
		    <dependency>
		        <groupId>com.fasterxml.jackson.core</groupId>
		        <artifactId>jackson-databind</artifactId>
		        <version>2.5.2</version>
		    </dependency>
		    <!-- FreeMarker -->
	        <dependency>
	            <groupId>org.freemarker</groupId>
	            <artifactId>freemarker</artifactId>
	            <version>2.3.23</version>
	        </dependency>
		</dependencies>
	</project>

添加依赖成功后的jar包如图3所示：

<center>
<img src="SpringMVC-05/SpringMVC-05-03.png" width="30%"/>图 3
</center>

### 3. 定义Controller与Action

定义控制器，增加两个请求处理方法jstl与ftl，ftl让第1个解析器解析，jstl让第2个视图解析器解析，第1个视图解析器也是默认的视图解析器。

	package org.spring.mvc.controller;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.RequestMapping;
	
	@Controller
	@RequestMapping("/controller11")
	public class Controller11 {
		@RequestMapping("/jstl")
	    public String jstl(Model model) {
	        model.addAttribute("message", "Hello JSTL View!");
	        return "controller11/jstl";
	    }
	    
	    @RequestMapping("/ftl")
	    public String ftl(Model model) {
	        model.addAttribute("users", new String[]{"tom","mark","jack"});
	        model.addAttribute("message", "Hello FreeMarker View!");
	        return "controller11/ftl";
	    }
	}

### 4. 新增目录与视图

在WEB-INF/view/controller11目录下新增jsp页面jstl.jsp页面，在WEB-INF/html/controller11目录下新增ftl.html页面。目录结构如下：

<center>
<img src="SpringMVC-05/SpringMVC-05-04.png" width="35%"/>图 4
</center>

### 5. 运行结果

访问路径：[http://localhost:8080/spring-mvc/controller11/jstl](http://localhost:8080/spring-mvc/controller11/jstl)，运行结果如图3所示：

<center>
<img src="SpringMVC-05/SpringMVC-05-05.png" width="70%"/>图 5
</center>

访问路径：[http://localhost:8080/spring-mvc/controller11/ftl](http://localhost:8080/spring-mvc/controller11/ftl)，运行结果如图6所示：

<center>
<img src="SpringMVC-05/SpringMVC-05-06.png" width="70%"/>图 6
</center>

### 6. 小结

当访问/controller11/ftl时会找到action ftl方法，该方法返回controller11/ftl字符串，视图解析器中order为1的解析器去controller11目录下找名称为ftl的视图，视图存在，将视图与模型渲染后输出。当访问/controller11/jstl时会找到action jstl访问，该方法返回controller11/jstl字符串，视图解析器中order为1的解析器去controller11目录下找名称为jstl的视图，未能找到，解析失败，转到order为2的视图解析器解析，在目录controller11下找到jstl的文件成功，将视图与模板渲染后输出。

如果想视图解析器更加直接的选择可以使用属性viewNames，如viewNames="html*"，则会只解析视图名以html开头的视图。

