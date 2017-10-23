---
title: 02-@RequestMapping详解
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:45:29
tags: SpringMVC
categories: SpringMVC
description:
---

<!--more-->


### 1. value 属性

value属性用来指定请求的实际地址，指定的地址可以是URL模板、正则表达式或路径占位；该属性与path属性互为别名关系，即@RequestMapping("/foo")}与@RequestMapping(path="/foo")相同；该属性是使用最频繁、最重要的一个属性，当只指定该属性时可以把value略去。

#### (1) 指定具体路径字符串

**只注解方法**，访问时直接指定方法的路径

	@Controller
	public class Controller03 {
		/**
		 * @url http://localhost:8080/spring-mvc/action01
		 * @return
		 */
		@RequestMapping("/action01")
	    public String action01(){
	        return "index";
	    }
	}

访问路径:[http://localhost:8080/spring-mvc/action01](http://localhost:8080/spring-mvc/action01)

**同时注解类与方法**，访问时需要先指定类的路径再指定方法的路径

	@Controller
	@RequestMapping("/controller04")
	public class Controller04 {
		/**
		 * @url http://localhost:8080/spring-mvc/controller04/action02
		 * @return
		 */
		@RequestMapping("/action02")
	    public String action02(){
	        return "index";
	    }
	}

访问路径:[http://localhost:8080/spring-mvc/controller04/action02](http://localhost:8080/spring-mvc/controller04/action02)

**value为空值**

第一种情况：注解在方法上时，如果value为空则表示该方法为类下默认的Action。

	@Controller
	@RequestMapping("/controller05")
	public class Controller05 {
		/**
		 * @url http://localhost:8080/spring-mvc/controller05/action03
		 * @param model
		 * @return
		 */
		@RequestMapping("/action03")
	    public String action03(Model model){
	        //在模型中添加属性message值为action03，渲染页面时使用
	        model.addAttribute("message", "action03");
	        return "index";
	    }
	    
		/**
		 * 该方法为类下默认的Action
		 * @url http://localhost:8080/spring-mvc/controller05
		 * @param model
		 * @return
		 */
	    @RequestMapping
	    public String action04(Model model){
	        //在模型中添加属性message值为action04，渲染页面时使用
	        model.addAttribute("message", "action04");
	        return "index";
	    }
	}

访问action04的路径:[http://localhost:8080/spring-mvc/controller05](http://localhost:8080/spring-mvc/controller05)，如果加上action02就会产生错误了。

第二种情况：注解在类上时，当value为空值时，则该类为默认的控制器，可以用于设置项目的起始页。

	@Controller
	@RequestMapping
	public class Controller06 {
		/**
		 * @url http://localhost:8080/spring-mvc/action05
		 * @param model
		 * @return
		 */
		@RequestMapping("/action05")
	    public String action05(Model model){
	        //在模型中添加属性message值为action05，渲染页面时使用
	        model.addAttribute("message", "action05");
	        return "index";
	    }
	    
		/**
		 * @url http://localhost:8080/spring-mvc/
		 * @param model
		 * @return
		 */
	    @RequestMapping
	    public String action06(Model model){
	        //在模型中添加属性message值为action06，渲染页面时使用
	        model.addAttribute("message", "action06");
	        return "index";
	    }
	}

访问action06的路径:[http://localhost:8080/spring-mvc/](http://localhost:8080/spring-mvc/)，同时省去了控制器名与Action名称，可用于欢迎页。

访问action05的路径:[http://localhost:8080/spring-mvc/action05](http://localhost:8080/spring-mvc/action05)

#### (2) 路径变量占位，URI模板模式

在Spring MVC中可以使用@PathVariable 注释方法参数的值绑定到一个URI模板变量。

	@RequestMapping("/action07/{p1}/{p2}")
	public String action07(@PathVariable int p1, @PathVariable int p2, Model model) {
		model.addAttribute("message", p1 + p2);
		return "index";
	}

访问action07的路径:[http://localhost:8080/spring-mvc/controller07/action07/1/2](http://localhost:8080/spring-mvc/controller07/action07/1/2)，运行结果：

<center>
<img src="SpringMVC-02/SpringMVC-02-01.png" width="85%"/>图 1
</center>

使用路径变量的好处：使路径变得更加简洁；框架会自动进行类型转换，获得参数更加方便，通过路径变量的类型可以约束访问参数，如果类型不一样，则访问不到action，如这里访问是的路径是/action07/1/a，则路径与方法不匹配，而不会是参数转换失败。

#### (3) 正则表达式模式的URI模板

	@RequestMapping(value = "/action08/{id:\\d{6}}-{name:[a-z]{3}}")
	public String action08(@PathVariable int id, @PathVariable String name, Model model) {
		model.addAttribute("message", "id:" + id + " name:" + name);
		return "index";
	}

正则要求id必须为6位的数字，而name必须为3位小写字母。

访问action08的路径:[http://localhost:8080/spring-mvc/controller07/action08/123456-abc](http://localhost:8080/spring-mvc/controller07/action08/123456-abc)，访问结果如下：

<center>
<img src="SpringMVC-02/SpringMVC-02-02.png" width="85%"/>图 1
</center>

#### (4) 矩阵变量@MatrixVariable

	/**
	 * @url http://localhost:8080/spring-mvc/controller07/action09/the book color;r=33;g=66
	 * @param model
	 * @param name
	 * @param r
	 * @param g
	 * @param b
	 * @return
	 */
	@RequestMapping(value = "/action09/{name}")
	public String action09(Model model,
			@PathVariable String name, // 路径变量，用于获得路径中的变量name的值
			@MatrixVariable String r,
			@MatrixVariable(required = true) String g, // 参数g是必须的
			@MatrixVariable(defaultValue = "99", required = false) String b) { // 参数b不是必须的，默认值是99
		model.addAttribute("message", name + " is #" + r + g + b);
		return "index";
	}

Spring MVC默认是不允许使用矩阵变量的，需要设置配置文件中的RequestMappingHandlerMapping的属性removeSemicolonContent为false；并且在annotation-driven中增加属性enable-matrix-variables="true"。修改后的springmvc-servlet.xml文件如下：

	<!-- 支持mvc注解驱动 -->
    <mvc:annotation-driven enable-matrix-variables="true" />

    <!-- 配置映射媒体类型的策略 -->
    <bean
        class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping">
        <property name="removeSemicolonContent" value="false" />
    </bean>

访问action09的路径:[http://localhost:8080/spring-mvc/controller07/action09/the book color;r=33;g=66](http://localhost:8080/spring-mvc/controller07/action09/the%20book%20color;r=33;g=66)，访问结果如下：

<center>
<img src="SpringMVC-02/SpringMVC-02-03.png" width="100%"/>图 1
</center>

#### (5) Ant风格路径模式

@RequestMapping注解也支持ant风格的路径模式，如/myPath/\*.do，/owners/*/pets/{petId}

	/**
	 * Ant风格路径模式
	 * @url http://localhost:8080/spring-mvc/controller07/action10/ant.do
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/action10/*.do")
	public String action10(Model model) {
		model.addAttribute("message", "Ant风格路径模式");
		return "index";
	}

访问action10的路径:[http://localhost:8080/spring-mvc/controller07/action10/ant.do](http://localhost:8080/spring-mvc/controller07/action10/ant.do)，访问结果如下：

<center>
<img src="SpringMVC-02/SpringMVC-02-04.png" width="80%"/>图 1
</center>

### 2. method属性

method属性可以指定请求谓词的类型，如GET、POST、HEAD、OPTIONS、PUT、PATCH、DELETE、TRACE等，约束请求范围。

	@RequestMapping(value = "/action11", method = { RequestMethod.POST, RequestMethod.DELETE })
	public String action11(Model model) {
		model.addAttribute("message", "请求谓词只能是POST与DELETE");
		return "index";
	}


访问action11的路径:[http://localhost:8080/spring-mvc/controller07/action11](http://localhost:8080/spring-mvc/controller07/action11)。

要访问action11的请求谓词类型必须是POST或者为DELETE，但当我们从浏览器的URL栏中直接请求时，发出的是一个GET请求，则结果显示405，访问结果如下：

<center>
<img src="SpringMVC-02/SpringMVC-02-05.png" width="80%"/>图 1
</center>

现将请求的谓词类型从POST修改为GET

	@RequestMapping(value = "/action12", method = RequestMethod.GET)
	public String action12(Model model) {
		model.addAttribute("message", "请求谓词只能是GET");
		return "index";
	}

访问action12的路径:[http://localhost:8080/spring-mvc/controller07/action12](http://localhost:8080/spring-mvc/controller07/action12)，访问正常，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-06.png" width="75%"/>图 1
</center>

### 3. consumes属性

consumes属性指定提交的请求的内容类型（Content-Type），如application/json, text/html，约束请求范围。如果用户发送的请求内容类型和consumes属性不匹配，则方法不会响应请求。

	@RequestMapping(value = "/action13", consumes="text/html")
    public String action13(Model model) {
        model.addAttribute("message", "请求的提交内容类型（Content-Type）是text/html");
        return "index";
    }

访问action13的路径:[http://localhost:8080/spring-mvc/controller07/action13](http://localhost:8080/spring-mvc/controller07/action13)。

在action8的注解中约束发送到服务器的请求的Content-Type必须是text/html类型，如果类型不一致则会报错（415），结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-07.png" width="75%"/>图 1
</center>

### 4. produces属性

### 5. params属性

params属性可以限制客户端发送到服务器的请求中必须含有特定的参数与值(参数的值为某些特定值或不为某些特定值)。

	@RequestMapping(value = "/action15", params = { "id=215", "name!=abc" })
	public String action15(Model model) {
		model.addAttribute("message", "请求的参数必须包含id=215与name不等于abc");
		return "index";
	}

访问action15的路径:[http://localhost:8080/spring-mvc/controller07/action15?id=215&name=abc](http://localhost:8080/spring-mvc/controller07/action15?id=215&name=abc)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-09.png" width="90%"/>图 1
</center>

访问action15的路径:[http://localhost:8080/spring-mvc/controller07/action15?id=215&name=def](http://localhost:8080/spring-mvc/controller07/action15?id=215&name=def)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-10.png" width="90%"/>图 1
</center>

**name的值不指定或者使用不等于也是通过的**

访问action15的路径:[http://localhost:8080/spring-mvc/controller07/action15?id=215&name=def](http://localhost:8080/spring-mvc/controller07/action15?id=215&name=def)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-11.png" width="90%"/>图 1
</center>

访问action15的路径:[http://localhost:8080/spring-mvc/controller07/action15?id=215&name!=abc](http://localhost:8080/spring-mvc/controller07/action15?id=215&name!=abc)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-12.png" width="90%"/>图 1
</center>

### 6. headers属性

headers属性可以限制客户端发送到服务器的请求头部信息中必须包含某个特定的值或不包含特定的值。

	@RequestMapping(value = "/action16",headers="Host=localhost:8088")
    public String action16(Model model) {
        model.addAttribute("message", "请求头部信息中必须包含Host=localhost:8088");
        return "index";
    }

访问action16的路径:[http://localhost:8080/spring-mvc/controller07/action16](http://localhost:8080/spring-mvc/controller07/action16)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-13.png" width="75%"/>图 1
</center>

	@RequestMapping(value = "/action17",headers="Host=localhost:8080")
    public String action17(Model model) {
        model.addAttribute("message", "请求头部信息中必须包含Host=localhost:8080");
        return "index";
    }

访问action17的路径:[http://localhost:8080/spring-mvc/controller07/action17](http://localhost:8080/spring-mvc/controller07/action17)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-14.png" width="75%"/>图 1
</center>

**这里同样可以使用!号；可以使用通配符如：Content-Type="application/\*"**

### 7. name属性

为当前映射指定一个名称，不常用，一般不会使用。

### 8. path属性

从Spring 4.2开始引入了@AliasFor注解，可以实现属性的别名，如value本身并没有特定的含义，而path会更加具体，见名知义，通俗说可以认为两者在使用中是一样的,如：@RequestMapping("/foo")}与@RequestMapping(path="/foo")相同。

示例代码:


访问action18的路径:[http://localhost:8080/spring-mvc/controller07/action18](http://localhost:8080/spring-mvc/controller07/action18)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-15.png" width="75%"/>图 1
</center>

访问action18的路径:[http://localhost:8080/spring-mvc/controller07/myaction](http://localhost:8080/spring-mvc/controller07/myaction)，结果如下所示：

<center>
<img src="SpringMVC-02/SpringMVC-02-16.png" width="75%"/>图 1
</center>
