帮助说明
〓第一步〓
将模板源码上传到你的网站空间。

〓第二步〓
网站源码初次上传到空间，首页是打不开的！
首先登陆网站后台，登陆路径是【你的域名/Admin/login.asp】，打开登陆界面，
输入用户名【admin】，密码【admin888】，验证密码【8888】，进入管理后台。
使用后台首页的快捷入口，修改网站基本信息。

■■■■■■■■■■
■■后台使用要点■■
■■■■■■■■■■

〓如何更改栏目页图片〓
每个栏目页顶端都会有栏目展示图片，怎么更改呢？步骤：
《内容》选项卡下，点开左侧《栏目管理》，点击右边《栏目中心》四个字展开网站的各栏目，
点击需要更改图片栏目后面的《编辑栏目》，打开栏目管理界面，默认显示《基本信息选项卡》，
点击《栏目选项》，看到第一行《栏目图片地址》，更改即可。

〓如何给栏目添加子栏目〓
《内容》选项卡下，点开左侧《栏目管理》，点击右边《栏目中心》四个字展开网站的各栏目，
点击需要添加子栏目的栏目的后面的《添加子栏目》，打开栏目添加界面，添加即可。
【添加之后，下面是重点：】
给栏目添加完子栏目，打开前台原栏目，未能显示出子栏目列表，这时候需要修改原栏目的栏目模板，方法：
《内容》选项卡下，点开左侧《栏目管理》，点击右边《栏目中心》四个字展开网站的各栏目，
点击原栏目后面的《编辑栏目》，在《基本信息》的选项卡下找到《栏目模板》将其后面的内容：
“{@TemplateDir}/栏目中心/栏目页.html”更改为：“{@TemplateDir}/栏目中心/频道页.html”，
确定修改，打开前台原栏目，看到子栏目列表。

〓修改《联系我们》内容〓
《内容》选项卡下，点开左侧《栏目管理》，点击右边《栏目中心》四个字展开网站的各栏目，
点击《联系我们》栏目后面的《编辑栏目》，即可看到修改内容。


■■■■■■■■
■■冷门问题■■
■■■■■■■■

〓网站放入子目录〓
亲，网站放子目录要修改配置文档的路径：在源码最外面【conn.asp】文档里面
【/KS_Data/xunwang.mdb】改为【/目录名/KS_Data/xunwang.mdb】
【\KS_Data\Collect\KS_Collect.Mdb】改为【\目录名\KS_Data\Collect\KS_Collect.Mdb】，即可。
同时图片也无法正常显示，需要到相关栏目修改图片路径。

〓数据库出错怎么办〓
如下提示：
——————————
Microsoft JET Database Engine 错误 '80040e09'
不能更新。数据库或对象为只读。
/Admin/login.asp，行 54
——————————
方法：更改KS_Data 的权限，没有相关权限的与空间服务商联系更改。

〓为什么管理后台操作失灵〓
如果亲使用后台时出现：不能粘贴复制，不能上传图片等操作失灵问题，可能是你用了
一些安全性浏览器，比如360，猎豹，淘宝等等浏览器，请使用系统自动的ie浏览器操作。