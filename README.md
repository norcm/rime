## 自用Rime配置

> 源于[rime-ice](https://github.com/iDvel/rime-ice)，并配合万象模型。
>
> 万象模型下载: https://github.com/amzxyz/RIME-LMDG/releases

### 使用

> 首先clone仓库
>
> ```shell
> git clone https://github.com/norcm/rime.git
> ```

#### Mac

```shell
ln -sf /Users/cuixinpeng/Projects/me/rime/configuration ~/Library/Rime
```

#### Windows

直接在小狼毫的设置中设置配置地址为项目地址`C:\WorkSpace\Projects\rime\configuration`

#### Hamster

1. 复制configuration文件夹到Hamster APP的文件中

2. Hamster点击部署以同步用户词典

3. 复制Rime文件夹下的rime_ice.db到configuration文件

4. 删除原有Rime文件夹，重命名configuration为Rime

### 配置更新

> 东风破[plum](https://github.com/rime/plum)是Rime官方的一个配置管理工具。

1. clone东风破仓库

   ```shell
   git clone --depth=1 https://github.com/rime/plum
   ```
2. 设置 `PROJECT_DIR`

   `PROJECT_DIR` 的值需要能让脚本找到 `other/plum`。

3. macOS 执行 `update.sh`

   ```shell
   export PROJECT_DIR=/your/project/root
   bash update.sh
   ```

4. Windows PowerShell 执行 `update.ps1`

   需要额外设置 `WEASEL_DIR`，值为小狼毫安装目录，脚本会直接拼接 `WeaselDeployer.exe`。

   ```powershell
   $env:PROJECT_DIR = 'D:\your\project\root'
   $env:WEASEL_DIR = 'C:\Program Files\Rime\weasel-0.17.4'
   .\update.ps1
   ```
