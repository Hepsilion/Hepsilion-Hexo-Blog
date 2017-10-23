---
title: 04-SpringMVC表单标签库
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:49:57
tags: SpringMVC
categories: SpringMVC
description:
---

<!--more-->

# Spring MVC 表单标签库

## 一、简介

从Spring2.0起就提供了一组全面的自动数据绑定标签来处理表单元素。生成的标签兼容HTML 4.01与XHTML 1.0。表单标签库中包含了可以用在JSP页面中渲染HTML元素的标签。表单标记库包含在spring-webmvc.jar中，库的描述符称为spring-form.tld，为了使用这些标签必须在jsp页面开头处声明这个tablib指令。

	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

以下是标签库中的常用标签：

- form  渲染表单元素form
- input 渲染< input type="text"/>元素
- password 渲染< input type="password"/>元素
- hidden 渲染< input type="hidden"/>元素
- textarea 渲染textarea元素
- checkbox 渲染一个< input type="checkbox"/>复选元素
- checkboxs 渲染多个< input type="checkbox"/>元素
- radiobutton 渲染一个< input type="radio"/>单选元素
- radiobuttons 渲染多个< input type="radio"/>元素
- select 渲染一个选择元素
- option 渲染一个可选元素
- options 渲染多个可选元素列表
- errors 在span元素中渲染字段错误

## 二、常用属性

- path:要绑定的属性路径，是最重要的属性，当绑定的对象有多个属性时必填，相当于modelAttribute.getXXX() 。
- cssClass:定义要应用到被渲染元素的CSS类，类样式。
- cssStyle:定义要应用到被渲染元素的CSS样式，行内样式。
- htmlEscape:接受true或者false，表示是否应该对被渲染的值进行HTML转义。
- cssErrorClass:定义要应用到被渲染input元素的CSS类，如果bound属性中包含错误，则覆盖cssClass属性值。

## 三、常用标签

### 1. form:form标签与form:input标签

这个标签会生成HTML form标签，同时为form内部所包含的标签提供一个绑定路径（binding path)。 它把命令对象（command object)存在PageContext中，这样form内部的标签就可以使用这个对象了。标签库中的其他标签都声明在form标签的内部。

commandName：暴露表单对象的模型属性名称，默认为command，它定义了模型属性的名称，其中包含了一个backing object，其属性将用于填充生成的表单。如果该属性存在，则必须在返回包含该表单的视图的请求处理方法中添加相应的模型属性。

modelAttribute：暴露form backing object的模型属性名称，默认为command

commandName与modelAttribute功能基本一样，使用modelAttribute就可以了，因为commandName已被抛弃。

action示例代码：

	@RequestMapping("/action49")
    public String action49(Model model){
        //向模型中添加一个名为product的对象，用于渲染视图
        model.addAttribute("product", new Product("Meizu note1", 999));
        return "controller10/action49";
    }

action49.jsp代码：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>controller10/action49</title>
		</head>
		<body>
		    <form:form modelAttribute="product">
		        <p>
		            <label for="name">Name:</label>
		            <form:input path="name" />
		        </p>
		        <p>
		            <label for="price">Price:</label>
		            <form:input path="price" />
		        </p>
		    </form:form>
		</body>
	</html>

form表单与模型中名称为product的对象进行绑定，form表单元素的path指的就是访问该对象的属性，如果没有该对象或找不到属性名将异常。系统将自动把指定模型中的值与页面进行绑定。

