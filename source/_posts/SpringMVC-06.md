---
title: 06-Spring MVC验证器
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-10-22 14:53:40
tags: SpringMVC
categories: SpringMVC
description:
---

<!--more-->
# Spring MVC验证器

在展示Spring MVC验证器之前，先在前面项目的基础上，通过一个相对综合的示例串联前面学习过的一些知识点，主要实现产品管理管理功能，包含产品的添加，删除，修改，查询，多删除功能。

## 一、综合示例

### 1. 新建POJO实体（entity）

在包org.spring.mvc.model包中新增产品类型类ProductType：

	package org.spring.mvc.model;
	
	import java.io.Serializable;
	
	/**
	 * 产品类型
	 */
	public class ProductType implements Serializable {
		private static final long serialVersionUID = 2L;
		// 编号
		private int id;
		// 名称
		private String name;
	
		public ProductType() {
		}
	
		public ProductType(int id, String name) {
			super();
			this.id = id;
			this.name = name;
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
	
		@Override
		public String toString() {
			return "编号：" + this.getId() + "，名称：" + this.getName();
		}
	}

修改产品POJO类Product：

	package org.spring.mvc.model;
	
	import java.io.Serializable;
	
	/**
	 * 产品
	 */
	public class Product implements Serializable {
		private static final long serialVersionUID = 1L;
		// 编号
		private int id;
		// 名称
		private String name;
		// 价格
		private double price;
		// 产品类型
		private ProductType productType;
	
		public Product() {
			productType = new ProductType();
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
	
		public Product(int id, String name, double price, ProductType type) {
			super();
			this.id = id;
			this.name = name;
			this.price = price;
			this.productType = type;
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
	
		public ProductType getProductType() {
			return productType;
		}
	
		public void setProductType(ProductType productType) {
			this.productType = productType;
		}
	
		@Override
		public String toString() {
			return "编号(id)：" + this.getId() + "，名称(name)：" + this.getName() + "，价格(price)：" + this.getPrice() + "，类型(productType.Name)：" + this.getProductType().getName();
		}
	}

### 2. 新建业务层（Service）

在包org.spring.mvc.service中创建产品类型服务接口ProductTypeService：

	package org.spring.mvc.service;
	
	import java.util.List;
	import org.spring.mvc.model.ProductType;
	
	/**
	 * 产品类型服务
	 *
	 */
	public interface ProductTypeService {
		/**
		 * 根据产品类型编号获得产品类型对象
		 */
		public ProductType getProductTypeById(int id);
	
		/**
		 * 获得所有的产品类型
		 */
		public List<ProductType> getAllProductTypes();
	}

创建产品类型服务接口ProductTypeService的实现类ProductTypeServiceImpl：

	package org.spring.mvc.service;
	
	import java.util.ArrayList;
	import java.util.List;
	
	import org.spring.mvc.model.ProductType;
	import org.springframework.stereotype.Service;
	
	@Service
	public class ProductTypeServiceImpl implements ProductTypeService {
		private static List<ProductType> productTypes;
	
		static {
			productTypes = new ArrayList<ProductType>();
			productTypes.add(new ProductType(11, "数码电子"));
			productTypes.add(new ProductType(21, "鞋帽服饰"));
			productTypes.add(new ProductType(31, "图书音像"));
			productTypes.add(new ProductType(41, "五金家电"));
			productTypes.add(new ProductType(51, "生鲜水果"));
		}
	
		@Override
		public ProductType getProductTypeById(int id) {
			for (ProductType productType : productTypes) {
				if (productType.getId() == id) {
					return productType;
				}
			}
			return null;
		}
	
		@Override
		public List<ProductType> getAllProductTypes() {
			return productTypes;
		}
	}

在包org.spring.mvc.service中创建产品服务接口ProductService：

	package org.spring.mvc.service;
	
	import java.util.List;
	
	import org.spring.mvc.model.Product;
	
	public interface ProductService {
		/**
		 * 获得所有的产品
		 */
		List<Product> getAllProducts();
	
		/**
		 * 通过编号获得产品
		 */
		Product getProductById(int id);
	
		/**
		 * 通过名称获得产品
		 */
		List<Product> getProductsByName(String productName);
	
		/**
		 * 新增产品对象
		 */
		void addProduct(Product enttiy) throws Exception;
	
		/**
		 * 更新产品对象
		 */
		public void updateProduct(Product entity) throws Exception;
	
		/**
		 * 删除产品对象
		 */
		void deleteProduct(int id);
	
		/**
		 * 多删除产品对象
		 */
		void deletesProduct(int[] ids);
	}

创建产品服务接口ProductService的实现类ProductServiceImpl：

	package org.spring.mvc.service;
	
	import java.util.ArrayList;
	import java.util.List;
	
	import org.spring.mvc.model.Product;
	import org.springframework.stereotype.Service;
	
	@Service
	public class ProductServiceImpl implements ProductService {
		private static List<Product> products;
	
		static {
			ProductTypeService productTypeService = new ProductTypeServiceImpl();
			products = new ArrayList<Product>();
			products.add(new Product(198, "Huwei P8", 4985.6, productTypeService.getProductTypeById(11)));
			products.add(new Product(298, "李宁运动鞋", 498.56, productTypeService.getProductTypeById(21)));
			products.add(new Product(398, "Spring MVC权威指南", 49.856,productTypeService.getProductTypeById(31)));
			products.add(new Product(498, "山东国光苹果", 4.9856, productTypeService.getProductTypeById(51)));
			products.add(new Product(598, "8开门超级大冰箱", 49856.1, productTypeService.getProductTypeById(41)));
		}
	
		/**
		 * 获得所有的产品
		 */
		@Override
		public List<Product> getAllProducts() {
			return products;
		}
	
		/**
		 * 通过编号获得产品
		 */
		@Override
		public Product getProductById(int id) {
			for (Product product : products) {
				if (product.getId() == id) {
					return product;
				}
			}
			return null;
		}
	
		/**
		 * 通过名称获得产品名称
		 */
		@Override
		public List<Product> getProductsByName(String productName) {
			if (productName == null || productName.equals("")) {
				return getAllProducts();
			}
			List<Product> result = new ArrayList<Product>();
			for (Product product : products) {
				if (product.getName().contains(productName)) {
					result.add(product);
				}
			}
			return result;
		}
	
		/**
		 * 新增
		 * 
		 * @throws Exception
		 */
		@Override
		public void addProduct(Product entity) throws Exception {
			if (entity.getName() == null || entity.getName().equals("")) {
				throw new Exception("产品名称必须填写");
			}
			if (products.size() > 0) {
				entity.setId(products.get(products.size() - 1).getId() + 1);
			} else {
				entity.setId(1);
			}
			products.add(entity);
		}
	
		/**
		 * 更新
		 */
		public void updateProduct(Product entity) throws Exception {
			if (entity.getPrice() < 0) {
				throw new Exception("价格必须大于0");
			}
			Product source = getProductById(entity.getId());
			source.setName(entity.getName());
			source.setPrice(entity.getPrice());
			source.setProductType(entity.getProductType());
		}
	
		/**
		 * 删除
		 */
		@Override
		public void deleteProduct(int id) {
			products.remove(getProductById(id));
		}
	
		/**
		 * 多删除
		 */
		@Override
		public void deletesProduct(int[] ids) {
			for (int id : ids) {
				deleteProduct(id);
			}
		}
	}

### 3. 实现展示、查询、删除与多删除功能

在org.spring.mvc.controller包中定义一个名为ProductController的控制器

index请求处理方法在路径映射注解@RequestMapping中也并未指定value值是让该action为默认action，所有当我们访问系统时这个index就成了欢迎页。

	package org.spring.mvc.controller;
	
	import org.spring.mvc.model.Product;
	import org.spring.mvc.service.ProductService;
	import org.spring.mvc.service.ProductTypeService;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	
	@Controller
	@RequestMapping("/product")
	public class ProductController {
		@Autowired
		ProductService productService;
		@Autowired
		ProductTypeService productTypeService;
	
		/**
		 * 展示与搜索
		 */
		@RequestMapping
		public String index(Model model, String searchKey) {
			model.addAttribute("products", productService.getProductsByName(searchKey));
			model.addAttribute("searchKey", searchKey);
			return "product/index";
		}
	
		/**
		 * 删除，id为路径变量
		 */
		@RequestMapping("/delete/{id}")
		public String delete(@PathVariable int id) {
			productService.deleteProduct(id);
			return "redirect:/product";
		}
	
		/**
		 * 多删除，ids的值为多个id参数组成
		 */
		@RequestMapping("/deletes")
		public String deletes(@RequestParam("id") int[] ids) {
			productService.deletesProduct(ids);
			return "redirect:/product";
		}
	}

定义所有页面风格用的main.css样式：

	@CHARSET "UTF-8";
	
	* {
		margin: 0;
		padding: 0;
		font-family: microsoft yahei;
		font-size: 14px;
	}
	
	body {
		padding-top: 20px;
	}
	
	.main {
		width: 90%;
		margin: 0 auto;
		border: 1px solid #777;
		padding: 20px;
		border-radius: 5px;
	}
	
	.main .title {
		font-size: 20px;
		font-weight: normal;
		border-bottom: 1px solid #ccc;
		margin-bottom: 15px;
		padding-bottom: 5px;
		color: #006ac1;
	}
	
	.main .title span {
		display: inline-block;
		font-size: 20px;
		color: #fff;
		padding: 0 8px;
		background: orangered;
		border-radius: 5px;
	}
	
	a {
		color: #006ac1;
		text-decoration: none;
	}
	
	a:hover {
		color: orangered;
	}
	
	.tab td, .tab, .tab th {
		border: 1px solid #777;
		border-collapse: collapse;
	}
	
	.tab td, .tab th {
		line-height: 26px;
		height: 26px;
		padding-left: 5px;
	}
	
	.abtn {
		display: inline-block;
		height: 18px;
		line-height: 18px;
		background: #006ac1;
		color: #fff;
		padding: 0 5px;
		border-radius: 5px;
	}
	
	.btn {
		height: 18px;
		line-height: 18px;
		background: #006ac1;
		color: #fff;
		padding: 0 8px;
		border: 0;
		border-radius: 5px;
	}
	
	.abtn:hover, .btn:hover {
		background: orangered;
		color: #fff;
	}
	
	p {
		padding: 5px 0;
	}
	
	fieldset {
		border: 1px solid #ccc;
		padding: 5px 10px;
	}
	
	fieldset legend {
		margin-left: 10px;
		font-size: 16px;
	}
	
	a.out, input.out {
		height: 23px;
		line-height: 23px;
	}
	
	form {
		margin: 10px 0;
	}

在view目录下新建目录product，在product目录下新建一个视图index.jsp：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<link href="<c:url value="/styles/main.css"/>" type="text/css" rel="stylesheet" />
			<title>产品管理</title>
		</head>
		<body>
			<div class="main">
				<h2 class="title">
					<span>产品管理</span>
				</h2>
				<form method="get">
					名称：<input type="text" name="searchKey" value="${searchKey}" /> <input type="submit" value="搜索" class="btn out" />
				</form>
				<form action="product/deletes" method="post">
					<table border="1" width="100%" class="tab">
						<tr>
							<th><input type="checkbox" id="chbAll"></th>
							<th>编号</th>
							<th>产品名</th>
							<th>价格</th>
							<th>类型</th>
							<th>操作</th>
						</tr>
						<c:forEach var="product" items="${products}">
							<tr>
								<th><input type="checkbox" name="id" value="${product.id}"></th>
								<td>${product.id}</td>
								<td>${product.name}</td>
								<td>${product.price}</td>
								<td>${product.productType.name}</td>
								<td><a href="product/delete/${product.id}" class="abtn">删除</a> <a href="product/edit/${product.id}" class="abtn">编辑</a></td>
							</tr>
						</c:forEach>
					</table>
					<p style="color: red">${message}</p>
					<p>
						<a href="product/add" class="abtn out">添加</a> <input type="submit" value="删除选择项" class="btn out" />
					</p>
					<script type="text/javascript" src="<c:url value="/scripts/jQuery1.11.3/jquery-1.11.3.min.js"/>"></script>
				</form>
			</div>
		</body>
	</html>

访问路径：[http://localhost:8080/spring-mvc/product](http://localhost:8080/spring-mvc/product)，运行结果如图1所示：

<center>
<img src="SpringMVC-06/SpringMVC-06-01.png" width="80%"/>图 1
</center>

### 4. 新增产品

在ProductController控制器中添加两个Action，一个用于渲染添加页面，另一个用于响应保存功能：

	/**
	 *  新增，渲染出新增界面
	 */
	@RequestMapping("/add")
	public String add(Model model) {
		// 与form绑定的模型
		model.addAttribute("product", new Product());
		// 用于生成下拉列表
		model.addAttribute("productTypes", productTypeService.getAllProductTypes());
		return "product/add";
	}

	/**
	 * 新增保存，如果新增成功转回列表页，如果失败回新增页，保持页面数据
	 */
	@RequestMapping("/addSave")
	public String addSave(Model model, Product product) {
		try {
			// 根据类型的编号获得类型对象
			product.setProductType(productTypeService.getProductTypeById(product.getProductType().getId()));
			productService.addProduct(product);
			return "redirect:/product";
		} catch (Exception exp) {
			// 与form绑定的模型
			model.addAttribute("product", product);
			// 用于生成下拉列表
			model.addAttribute("productTypes", productTypeService.getAllProductTypes());
			// 错误消息
			model.addAttribute("message", exp.getMessage());
			return "product/add";
		}
	}

在view/product目录下新增视图add.jsp页面：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
			<link href="<c:url value="/styles/main.css"/>" type="text/css" rel="stylesheet" />
			<title>新增产品</title>
		</head>
		<body>
			<div class="main">
				<h2 class="title">
					<span>新增产品</span>
				</h2>
				<form:form action="addSave" modelAttribute="product">
					<fieldset>
						<legend>产品</legend>
						<p>
							<label for="name">产品名称：</label>
							<form:input path="name" />
						</p>
						<p>
							<label for="title">产品类型：</label>
							<form:select path="productType.id" items="${productTypes}" itemLabel="name" itemValue="id">
							</form:select>
						</p>
						<p>
							<label for="price">产品价格：</label>
							<form:input path="price" />
						</p>
						<p>
							<input type="submit" value="保存" class="btn out">
						</p>
					</fieldset>
				</form:form>
				<p style="color: red">${message}</p>
				<p>
					<a href="<c:url value="/product" />" class="abtn out">返回列表</a>
				</p>
			</div>
		</body>
	</html>

点击添加按钮，运行结果如图2所示：

<center>
<img src="SpringMVC-06/SpringMVC-06-02.png" width="80%"/>图 2
</center>

### 5. 编辑产品

在ProductController控制器中添加两个Action，一个用于渲染编辑页面，根据要编辑的产品编号获得产品对象，另一个用于响应保存功能。

	/**
	 * 编辑，渲染出编辑界面，路径变量id是用户要编辑的产品编号
	 */
	@RequestMapping("/edit/{id}")
	public String edit(Model model, @PathVariable int id) {
		// 与form绑定的模型
		model.addAttribute("product", productService.getProductById(id));
		// 用于生成下拉列表
		model.addAttribute("productTypes", productTypeService.getAllProductTypes());
		return "product/edit";
	}

	/**
	 *  编辑后保存，如果更新成功转回列表页，如果失败回编辑页，保持页面数据
	 */
	@RequestMapping("/editSave")
	public String editSave(Model model, Product product) {
		try {
			// 根据类型的编号获得类型对象
			product.setProductType(productTypeService.getProductTypeById(product.getProductType().getId()));
			productService.updateProduct(product);
			return "redirect:/product";
		} catch (Exception exp) {
			// 与form绑定的模型
			model.addAttribute("product", product);
			// 用于生成下拉列表
			model.addAttribute("productTypes", productTypeService.getAllProductTypes());
			// 错误消息
			model.addAttribute("message", exp.getMessage());
			return "product/edit";
		}
	}

在view/product目录下新增视图edit.jsp页面：

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
			<link href="<c:url value="/styles/main.css" />" type="text/css" rel="stylesheet" />
			<title>编辑产品</title>
		</head>
		<body>
		    <div class="main">
		        <h2 class="title"><span>编辑产品</span></h2>
		        <form:form action="../editSave" modelAttribute="product">
		        <fieldset>
		            <legend>产品</legend>
		            <p>
		                <label for="name">产品名称：</label>
		                <form:input path="name"/>
		            </p>
		            <p>
		                <label for="title">产品类型：</label>
		                <form:select path="productType.id" items="${productTypes}"  itemLabel="name" itemValue="id">
		                </form:select>
		            </p>
		            <p>
		                <label for="price">产品价格：</label>
		                <form:input path="price"/>
		            </p>
		            <p>
		              <form:hidden path="id"/>
		              <input type="submit" value="保存" class="btn out">
		            </p>
		        </fieldset>
		        </form:form>
		        <p style="color: red">${message}</p>
		        <p>
		            <a href="<c:url value="/product" />"  class="abtn out">返回列表</a>
		        </p>
		    </div>
		</body>
	</html>

点击编辑按钮，运行结果如图3所示：

<center>
<img src="SpringMVC-06/SpringMVC-06-03.png" width="90%"/>图 3
</center>

## 二、Spring MVC验证器

Spring MVC不仅是在架构上改变了项目，使代码变得可复用、可维护与可扩展，其实在功能上也加强了不少。验证与文件上传是许多项目中不可缺少的一部分。在项目中验证非常重要，首先是安全性考虑，如防止注入攻击，XSS等；其次还可以确保数据的完整性，如输入的格式，内容，长度，大小等。Spring MVC可以使用验证器Validator与JSR303完成后台验证功能。这里也会介绍方便的前端验证方法。

### 1. Validator验证器

Spring MVC Validator验证器是一个接口，通过实现该接口可以定义对实体对象的验证。该接口如下所示：

	package org.springframework.validation;
	
	/**
	 * Spring MVC内置的验证器接口
	 */
	public interface Validator {
	    /**
	     * 是否可以验证该类型
	     */
	    boolean supports(Class<?> clazz);
	
	    /**
	     * 执行验证 target表示要验证的对象 error表示错误信息
	     */
	    void validate(Object target, Errors errors);
	}

#### (1) 定义验证器

	package org.spring.mvc.model;
	
	import org.springframework.validation.Errors;
	import org.springframework.validation.ValidationUtils;
	import org.springframework.validation.Validator;
	
	/**
	 * 产品验证器
	 *
	 */
	public class ProductValidator implements Validator {
		/**
		 *  当前验证器可以验证的类型
		 */
		@Override
		public boolean supports(Class<?> clazz) {
			return Product.class.isAssignableFrom(clazz);
		}
	
		/**
		 *  执行校验
		 */
		@Override
		public void validate(Object target, Errors errors) {
			// 将要验证的对象转换成Product类型
			Product entity = (Product) target;
			// 如果产品名称为空或为空格，使用工具类
			ValidationUtils.rejectIfEmptyOrWhitespace(errors, "name", "required", "产品名称必须填写");
			// 价格，手动判断
			if (entity.getPrice() < 0) {
				errors.rejectValue("price", "product.price.gtZero", "产品价格必须大于等于0");
			}
			// 产品类型必须选择
			if (entity.getProductType().getId() == 0) {
				errors.rejectValue("productType.id", "product.productType.id.required", "请选择产品类型");
			}
		}
	}

ValidationUtils是一个工具类，中间有一些方可以用于判断内容是否有误。

#### (2) 执行校验

	/**
	 * 新增保存，如果新增成功转回列表页，如果失败回新增页，保持页面数据
	 *  
	 * @param model
	 * @param product
	 * @return
	 */
	@RequestMapping("/addSave")
	public String addSave(Model model, Product product, BindingResult bindingResult) {
		// 创建一个产品验证器
        ProductValidator validator = new ProductValidator();
        // 执行验证，将验证的结果给bindingResult，该类型继承Errors
        validator.validate(product, bindingResult);

        // 获得所有的字段错误信息，非必要
        for (FieldError fielderror : bindingResult.getFieldErrors()) {
            System.out.println(fielderror.getField() + "，" + fielderror.getCode() + "，" + fielderror.getDefaultMessage());
        }
		
		try {
			// 是否存在错误，如果没有，执行添加
	        if (!bindingResult.hasErrors()) {
	            // 根据类型的编号获得类型对象
	            product.setProductType(productTypeService.getProductTypeById(product.getProductType().getId()));
	            productService.addProduct(product);
	            return "redirect:/product2";
	        } else {
	            // 与form绑定的模型
	            model.addAttribute("product", product);
	            // 用于生成下拉列表
	            model.addAttribute("productTypes", productTypeService.getAllProductTypes());
	            return "product2/add";
	        }
		} catch (Exception exp) {
			// 与form绑定的模型
			model.addAttribute("product", product);
			// 用于生成下拉列表
			model.addAttribute("productTypes", productTypeService.getAllProductTypes());
			// 错误消息
			model.addAttribute("message", exp.getMessage());
			return "product2/add";
		}
	}

注意在参数中增加了一个BindingResult类型的对象，该类型继承自Errors，获得绑定结果，承载错误信息，该对象中有一些方法可以获得完整的错误信息，可以使用hasErrors方法判断是否产生了错误。

#### (4) 在UI中添加错误标签

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
			<link href="<c:url value="/styles/main.css"/>" type="text/css" rel="stylesheet" />
			<title>新增产品</title>
		</head>
		<body>
		    <div class="main">
		        <h2 class="title"><span>新增产品</span></h2>
		        <form:form action="addSave" modelAttribute="product">
		        <fieldset>
		            <legend>产品</legend>
		            <p>
		                <label for="name">产品名称：</label>
		                <form:input path="name"/>
		                <form:errors path="name" cssClass="error"></form:errors>
		            </p>
		            <p>
		                <label for="title">产品类型：</label>
		                <form:select path="productType.id">
		                     <form:option value="0">--请选择--</form:option>
		                     <form:options items="${productTypes}"  itemLabel="name" itemValue="id"/>
		                </form:select>
		                <form:errors path="productType.id" cssClass="error"></form:errors>
		            </p>
		            <p>
		                <label for="price">产品价格：</label>
		                <form:input path="price"/>
		                <form:errors path="price" cssClass="error"></form:errors>
		            </p>
		            <p>
		              <input type="submit" value="保存" class="btn out">
		            </p>
		        </fieldset>
		        </form:form>
		        <p style="color: red">${message}</p>
		        <p>
		            <a href="<c:url value="/product2" />"  class="abtn out">返回列表</a>
		        </p>
		    </div>
		</body>
	</html>

#### (5) 测试运行

访问路径：[http://localhost:8080/spring-mvc/product2](http://localhost:8080/spring-mvc/product2)，运行结果如图4所示：

<center>
<img src="SpringMVC-06/SpringMVC-06-04.png" width="80%"/>图 4
</center>

控制台输出：

	name，required，产品名称必须填写
	price，product.price.gtZero，产品价格必须大于等于0
	productType.id，product.productType.id.required，请选择产品类型

### 2. JSR303验证器

JSR是Java Specification Requests的缩写，意思是Java规范提案，是指向JCP(Java Community Process)提出新增一个标准化技术规范的正式请求。任何人都可以提交JSR，以向Java平台增添新的API和服务。JSR已成为Java界的一个重要标准。JSR303只是一个标准，是一个数据验证规范，对这个标准的实现有：hibernate-validator，Apache BVal等。这里我们使用hibernate-validator实现校验。

#### (1) 添加hibernate-validator依赖

修改配置pom.xml配置文件，添加依赖。

	<!--JSR303 Bean校验-->
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-validator</artifactId>
        <version>5.2.2.Final</version>
    </dependency>

#### (2) 注解实体类

为Bean的name和price属性设置验证规则：

	// 名称
	@Size(min=1,max=50,message="名称长度必须介于{2}-{1}之间")
    @Pattern(regexp="^[\\w\\u4e00-\\u9fa5]{0,10}$",message="格式错误，必须是字母数字与中文")
	private String name;
	// 价格
	@Range(min=0,max=1000000,message="价格只允许在{2}-{1}之间")
	private double price;


常用验证的注解如下所示：

##### 空值检查

- @Null 验证对象是否为null
- @NotNull 验证对象是否不为null, 无法查检长度为0的字符串
- @NotBlank 检查约束字符串是不是Null还有被Trim的长度是否大于0,只对字符串,且会去掉前后空格.
- @NotEmpty 检查约束元素是否为NULL或者是EMPTY.

##### Booelan检查

- @AssertTrue 验证 Boolean 对象是否为 true 
- @AssertFalse 验证 Boolean 对象是否为 false 

##### 长度检查

- @Size(min=, max=) 验证对象（Array,Collection,Map,String）长度是否在给定的范围之内 
- @Length(min=, max=) Validates that the annotated string is between min and max included.

##### 日期检查

- @Past         验证 Date 和 Calendar 对象是否在当前时间之前 
- @Future     验证 Date 和 Calendar 对象是否在当前时间之后 

##### 正则

- @Pattern    验证 String 对象是否符合正则表达式的规则

##### 数值检查

建议使用在Stirng,Integer类型，不建议使用在int类型上，因为表单值为“”时无法转换为int，但可以转换为String为"",Integer为null

- @Min            验证 Number 和 String 对象是否大等于指定的值 
- @Max            验证 Number 和 String 对象是否小等于指定的值 
- @DecimalMax 被标注的值必须不大于约束中指定的最大值. 这个约束的参数是一个通过BigDecimal定义的最大值的字符串表示.小数存在精度
- @DecimalMin 被标注的值必须不小于约束中指定的最小值. 这个约束的参数是一个通过BigDecimal定义的最小值的字符串表示.小数存在精度
- @Digits     验证 Number 和 String 的构成是否合法 
- @Digits(integer=,fraction=) 验证字符串是否是符合指定格式的数字，interger指定整数精度，fraction指定小数精度。

##### 范围

- @Range(min=, max=) 检查被注解对象的值是否处于min与max之间，闭区间，包含min与max值
- @Range(min=10000,max=50000,message="必须介于{2}-{1}之间")

##### 其它注解

- @Valid 递归的对关联对象进行校验, 如果关联对象是个集合或者数组,那么对其中的元素进行递归校验,如果是一个map,则对其中的值部分进行校验.(是否进行递归验证)，该注解使用在Action的参数上。
- @CreditCardNumber信用卡验证
- @Email  验证是否是邮件地址，如果为null,不进行验证，算通过验证。
- @ScriptAssert(lang= ,script=, alias=)
- @URL(protocol=,host=, port=,regexp=, flags=)

### (3) 注解控制器参数

在需要使用Bean验证的参数对象上注解@Valid，触发验证

	@RequestMapping("/addGoodsSave")
	public String addSave(Model model, @Valid Product product, BindingResult bindingResult) {
		try {
			// 是否存在错误，如果没有，执行添加
	        if (!bindingResult.hasErrors()) {
	            // 根据类型的编号获得类型对象
	            product.setProductType(productTypeService.getProductTypeById(product.getProductType().getId()));
	            productService.addProduct(product);
	            return "redirect:/product3";
	        } else {
	            // 与form绑定的模型
	            model.addAttribute("product", product);
	            // 用于生成下拉列表
	            model.addAttribute("productTypes", productTypeService.getAllProductTypes());
	            return "product3/addGoods";
	        }
		} catch (Exception exp) {
			// 与form绑定的模型
            model.addAttribute("product", product);
            // 用于生成下拉列表
            model.addAttribute("productTypes", productTypeService.getAllProductTypes());
            return "product3/addGoods";
		}
	}

### (4) 在UI中添加错误标签

这里与Spring MVC Validator基本一致，在product3目录下新增一个名为addGoods.jsp的页面

	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
	<!DOCTYPE html>
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
			<link href="<c:url value="/styles/main.css" />" type="text/css" rel="stylesheet" />
			<title>新增产品</title>
		</head>
		<body>
			<div class="main">
				<h2 class="title">
					<span>新增产品</span>
				</h2>
				<form:form action="addGoodsSave" modelAttribute="product">
					<fieldset>
						<legend>产品</legend>
						<p>
							<label for="name">产品名称：</label>
							<form:input path="name" />
							<form:errors path="name" cssClass="error"></form:errors>
						</p>
						<p>
							<label for="title">产品类型：</label>
							<form:select path="productType.id">
								<form:option value="0">--请选择--</form:option>
								<form:options items="${productTypes}" itemLabel="name" itemValue="id" />
							</form:select>
							<form:errors path="productType.id" cssClass="error"></form:errors>
						</p>
						<p>
							<label for="price">产品价格：</label>
							<form:input path="price" />
							<form:errors path="price" cssClass="error"></form:errors>
						</p>
						<p>
							<input type="submit" value="保存" class="btn out">
						</p>
					</fieldset>
				</form:form>
				<p style="color: red">${message}</p>
				<p>
					<a href="<c:url value="/product3" />" class="abtn out">返回列表</a>
				</p>
			</div>
		</body>
	</html>

#### (5) 测试运行

访问路径：[http://localhost:8080/spring-mvc/product3/addGoodsSave](http://localhost:8080/spring-mvc/product3/addGoodsSave)，运行结果如图5所示：

<center>
<img src="SpringMVC-06/SpringMVC-06-05.png" width="80%"/>图 5
</center>

#### (6) 小结

从上面的示例可以看出这种验证更加方便直观，一次定义反复使用，验证在编辑、更新时同样可以使用；另外验证的具体信息可以存放在配置文件中，如message.properties，这样便于国际化与修改。

### 3. 使用jQuery扩展插件Validate实现前端校验

暂时没看