<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set value="${pageContext.request.contextPath}" var="cp"/>

<c:set var="msCss" value=" height:18px; "/>
<c:choose>
	<c:when test='<%=request.getHeader("User-Agent").indexOf("MSIE 8")!=-1%>'>
    <c:set var="msCss" value=" height:/*＼**/15px; padding-top:/*＼**/4px; "/>
    </c:when>
    <c:otherwise>
    <c:set var="msCss" value=" height:19px; "/>
    </c:otherwise>
</c:choose>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>주소찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link type="text/css" rel="stylesheet" href="${cp }/res/css/content.css" />
<link rel="stylesheet" type="text/css" href="${cp }/res/css/style.css" />
<style type="text/css">
	.zip_search_input03_g { position:absolute; width:200px; height:23px; left:226px; }
	.zip_search_bt_g { position:relative; width:49px; height:23px; left:426px; }
	a:hover  { color:blue; text-decoration:none;cursor:pointer; }
</style> 
<script type="text/javascript" src='<c:url value="/res/js/jquery.js"/>'></script>
<script type="text/javascript" src='<c:url value="/res/js/jquery-ui.js"/>'></script>
<script type="text/javascript" src='<c:url value="/res/js/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/res/js/common.js"/>'></script>
<script language="JavaScript">
<!--
$(document).ready(function() {
	gfn_addValChkEvent();
	$('#keyword').focus();
	
	$('input').keyup(function(e){
		if(e.keyCode == 13) {
			getAddrLoc(0);
		}
	});
});

