<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set value="${pageContext.request.contextPath }" var="cp" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>행정자치부-OpenAPI 우편번호 찾기 searchAPI</title>
</head>
<body>
	<div>
		<h1>행정자치부 - OpenAPI 우편번호 찾기 searchAPI</h1>
		<ol>
			<li><a href="${cp}/sample/apiSampleJSONP.do">apiSampleJSONP.jsp</a></li>
			<li><a href="${cp}/sample/apiSampleXML.do">apiSampleXML.jsp</a></li>
			<li><a href="${cp}/sample/apiSampleXMLPop.do">apiSampleXMLPop.jsp(팝업방식)</a></li>
		</ol>
	</div>
</body>
</html>