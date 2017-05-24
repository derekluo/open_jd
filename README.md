OpenJd
==========

京东开放平台 JOS Ruby SDK

    gem 'open_jd', github: 'derekluo/open_jd'

如果使用 [patron][] 代替 Net::HTTP, 请在 Gemfile 中添加下列代码

    gem 'patron'

执行 bundle 安装:

    $ bundle

## 使用

### Rails 使用 yaml 配置文件

运行 generator 创建配置文件:

    $ rails g open_jd:install
    
上述命令会在 config 目录创建 jd.yml 配置文件

打开这个文件并填写您在京东开放平台的相关信息

注意: `app_key`, `secret_key`, `access_token` 为必填项

使用 `OpenJd.get` 或 `OpenJd.post`：
    
    hash = OpenJd.post(
      method: 'jingdong.sku.read.findSkuById',
      fields: { skuId: params[:id] }
    )


返回值为 Hash 格式.

另外也可以使用 `OpenJd.get!` 和 `OpenJd.post!` 在发生错误时会抛出 `OpenJd::Error`.

### 在 Ruby 代码中使用

    OpenJd.config = {
      'app_key'       => 'test',
      'secret_key'    => 'test',
      'access_token'  => 'test'
    }

    OpenJd.initialize_session

    hash = OpenJd.get(
      method: 'jingdong.sku.read.findSkuById',
      fields: { skuId: params[:id] }
    )

### 查看请求字符串

如果需要查看发出的请求字符串, 请使用 OpenJd.url 方法

    OpenJd.url(
      method: 'jingdong.sku.read.findSkuById',
      fields: { skuId: params[:id] }
    )

[patron]: https://github.com/toland/patron
[open_taobao]: https://github.com/wongyouth/open_taobao