<% //OPEN API START %>
function getAddrLoc(page){
	
	if($('#keyword').val().length<2)
	{
		alert('조회할 주소를 두 글자 이상 입력해 주세요.');
		$('#keyword').focus();
		return false;
	}
	
	if(page == null || page == 0) page = 1;
	
	$.ajax({
		 url: "<c:url value='/sample/getAddrApi.do'/>"
		,type:"post"
		,data:$("#f_cond").serialize() +"&currentPage="+page
		,dataType:"xml"
		,success:function(xmlStr){
			$("#list").html("");
			var errCode = $(xmlStr).find("errorCode").text();
			var errDesc = $(xmlStr).find("errorMessage").text();
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(xmlStr != null){
					makeList(xmlStr);
				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

function makeList(xmlStr){
	var totalCount = $(xmlStr).find("totalCount").text();
	if(totalCount == 0) {
		alert("검색 결과가 없습니다.");
		return;
	}
	
	var currentPage = $(xmlStr).find("currentPage").text();
	var countPerPage = $(xmlStr).find("countPerPage").text();
	$("#addrList tbody").html("");
	$(xmlStr).find("juso").each(function(){
		var tr = $("<tr style='height:5px;'></tr>");
        $("<td style='text-align:center; width:300px;'></th>").html("<strong>"+$(this).find('zipNo').text()+"</strong>").appendTo(tr);
        $("<td style='text-align:left; width:1000px;'></td>").html("<a href='#' onclick='parent.setAddr(\""+$(this).find('zipNo').text()+"\", \""+$(this).find('roadAddr').text()+"\")'>"+$(this).find('roadAddr').text()).appendTo(tr);
        $("<td style='text-align:left; width:1000px;'></td>").html("<a href='#' onclick='parent.setAddr(\""+$(this).find('zipNo').text()+"\", \""+$(this).find('jibunAddr').text()+"\")'>"+$(this).find('jibunAddr').text()).appendTo(tr);
        tr.appendTo($("#addrList tbody"));
		//htmlStr += "<td>"+$(this).find('roadAddr').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('roadAddrPart1').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('roadAddrPart2').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('jibunAddr').text()     +"</td>";
		//htmlStr += "<td>"+$(this).find('engAddr').text()     +"</td>";
		//htmlStr += "<td>"+$(this).find('zipNo').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('admCd').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('rnMgtSn').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('bdMgtSn').text()      +"</td>";
		//htmlStr += "<td>"+$(this).find('detBdNmList').text()      +"</td>";
		//htmlStr += "</tr>";
	});
	//paintGrid("addrList");
    $('div.paging').html(
			paintPager(currentPage, countPerPage, totalCount, 'getAddrLoc')
			//paintPager(currentPage, countPerPage, totalCount, 'getAddrLoc')
    );
}

function paintPager(page, cpp, totalCnt, funcName){
   var pageBlockCnt = 10;
    var startBlockNum = (Math.floor((page-1)/(pageBlockCnt)) * pageBlockCnt) + 1;
    var endBlockNum = (Math.ceil(page/pageBlockCnt) * pageBlockCnt);
    //console.log("endBlockNum[(Math.ceil(page/pageBlockCnt) * pageBlockCnt)]: " + endBlockNum);
    var lastBlockNum = Math.ceil((totalCnt)/cpp);
    //console.log("lastBlockNum[Math.ceil(totalCnt/cpp]: " + lastBlockNum);
    if(endBlockNum > lastBlockNum){
        endBlockNum = lastBlockNum;
    }
    //console.log("lastBlockNum: " + lastBlockNum);
    var prev = page - 1; if(prev < 1) prev = 1;
    var next = page -0 + 1; if(next > lastBlockNum) next = lastBlockNum;
    if(funcName == null) funcName = 'doSearch';
    var pagerHtml = '';
    //pagerHtml += '<span class="fst"><a href="javascript:_goPage(1, \'' +funcName+ '\');"><img src="${cp}/res_openapi/images/btn/board_button_first.png"/></a></span>'; // 처음
    pagerHtml += '&nbsp;<span class="pre"><a href="javascript:_goPage('+prev+ ', \'' +funcName+ '\');">[이전]</a></span>&nbsp;'; // 이전
    
    //console.log("startBlockNum: " + startBlockNum + ",endBlockNum: " + endBlockNum);
    for(var i=startBlockNum ;i<=endBlockNum;i++){
    	//console.log("i: " + i);
        if(i > lastBlockNum) continue;
        if( i == page )
            pagerHtml += '<span class="bar"><b><a href="javascript:_goPage('+i+ ', \'' +funcName+ '\');" class="current">' +i+ '</a></b></span>&nbsp;';
        else
            pagerHtml += '<span class="bar"><a href="javascript:_goPage('+i+ ', \'' +funcName+ '\');">' +i+ '</a></span>&nbsp;';
    }
    pagerHtml += '&nbsp;<span class="nxt"><a href="javascript:_goPage('+next+ ', \'' +funcName+ '\');">[다음]</a></span>'; // 다음
    //pagerHtml += '<span class="end"><a href="javascript:_goPage('+lastBlockNum+ ', \'' +funcName+ '\');"><img src="${cp}/res_openapi/images/btn/board_button_last.png"/></a></span>'; // 끝
    if(i == 1) pagerHtml = ""	;
    return pagerHtml;
}

function _goPage(p, funcName){
    eval(funcName+'('+p+')');
}

/**
 * 주소 리턴. 오픈한 창에 getPopUpRtnVal 함수가 있어야 한다.
 */
function setAddr(zip, address)
{
	opener.getPopUpRtnVal(zip, address);
	window.close();
}
<% //OPEN API END %>

//-->
</script>

</head>
<body>
<input type="hidden" name="contextPath" id="contextPath" value="${pageContext.request.contextPath}"/>
	<div class="popup_layer" style="width: 100%;">
		<p class="popup_tit">우편번호 찾기</p>
		<div class="popup_con" style="padding-top:15px; padding-bottom:10px;">
			<p><strong>도로명, 건물명, 지번에 대해 통합검색이 가능합니다.</strong></p>
			<p class="font12" style="margin-bottom: 25px;">예 ) 강남대로 465 / 서초동 1303-22 / 교보타워</p>
			<form name="f_cond" id="f_cond" onsubmit="return false">
			<input type="hidden" id="countPerPage" name="countPerPage" value="10" />
			<div style="margin-bottom: 25px;">
				<input type="text" maxlength="30" id="keyword" name="keyword" reqType="KN" class="input_text"/>
				<input type="button" onclick="javascript:getAddrLoc(0);" class="btn_gray" value="검색"/>
			</div>
			</form>
			<div class="box_post">
				<table class="res_web_tbl post_tbl" id="addrList">
					<caption>우편번호 찾기</caption>
					<thead style="width: 100%;">
						<tr>
							<th width="300px;">우편번호</th>
							<th width="1000px;">도로명주소</th>
							<th width="1000px;">지번주소</th>
						</tr>
					</thead>
					<tbody style="width: 100%; max-height: 390px;">
					</tbody>
				</table>
			</div>
		</div>
		<a href="#" class="popup_close" onclick="window.close();"><span class="hidden">레이어닫기</span></a>
	</div>
	<table align="center" width="100%">
		<tr>
			<td class="PagingArea" align="center" width="60%"><div class="paging" style="margin-top: 13px; height: 30px;"></div></td>
		</tr>
	</table>
</body>
</html>