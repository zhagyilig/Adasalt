## saltstack 入门
### 了解saltstack
----
[**SALTSTACK官网link**](http://docs.saltstack.cn/)  
Salt 是：  
一个配置管理系统，能够维护预定义状态的远程节点(比如，确保指定的报被安装，指定的服务在运行)
一个分布式远程执行系统，用来在远程节点（可以是单个节点，也可以是任意规则挑选出来的节点）上执行命令和查询数据。

开发其的目的是为远程执行提供最好的解决方案，并使远程执行变得更好，更快，更简单  
既要考虑大规模部署，又要考虑小规模系统，提供适应多种场合的应用让人沮丧，但Salt非常容易设置和维护，而不用考虑项目的大小。从数量可观的本地网络系统，到跨数据中心的互联网部署，Salt设计为在任意数量的server下都可工作。salt的拓扑使用简单的server/client模式，需求的功能内建在一组daemon中。salt在几乎不改动配置的情况下就可以工作，也可以调整从而满足特定的需求。

**并行执行**  
Salt的核心功能：    

- 使命令发送到远程系统是并行的而不是串行的  
- 使用安全加密的协议  
- 使用最小最快的网络载荷  
- 提供简单的编程接口  
- Salt同样引入了更加细致化的领域控制系统来远程执行，使得系统成为目标不止可以通过主机名，还可以通过系统属性。  

**BUILDS ON PROVEN TECHNOLOGY**   
Salt运用大量的技术和技巧。网络层使用卓越的`ZeroMQ`_ 网络类库构建，所以Salt的守护端包含了可行的和透明的AMQ代理。Salt使用公钥和master守护端认证，然后使用更快的AES`_ 负载通信加密; 身份认证和加密对salt是不可或缺的。Salt通过`msgpack`_建立通信，使得速度更快并且网络流量少。  

**PYTHON客户端接口**   
为了允许简单的扩展，Salt执行程序可以写为纯Python模块。数据从Salt执行过程中收集到可以发送回master服务端，或者发送到任何任意程序。Salt可以从一个简单的Python API调用，或者从命令行被调用，所以Salt可以用来执行一次性命令，也可以作为一个更大的应用程序的一个组成部分。  

**快速，灵活，易扩展**  
结果是能够在1台或多台目标机器上快速执行命令的系统。Salt运行快速，安装简单，高度可定制；Salt用相同的远程执行架构满足管理不同数量服务器的需求。Salt基础设施可以集成最好的远程执行工具，增强了Salt的能力及用途，得到功能丰富实用可以适用于任何网络的系统。  
开放下开发，可以被用来开发开放和私有项目。请将你的扩展提交回Salt项目使我们可以共同让Salt茁壮成长。请随意播撒Salt在你的系统上，享受美味芬芳。  

### 部署saltstack
----  
[**官网部署链接**](http://docs.saltstack.cn/topics/installation/rhel.html)  

	To install using the SaltStack repository:
	Run one of the following commands based on your version to import the SaltStack repository key:

	#Version 7:
	rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub

	#Version 6:
	rpm --import https://repo.saltstack.com/yum/redhat/6/x86_64/latest/SALTSTACK-GPG-KEY.pub
	
	#Version 5:
	wget https://repo.saltstack.com/yum/redhat/5/x86_64/latest/SALTSTACK-EL5-GPG-KEY.pub
	rpm --import SALTSTACK-EL5-GPG-KEY.pub
	rm -f SALTSTACK-EL5-GPG-KEY.pub
	
	Save the following file to /etc/yum.repos.d/saltstack.repo:
	vim /etc/yum.repos.d/saltstack.repo
	
	#Version 7 and 6:
	[saltstack-repo]
	name=SaltStack repo for RHEL/CentOS $releasever
	baseurl=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
	enabled=1
	gpgcheck=1
	gpgkey=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
	
	#Version 5:
	[saltstack-repo]
	name=SaltStack repo for RHEL/CentOS $releasever
	baseurl=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
	enabled=1
	gpgcheck=1
	gpgkey=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-EL5-GPG-KEY.pub
	
	Run sudo yum clean expire-cache
	
	Run sudo yum update   
	
	Install the salt-minion, salt-master, or other Salt components:
	
	yum install -y salt-master
	yum install -y salt-minion
	yum install -y salt-ssh
	yum install -y salt-syndic
	yum install -y salt-cloud

	注解:
	As of 2015.8.0, EPEL repository is no longer required for installing on RHEL systems. SaltStack repository provides all needed dependencies.  

### 重点
---
**四种运行方式：**    

- Local   //本地模式  
- Minion/Master    //C/S架构（客户端/服务器 ）  
- Syndic -Zabbix proxy    //代理模式  
- Salt     //SSHSSH模式    

**远程执行：**   
[**官网链接**](https://docs.saltstack.com/en/latest/topics/tutorials/modules.html)  

- 目标（Targeting）
- 模块（Module）
- 返回(Returnners)

**数据系统：**   

- grains    //minion端定义
- pillar    //master端定义

**配置管理：**    

- sls(yaml、jinja)   //规则：缩进 冒号 段横杆
- highstate          // - template: jinja 
- states module

### 实战-salt部署tomcat：  
准备安装包：jdk-8u112-linux-x64.tar.gz  apache-tomcat-7.0.64-1.tar.gz
			
	[root@zabbix-server state]# cat /etc/salt/master.d/file_roots.conf 
	file_roots:
	  base:
	    - /etc/salt/state
	    ......
	     
	[root@zabbix-server state]# tree  /etc/salt/state/
	/etc/salt/state/
	├── jdk
	│   ├── files
	│   │   └── jdk-8u112-linux-x64.tar.gz
	│   └── install.sls
	├── tomcat
	│   ├── files
	│   │   └── apache-tomcat-7.0.64-1.tar.gz
	│   └── install.sls
	└── top.sls
	 
	[root@zabbix-server jdk]# cat  install.sls 
	jdk-install:
	  file.managed:
	    - name: /usr/local/src/jdk-8u112-linux-x64.tar.gz
	    - source: salt://jdk/files/jdk-8u112-linux-x64.tar.gz
	    - user: root
	    - group: root
	    - mode: 755
	  cmd.run:
	    - name: cd /usr/local/src && tar xf jdk-8u112-linux-x64.tar.gz && mv jdk1.8.0_112 /usr/local/jdk && chown -R root:root /usr/local/jdk
	    - unless: test -d /usr/local/jdk
	    - require:
	      - file: jdk-install
	 
	jdk-config:
	  file.append:
	    - name: /etc/profile
	    - text:
	      - export JAVA_HOME=/usr/local/jdk
	      - export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
	      - export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
	       
	[root@zabbix-server tomcat]# cat install.sls 
	include:
	  - jdk.install
	 
	tomcat-install:
	  file.managed:
	    - name: /usr/local/src/apache-tomcat-7.0.64-1.tar.gz
	    - source: salt://tomcat/files/apache-tomcat-7.0.64-1.tar.gz
	    - user: root
	    - group: root
	    - mode: 755
	  cmd.run:
	    - name: cd /usr/local/src &&  tar xf apache-tomcat-7.0.64-1.tar.gz &&　mv apache-tomcat-7.0.64-1 /usr/local/tomcat && chown -R root:root /usr/local/tomcat
	    - unless: test -d /usr/local/tomcat
	    - require:
	      - file: tomcat-install
	 
	tomcat-config:
	  file.managed:
	    - name: /etc/profile
	    - text: 
	      - export: TOMCAT_HOME=/usr/local/tomcat
	  
	[root@zabbix-server state]# cat  top.sls 
	base:
	  '(jenkins|gitlab).saltstack.me':
	    - match: pcre
	    - tomcat.install
		
	执行部署命令： 
	[root@zabbix-server state]# salt -E '(jenkins|gitlab).saltstack.me' state.highstate 
	
	[root@zabbix-server state]# salt -E '(jenkins|gitlab).saltstack.me' saltutil.running   


### 遇见的问题：
	minion启动报错：
	5] The Salt Master has rejected this minion's public key!To repair this issue, delete the public key for this minion on the Salt Master and restart this minion.Or restart the Salt Master in open mode to clean out the keys. The Salt Minion will now exit.
	解决方法：
	在启动salt minion的时候saltstack报错：The Salt Master has rejected this minion's public key!
	这个问题是由于salt minion的id有问题导致的，解决此问题的方法是首先到master上删除saltstack的minion缓存，文件目录位置在： /etc/salt/pki/master/minions。
	然后到salt minion的服务器上，修改minion的配置文件将id设置为正确的值。 