访问路径：[http://localhost:8080/spring-mvc/controller10/action49](http://localhost:8080/spring-mvc/controller10/action49)，运行结果如图1所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-01.png" width="80%"/>图 1
</center>

模型可以为空，不是为null，中间可以没有数据，但非字符类型会取默认值，如价格会变成0.0。

action示例代码：

	@RequestMapping("/action50")
    public String action50(Model model){
        //向模型中添加一个名为product的对象，用于渲染视图
        model.addAttribute("product", new Product());
        return "controller10/action49";
    }

访问路径：[http://localhost:8080/spring-mvc/controller10/action50](http://localhost:8080/spring-mvc/controller10/action50)，运行结果如图2所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-02.png" width="80%"/>图 2
</center>

input元素可以设置其它的属性。修改后的表单：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>controller10/action49</title>
	</head>
	<body>
		<form:form modelAttribute="product">
			<p>
				<label for="name">名称：</label>
				<form:input path="name" cssClass="textCss" cssStyle="color:blue" a="b" htmlEscape="false" />
			</p>
			<p>
				<label for="price">价格：</label>
				<form:input path="price" />
			</p>
		</form:form>
	</body>
	</html>

修改后的示例代码：

	@RequestMapping("/action51")
    public String action51(Model model){
        //向模型中添加一个名为product的对象，用于渲染视图
		model.addAttribute("product", new Product("Meizu note1<hr/>", 999));
        return "controller10/action51";
    }

访问路径：[http://localhost:8080/spring-mvc/controller10/action51](http://localhost:8080/spring-mvc/controller10/action51)，运行结果如图3所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-03.png" width="80%"/>图 3
</center>

### 2. form:checkbox标签

form:checkbox标签将渲染成一个复选框，通过该标签可以获得3种不同类型的值，分别是boolean、数组和基本数据类型。

- 若绑定的值是java.lang.Boolean类型，当其值为true时，checkbox被标记为选中；
- 若绑定的值是数组类型或java.util.Collection，当setValue(Object)配置的值出现在绑定的Collection中时，checkbox被标记为选中；
- 若绑定的值是其他类型，当setValue(Object)配置的值等于其绑定值时，checkbox被标记为选中。

定义一个实体类Person：

	package org.spring.mvc.model;
	
	public class Person {
		// 婚否
		private boolean isMarried;
		// 爱好
		private String[] hobbies;
		// 学历
		private String education;
	
		public boolean getIsMarried() {
			return isMarried;
		}
	
		public void setIsMarried(boolean isMarried) {
			this.isMarried = isMarried;
		}
	
		public String[] getHobbies() {
			return hobbies;
		}
	
		public void setHobbies(String[] hobbies) {
			this.hobbies = hobbies;
		}
	
		public String getEducation() {
			return education;
		}
	
		public void setEducation(String education) {
			this.education = education;
		}
	}

特别注意的是boolean类型的值生成的get/set方法前是不带get与set的，这样会引起异常，建议手动修改。

action示例代码：

	@RequestMapping("/action52")
	public String action52(Model model) {
		Person person = new Person();
		person.setIsMarried(true);
		person.setHobbies(new String[]{"Movie", "Surfing"});
		person.setEducation("Bachelor");
		model.addAttribute("person", person);
		return "controller10/action52";
	}

	@RequestMapping("/action53")
	@ResponseBody
	public Person action53(HttpServletResponse response, Person person) {
		return person;
	}

action52.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>controller10/action52</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action53">
		        <p>
		            <label for="name">isMarried:</label>
		            <form:checkbox path="isMarried" />
		        </p>
		        <p>
		            <label for="name">Hobbies:</label>
		            <form:checkbox path="hobbies" value="Reading"/>Reading
		            <form:checkbox path="hobbies" value="Surfing"/>Surfing
		            <form:checkbox path="hobbies" value="Movie"/>Movie
		        </p>
		        <p>
		            <label for="name">hasGraduate:</label>
		            <form:checkbox path="education" value="Bachelor"/>Bachelor
		        </p>
		        <p>
		        	<button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action52](http://localhost:8080/spring-mvc/controller10/action52)，运行结果如图4所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-04.png" width="80%"/>图 4
</center>

form:checkbox在渲染成input标签里会变成2个表单元素，这样可以确保用户没有选择内容时也会将值带会服务器，默认是没有这样的。

### 3. form:radiobutton标签

form:radiobutton标签生成类型为radio的HTML input标签，也就是常见的单选框。这个标签的典型用法是一次声明多个标签实例，所有的标签都有相同的path属性，但是他们的value属性不同。

action示例代码：

	@RequestMapping("/action54")
    public String action54(Model model){
		Person person = new Person();
		person.setEducation("Bachelor");
		model.addAttribute("person", person);
        return "controller10/action54";
    }

action54.jsp:
	
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>bar/action31</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action53">
		        <p>
		            <label for="name">Education</label>
		            <form:radiobutton path="education" value="College"/>College
		            <form:radiobutton path="education" value="Bachelor"/>Bachelor
		            <form:radiobutton path="education" value="Master"/>Master
		        </p>
		        <p>
		        <button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action54](http://localhost:8080/spring-mvc/controller10/action54)，运行结果如图5所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-05.png" width="80%"/>图 5
</center>

### 4. form:password标签

form:password标签生成类型为password的HTML input标签，渲染后生成一个密码框。input标签的值和表单支持对象相应属性的值保持一致。该标签与input类似，但有一个特殊的属性showPassword，是否将对象中的值绑定到密码框中，默认为false，也意味着密码框中不会出现默认的掩码。

action示例代码：

	@RequestMapping("/action55")
    public String action55(Model model){
        Person person=new Person();
        person.setEducation("edu");
        model.addAttribute("person", person);
        return "controller10/action55";
    }


action55.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>bar/action31</title>
		</head>
		<body>
			<form:form modelAttribute="person" action="action53">
				<p>
					<label for="name">Education</label>
					<form:radiobutton path="education" value="College" />College
					<form:radiobutton path="education" value="Bachelor" />Bachelor
					<form:radiobutton path="education" value="Master" />Master
				</p>
				<p>
					<label>Password:</label>
					<form:password path="education" showPassword="false" />
				</p>
				<p>
					<button>Submit</button>
				</p>
			</form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action55](http://localhost:8080/spring-mvc/controller10/action55)，运行结果如图6所示：其中showPassword值为false

<center>
<img src="SpringMVC-04/SpringMVC-04-06.png" width="80%"/>图 6
</center>

当showPassword值为true时，运行结果如图7所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-07.png" width="80%"/>图 7
</center>

### 5. form:select标签

form:select标签生成HTML select标签，就是下拉框，多选框。在生成的HTML代码中，被选中的选项和表单支持对象相应属性的值保持一致。这个标签也支持嵌套的option和options标签。

action示例代码：

	@RequestMapping("/action56")
    public String action56(Model model){
        List<ProductType>  productTypes = new ArrayList<ProductType>();
        productTypes.add(new ProductType(11, "数码电子"));
        productTypes.add(new ProductType(21, "鞋帽服饰"));
        productTypes.add(new ProductType(31, "图书音像"));
        productTypes.add(new ProductType(41, "五金家电"));
        productTypes.add(new ProductType(51, "生鲜水果"));
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("person", new Person());
        return "controller10/action56";
    }

在action56中为模型添加了一个属性productTypes，该对象用于绑定到页面的下拉列表框。

action56.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>bar/action41</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action42">
		        <p>
		            <label for="name">Product Types: </label>
		            <form:select size="3" multiple="multiple" path="education" items="${productTypes}"  itemLabel="name"  itemValue="id"></form:select>
		        </p>
		        <p>
		        	<button>提交</button>
		        </p>
		    </form:form>
		</body>
	</html>

- size="3" 表示可见项为3项，默认可见项为1项
- multiple="multiple" 表示允许多选，默认为单选
- path="education" 与表单中指定的modelAttribute对象进行双向绑定
- items="${productTypes}" 绑定到下拉列表的集合对象
- itemLabel="name" 集合中的对象的name属性作为下拉列表option的text属性
- itemValue="id" 集合中的对象的id属性作为下拉列表option的value属性

访问路径：[http://localhost:8080/spring-mvc/controller10/action56](http://localhost:8080/spring-mvc/controller10/action56)，运行结果如图8所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-08.png" width="80%"/>图 8
</center>

### 6. form:option标签

option标签生成HTML option标签，可以用于生成select表单元素中的单项，没有path属性，有label与value属性。

action示例代码：

	@RequestMapping("/action57")
    public String action57(Model model){
        model.addAttribute("person", new Person());
        return "controller10/action57";
    }

action57.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>bar/action51</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action52">
		        <p>
		            <label for="name">Education: </label>
		            <form:select path="education">
		                <form:option value="" >--Select--</form:option>
		                <form:option value="College">College</form:option>
		                <form:option value="Bachelor">Bachelor</form:option>
		                <form:option value="Master">Master</form:option>
		            </form:select>
		        </p>
		        <p>
		            <button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action57](http://localhost:8080/spring-mvc/controller10/action57)，运行结果如图9所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-09.png" width="80%"/>图 9
</center>

### 7. form:options标签

form:options标签生成一系列的HTML option标签，可以用它生成select标签中的子标签。

action示例代码：

	@RequestMapping("/action58")
    public String action58(Model model){
        List<ProductType>  productTypes = new ArrayList<ProductType>();
        productTypes.add(new ProductType(11, "数码电子"));
        productTypes.add(new ProductType(21, "鞋帽服饰"));
        productTypes.add(new ProductType(31, "图书音像"));
        productTypes.add(new ProductType(41, "五金家电"));
        productTypes.add(new ProductType(51, "生鲜水果"));
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("person", new Person());
        return "controller10/action58";
    }

action58.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>controller10/action58</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action62">
		        <p>
		            <label for="name">Product Type: </label>
		            <form:select path="education">
		               <form:option value="">--Select--</form:option>
		               <form:options items="${productTypes}" itemLabel="name" itemValue="id"/>
		            </form:select>
		        </p>
		        <p>
		            <button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action58](http://localhost:8080/spring-mvc/controller10/action58)，运行结果如图10所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-10.png" width="80%"/>图 10
</center>

上面的这个例子同时使用了option标签和options标签。这两个标签生成的HTML代码是相同的，但是第一个option标签允许你在JSP中明确声明这个标签的值只供显示使用，并不绑定到表单支持对象的属性上。

### 8. form:textarea、form:errors标签

form:textarea标签生成HTML textarea标签，就是一个多行文本标签，用法与input非常类似。

form:errors标签用于显示错误信息。

### 9. form:hidden标签

form:hidden标签生成类型为hidden的HTML input标签。在生成的HTML代码中，input标签的值和表单支持对象相应属性的值保持一致。如果你需要声明一个类型为hidden的input标签，但是表单支持对象中没有对应的属性，你只能使用HTML的标签。

action示例代码：

	@RequestMapping("/action59")
    public String action59(Model model){
        Person person=new Person();
        person.setEducation("99");
        model.addAttribute("person", person);
        return "controller10/action59";
    }

action59.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>controller10/action59</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action72">
		        <p>
		            <form:hidden path="education" />
		            <input type="hidden" value="1" name="id">
		        </p>
		        <p>
		            <button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/controller10/action59](http://localhost:8080/spring-mvc/controller10/action59)。

### 10. form:radiobuttons标签与form:checkboxs标签

form:radiobuttons标签将生成一组单选框，只允许多个中选择1个；form:checkboxs标签生成一组复选列表，允许多选。

action示例代码：

	@RequestMapping("/action60")
    public String action60(Model model) {
        List<ProductType> productTypes = new ArrayList<ProductType>();
        productTypes.add(new ProductType(11, "数码电子"));
        productTypes.add(new ProductType(21, "鞋帽服饰"));
        productTypes.add(new ProductType(31, "图书音像"));
        productTypes.add(new ProductType(41, "五金家电"));
        productTypes.add(new ProductType(51, "生鲜水果"));
        model.addAttribute("productTypes", productTypes);
        model.addAttribute("person", new Person());
        return "controller10/action60";
    }

action60.jsp:

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>controller10/action60</title>
		</head>
		<body>
		    <form:form modelAttribute="person" action="action82">
		        <p>
		            <label for="name">Product Type: </label>
		            <form:radiobuttons path="education" items="${productTypes}"  itemLabel="name"  itemValue="id" delimiter=","  element="a"/>
		        </p>
		        <p>
		            <label for="name">Product Type: </label>
		            <form:checkboxes path="education" items="${productTypes}"  itemLabel="name"  itemValue="id" delimiter="-"/>
		        </p>
		        <p>
		        	<button>Submit</button>
		        </p>
		    </form:form>
		</body>
	</html>

- 属性delimiter=","，表示生成的单项间使用","号分隔，默认为空。
- 属性element="a"，表示生成的单项容器，默认为span。

访问路径：[http://localhost:8080/spring-mvc/controller10/action60](http://localhost:8080/spring-mvc/controller10/action60)，运行结果如图11所示：

<center>
<img src="SpringMVC-04/SpringMVC-04-11.png" width="80%"/>图 11
</center>