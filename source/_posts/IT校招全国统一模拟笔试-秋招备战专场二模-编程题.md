---
title: IT校招全国统一模拟笔试(秋招备战专场二模)编程题
thumbnail: 'https://wx2.sinaimg.cn/small/e3dde130ly1fft6ucav3vj20zk0iyq5v.jpg'
date: 2017-07-23 21:11:16
tags: 算法
categories: 动态规划
description:
---

<!--more-->

# 随机的机器人

有一条无限长的纸带,分割成一系列的格子,最开始所有格子初始是白色。现在在一个格子上放上一个萌萌的机器人(放上的这个格子也会被染红),机器人一旦走到某个格子上,就会把这个格子涂成红色。现在给出一个整数n,机器人现在会在纸带上走n步。每一步,机器人都会向左或者向右走一个格子,两种情况概率相等。机器人做出的所有随机选择都是独立的。现在需要计算出最后纸带上红色格子的期望值。
 
输入描述：输入包括一个整数n(0 ≤ n ≤ 500)，即机器人行走的步数。

输出描述：输出一个实数，表示红色格子的期望个数，保留一位小数。

示例1

输入: 4

输出: 3.4

	import java.text.DecimalFormat;
	import java.util.*;
	
	public class Main{
	    public static void main(String[] args){
	    	Scanner scanner=new Scanner(System.in);
	        int n=scanner.nextInt();
	        
	        double[][][] dp=new double[2][n+3][n+3];
	        dp[0][1][0]=1;
	        for(int i=1; i<=n; i++){
	        	int cur=i%2, prev=1-cur;
	        	
	        	for(int j=1; j<=i+1; j++){
	            	for(int k=0; k<j; k++){
	            		dp[cur][j][k]=0;
	            	}
	            }
	        	
	        	for(int j=1; j<=i; j++){
	        		for(int k=0; k<j; k++){
	        			//left
	        			if(k==0)
	        				dp[cur][j+1][k]+=dp[prev][j][k]/2;
	        			else
	        				dp[cur][j][k-1]+=dp[prev][j][k]/2;
	        			//right
	        			if(k==j-1)
	        				dp[cur][j+1][k+1]+=dp[prev][j][k]/2;
	        			else
	        				dp[cur][j][k+1]+=dp[prev][j][k]/2;
	        		}
	        	}
	        }
	        double ans=0;
	        for(int j=1; j<=n+1; j++){
	        	for(int k=0; k<j; k++){
	        		ans+=j*dp[n%2][j][k];
	        	}
	        }
	        DecimalFormat df=new DecimalFormat("0.0");
	        System.out.println(df.format(ans));
	    }
	}
