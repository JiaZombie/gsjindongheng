﻿<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="../../../Conn.asp"-->
<!--#include file="../../../KS_Cls/Kesion.CommonCls.asp"-->
<!--#include file="../Session.asp"-->
<!--#include file="LabelFunction.asp"-->
<%

Dim KSCls
Set KSCls = New GetGenericList
KSCls.Kesion()
Set KSCls = Nothing

Class GetGenericList
        Private KS
		Private Sub Class_Initialize()
		  Set KS=New PublicCls
		End Sub
        Private Sub Class_Terminate()
		 Call CloseConn()
		 Set KS=Nothing
		End Sub
		Public Sub Kesion()
		Dim TempClassList, InstallDir, CurrPath, FolderID, LabelContent, L_C_A, Action, LabelID, Str, Descript, LabelFlag
		Dim ChannelID,ClassID, IncludeSubClass, ShowClassName, OpenType, DocProperty, Num, RowHeight, TitleLen, OrderStr, ColNumber, ShowPicFlag, NavType, Navi, MoreLinkType, MoreLink, SplitPic, DateRule, DateAlign, TitleCss, DateCss,SpecialID,ShowNewFlag,ShowHotFlag, PrintType,AjaxOut,LabelStyle,IntroLen,ispic,attr
		Dim PicWidth,PicHeight,PicStyle,PicBorderColor,PicSpacing,CallBySpace
		Dim ButtonType,PriceType,SQLParam
		Dim TypeID,ShowGQType,Province,City
		FolderID = Request("FolderID")
		CurrPath = KS.GetCommonUpFilesDir()
		ChannelID=KS.ChkCLng(Request("ChannelID"))
		
		With KS
		'判断是否编辑
		LabelID = Trim(Request.QueryString("LabelID"))
		If LabelID = "" Then
		  ClassID = "0":DateRule="YYYY-MM-DD"
		  Action = "Add"
		Else
		  Action = "Edit"
		  Dim LabelRS, LabelName
		  Set LabelRS = Server.CreateObject("Adodb.Recordset")
		  LabelRS.Open "Select top 1 * From KS_Label Where ID='" & LabelID & "'", Conn, 1, 1
		  If LabelRS.EOF And LabelRS.BOF Then
			 LabelRS.Close
			 Set LabelRS = Nothing
			 .echo ("<Script>alert('参数传递出错!');history.back();</Script>")
			 Exit Sub
		  End If
			LabelName = Replace(Replace(LabelRS("LabelName"), "{LB_", ""), "}", "")
			FolderID = LabelRS("FolderID")
			LabelContent = LabelRS("LabelContent")
			LabelFlag = LabelRS("LabelFlag")
			LabelRS.Close:Set LabelRS = Nothing
			LabelStyle         = KS.GetTagLoop(LabelContent)
			LabelContent       = Replace(Replace(LabelContent, "{Tag:GetGenericList", ""),"}" & LabelStyle&"{/Tag}", "")
            'response.write LabelContent
			Dim XMLDoc,Node
			Set XMLDoc=KS.InitialObject("msxml2.FreeThreadedDOMDocument"& MsxmlVersion)
			If XMLDoc.loadxml("<label><param " & LabelContent & " /></label>") Then
			  Set Node=XMLDoc.DocumentElement.SelectSingleNode("param")
			Else
			 .echo ("<Script>alert('标签加载出错!');history.back();</Script>")
			 Exit Sub
			End If
			If  Not Node Is Nothing Then
			  ChannelID          = Node.getAttribute("modelid")
			  ClassID            = Node.getAttribute("classid")
			  IncludeSubClass    = Node.getAttribute("includesubclass")
			  showclassname      = Node.getAttribute("showclassname")
			  DocProperty        = Node.getAttribute("docproperty")
			  Attr               = Node.getAttribute("attr")
			  OpenType           = Node.getAttribute("opentype")
			  Num                = Node.getAttribute("num")
			  RowHeight          = Node.getAttribute("rowheight")
			  TitleLen           = Node.getAttribute("titlelen")
			  IntroLen           = Node.getAttribute("introlen")
			  OrderStr           = Node.getAttribute("orderstr")
			  ColNumber          = Node.getAttribute("col")
			  ShowPicFlag        = Node.getAttribute("showpicflag")
			  NavType            = Node.getAttribute("navtype")
			  Navi               = Node.getAttribute("nav")
			  MoreLinkType       = Node.getAttribute("morelinktype")
			  MoreLink           = Node.getAttribute("morelink")
			  SplitPic           = Node.getAttribute("splitpic")
			  DateRule           = Node.getAttribute("daterule")
			  DateAlign          = Node.getAttribute("datealign")
			  TitleCss           = Node.getAttribute("titlecss")
			  DateCss            = Node.getAttribute("datecss")
			  SpecialID          = Node.getAttribute("specialid")
			  ShowNewFlag        = Node.getAttribute("shownewflag")
			  ShowHotFlag        = Node.getAttribute("showhotflag")
			  PrintType          = Node.getAttribute("printtype")
			  AjaxOut            = Node.getAttribute("ajaxout")
			  
			  PicWidth           = Node.getAttribute("picwidth")
			  PicHeight          = Node.getAttribute("picheight")
			  PicStyle           = Node.getAttribute("picstyle")
			  PicBorderColor     = Node.getAttribute("picbordercolor")
			  PicSpacing         = Node.getAttribute("picspacing")
			  
			  ButtonType         = Node.getAttribute("buttontype")
			  PriceType          = Node.getAttribute("pricetype")
			  
			  TypeID             = Node.getAttribute("typeid")
			  ShowGQType         = Node.getAttribute("showgqtype")
			  CallBySpace        = Node.getAttribute("callbyspace")
			  Province           = Node.getAttribute("province")
			  City               = Node.getAttribute("city")
			  ispic              = Node.getAttribute("ispic")
              SQLParam           = Node.getAttribute("sqlparam")
			End If
            
			Set Node=Nothing
			Set XMLDoc=Nothing
		End If
		If PrintType="" Then PrintType=1
		If Num = "" Then Num = 10
		DocProperty = DocProperty & "00000000"
		If RowHeight = "" Then RowHeight = 20
		If TitleLen = "" Then TitleLen = 30
		If IntroLen = "" Then IntroLen = 50
		If ColNumber = "" Then ColNumber = 1
		If SpecialID=""  Then SpecialID=0
		If KS.IsNUL(ShowNewFlag) Then ShowNewFlag=False
		If KS.IsNUL(ShowHotFlag) Then ShowHotFlag=False
		If KS.IsNUL(CallBySpace) Then CallBySpace=False
		If KS.IsNul(ispic)       Then ispic=False
		If PicWidth="" Then PicWidth=130
		If PicHeight="" Then PicHeight=90
		If PicStyle="" Then PicStyle=1
		If PicSpacing="" Then PicSpacing=2
		If ButtonType="" Then ButtonType=4
		If PriceType="" Then PriceType=0
		If TypeID="" Then TypeID=0
		If KS.IsNUL(ShowGQType) Then ShowGQType=true
		If KS.IsNUL(AjaxOut) Then AjaxOut=false
		If LabelStyle="" Then LabelStyle="[loop={@num}] " & vbcrlf & "<li><a href=""{@linkurl}"" target=""_blank"">{@title}</a></li>" & vbcrlf & "[/loop]"
        .echo "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Strict//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"">"
		.echo "<html xmlns=""http://www.w3.org/1999/xhtml"">"
		.echo "<head>"
		.echo "<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"
		.echo "<link href=""../admin_style.css"" rel=""stylesheet"">"
		.echo "<script src=""../../../ks_inc/Common.js"" language=""JavaScript""></script>"
		.echo "<script src=""../../../ks_inc/Jquery.js"" language=""JavaScript""></script>"
		.echo "<script src=""../../../ks_inc/kesion.box.js"" language=""JavaScript""></script>"
		%>
		<style type="text/css">
		 .field{width:720px;}
		 .field li{cursor:pointer;float:left;border:1px solid #DEEFFA;background-color:#F7FBFE;height:18px;line-height:18px;margin:3px 1px 0px;padding:2px}
		 .field li.diyfield{border:1px solid #f9c943;background:#FFFFF6}
		</style>
		<script type="text/javascript">
		var TempFieldStr='';
		var TempDateStr='';
		var TempTitleCss='';
		var GenericPicStyleOption="<option value='1'>①:仅显示缩略图</option><option value='2'>②:缩略图+名称:上下</option><option value='3'>③:缩略图+(名称+简介:上下):左右</option><option value='4'>④:(名称+简介:上下)+缩略图:左右</option>";
						 
		$(document).ready(function(){
		  $("#ChannelID").change(function(){
		    $(parent.document).find('#ajaxmsg').toggle();
			
			$.get('../../../plus/ajaxs.asp',{action:'GetClassOption',channelid:$(this).val()},function(data){
			  $("#ClassList").empty();
			  $("#ClassList").append("<option value='-1' style='color:red'>-当前栏目(通用)-</option>").append("<option value='0'>-不指定栏目-</option>").append(unescape(data));
			  SetField($("#ChannelID").val());
			  SetPicStyle($("#ChannelID").val());
			  SetModelParam($("#ChannelID").val());
			  GetAttribute($("#ChannelID").val());
			  $(parent.document).find('#ajaxmsg').toggle();
			 });
		    });
		   
		  $("#MutileClass").click(function(){
		    if ($(this).attr("checked")==true){
		      $("#ClassList").attr("multiple","multiple");
		      $("#ClassList").attr("style","height:60px");
			  $("#MoreLinkArea").hide();
		    }else{
			   $("#ClassList").removeAttr("multiple");
			   $("#ClassList").removeAttr("style");
			   $("#MoreLinkArea").show();
			}
		  });
		  
		  SetPicStyle($("#ChannelID").val()); //填充样式选项
		  GetAttribute($("#ChannelID").val());
		  $("#PicStyle").change(function(){
		    $("#ViewStylePicArea").html('<img style="border:1px solid #ccc;margin:5px" src="../../Images/View/S'+$(this).val()+'.gif" height="100" width="180" border="0">');
			if ($(this).val()==1){
			 if ($("#ShowPicTitleCss").html()!=null)	TempTitleStr=$("#ShowPicTitleCss").html();
			 $("#ShowPicTitleCss").empty();
			}else{
			$("#ShowPicTitleCss").html(TempTitleStr);
			}
		  });
		  $("#ViewStylePicArea").html('<img style="border:1px outset #ccc;margin:5px" src="../../Images/View/S<%=PicStyle%>.gif" height="100" width="180" border="0">');
		  try{
		  $("#PicStyle>option[value=<%=PicStyle%>]").attr("selected",true);
		  }catch(e){
		  }
		  <%if Instr(ClassID,",")<>0 Then%>
		   var searchStr="<%=ClassID%>";
		   $("#MutileClass").attr("checked",true);
		   $("#ClassList").attr("multiple","multiple");
		   $("#ClassList").attr("style","height:60px");
		   setTimeout(function(){ 
		   $("#ClassList>option").each(function(){
		     if($(this).val()=='-1' || $(this).val()=='0')
			  $(this).attr("selected",false)
			 else if (searchStr.indexOf($(this).val())!=-1)
			 { 
			   $(this).attr("selected",true);
			 }
		   });},1);
		  <%end if
		  If LabelID <> "" Then
		   .echo "$('#ChannelID').attr('disabled',true);"
		  End If
		  %>
		  TempFieldStr=$("#ShowFieldArea").html();
		  TempDateStr=$("#ShowTableDate").html();
		  TempTitleStr=$("#ShowTitleCss").html();
		  ChangeOutArea($("#PrintType option:selected").val());
		  

		})
		function GetAttribute(channelid){
		    $.get('../../../plus/ajaxs.asp',{action:'GetModelAttr',attr:'<%=attr%>',channelid:channelid},function(data){
			  $("#showattr").html('').html(data)
			 });
		}
		
		function SetField(channelid){  
		   switch (parseInt(channelid)){
		   	case 1:
			 $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@fulltitles}')\" title=\"完整标题\">完整标题</li>");
			 break;
		    case 3:
		     $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@rank}')\" title=\"推荐星级\">星级</li><li onclick=\"InsertLabel('{@downsize}')\" title=\"软件大小\">软件大小</li>");
			 break;
		    case 4:
		     $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@author}')\" title=\"作者\">作者</li><li onclick=\"InsertLabel('{@rank}')\" title=\"等级\">等级</li>");
			 break;
		    case 5:
		     $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@bigphoto}')\" title=\"商品大图\">商品大图</li><li onclick=\"InsertLabel('{@price_market}')\" title=\"市场价格\">市 场 价</li><li onclick=\"InsertLabel('{@price_member}')\" title=\"商 城 价\">商 城 价</li><li onclick=\"InsertLabel('{@price_vip}')\" title=\"VIP价格\">VIP 价格</li><li onclick=\"InsertLabel('{@limitbuyprice}')\" title=\"抢购商品有效,SQL条件里建议加 i.islimitbuy=1\">抢购价</li><li onclick=\"InsertLabel('{@score_vip}')\" title=\"赠送积分\">赠送积分</li><li title=\"品牌ID\" onclick=\"InsertLabel('{@brandid}')\">品牌ID号</li><li title=\"品牌名称\" onclick=\"InsertLabel('{@brandname}')\">品牌名称</li><li title=\"品牌英文名\" onclick=\"InsertLabel('{@brandename}')\">品牌英文名</li><br/><li title=\"商品型号\" onclick=\"InsertLabel('{@promodel}')\">商品型号</li><li title=\"商品编号\" onclick=\"InsertLabel('{@proid}')\">商品编号</li><li title=\"商品单位\" onclick=\"InsertLabel('{@unit}')\">商品单位</li>");
			 break;
		    case 7:
		     $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@movieact}')\" title=\"主要演员\">主要演员</li><li onclick=\"InsertLabel('{@moviedy}')\" title=\"影片导演\">影片导演</li><li title=\"播放时间\" onclick=\"InsertLabel('{@movietime}')\">播放时间</li><li title=\"影片语言\" onclick=\"InsertLabel('{@movieyy}')\">影片语言</li><li title=\"出产地区\" onclick=\"InsertLabel('{@moviedq}')\">出产地区</li><li title=\"所需点数\" onclick=\"InsertLabel('{@readpoint}')\">所需点数</li><li title=\"推荐级别\" onclick=\"InsertLabel('{@rank}')\">推荐级别</li>");
		     break;
		    case 8:
		     $("#ShowFieldArea").html(TempFieldStr+"<li onclick=\"InsertLabel('{@validdate}')\" title=\"有效期\">有 效 期</li><li onclick=\"InsertLabel('{@typeid}')\" title=\"交易类别名称\">交易类别名称</li><li onclick=\"InsertLabel('{@gqtypeid}')\" title=\"交易类别ID\">交易类别ID</li><li onclick=\"InsertLabel('{@price}')\" title=\"交易价格\">交易价格</li><li title=\"联系人\" onclick=\"InsertLabel('{@contactman}')\">联 系 人</li><li title=\"公司名称\" onclick=\"InsertLabel('{@companyname}')\">公司名称</li><li title=\"所在省份\" onclick=\"InsertLabel('{@province}')\">所在省份</li><li title=\"所在城市\" onclick=\"InsertLabel('{@city}')\">所在城市</li><li title=\"详细地址\" onclick=\"InsertLabel('{@address}')\">详细地址<li title=\"联系电话\" onclick=\"InsertLabel('{@tel}')\">联系电话</li></li>");
		     break;
			
		   default:
		     $("#ShowFieldArea").html(TempFieldStr);
		   }
		   
		   if ($("#PrintType").val()==4){
		      $(parent.document).find('#ajaxmsg').toggle();
		  	  $.get('../../../plus/ajaxs.asp',{action:'GetFieldOption',channelid:channelid},function(data){
			  $("#ShowFieldArea").html($("#ShowFieldArea").html()+data)
			  $(parent.document).find('#ajaxmsg').toggle();
			 });

		 }
		}
		
		function SetPicStyle(channelid)
		{ 
		   switch (parseInt(channelid))
		   { case 0:
		     case 1:
			 case 2:
			 case 3:
			   $("#PicStyle").empty().append(GenericPicStyleOption);
			  break;
			 case 4:
			   $("#PicStyle").empty().append(GenericPicStyleOption).append("<option value='5'>⑤:缩略图+(名称+类别+作者+时间:上下):左右</option>").append("<option value='6'>⑥:缩略图+(名称+介绍:上下+人气等):左右</option>");
			   break;
			 case 5:
			   $("#PicStyle").empty().append(GenericPicStyleOption).append("<option value='7'>⑤:缩略图+按钮</option>").append("<option value='8'>⑥:缩略图+名称+按钮:上下</option>").append("<option value='9'>⑦:缩略图+名称+价格+按钮:上下</option>").append("<option value='10'>⑧:缩略图+(价格+按钮:上下):左右</option>").append("<option value='11'>⑨:(缩略图+名称)+(价格+按钮):左右</option>").append("<option value='12'>⑩:缩略图+(名称+价格+按钮):左右</option>");
			   break;
			 case 7:
			   $("#PicStyle").empty().append(GenericPicStyleOption).append("<option value='13'>⑤:缩略图+(名称+主演+简介+按钮):左右</option>").append("<option value='14'>⑥:缩略图+(名称+简介+属性):左右</option>").append("<option value='15'>⑦:缩略图+(名称+主演+导演+简介+按钮):左右</option>");
			   break;
			 case 8:
			   $("#PicStyle").empty().append(GenericPicStyleOption).append("<option value='16'>⑤:缩略图+[(标题+地区+时间)+简介]:左右</option>").append("<option value='17'>⑥:缩略图+(名称+简介+属性):左右</option>");
			   break;
			 default:
			  break;
		   }
		}
		function ProductStyle(){
		 return "<tr class='tdbg'><td colspan='2'>按钮样式 <select style='width:160px' name='ButtonType' id='ButtonType'><option value='0'>不显示</option><option value='1'>显示购买按钮</option><option value='2'>显示收藏按钮</option><option value='3'>显示详情按钮</option><option value='4' selected>显示购买+收藏按钮</option><option value='5'>显示购买+详情按钮</option><option value='6'>显示收藏+详情按钮</option><option value='7'>显示购买+详情+收藏按钮</option></select> 价格样式 <select style='width:160px' class='textbox' name='PriceType' id='PriceType'><option value='0' selected>自动显示</option><option value='1'>只显示商城价</option><option value='2'>只显示参考价</option><option value='3'>只显示VIP价</option><option value='4'>参考价+商城价</option><option value='5'>参考价+商城价+VIP价</option><option value='6'>参考价+VIP价</option><option value='7'>商城价+VIP价</option></select></td></tr>";
		}
		function SetModelParam(channelid)
		{
		  if (parseInt(channelid)<=1) 
		    $("#twbz").show() 
		  else $("#twbz").hide();
		  
		  $.get('../../../plus/ajaxs.asp',{action:'getModelType',channelid:channelid},function(basictype){
		     if (basictype==1 || basictype==8){
			   $("#ModelParamArea1").show();
			 }else{
			   $("#ModelParamArea1").hide();
			 }
		  });
		  if (parseInt(channelid)==5){
		   if (parseInt($("#PrintType").val())==2) {
		    $("#ModelParamArea").show().empty().append(ProductStyle());
			}else{
		    $("#ModelParamArea").hide().empty().append(ProductStyle());
		    }
		   $("#ButtonType>option[value=<%=ButtonType%>]").attr("selected",true);
		   $("#PriceType>option[value=<%=PriceType%>]").attr("selected",true);
		  }
		 else if(parseInt(channelid)==8){
		  $("#ModelParamArea").show().empty().append("<tr class='tdbg'><td colspan='2'>交易类型 <%= Replace(Replace(KS.ReturnGQType(TypeID,1),"""","\"""),vbcrlf,"\n")%>  <label><input type='checkbox' name='ShowGQType' id='ShowGQType'>显示交易类型</label></td></tr>");
		  $("#TypeID").css("width",120);
		  <%if ChannelID=8 Then%>
		  $("#TypeID>option[value=<%=ButtonType%>]").attr("selected",true);
		  <%if cbool(ShowGQType)=true then .echo "$('#ShowGQType').attr('checked',true);"%>
		  <%End If%>
		 }else{
		   $("#ModelParamArea").hide()
		  }
		}
		
		function InsertLabel(label)
		{
		  InsertValue(label);
		}
		var pos=null;
		 function setPos()
		 { if (document.all){
				$("#LabelStyle").focus();
				pos = document.selection.createRange();
			  }else{
				pos = document.getElementById("LabelStyle").selectionStart;
			  }
		 }
		 //插入
		function InsertValue(Val)
		{  if (pos==null) {alert('请先定位要插入的位置!');return false;}
			if (document.all){
				  pos.text=Val;
			}else{
				   var obj=$("#LabelStyle");
				   var lstr=obj.val().substring(0,pos);
				   var rstr=obj.val().substring(pos);
				   obj.val(lstr+Val+rstr);
			}
		 }
        function FieldInsertCode(fieldname,dbtype,dbname)
		{ 
		   if(pos==null) {alert('请先定位插入位置!');return false;}
		   var link="../FieldParam.asp?fieldname=" + fieldname + "&dbtype="+ dbtype + "&dbname=" + dbname+"&datasourcetype=0";
		  var p=new KesionPopup()
		  p.PopupImgDir="../../";
		  p.PopupCenterIframe('插入字段标签',link,350,230,'no');
		}
		
		function ChangeOutArea(Val)
		{
		 SetModelParam($("#ChannelID").val());
		 switch (parseInt(Val)){
		  case 2:
		   $("#DiyArea").hide();
		   $("#TableArea").hide();
		   $("#PicArea").show();
		   $("#ShowIntroArea").show();
   		   
		     $("#ShowPicTitleCss").html(TempTitleStr);
		     $("#ShowTitleCss").empty();
		   $("#ViewStylePicArea").html('<img style="border:1px outset #ccc;margin:5px" src="../../Images/View/S'+$("#PicStyle").val()+'.gif" height="100" width="180" border="0">');
		   break;
		  case 3:
		  case 4:
		  $("#DiyArea").show();
		  $("#TableArea").hide();
		  $("#PicArea").hide();
		  $("#ShowDiyDate").html(TempDateStr);
		  $("#ShowTableDate").html('')
		  $("#DateRule").attr("style","width:100px");
		  $("#ShowIntroArea").show();
		  break;
		  default :
		  $("#DiyArea").hide();
		  $("#PicArea").hide();
		  $("#TableArea").show();
		  $("#ShowTableDate").html(TempDateStr);
		  $("#ShowDiyDate").html('')
		  $("#DateRule").attr("style","width:168px");
		  $("#ShowIntroArea").hide();
		  $("#ShowTitleCss").html(TempTitleStr);
		  $("#ShowPicTitleCss").html('');
		  break;
		 }
		 SetField($("#ChannelID").val());
		 
		}
		function SetNavStatus()
		{
		  if ($("select[name=NavType]").val()==0)
		   {$("#NavWord").show();
			$("#NavPic").hide();
			}else{
		   $("#NavWord").hide();
		   $("#NavPic").show();}
		}
		function SetMoreLinkStatus()
		{
		  if ($("select[name=MoreLinkType]").val()==0){
		    $("#LinkWord").show();
			$("#LinkPic").hide();
			}else{
		   $("#LinkWord").hide();
		   $("#LinkPic").show();}
		}
		function SetLabelFlag(Obj){
		 if (Obj.value=='-1')
		  $("#LabelFlag").val(1);
		  else
		  $("#LabelFlag").val(0);
		}
		function SpecialChange(SpecialID){
			if (SpecialID==-1) 
			  $("#ClassArea").hide();
			else
			  $("#ClassArea").show();	
		}
		function CheckForm(){
		    if ($("input[name=LabelName]").val()==''){
			  alert('请输入标签名称');
			  $("input[name=LabelName]").focus(); 
			  return false
			  }
			var ChannelID=$("#ChannelID").val();
			var ClassList='';
		    if ($("#MutileClass").attr("checked")==true){
				$("#ClassList option:selected").each(function(){
					if ($(this).val()!='0' && $(this).val()!='-1')
						if (ClassList=='') 
						 ClassList=$(this).val() 
						else
						 ClassList+=","+$(this).val();
					})
			 }else{
			    ClassList=$("#ClassList").val();
			 }
			 
			 var DocProperty='';
			 $("input[name=DocProperty]").each(function(){
			     if ($(this).attr("checked")==true){
				  DocProperty=DocProperty+'1'
				 }else{
				  DocProperty=DocProperty+'0'
				 }      
			 })
			var province=$("#Province option:selected").val();
			var city=$("#City option:selected").val();
			var SpecialID=$("select[name=SpecialID]").val();
			if (SpecialID==-1) ClassList=0;
			var IncludeSubClass=false,NavType=1;
			var ShowClassName,ShowPicFlag,ShowNewFlag,ShowHotFlag;
			var OpenType=$("#OpenType").val();
			var Num= $("#Num").val();
			var RowHeight=$("input[name=RowHeight]").val();
			var TitleLen=$("input[name=TitleLen]").val();
			var IntroLen=$("input[name=IntroLen]").val();
			var OrderStr=$("#OrderStr").val();
			var ColNumber=$("input[name=ColNumber]").val();
			var Nav,NavType=$("select[name=NavType]").val();
			var MoreLink,MoreLinkType=$("select[name=MoreLinkType]").val();
			var SplitPic=$("input[name=SplitPic]").val();
			var DateRule= $("#DateRule").val();
			var DateAlign=$("select[name=DateAlign]").val();
			var TitleCss=$("input[name=TitleCss]").val();
			var DateCss=$("input[name=DateCss]").val();
			var PicWidth=$("input[name=PicWidth]").val();
			var PicHeight=$("input[name=PicHeight]").val();
			var PicStyle=$("#PicStyle").val();
			var PicBorderColor=$("input[name=PicBorderColor]").val();
			var PicSpacing=$("input[name=PicSpacing]").val();
			var PrintType=$("#PrintType").val();
			var SQLParam=$("#SQLParam").val().replace(/"/g,"'");
			var AjaxOut=false;
			if ($("#AjaxOut").attr("checked")==true){AjaxOut=true}
			var IncludeSubClass=false;
			if ($("#IncludeSubClass").attr("checked")==true) IncludeSubClass=true;
			var ShowClassName =false;
			if ($("#ShowClassName").attr("checked")==true) ShowClassName = true;
			var ShowPicFlag=false;
			if ($("#ShowPicFlag").attr("checked")==true)  ShowPicFlag= true;
			var ShowHotFlag=false;
			if ($("#ShowHotFlag").attr("checked")==true)  ShowHotFlag= true;
			var ShowNewFlag=false;
			if ($("#ShowNewFlag").attr("checked")==true)  ShowNewFlag= true;
			var CallBySpace=false;
			if ($("#CallBySpace").attr("checked")==true) CallBySpace=true;
			var ispic=false;
			if ($("#ispic").attr("checked")==true) ispic=true;
			   
			if  (Num=='')  Num=10;
			if (RowHeight=='') RowHeight=20
			if  (TitleLen=='') TitleLen=30;
			if  (ColNumber=='') ColNumber=1;
			if  (NavType==0) Nav=$("input[name=TxtNavi]").val();
			 else  Nav=$("input[name=NaviPic]").val();
			if  (MoreLinkType==0) MoreLink=$("input[name=MoreLinkWord]").val();
			else  MoreLink=$("input[name=MoreLinkPic]").val();
			
			var av='';
		   $("input[name=attr]").each(function(){
		     if ($(this).attr("checked")==true){
			   if (av==''){
			    av=$(this).val();
			   }else{
			    av+='|'+$(this).val();
			   }
			 }
		   });
			
			var tagVal='{Tag:GetGenericList labelid="0" printtype="'+PrintType+'" sqlparam="'+SQLParam+'" province="'+province+'" city="'+city+'" ajaxout="'+AjaxOut+'" modelid="'+ChannelID+'" ispic="'+ispic+'" classid="'+ClassList+'" specialid="'+SpecialID+'" callbyspace="'+CallBySpace+'" includesubclass="'+IncludeSubClass+'" attr="'+av+'" docproperty="'+DocProperty+'" orderstr="'+OrderStr+'" opentype="'+OpenType+'" num="'+Num+'" titlelen="'+TitleLen+'" introlen="'+IntroLen+'" rowheight="'+RowHeight+'" col="'+ColNumber+'" showclassname="'+ShowClassName+'" showpicflag="'+ShowPicFlag+'" shownewflag="'+ShowNewFlag+'" showhotflag="'+ShowHotFlag+'" navtype="'+NavType+'" nav="'+Nav+'" morelinktype="'+MoreLinkType+'" morelink="'+MoreLink+'" splitpic="'+SplitPic+'" daterule="'+DateRule+'" datealign="'+DateAlign+'" titlecss="'+TitleCss+'" datecss="'+DateCss+'" picwidth="'+PicWidth+'" picheight="'+PicHeight+'" picstyle="'+PicStyle+'" picbordercolor="'+PicBorderColor+'" picspacing="'+PicSpacing+'"';
			if (ChannelID==5){
			 var ButtonType=$("#ButtonType").val();
			 var PriceType =$("#PriceType").val();
			 tagVal += ' buttontype="'+ButtonType+'" pricetype="'+PriceType+'"';
			}else if(ChannelID==8){
			 var TypeID=$("#TypeID").val();
			 var ShowGQType=false;
			 if($("#ShowGQType").attr("checked")==true) ShowGQType=true;
			 tagVal += ' typeid="'+TypeID+'" showgqtype="'+ShowGQType+'"';
			}
			tagVal  +='}'+$("#LabelStyle").val()+'{/Tag}';
			
			$("input[name=LabelContent]").val(tagVal);
			
			$("#myform").submit();
		}
		</script>
		<%
		.echo "</head>"
		.echo "<body topmargin=""0"" leftmargin=""0"" onload=""SpecialChange(" & SpecialID &");"">"
		.echo "<div align=""center"">"
		.echo "<iframe src='about:blank' name='_hiddenframe' style='display:none' id='_hiddenframe' width='0' height='0'></iframe>"
		.echo "<form  method=""post"" id=""myform"" name=""myform"" action=""AddLabelSave.asp"" target='_hiddenframe'>"
		.echo " <input type=""hidden"" name=""LabelContent"">"
		.echo " <input type=""hidden"" name=""LabelFlag"" id=""LabelFlag"" value=""" & LabelFlag & """>"
		.echo " <input type=""hidden"" name=""Action"" value=""" & Action & """>"
		.echo " <input type=""hidden"" name=""LabelID"" value=""" & LabelID & """>"
		.echo " <input type=""hidden"" name=""FileUrl"" value=""GetGenericList.asp"">"
		.echo ReturnLabelInfo(LabelName, FolderID, Descript)
		.echo "          <table width=""98%"" style='margin-top:5px' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>"
		.echo "            <tr id=""ClassArea"" class=tdbg>"
		.echo "              <td width=""50%"" height=""24"" colspan=""2"">选择范围"
		.echo "                <select name=""ChannelID"" id=""ChannelID"">"
		.echo "                 <option value=""0"">-所有模型-</option>"
        .LoadChannelOption ChannelID
		.echo "                </select>"
		.echo "                <select class=""textbox"" style=""width:170px"" name=""ClassList"" id=""ClassList"" onChange=""SetLabelFlag(this)"">"
		.echo "                 <option selected value=""-1"" style=""color:red"">- 当前栏目(通用)-</option>"
						
						If ClassID = "0" Then
						   .echo ("<option  value=""0"" selected>- 不指定栏目 -</option>")
						Else
						  .echo ("<option  value=""0"">- 不指定栏目 -</option>")
					   End If
						  .echo Replace(KS.LoadClassOption(ChannelID,false),"value='" & ClassID & "'","value='" & ClassID &"' selected")
						  .echo "</select>"

						  
					If cbool(IncludeSubClass) = True Or LabelID = "" Then
					  Str = " Checked"
					Else
					  Str = ""
					End If
					  .echo "<input type='checkbox' name='MutileClass' id='MutileClass' value='1'>指定多栏目"
					  .echo ("<input name=""IncludeSubClass"" type=""checkbox"" id=""IncludeSubClass"" value=""true""" & Str & ">")
			
		.echo "                  调用子栏目"
		
		.echo "<strong><font color=blue><input type='checkbox' name='CallBySpace' onclick=""if (this.checked){alert('提示：勾选后该标签只能放在个人/企业空间模板');}"" id='CallBySpace' value='1'"
		If cbool(CallBySpace)=true Then .echo " checked"
		.echo ">用于在个人/企业空间模板调用</font></strong>"
		.echo "</div></td>"
		.echo "            </tr>"
		
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" colspan='2'>SQL 条件"
		.echo "                <input name=""SQLParam"" class=""textbox"" type=""text"" value=""" & SQLParam &""" id=""SQLParam"" style=""width:180px;"" > <font class='tips'>tips:可留空，也可以加sql查询条件，如 and i.inputer='admin' 表示只查询admin添加的文档</font></td>"
		.echo "            </tr>"
		
		.echo "           <tr class=tdbg>"
		.echo "              <td width=""50%"" height=""24"">所属专题"
		.echo "                <select class=""textbox"" onchange=""SpecialChange(this.value)"" style=""width:70%;"" name=""SpecialID"" id=""SpecialID"">"
		.echo "                <option selected value=""-1"" style=""color:red"">- 当前专题(专题页通用)-</option>"
						 If SpecialID = "0" Then
						   .echo ("<option  value=""0"" selected>- 不指定专题 -</option>")
						   Else
						  .echo ("<option  value=""0"">- 不指定专题 -</option>")
						  End If
		.echo KS.ReturnSpecial(SpecialID)
		.echo "</Select>"
		
		.echo "                　　</td>"
		.echo "              <td width=""50%"" height=""24"">属性控制"

		.echo "                <label><input name=""DocProperty"" type=""checkbox"" value=""1"""
		If mid(DocProperty,1,1) = 1 Then .echo (" Checked")
		.echo ">推荐</label>"
		.echo "<label><input name=""DocProperty"" type=""checkbox""  value=""2"""
		If mid(DocProperty,2,1) = 1 Then .echo (" Checked")
		  .echo ">滚动</label>"
		.echo "<label><input name=""DocProperty"" type=""checkbox"" value=""3"""
		If mid(DocProperty,3,1) = 1 Then .echo (" Checked")
		  .echo ">头条</label>"
		.echo "<label><input name=""DocProperty"" type=""checkbox"" value=""4"""
		If mid(DocProperty,4,1) = 1 Then .echo (" Checked")
		  .echo ">热门</label>"
		.echo "<label><input name=""DocProperty"" type=""checkbox"" value=""5"""
		If mid(DocProperty,5,1) = 1 Then .echo (" Checked")
		  .echo ">幻灯</label>"
		.echo "<label><input onclick=""if(this.checked)alert('温馨提示:标签只有指定到文章类模型此属性才有效')"" name=""DocProperty"" type=""checkbox"" value=""6"""
		If mid(DocProperty,6,1) = 1 Then .echo (" Checked")
		  .echo ">视频</label>"
		
		.echo "   <span id=""showattr"">333</span></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" width=""50%"">排序方法"
		.echo "                <select style=""width:70%;"" class='textbox' name=""OrderStr"" id=""OrderStr"">"
					If OrderStr = "ID Desc" Then
					.echo ("<option value='ID Desc' selected>文档ID(降序)</option>")
					Else
					.echo ("<option value='ID Desc'>文档ID(降序)</option>")
					End If
					If OrderStr = "ID Asc" Then
					.echo ("<option value='ID Asc' selected>文档ID(升序)</option>")
					Else
					.echo ("<option value='ID Asc'>文档ID(升序)</option>")
					End If
					If OrderStr = "Rnd" Then
					.echo ("<option value='Rnd' style='color:blue' selected>随机显示</option>")
					Else
					.echo ("<option value='Rnd' style='color:blue'>随机显示</option>")
					End If
					
					If OrderStr = "ModifyDate Asc" Then
					.echo ("<option value='ModifyDate Asc' selected>修改时间(升序)</option>")
					Else
					.echo ("<option value='ModifyDate Asc'>修改时间(升序)</option>")
					End If
					If OrderStr = "ModifyDate Desc" Then
					 .echo ("<option value='ModifyDate Desc' selected>修改时间(降序)</option>")
					Else
					 .echo ("<option value='ModifyDate Desc'>修改时间(降序)</option>")
					End If
					If OrderStr = "AddDate Asc" Then
					.echo ("<option value='AddDate Asc' selected>添加时间(升序)</option>")
					Else
					.echo ("<option value='AddDate Asc'>添加时间(升序)</option>")
					End If
					If OrderStr = "AddDate Desc" Then
					 .echo ("<option value='AddDate Desc' selected>添加时间(降序)</option>")
					Else
					 .echo ("<option value='AddDate Desc'>添加时间(降序)</option>")
					End If
					If OrderStr = "Hits Asc" Then
					 .echo ("<option value='Hits Asc' selected>点击数(升序)</option>")
					Else
					 .echo ("<option value='Hits Asc'>点击数(升序)</option>")
					End If
					If OrderStr = "Hits Desc" Then
					  .echo ("<option value='Hits Desc' selected>点击数(降序)</option>")
					Else
					  .echo ("<option value='Hits Desc'>点击数(降序)</option>")
					End If
					If OrderStr = "HitsByDay Asc" Then
					 .echo ("<option value='HitsByDay Asc' selected>日访问量(升序)</option>")
					Else
					 .echo ("<option value='HitsByDay Asc'>日访问量(升序)</option>")
					End If
					If OrderStr = "HitsByDay Desc" Then
					  .echo ("<option value='HitsByDay Desc' selected>日访问量(降序)</option>")
					Else
					  .echo ("<option value='HitsByDay Desc'>日访问量(降序)</option>")
					End If
					If OrderStr = "HitsByWeek Asc" Then
					 .echo ("<option value='HitsByWeek Asc' selected>周访问量(升序)</option>")
					Else
					 .echo ("<option value='HitsByWeek Asc'>周访问量(升序)</option>")
					End If
					If OrderStr = "HitsByWeek Desc" Then
					  .echo ("<option value='HitsByWeek Desc' selected>周访问量(降序)</option>")
					Else
					  .echo ("<option value='HitsByWeek Desc'>周访问量(降序)</option>")
					End If
					If OrderStr = "HitsByMonth Asc" Then
					 .echo ("<option value='HitsByMonth Asc' selected>月访问量(升序)</option>")
					Else
					 .echo ("<option value='HitsByMonth Asc'>月访问量(升序)</option>")
					End If
					If OrderStr = "HitsByMonth Desc" Then
					  .echo ("<option value='HitsByMonth Desc' selected>月访问量(降序)</option>")
					Else
					  .echo ("<option value='HitsByMonth Desc'>月访问量(降序)</option>")
					End If

		.echo "         </select></td>"
		.echo "              <td height=""24"">" & ReturnOpenTypeStr(OpenType) & "</td>"
		.echo "            </tr>"

		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" colspan='2'>文档数量"
		.echo "                <input name=""Num"" class=""textbox"" type=""text"" id=""Num""    style=""width:40px;text-align:center"" onBlur=""CheckNumber(this,'文档数量');"" value=""" & Num & """>条 标题字数<input name=""TitleLen"" class=""textbox"" onBlur=""CheckNumber(this,'标题字数');"" type=""text""    style=""width:40px;;text-align:center"" value=""" & TitleLen & """> 行距"
		.echo "                <input name=""RowHeight"" class=""textbox"" type=""text"" id=""RowHeight2""    style=""width:40px;;text-align:center"" onBlur=""CheckNumber(this,'文档行距');"" value=""" & RowHeight & """>px 列数<input type=""text"" class=""textbox"" onBlur=""CheckNumber(this,'排列列数');""  style=""width:40px;text-align:center"" value=""" & ColNumber & """ name=""ColNumber""> <font class='tips'>Tips:若自定义样式输出,行距和列数请在您的样式里控制</font></td>"
		.echo "            </tr>"
		
		
		.echo "            <tr class=tdbg>"
		.echo "              <td width=""50%"" height=""24"">输出格式"
		.echo " <select class='textbox'  name=""PrintType"" id=""PrintType"" onChange=""ChangeOutArea(this.options[this.selectedIndex].value);"">"
        .echo "  <option value=""1"""
		If PrintType=1 Then .echo " selected"
		.echo ">文本列表样式(Table)</option>"
        .echo "  <option value=""2"""
		If PrintType=2 Then .echo " selected"
		.echo ">图片列表样式(Table)</option>"
        .echo "  <option value=""3"""
		If PrintType=3 Then .echo " selected"
		.echo ">自定义输出样式(不带自定义字段)</option>"
        .echo "  <option style='color:green' value=""4"""
		If PrintType=4 Then .echo " selected"
		.echo ">自定义输出样式(带自定义字段)</option>"
        .echo "</select>"
		.echo "            <label><input type='checkbox' name='AjaxOut' id='AjaxOut' value='1'"
		If AjaxOut="true" Then .echo " checked"
		.echo ">采用Ajax输出</label></td>"
		.echo "              <td><span id='ShowDiyDate'></span> <span id='ShowIntroArea'><br/>简介字数<input type='text' class='textbox' style='text-align:center' name='IntroLen' id='IntroLen' value='" & IntroLen & "' size='4'></span></td>"
		.echo "            </tr>"
		
		.echo "           <tbody id='ModelParamArea'></tbody>"
		.echo "           <tbody id='ModelParamArea1'><tr class='tdbg'><td>指定地区 <script src='../../../plus/area.asp'></script></td><td><label style='font-weight:bold;color:brown'><input type='checkbox' value='1' name='ispic' id='ispic'"
		if cbool(ispic)=true then .echo " checked"
		.echo "/>仅显示有图片的文档</label></td></tr></tbody>"
		%>
		<script language="javascript">
			<%if Province<>"" then%>
					 $('#Province').val('<%=province%>');
			<%end if%>
			<%if City<>"" Then%>
			  $('#City')[0].options[0]=new Option('<%=City%>','<%=City%>');
			  $('#City')[0].options(0).selected=true;
		    <%end if%>
		</script>
		<%
		.echo "            <tbody id=""DiyArea"">"
		.echo "            <tr class=tdbg>"
		.echo "              <td colspan='2' id='ShowFieldArea' class='field'><li onclick=""InsertLabel('{@autoid}')"">行 号</li><li onclick=""InsertLabel('{@linkurl}')"">链接URL</li><li onclick=""InsertLabel('{@id}')"">文档ID</li><li onclick=""InsertLabel('{@title}')"">标 题</li><li onclick=""InsertLabel('{@fulltitle}')"" style='color:red'>不截断标题</li> <li onclick=""InsertLabel('{@intro}')"">简要介绍</li><li onclick=""InsertLabel('{@photourl}')"">图片地址</li><li onclick=""InsertLabel('{@adddate}')"">添加时间</li><li onclick=""InsertLabel('{@inputer}')"">录入员</li><li onclick=""InsertLabel('{@hits}')"">点击数</li><li onclick=""InsertLabel('{@newimg}')"" title='显示新信息图片标志' style='color:red;'>最新图标志</li><li onclick=""InsertLabel('{@hotimg}')"" title='显示热门信息图片标志' style='color:red;'>热门图标志</li><li onclick=""InsertLabel('{@classname}')"">当前栏目名称</li><li onclick=""InsertLabel('{@classurl}')"">当前栏目URL</li><li onclick=""InsertLabel('{@topclassname}')"">一级栏目名称</li><li onclick=""InsertLabel('{@topclassurl}')"">一级栏目URL</li></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td colspan='2'><textarea name='LabelStyle' onkeyup='setPos()' onclick='setPos()' id='LabelStyle' style='width:95%;height:150px'>" & LabelStyle & "</textarea></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td colspan='2' class='attention'><strong><font color=red>使用说明 :</font></strong><br />1、循环标签[loop=n][/loop]对可以省略,也可以平行出现多对；<br />2、输出格式选择不带自定义字段输出的运行效率高于带自定义字段,如果列表没有用到自定义字段请选择不带自定义字段输出</font><br/>3、支持条件判断语句，格式：<font color=blue>{$IF 条件}</font><font color=red>{成立执行的代码}</font><font color=green>{不成立执行的代码}</font><font color=blue>{/$IF}</font></td>"
		.echo "            </tr>"
		.echo "           </tbody>"
		
		

		
		.echo "          <tbody id='TableArea'>"
		.echo "           <tr class=tdbg>"
		 .echo "             <td colspan=2 height=""30"">附加显示 "
				   If cbool(ShowClassName) = true Then
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowClassName"" name=""ShowClassName"" checked>显示栏目</label>")
				   Else
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowClassName"" name=""ShowClassName"">显示栏目</label>")
				   End If
                    .echo "&nbsp;&nbsp;&nbsp;<label id='twbz'>"
					 If cbool(ShowPicFlag) = True Then
					  .echo ("<input type=""checkbox"" value=""true"" onclick=""if (this.checked)alert('温馨提示:标签只有指定到文章类模型此属性才有效')"" id=""ShowPicFlag"" name=""ShowPicFlag"" checked>“图文”标志</label>")
					 Else
					  .echo ("<input type=""checkbox"" value=""true"" onclick=""if (this.checked)alert('温馨提示:标签只有指定到文章类模型此属性才有效')"" id=""ShowPicFlag"" name=""ShowPicFlag"">“图文”标志</label>")
					 End If
				   .echo "&nbsp;&nbsp;&nbsp;"
					 If  cbool(ShowNewFlag) = True Then
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowNewFlag"" name=""ShowNewFlag"" checked>最新文档标志</label>")
					 Else
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowNewFlag"" name=""ShowNewFlag"">最新文档标志</label>")
					 End If
				 .echo "&nbsp;&nbsp;&nbsp;"
					 If  cbool(ShowHotFlag) = True Then
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowHotFlag"" name=""ShowHotFlag"" checked>显示热门文档标志</label>")
					 Else
					  .echo ("<label><input type=""checkbox"" value=""true"" id=""ShowHotFlag"" name=""ShowHotFlag"">显示热门文档标志</label>")
					 End If
			   
		.echo "       　</td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td width=""50%"" height=""24"">导航类型"
		.echo "                <select name=""NavType"" style=""width:70%;"" class='textbox' onchange=""SetNavStatus()"">"
				   If LabelID = "" Or CStr(NavType) = "0" Then
					.echo ("<option value=""0"" selected>文字导航</option>")
					.echo ("<option value=""1"">图片导航</option>")
				   Else
					.echo ("<option value=""0"">文字导航</option>")
					.echo ("<option value=""1"" selected>图片导航</option>")
				   End If
		 .echo "               </select></td>"
		 .echo "             <td width=""50%"" height=""24"">"
			   If LabelID = "" Or CStr(NavType) = "0" Then
				  .echo ("<div align=""left"" id=""NavWord""> ")
				  .echo ("<input type=""text"" class=""textbox"" name=""TxtNavi"" style=""width:70%;"" value=""" & Navi & """>")
				  .echo ("</div>")
				  .echo ("<div align=""left"" id=NavPic style=""display:none""> ")
				  .echo ("<input type=""text"" class=""textbox"" readonly style=""width:120;"" id=""NaviPic"" name=""NaviPic"">")
				  .echo ("<input class='button' type=""button"" onClick=""OpenThenSetValue('../SelectPic.asp?CurrPath=" & CurrPath & "&ShowVirtualPath=true',550,290,window,document.myform.NaviPic);"" name=""Submit3"" value=""选择图片..."">")
				  .echo ("&nbsp;<span style=""cursor:pointer;color:green;"" onclick=""javascript:document.myform.NaviPic.value='';"" onmouseover=""this.style.color='red'"" onMouseOut=""this.style.color='green'"">清除</span>")
				  .echo ("</div>")
				Else
				  .echo ("<div align=""left"" id=""NavWord"" style=""display:none""> ")
				  .echo ("<input type=""text"" class=""textbox"" name=""TxtNavi"" style=""width:70%;"">")
				  .echo ("</div>")
				  .echo ("<div align=""left"" id=NavPic> ")
				  .echo ("<input type=""text"" class=""textbox"" readonly style=""width:120;"" id=""NaviPic"" name=""NaviPic"" value=""" & Navi & """>")
				  .echo ("<input class='button' type=""button"" onClick=""OpenThenSetValue('../SelectPic.asp?CurrPath=" & CurrPath & "&ShowVirtualPath=true',550,290,window,document.myform.NaviPic);"" name=""Submit3"" value=""选择图片..."">")
				  .echo ("&nbsp;<span style=""cursor:pointer;color:green;"" onclick=""javascript:document.myform.NaviPic.value='';"" onmouseover=""this.style.color='red'"" onMouseOut=""this.style.color='green'"">清除</span>")
				  .echo ("</div>")
				End If
		 .echo "             </td>"
		 .echo "           </tr>"
		 .echo "           <tr  class=tdbg id=""MoreLinkArea"""
		 If Instr(ClassID,",")<>0 Then .echo " style='display:none'"
		 .echo ">"
		 .echo "             <td width=""50%"" height=""24"">更多链接"
		 .echo "               <select name=""MoreLinkType"" style=""width:70%;"" class='textbox' onchange=""SetMoreLinkStatus()"">"
				  If LabelID = "" Or CStr(MoreLinkType) = "0" Then
					.echo ("<option value=""0"" selected>文字链接</option>")
					.echo ("<option value=""1"">图片链接</option>")
				   Else
					.echo ("<option value=""0"">文字链接</option>")
					.echo ("<option value=""1"" selected>图片链接</option>")
				   End If
		.echo "                </select></td>"
		.echo "              <td width=""50%"" height=""24"">"
				If LabelID = "" Or CStr(MoreLinkType) = "0" Then
					.echo ("<div align=""left"" id=""LinkWord""> ")
					.echo ("  <input type=""text"" class=""textbox"" name=""MoreLinkWord"" style=""width:70%;"" value=""" & MoreLink & """>")
					.echo ("</div>")
					.echo ("<div align=""left"" id=""LinkPic"" style=""display:none""> ")
					.echo ("<input type=""text"" class=""textbox"" readonly style=""width:120;"" id=""MoreLinkPic"" name=""MoreLinkPic"">")
					.echo ("<input class='button' type=""button"" onClick=""OpenThenSetValue('../SelectPic.asp?CurrPath=" & CurrPath & "&ShowVirtualPath=true',550,290,window,document.myform.MoreLinkPic);"" name=""Submit3"" value=""选择图片..."">")
					.echo ("&nbsp;<span style=""cursor:pointer;color:green;"" onclick=""javascript:document.myform.MoreLinkPic.value='';"" onmouseover=""this.style.color='red'"" onMouseOut=""this.style.color='green'"">清除</span>")
					.echo ("</div>")
				Else
				   .echo ("<div align=""left"" id=""LinkWord"" style=""display:none""> ")
				   .echo ("<input type=""text"" class=""textbox"" name=""MoreLinkWord"" style=""width:70%;"">")
				   .echo ("</div>")
				   .echo ("<div align=""left"" id=""LinkPic""> ")
				   .echo ("<input type=""text"" class=""textbox"" readonly style=""width:120;"" id=""MoreLinkPic"" name=""MoreLinkPic"" value=""" & MoreLink & """>")
				   .echo ("<input class='button' type=""button"" onClick=""OpenThenSetValue('../SelectPic.asp?CurrPath=" & CurrPath & "&ShowVirtualPath=true',550,290,window,document.myform.MoreLinkPic);"" name=""Submit3"" value=""选择图片..."">")
				   .echo ("&nbsp;<span style=""cursor:pointer;color:green;"" onclick=""javascript:document.myform.MoreLinkPic.value='';"" onmouseover=""this.style.color='red'"" onMouseOut=""this.style.color='green'"">清除</span>")
				   .echo ("</div>")
				End If
		.echo "              </td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" colspan=""2"">分隔图片"
		.echo "                <input name=""SplitPic"" class=""textbox"" type=""text"" id=""SplitPic"" style=""width:61%;"" value=""" & SplitPic & """ readonly>"
		.echo "                <input class='button' name=""SubmitPic"" class='button' onClick=""OpenThenSetValue('../SelectPic.asp?CurrPath=" & CurrPath & "&ShowVirtualPath=true',550,290,window,document.myform.SplitPic);"" type=""button"" id=""SubmitPic2"" value=""选择图片..."">"
		.echo "                <span style=""cursor:pointer;color:green;"" onclick=""javascript:document.myform.SplitPic.value='';"" onmouseover=""this.style.color='red'"" onMouseOut=""this.style.color='green'"">清除</span>"
		.echo "                <div align=""left""> </div></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" id='ShowTableDate'>日期格式"
		.echo ReturnDateFormat(DateRule)
		.echo "                 </td>"
		.echo "              <td height=""24"">"
		.echo "                <div align=""left"">日期对齐"
		.echo "                  <select class=""textbox"" name=""DateAlign"" id=""select3"" style=""width:70%;"">"
							
					If LabelID = "" Or CStr(DateAlign) = "left" Then
					 Str = " selected"
					Else
					 Str = ""
					End If
					 .echo ("<option value=""left""" & Str & ">左对齐</option>")
					If CStr(DateAlign) = "center" Then
					 Str = " selected"
					Else
					 Str = ""
					End If
					 .echo ("<option value=""center""" & Str & ">居中对齐</option>")
					If CStr(DateAlign) = "right" Then
					 Str = " selected"
					Else
					 Str = ""
					End If
					 .echo ("<option value=""right""" & Str & ">右对齐</option>")
					 
		.echo "                  </select>"
		.echo "                </div></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" id=""ShowTitleCss"">标题样式"
		.echo "                <input name=""TitleCss"" class=""textbox"" type=""text"" id=""TitleCss"" style=""width:70%;"" value=""" & TitleCss & """></td>"
		.echo "              <td height=""24"">日期样式"
		.echo "                <input name=""DateCss"" class=""textbox"" type=""text"" id=""DateCss"" style=""width:70%;"" value=""" & DateCss & """></td>"
		.echo "            </tr>"
		.echo "              </tbody>"



		.echo "           <tbody id='PicArea'>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"">图片设置 宽"
		.echo "                <input name=""PicWidth"" class=""textbox"" type=""text"" id=""PicWidth"" size='4' value=""" & PicWidth & """>px 高<input name=""PicHeight"" class=""textbox"" type=""text"" id=""PicHeight"" size='4' value=""" & PicHeight & """>px</td>"
		.echo "                <td colspan='2' rowspan='5' id='ViewStylePicArea'>图片显示</td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"">显示样式"
		.echo "                <select class='textbox' style='width:230px' name=""PicStyle"" id=""PicStyle"">"
							.echo ("<option value=""1"">①:仅显示缩略图</option>")
							.echo ("<option value=""2"">②:缩略图+名称:上下</option>")
							.echo ("<option value=""3"">③:缩略图+(名称+简介:上下):左右</option>")
							.echo ("<option value=""4"">④:(名称+简介:上下)+缩略图:左右</option>")
						 
		.echo "                </select> <font color=""#FF0000""> =>右边效果预览</font></td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"">边框颜色 <input type=""text"" id=""PicBorderColor"" class=""textbox"" name=""PicBorderColor"" style=""width:120;"" value=""" & PicBorderColor & """><img border=0 id=""ColorThumbsBorderShow"" src=""../../images/rect.gif"" style=""cursor:pointer;background-Color:" & PicBorderColor & ";"" onClick=""Getcolor(this,'../../../editor/ksplus/selectcolor.asp?ColorThumbsBorderShow|PicBorderColor');"" title=""选取颜色""> 可留空</td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"">图片间距:<input type='text' class='textbox' name='PicSpacing' id='PicSpacing' value='" & PicSpacing & "' size='8' style='text-align:center'> px</td>"
		.echo "            </tr>"
		.echo "            <tr class=tdbg>"
		.echo "              <td height=""24"" id=""ShowPicTitleCss""></td>"
		.echo "            </tr>"
		.echo "           </tbody>"

		.echo "         </table>"			 
		.echo "    </form>"
		.echo "</div>"
		.echo "</body>"
		.echo "</html>"
		End With
		End Sub
End Class
%> 