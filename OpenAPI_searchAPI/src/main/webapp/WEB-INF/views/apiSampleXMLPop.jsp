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

//우편번호 적용
function getPopUpRtnVal(zip, address){
	$('#zipcod').val(zip);
	$('#add1').val(address);
	$('#add2').focus();
}

//OpenAPI 주소 찾기 팝업
function fn_searchJibunPop(){
	var url = '${cp}/sample/popup/apiSamplePopup.do';
	window.open(url, 'subWin', 'width=1035px, height=695px, scrollbars=no, menubar=no, status=no, location=no,toolbar=no, resizable=no,fullscreen=no, channelmode=no');  
}

</script>
</script>
<title>(팝업)OPEN API 샘플-XML</title>
</head>
<body>
<form name="form" id="form" method="post" onsubmit="return false">
  <table>
  	<tr>
		<th scope="row" class="left" rowspan="2">주소</th>
		<td class="border0">
			<input type="text" name="zipcod" id="zipcod" class="input_text" title="우편번호"  style="width:60px" maxlength="6" readonly/>
			<a href="javascript:" class="btn_radius btn_lgray" onclick="fn_searchJibunPop();">우편번호</a>	
		</td>
	</tr>
	<tr>
		<td style="padding-top:0">
			<input type="text" name="add1" id="add1" class="input_text mg10" maxlength="100" readonly  title="주소" style="width:390px;"/><br/>
			<input type="text" name="add2" id="add2" class="input_text" maxlength="50" reqType="KNE" title="주소2" style="width:390px;"/>
		</td>
	</tr>
  </table>
</form>
</body>
</html>