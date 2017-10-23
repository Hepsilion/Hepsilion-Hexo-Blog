---
title: 03-请求处理方法Action详解
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:47:25
tags: SpringMVC
categories: SpringMVC
description:
---

<!--more-->

# SpringMVC 请求处理方法Action详解

在Spring MVC的每个控制器中可以定义多个请求处理方法，我们把这种请求处理方法称为Action，每个请求处理方法可以有多个不同类型的参数和一个某种类型的返回结果。

## 一、Action参数

### 1. 自动参数映射

#### (1) 基本数据类型或包装类型

方法的参数可以是任意基本数据类型或包装类型。当方法的参数名与http请求的参数名相同时，参数会进行自动映射；但如果请求的参数中没有对应名称与类型的数据，则会产生异常。

示例代码：基本数据类型

	@RequestMapping("/action19")
	public String action19(Model model, int id, String name) {
		model.addAttribute("message", "name=" + name + ",id=" + id);
		return "index";
	}

访问路径：[http://localhost:8080/spring-mvc/controller08/action19?id=1234&name=kevin](http://localhost:8080/spring-mvc/controller08/action19?id=1234&name=kevin)，运行结果如图1所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-01.png" width="100%"/>图 1
</center>

示例代码：包装类型

	@RequestMapping("/action20")
	public String action20(Model model, Integer id, Double price) {
		model.addAttribute("message", "price=" + price + ",id=" + id);
		return "index";
	}

访问路径：[http://localhost:8080/spring-mvc/controller08/action20?id=1234&price=20.0](http://localhost:8080/spring-mvc/controller08/action20?id=1234&price=20.0)，运行结果如图2所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-02.png" width="100%"/>图 2
</center>

#### (2) 自定义数据类型

除了基本数据类型和其对应的包装类型，我们也可以自定义数据类型，如一个自定义的POJO对象，Spring MVC会通过反射把请求中的参数设置到对象的属性中并进行类型转换。

自定义数据类型Product：

	package org.spring.mvc.model;
	
	import java.io.Serializable;

	public class Product implements Serializable {
		private static final long serialVersionUID = 1L;
		private int id;
		private String name;
		private double price;
	
		public Product() {
		}
	
		public Product(String name, double price) {
			super();
			this.name = name;
			this.price = price;
		}
	
		public Product(int id, String name, double price) {
			super();
			this.id = id;
			this.name = name;
			this.price = price;
		}
	
		public int getId() {
			return id;
		}
	
		public void setId(int id) {
			this.id = id;
		}
	
		public String getName() {
			return name;
		}
	
		public void setName(String name) {
			this.name = name;
		}
	
		public double getPrice() {
			return price;
		}
	
		public void setPrice(double price) {
			this.price = price;
		}
	
		@Override
		public String toString() {
			return "编号(id)：" + this.getId() + "，名称(name)：" + this.getName() + "，价格(price)：" + this.getPrice();
		}
	}

示例代码：自定义数据类型

	@RequestMapping("/action21")
    public String action21(Model model, Product product) {
        model.addAttribute("message", product);
        return "index";
    }

访问路径：[http://localhost:8080/spring-mvc/controller08/action21?id=1234&name=meat&price=20.0](http://localhost:8080/spring-mvc/controller08/action21?id=1234&name=meat&price=20.0)，运行结果如图3所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-03.png" width="100%"/>图 3
</center>

示例中使用的是请求URL中的参数，其实也可以是客户端提交的任意参数，特别是表单中的数据。

#### (3) 复杂数据类型

复杂数据类型指的是一个自定义类型中还包含另外一个对象类型

自定义数据类型User，其中包含Product成员：

	package org.spring.mvc.model;
	
	public class User {
	    private String username;
	    private Product product;
	
	    public String getUsername() {
	        return username;
	    }
	
	    public void setUsername(String username) {
	        this.username = username;
	    }
	
	    public Product getProduct() {
	        return product;
	    }
	
	    public void setProduct(Product product) {
	        this.product = product;
	    }
	}

示例代码：复杂数据类型

	@RequestMapping("/action22")
    public String action22(Model model, User user) {
        model.addAttribute("message", user.getUsername() + "," + user.getProduct().getName());
        return "index";
    }

访问路径：[http://localhost:8080/spring-mvc/controller08/action22?username=tom&product.name=rice](http://localhost:8080/spring-mvc/controller08/action22?username=tom&product.name=rice)，运行结果如图4所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-04.png" width="100%"/>图 4
</center>

使用表单提交数据，创建表单action22.jsp：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>action22</title>
		</head>
		<body>
		    <form method="post" action="action02">
			     username:<input name="username" /><br/>
			     pdctname:<input name="product.name" /><br/>
			    <button>提交</button>
			</form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/action22.jsp](http://localhost:8080/spring-mvc/action22.jsp)，运行结果如图5所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-05.png" width="75%"/>图 5
</center>

提交之后，运行结果如图6所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-06.png" width="75%"/>图 6
</center>

#### (4) List集合类型

不能直接在action的参数中指定List<T>类型。

定义一个数据类型ProductList，其中包含一个List成员：

	public class ProductList {
		private List<Product> items;
	
		public List<Product> getItems() {
			return items;
		}
	
		public void setItems(List<Product> items) {
			this.items = items;
		}
	}

示例代码：List集合类型

	@RequestMapping("/action23")
    public String action23(Model model, ProductList products) {
        model.addAttribute("message", products.getItems().get(0) + "<br/>" + products.getItems().get(1));
        return "index";
    }

在URL中模拟表单数据，访问路径：[http://localhost:8080/spring-mvc/controller08/action23?items[0].name=phone&items[1].name=book](http://localhost:8080/spring-mvc/controller08/action23?items[0].name=phone&items[1].name=book)，运行结果如图7所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-07.png" width="100%"/>图 7
</center>

这里同样可以使用一个表单向服务器提交数据。

#### (5) Map集合类型

Map与List的实现方式基本一样。

定义一个数据类型ProductMap，其中包含一个Map成员：

	public class ProductMap {
		private Map<String, Product> items;
	
		public Map<String, Product> getItems() {
			return items;
		}
	
		public void setItems(Map<String, Product> items) {
			this.items = items;
		}
	}

示例代码：Map集合类型

	@RequestMapping("/action24")
    public String action24(Model model, ProductMap map) {
        model.addAttribute("message", map.getItems().get("p1") + "<br/>" + map.getItems().get("p2"));
        return "index";
    }

在URL中模拟表单数据，访问路径：[http://localhost:8080/spring-mvc/controller08/action24?items[p1].name=phone&items[p2].name=book](http://localhost:8080/spring-mvc/controller08/action24?items[p1].name=phone&items[p2].name=book)，运行结果如图8所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-08.png" width="100%"/>图 8
</center>

集合类型基本都一样，set也差不多，问题是如果为了获得一个集合需要刻意去包装会很麻烦，可以通过@RequestParam结合@RequestBody等注解完成。

### 2. @RequestParam参数绑定

简单的参数可以使用上一节中讲过的自动参数映射，虽然自动参数映射很方便，但有些细节是不能处理的，如参数是否为必须参数、参数名称没有办法指定、指定参数的默认值。复杂的参数映射可以使用@RequestParam完成，Spring MVC会自动查找请求中的参数，并进行参数绑定和类型转换。

@RequestParam共有4个注解属性：

- required属性表示是否为必须，默认值为true，如果请求中没有指定的参数会报异常；
- defaultValue用于设置参数的默认值，如果不指定值则使用默认值，只能是String类型的。
- name与value互为别名关系用于指定参数名称。

#### (1) 基本数据类型

示例代码：

	@RequestMapping("/action25")
    public String action25(Model model, @RequestParam(required = false, defaultValue = "99") int id) {
        model.addAttribute("message", id);
        return "index";
    }

访问路径：[http://localhost:8080/spring-mvc/controller08/action25?id=98](http://localhost:8080/spring-mvc/controller08/action25?id=98)，运行结果如图9所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-09.png" width="85%"/>图 9
</center>

访问路径：[http://localhost:8080/spring-mvc/controller08/action25](http://localhost:8080/spring-mvc/controller08/action25)，运行结果如图10所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-10.png" width="85%"/>图 10
</center>

#### (2) List与数组直接绑定：基本数据类型

在上一节中我们使用自动参数映射是不能直接完成List数组绑定的，结合@RequestParam可以轻松实现。

示例代码：

	@RequestMapping("/action26")
    public String action26(Model model, @RequestParam("id") List<String> ids) {
        model.addAttribute("message", Arrays.deepToString(ids.toArray()));
        return "index";
    }

在URL中模拟表单数据，访问路径：[http://localhost:8080/spring-mvc/controller08/action26?id=tom&id=rose](http://localhost:8080/spring-mvc/controller08/action26?id=tom&id=rose)，运行结果如图11所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-11.png" width="85%"/>图 11
</center>

使用表单提交数据，创建表单action26.jsp：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>action22</title>
		</head>
		<body>
		    <form action="controller08/action26" method="post">
			    <p>
			        <label>爱好：</label> 
			        <input type="checkbox" value="reading" name="id" />阅读
			         <input type="checkbox" value="surfing" name="id" />上网
			         <input type="checkbox" value="gaming" name="id" />电游
			    </p>
			    <button>提交</button>
			</form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/action26.jsp](http://localhost:8080/spring-mvc/action26.jsp)，运行结果如图12所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-12.png" width="85%"/>图 12
</center>

提交之后，运行结果如图13所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-13.png" width="85%"/>图 13
</center>

@RequestParam("id")表明参数是必须的。因为页面中的表单name的名称为id，所有服务器在收集数据时应该使用id页非ids。

如果name属性和参数名称同名，则name属性可以省去。示例代码：

	@RequestMapping("/action27")
    public String action27(Model model, @RequestParam("id") List<String> id) {
        model.addAttribute("message", Arrays.deepToString(id.toArray()));
        return "index";
    }

#### (3) List与数组直接绑定：自定义数据类型

上一小节中我们绑定的集合中存放的是基本数据类型，如果需要直接绑定更加复杂的数据类型则需要使用@RequestBody与@ResponseBody注解。

- @RequestBody 将HTTP请求正文转换为适合的HttpMessageConverter对象。
- @ResponseBody 将内容或对象作为 HTTP 响应正文返回，并调用适合HttpMessageConverter的Adapter转换对象，写入输出流。

@RequestBody注解修饰的参数默认接收的Content-Type是application/json，因此客户端在发送POST请求时需要设置请求报文头信息，否则Spring MVC在解析集合请求参数时不会自动将参数转换成JSON数据再解析成相应的集合。Spring默认的json协议解析由Jackson完成，要完成这个功能需要修改配置环境。

(a) 修改Spring MVC配置文件，启用mvc注解驱动功能

	<mvc:annotation-driven />

(b) 修改pom.xml，添加jackson依赖

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

(c) 使用Ajax发送请求时需要设置contentType属性为'application/json;charse=UTF-8'(请求的默认contentType属性并非是application/json，而是application/x-www-form-urlencoded)，服务器将把接收到的参数转换成JSON字符串，如果条件不满足有可能会出现415异常。

前端示例代码：定义一个action28-29.jsp页面，在客户端发送请求时设置contentType为application/json

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>List与数组直接绑定：自定义数据类型</title>
		</head>
		<body>
			<button type="button" onclick="addPdts_click1();">向服务器发送json</button>
			<button type="button" onclick="addPdts_click2();">接收服务器返回的json</button>
			<p id="msg"></p>
			<script type="text/javascript" src="<c:url value="/scripts/jQuery1.11.3/jquery-1.11.3.min.js"/>"></script>
			<script type="text/javascript">
				var products = new Array();
				products.push({
					id : 1,
					name : "iPhone 6 Plus",
					price : 4987.5
				});
				products.push({
					id : 2,
					name : "iPhone 7 Plus",
					price : 5987.5
				});
				products.push({
					id : 3,
					name : "iPhone 8 Plus",
					price : 6987.5
				});
				function addPdts_click1() {
					$.ajax({
						type : "POST", //请求谓词类型
						url : "controller08/action28",
						data : JSON.stringify(products), //将products对象转换成json字符串
						contentType : "application/json;charset=UTF-8", //发送信息至服务器时的内容编码类型，默认为application/x-www-form-urlencoded
						dataType : "text", //期望服务器返回的数据类型
						success : function(result) {
							$("#msg").html(result);
						}
					});
				}
				function addPdts_click2() {
					$.ajax({
						type : "POST", //请求谓词类型
						url : "controller08/action29",
						data : JSON.stringify(products), //将products对象转换成json字符串
						contentType : "application/json;charset=UTF-8", //发送信息至服务器时的内容编码类型，默认为application/x-www-form-urlencoded
						dataType : "json", //期望服务器返回的数据类型
						success : function(result) {
							var str = "";
							$.each(result, function(i, obj) {
								str += "编号：" + obj.id + ",名称：" + obj.name + ",价格：" + obj.price + "<br/>";
							});
							$("#msg").html(str);
						}
					});
				}
			</script>
		</body>
	</html>

页面中有两个请求方法，第一个方法将一个json集合发送到服务器并映射成一个List集合；第二个方法接收服务器返回的json对象。

接收第一个请求的服务器示例代码:

	@RequestMapping("/action28")
    public void action28(@RequestBody List<Product> products, HttpServletResponse response) throws IOException {
        response.setCharacterEncoding("UTF-8");
        System.out.println(Arrays.deepToString(products.toArray()));
        response.getWriter().write("添加成功");
    }

action28的参数List< Product> products是接收从客户端发送到服务器的产品集合，在参数前增加**@RequestBody注解的作用是让Spring MVC在接收到客户端请求时选择合适的转换器将参数转换成相应的对象**。

接收第二个请求的服务器示例代码:

	@RequestMapping("/action29")
	@ResponseBody
    public List<Product> action29(@RequestBody List<Product> products, HttpServletResponse response) throws IOException {
		products.get(0).setPrice(999.99);
		return products;
    }

action29的返回值为List<Product>，且在方法上有一个**注解@ResponseBody，系统会使用jackson将该返回值对象自动序列化成json字符序列**。

访问路径：[http://localhost:8080/spring-mvc/action28-29.jsp](http://localhost:8080/spring-mvc/action28-29.jsp)，运行结果如图14所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-14.png" width="80%"/>图 14
</center>

点击第一个按钮时的如图15所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-15.png" width="80%"/>图 15
</center>

控制台输出：

[编号(id)：1，名称(name)：iPhone 6 Plus，价格(price)：4987.5, 编号(id)：2，名称(name)：iPhone 7 Plus，价格(price)：5987.5, 编号(id)：3，名称(name)：iPhone 8 Plus，价格(price)：6987.5]

点击第二个按钮时的如图16所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-16.png" width="80%"/>图 16
</center>

### 3. 重定向与Flash属性

如果一个请求处理方法Action的返回结果为"index"字符串，则表示结果转发到index视图。但有时候我们需要重定向，将结果重定向到一个指定的页面或另一个action，则可以在返回的结果前加上一个"redirect:"前缀。

示例代码:

	@RequestMapping("/action30")
    public String action30(Model model) {
        model.addAttribute("message", "action30Message");
        return "redirect:action31";
    }
	
	@RequestMapping("/action31")
    public String action31(Model model) {
		model.addAttribute("message", "action31Message");
        return "index";
    }

访问路径：[http://localhost:8080/spring-mvc/controller08/action30](http://localhost:8080/spring-mvc/controller08/action30)，运行结果如图17所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-17.png" width="90%"/>图 17
</center>

在action30中返回的结果为redirect:action31，表示重定向到action31这个请求处理方法，所有重定向都是以当前路径为起点的。action30向model中添加了名称message的数据，因为重定向到action31中会发起两次请求，为了保持action30中的数据，Spring MVC自动将数据重写到了url中。

**为了实现重定向时传递复杂数据，可以使用Flash属性。**

示例代码：

	@RequestMapping("/action32")
    public String action32(Model model, RedirectAttributes redirectAttributes) {
        Product product = new Product(2, "iPhone7 Plus", 6989.5);
        redirectAttributes.addFlashAttribute("product", product);
        return "redirect:action33";
    }

	@RequestMapping("/action33")
    public String action33(Model model, Product product) {
        model.addAttribute("message", product);
        System.out.println(model.containsAttribute("product")); // true
        return "index";
    } 

当访问action32时，首先创建了一个Product对象，并将该对象添加到了Flash属性中，在重定向后取出该对象。

访问路径：[http://localhost:8080/spring-mvc/controller08/action32](http://localhost:8080/spring-mvc/controller08/action32)，运行结果如图18所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-18.png" width="90%"/>图 18
</center>

此时URL地址已经发生了变化，product对象其实也已经被存入了model中，在action33的视图中可以直接拿到。

### 4. @ModelAttribute注解

@ModelAttribute注解可以应用在方法参数上或方法上，其作用是：

- 当注解在方法的参数上时，会将被注解的参数对象添加到Model中；
- 当注解在请求处理方法Action上时，会将该方法变成一个非请求处理的方法，而是让其它Action被调用时先调用该方法。

#### (1) 注解在参数上

当@ModelAttribute注解在参数上时，会将被注解的参数添加到Model中，并自动完成数据绑定。

示例代码：

访问路径：[http://localhost:8080/spring-mvc/controller08/action34?id=12&name=apple&price=6000](http://localhost:8080/spring-mvc/controller08/action34?id=12&name=apple&price=6000)，运行结果如图19所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-19.png" width="100%"/>图 19
</center>

其实不使用@ModelAttribute也样可以完成参数与对象间的自动映射，但使用注解可以设置更多详细内容，如名称、是否绑定等。

#### (2) 注解在方法上

@ModelAttribute注解还可以用于标注一个非请求处理方法，通俗说就是一个非Action或普通方法。如果一个控制器类有多个请求处理方法，以及一个由@ModelAttribute注解的方法，则在调用其它Action之前会先调用由@ModelAttribute注解的方法。

示例代码：

	@RequestMapping("/action35")
    public String action35(Model model) {
        Map<String, Object> map = model.asMap();
        for (String key : map.keySet()) {
            System.out.println(key + "：" + map.get(key));
        }
        return "index";
    }

    @ModelAttribute
    public String noaction() {
        System.out.println("noaction 方法被调用！");
        String message = "来自noaction方法的信息";
        return message;
    }

当访问路径：[http://localhost:8080/spring-mvc/controller08/action35](http://localhost:8080/spring-mvc/controller08/action35)，控制台会输出：

	noaction 方法被调用！
	string：来自noaction方法的信息

非请求处理方法可以返回void，也可以返回一个任意对象，该对象会被自动添加到每一个要被访问的Action的Model中。从示例中可以看出key为类型名称。

## 二、Action返回值

Spring MVC的action返回值可以为String、void、ModelAndView、Map、Model和其它任意类型。

### 0. URL问题

在/src/main/webapp/WEB-INF/image目录下添加图片3.jpg。

**第一次尝试**

在/src/main/webapp/WEB-INF/view/controller09目录下添加视图action36.jsp：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>action5的视图</title>
		</head>
		<body>
		    <img alt="风景" src="../../image/3.jpg">
		</body>
	</html>

目标结构如下：

<center>
<img src="SpringMVC-03/SpringMVC-03-20.png" width="30%"/>图 19
</center>

定义一个action访问该图片：

	@RequestMapping("/action36")
    public String action36(Model model) {
        return "controller09/action36";
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action36](http://localhost:8080/spring-mvc/controller09/action36)，运行结果如图21所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-21.png" width="90%"/>图 21
</center>

访问不到图片的原因是：

- 此时action36.jsp视图并非以它所在的目录为实际路径，而是以当前action所在的控制器为起始目录的。当前控制器的url为：http://localhost:8080/spring-mvc/controller09/，而图片的src为：../../image/3.jpg，向上2级后变成：http://localhost:8087/image/3.jpg，但是此路径中并没有存放3.jpg这张图片。解决的办法是在视图中使用"绝对"路径；
- 另外一个问题是我们将静态资源存放到WEB-INF目录下不太合理，该目录是禁止客户端访问的。

**修改**

修改action36.jsp视图如下：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>action5的视图</title>
		</head>
		<body>
			<img alt="风景" src="../../image/3.jpg">
		    <img alt="风景" src="<c:url value="/image/3.jpg"></c:url>">
		</body>
	</html>

修改后目标结构如下：

<center>
<img src="SpringMVC-03/SpringMVC-03-22.png" width="30%"/>图 22
</center>

访问路径：[http://localhost:8080/spring-mvc/controller09/action36](http://localhost:8080/spring-mvc/controller09/action36)，运行结果如图23所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-23.png" width="90%"/>图 23
</center>

小结：借助标签<c:url value="/image/3.jpg"></c:url>将路径转换成"绝对路径"；建议在引用外部资源如js、css、图片信息时都使用该标签解析路径。

### 1. 返回值为String

#### (1) String作为视图名称

默认如果action返回String，此时String为视图名称，Spring MVC会去视图解析器设定的目录下查找，查找的规则是：URL= prefix前缀+视图名称+suffix后缀。

在Spring MVC的配置文件中配置视图解析器：

	<!-- 视图解析器 -->
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="internalResourceViewResolver">
		<!-- 前缀 -->
		<property name="prefix" value="/WEB-INF/view/" />
		<!-- 后缀 -->
		<property name="suffix" value=".jsp" />
	</bean>

示例代码：

	@RequestMapping("/action37")
    public String action37(Model model) {
        model.addAttribute("message", "action31");
        return "index";
    }

返回视图的路径为：/WEB-INF/view/index.jsp

#### (2) String作为内容输出

如果方法声明了@ResponseBody注解，将内容或对象作为HTTP响应正文返回，并调用适合HttpMessageConverter的Adapter转换对象，写入输出流，此时的String不再是路径而是内容。

示例代码：

	@RequestMapping("/action38")
    @ResponseBody
    public String action38() {
        return "not <b>path</b>,but <b>content</b>";
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action38](http://localhost:8080/spring-mvc/controller09/action38)，运行结果如图24所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-24.png" width="80%"/>图 24
</center>

### 2. 返回值为void

void在普通方法中是没有返回值的意思，但作为请求处理方法的返回值类型并非这样，存在如下两种情况：

#### (1) 方法名默认作为视图名

当方法没有返回值时，方法中并未指定视图的名称，则默认视图的名称为方法名，查找的规则为：URL= prefix前缀+控制器路径+方法名称+suffix后缀组成。

示例代码：

	@RequestMapping("/action39")
    public void action39() {
    }

返回视图的路径为：/WEB-INF/view/controller09/action39.jsp，controller09是当前控制器映射的路径，action39是方法名。

访问路径：[http://localhost:8080/spring-mvc/controller09/action39](http://localhost:8080/spring-mvc/controller09/action39)，运行结果如图25所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-25.png" width="80%"/>图 25
</center>

上面的action代码等同于

	@RequestMapping("/action39")
    public String action39() {
        return "controller09/action39";  //controller09是控制器的路径
    }

#### (2) 直接响应输出结果

当方法的返回值为void，但输出流中存在输出内容时，则不会去查找视图，而是将输入流中的内容直接响应到客户端，响应的内容类型是纯文本。

示例代码：

	@RequestMapping("/action40")
    public void action40(HttpServletResponse response) throws IOException {
        response.getWriter().write("<h2>void method</h2>");
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action40](http://localhost:8080/spring-mvc/controller09/action40)，运行结果如图26所示：

<center>
<img src="SpringMVC-03/SpringMVC-03-26.png" width="80%"/>图 26
</center>

### 3. 返回值为ModelAndView

在旧的Spring MVC中ModelAndView使用频率非常高，它可以同时指定返回的模型与视图名称。ModelAndView有个多构造方法重载，单独设置属性也很方便。

示例代码：

	@RequestMapping("/action41")
    public ModelAndView action41() {
        //1. 只指定视图
        //return new ModelAndView("index");
        
        //2. 分别指定视图与模型
        Map<String, Object> model=new HashMap<String,Object>();
        model.put("message", "ModelAndView action41");
        return new ModelAndView("index", model);
        
        //3. 同时指定视图与模型
        //return new ModelAndView("index", "message","action41 ModelAndView ");
        
        //4. 分开指定视图与模型
        //ModelAndView modelAndView=new ModelAndView();
        //指定视图名称
        //modelAndView.setViewName("index");
        //添加模型中的对象
        //modelAndView.addObject("message", "<h2>Hello ModelAndView</h2>");
        //return modelAndView;
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action41](http://localhost:8080/spring-mvc/controller09/action41)

### 4. 返回值为Map

当返回结果为Map时，相当于只是返回了Model，并未指定具体的视图，返回视图的办法与void是一样的，即URL= prefix前缀+控制器路径+方法名称 +suffix后缀组成。

示例代码：

	@RequestMapping("/action42")
	public Map<String, Object> action42() {
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("message", "Hello Map");
		model.put("other", "more item");
		return model;
	}

访问路径：[http://localhost:8080/spring-mvc/controller09/action42](http://localhost:8080/spring-mvc/controller09/action42)

实际访问的视图路径是：/WEB-INF/view/controller09/action42.jsp，返回给客户端的map相当于模型，在视图中可以取出。

### 5. 返回值为任意类型

#### (1) 返回值为基本数据类型

当返回结果直接为int,double,boolean等基本数据类型时，将会报exception is java.lang.IllegalArgumentException: Unknown return value type异常。

示例代码：

	@RequestMapping("/action43")
	public int action43() {
		return 9527;
	}

如果确实需要直接将基本数据类型返回，则可以使用注解@ReponseBody。

示例代码：

	@RequestMapping("/action44")
	@ResponseBody
	public int action44() {
		return 9527;
	}

访问路径：[http://localhost:8080/spring-mvc/controller09/action44](http://localhost:8080/spring-mvc/controller09/action44)

#### (2) 返回值为自定义类型

当返回值为自定义类型时，Spring会把方法认为是视图名称，与返回值为void类似的办法处理URL，但页面中获得数据比较麻烦。

示例代码：

	@RequestMapping("/action45")
    public Product action45() {
        return new Product(1,"iPhone",1980.5);
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action45](http://localhost:8080/spring-mvc/controller09/action45)

如果存在action45对应的视图，页面可以正常显示，但无内容。

如果在action上添加@ResponseBody注解，则返回的是Product本身，而非视图，Spring会选择一个合适的方式解析对象，默认是json。

示例代码：

	@RequestMapping("/action46")
	@ResponseBody
    public Product action46() {
        return new Product(1,"iPhone",1980.5);
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action46](http://localhost:8080/spring-mvc/controller09/action46)

### 6. 返回值为Model类型

Model接口定义在org.springframework.ui包下，model对象会用于页面渲染，视图路径使用方法名，与void类似。

示例代码：

	@RequestMapping("/action47")
    public Model action47(Model model) {
        model.addAttribute("message", "返回类型为org.springframework.ui.Model");
        return model;
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action47](http://localhost:8080/spring-mvc/controller09/action47)

返回的类型还有许多如view等，通过view可指定一个具体的视图，如下载Excel、Pdf文档，其实它们也修改http的头部信息，手动同样可以实现。

示例代码：

	@RequestMapping("/action48")
    @ResponseBody
    public String action48(HttpServletResponse response) {
        response.setHeader("Content-type","application/octet-stream");         
        response.setHeader("Content-Disposition","attachment; filename=table.xls");
        return "<table><tr><td>Hello</td><td>Excel</td></tr></table>";
    }

访问路径：[http://localhost:8080/spring-mvc/controller09/action48](http://localhost:8080/spring-mvc/controller09/action48)

### 7. 小结

- 使用String作为请求处理方法的返回值类型是比较通用的方法，这样返回的逻辑视图名不会和请求URL绑定，具有很高的灵活性，而模型数据又可以通过Model控制；
- 使用void、map、Model作为请求处理方法的返回值类型时，这样返回对应的逻辑视图名称真实url为：prefix前缀+控制器路径+方法名+suffix后缀组成；
- 使用String、ModelAndView返回视图名称可以不受请求的url绑定，ModelAndView可以设置返回的视图名称；
- 另外在非MVC中使用的许多办法在Action也可以使用。
