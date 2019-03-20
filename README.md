# dwz
基于OR实现的短网址项目

# 依赖
本项目基于Openresty lor框架+MySQL开发实现

1、安装Openresty和lor框架，安装参考官方文档：
<<<<<<< HEAD
>Openresty：https://openresty.org/en/installation.html
>lor：http://lor.sumory.com/docs/installation-cn
=======
>Openresty：https://openresty.org/en/installation.html  
>lor：http://lor.sumory.com/docs/installation-cn  
>>>>>>> c7b7793c8d025b861d921f92a21d93ffa3069b41

2、安装MySQL，导入dwz.sql

# 运行
<<<<<<< HEAD
$ git clone https://github.com/emolwy/dwz.git
配置 config.lua
=======
$ git clone https://github.com/emolwy/dwz.git  
配置 config.lua  
>>>>>>> c7b7793c8d025b861d921f92a21d93ffa3069b41
$ vi dwz/app/config/config.lua

```
return {
	-- mysql配置
	mysql = {
		timeout = 5000,
		connect_config = {
<<<<<<< HEAD
			host = "127.0.0.1",
=======
		host = "127.0.0.1",
>>>>>>> c7b7793c8d025b861d921f92a21d93ffa3069b41
	        port = 3306,
	        database = "dwz",
	        user = "root",
	        password = "A123456",
	        max_packet_size = 1024 * 1024
		},
		pool_config = {
			max_idle_timeout = 20000, -- 20s
<<<<<<< HEAD
        	pool_size = 50 -- connection pool size
=======
        		pool_size = 50 -- connection pool size
>>>>>>> c7b7793c8d025b861d921f92a21d93ffa3069b41
		}
	}
}
```

$ cd dwz/  

$ ./start.sh

<<<<<<< HEAD
访问http://yourip:8888/
=======
访问http://yourip:8888/
>>>>>>> c7b7793c8d025b861d921f92a21d93ffa3069b41
