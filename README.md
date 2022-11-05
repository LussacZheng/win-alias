# win-alias

Useful aliases and utilities for Windows CMD.  
适用于 Windows CMD 的实用别名和命令。

## 安装

1. 使用 [Git](https://git-scm.com/) 克隆此项目：

   ```batch
   git clone https://github.com/LussacZheng/win-alias.git
   ```

   或直接下载 [代码文件](https://github.com/LussacZheng/win-alias/archive/master.zip) 并解压。

2. 在环境变量中新建条目 `WIN_ALIAS` ，并将 `alias` , `git-alias` 文件夹的绝对路径加入此环境变量。
3. 在环境变量 `Path` 中添加 `%WIN_ALIAS%` 。

## 使用说明

### [`alias`](alias/alias.cmd)

> - 参数：不接受参数

列出当前可用别名。

### [`hash`](alias/hash.cmd)

> - 参数：`hash [HashAlgorithm] <file>`
> - 帮助：`hash help`

输出目标文件的哈希值，并将其哈希值写入剪贴板。

### [`hosts`](alias/hosts.cmd)

> - 参数：`hosts [any]`

使用记事本打开 hosts 文件以供编辑。

如果附带任意参数，编辑完成后将刷新 DNS 解析缓存。

### [`npmls`](alias/npmls.cmd)

> - 参数：不接受参数
> - 别名：`npm ls -g -depth=0`

列出所有已经全局安装的 npm 包。  

### [`open`](alias/open.cmd)

> - 参数：不接受参数
> - 别名：`explorer .\`

使用文件资源管理器打开当前工作目录。

### [`port`](alias/port.cmd)

> - 参数：`port <PortNumber>`

查找当前哪个进程占用了目标端口。

主要用于获取 PID 号以在任务管理器结束进程。

### [`proxy`](alias/proxy.cmd)

> - 参数：`proxy [command]`
> - 帮助：`proxy help`
> - 配置：`alias/proxy.conf`

快速为当前 CMD 窗口启用/禁用代理。

代理地址与端口需在同一目录下的 `proxy.conf` 中配置，`proxy` 将据此设置 `HTTP(S)_PROXY` 的值 。

- [`pg`](alias/pg.cmd)

  > - 参数：`pg *`  ( `*` 表示 `wget` 本身可以接收的参数)
  > - 别名：`proxy on & wget *`

  使 wget 通过代理下载文件。

  近似等效于 `wget -e use_proxy=yes -e https_proxy=http://127.0.0.1:1080 *` 。

- [`ptest`](alias/ptest.cmd)

  > - 参数：`ptest [any]`

  通过下载一个 10 MiB 的文件，来测试当前代理的下载速度。

  如果附带任意参数，还将下载一个 100 MiB 的文件。

## 注意事项

- 原则上，一个文件对应一个命令，且修改文件名不应影响命令的使用。即用户可以自定义命令名。  
  但二级命令依赖于其基础命令，相关文件内容需要同步修改。
- 如果命令需要配置文件，配置文件应与命令同名。

## License

This project is licensed under the [MIT License](./LICENSE).
