﻿document.writeln('<table width=\"98%\" border=\"0\" align=\"center\">')
document.writeln('<form id=\"SearchForm\" name=\"SearchForm\" method=\"get\" action=\"/wap/item/index.asp\">')
document.writeln('  <tr>')
document.writeln('    <td align=\"center\"><select name=\"t\">')
document.writeln('        <option value=\"1\">标 题</option>')
document.writeln('        <option value=\"2\">内 容</option>')
document.writeln('        <option value=\"3\">作 者</option>')
document.writeln('        <option value=\"4\">录入者</option>')
document.writeln('        <option value=\"5\">关键字</option>')
document.writeln('      </select>')
document.writeln('        <select name=\"tid\" style=\"width:150px\">')
document.writeln('          <option value=\"0\" selected=\"selected\">所有栏目</option>')
document.writeln('<option value=\'20131555815230\'>新闻中心 </option><option value=\'20136370480445\'>──公司快报 </option><option value=\'20131163136311\'>──行业资讯 </option><option value=\'20139999143319\'>──企业公告 </option>        </select>')
document.writeln('        <input name=\"key\" type=\"text\" class=\"textbox\"  value=\"关键字\" onfocus=\"this.select();\"/>')
document.writeln('        <input name=\"ChannelID\" value=\"112\" type=\"hidden\" />')
document.writeln('        <input type=\"submit\" class=\"inputButton\" name=\"sbtn\" value=\"搜 索\" /></td>')
document.writeln('  </tr>')
document.writeln('</form>')
document.writeln('</table>')