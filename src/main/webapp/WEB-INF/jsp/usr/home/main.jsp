<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MAIN" />
<%@ include file="../common/head.jspf" %>
<style>
.mainbox{
position: absolute;
width: 1760px;
height: 521px;
left: 80px;
top: 214px;

background: #FFFAF3;
}
.maintitle{
position: absolute;
width: 368px;
height: 67px;
left: 194px;
top: 310px;

font-family: 'Open Sans Condensed';
font-style: normal;
font-weight: 300;
font-size: 48px;
line-height: 65px;
text-align: center;
letter-spacing: 0.06em;

color: #000000;
}
.vector1{

}
.maintext{
position: absolute;
width: 388px;
height: 136px;
left: 194px;
top: 468px;

font-family: 'Open Sans Condensed';
font-style: normal;
font-weight: 700;
font-size: 18px;
line-height: 147.6%;

letter-spacing: 0.06em;

color: #000000;
}
.brush{
position: absolute;
width: 1760px;
height: 147px;
left: 80px;
top: 640px;
background: rgba(192, 141, 93, 0.2);
filter: blur(50px);
}
.mainImage{
position: absolute;
width: 911px;
height: 415px;
left: 872px;
top: 267px;
background-image: url("명상사진.jpg");
}
</style>
	<div class="mainbox"></div>
	<div class="maintitle">
		<span>메인타이틀</span>
	</div>
	<div class="vector1"></div>
	<div class="maintext">
		<span>
			메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글메인글
		</span>
	</div>
	<div class="mainImage"></div>
	<div class="brush">	</div>

<%@ include file="../common/foot.jspf" %>