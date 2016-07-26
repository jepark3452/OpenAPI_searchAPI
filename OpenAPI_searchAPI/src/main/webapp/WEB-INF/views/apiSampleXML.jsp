<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set value="${pageContext.request.contextPath }" var="cp" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- jQuery -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<%-- <script src="<c:url value='/res/js/jquery-3.1.0.min.js'/>" charset="utf-8"></script> --%>
<script language="javascript">

$(document).ready(function() {
	$('#keyword').keyup(function(e){
		if(e.keyCode == 13) {
			getAddr();
		}
	});
});

function getAddr(page){
	
	if($('#keyword').val().length<2)
	{
		alert('조회할 주소를 두 글자 이상 입력해 주세요.');
		$('#keyword').focus();
		return false;
	}
	
	if(page == null || page == 0) page = 1;
	
	// AJAX 주소 검색 요청
	$.ajax({
		url:"${cp}/sample/getAddrApi.do"								// 호출할 Controller API URL  
		,type:"post"
		,data:$("#form").serialize()+"&currentPage="+page 		// 요청 변수 설정
		,dataType:"xml"														// 데이터 결과 : XML
		,success:function(xmlStr){										// xmlStr : 주소 검색 결과 XML 데이터
			$("#list").html("");												// 결과 출력 영역 초기화
			var errCode= $(xmlStr).find("errorCode").text();		// 응답코드
			var errDesc= $(xmlStr).find("errorMessage").text();	// 응답메시지
			if(errCode != "0"){ 												// 응답에러시 처리
				alert(errCode+"="+errDesc);
			}else{
				if(xmlStr!= null){
					makeList(xmlStr);											// 결과 XML 데이터 파싱 및 출력
				}
			}
		}
		,error: function(xhr,status, error){
			alert("에러발생");													// AJAX 호출 에러
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
	var htmlStr = "";
	htmlStr += "<table>";
	// jquery를 이용한 XML 결과 데이터 파싱
	$(xmlStr).find("juso").each(function(){
		htmlStr += "<tr>";
		htmlStr += "<td>"+$(this).find('roadAddr').text() +"</td>";
		htmlStr += "<td>"+$(this).find('roadAddrPart1').text() +"</td>";
		htmlStr += "<td>"+$(this).find('roadAddrPart2').text() +"</td>";
		htmlStr += "<td>"+$(this).find('jibunAddr').text() +"</td>";
		htmlStr += "<td>"+$(this).find('engAddr').text() +"</td>";
		htmlStr += "<td>"+$(this).find('zipNo').text() +"</td>";
		htmlStr += "<td>"+$(this).find('admCd').text() +"</td>";
		htmlStr += "<td>"+$(this).find('rnMgtSn').text() +"</td>";
		htmlStr += "<td>"+$(this).find('bdMgtSn').text() +"</td>";
		htmlStr += "<td>"+$(this).find('detBdNmList').text() +"</td>";
		htmlStr += "</tr>";
	});
	htmlStr += "</table>";
	// 결과 HTML을 FORM의 결과 출력 DIV에 삽입
	$("#list").html(htmlStr);
	
	 $('#paging').html(
		paintPager(currentPage, countPerPage, totalCount, 'getAddr')
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

</script>
</script>
<title>OPEN API 샘플-XML</title>
</head>
<body>
<form name="form" id="form" method="post" onsubmit="return false">
  <input type="hidden" name="countPerPage" value="10"/>						<!-- 요청 변수 설정 (페이지당 출력 개수) -->
  <input type="text" id="keyword" name="keyword" value=""/>				<!-- 요청 변수 설정 (키워드) -->
  <input type="button" onClick="getAddr();" value="주소검색하기"/>
  
  <div id="list"> <!-- 검색 결과 리스트 출력 영역 --> </div>
  <div id="paging" style="margin-top: 13px; height: 30px;" align="center"><!-- 페이징영역 --></div>
</form>
</body>
</html>