<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REPLY MODIFY" />
<%@ include file="../common/head.jspf" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
<style>
.chart-box{
width: 400px;
height : 600px;
}
</style>
<section>
	<div class="container mx-auto">
		<div>			
			<span>기간</span>
			<input type="text" name="startDate" class="input input-bordered max-w-xs" placeholder="20000101"/>부터
			<input type="text" name="lastDate" class="input input-bordered max-w-xs" placeholder="20230101"/>까지
			<span>게시판 선택</span>
			<select id ="boardId" name="boardId" class="select select-bordered">
				<option value="0">전체</option>									
				<option value="1">나만의 명상방법</option>
				<option value="2">좋은글 / 좋은 글귀</option>
				<option value="3">자유</option>
			</select>
			<button type="button" class="btn btn-active btn-ghost" onclick="statisticsChart();">조회</button>				
		</div>
		<div class="chart-box">
			<canvas id="bar-chart" width="50" height="50"></canvas>
		</div>
	</div>
</section>

<script>
function statisticsChart(){
	$('.chartjs-hidden-iframe').remove();
	$.get('/adm/statistics/article', {
		startDate : $('input[name=startDate]').val(),
		lastDate : $('input[name=lastDate]').val(),
		boardId : $('#boardId').val(),
		ajaxMode : 'Y'
	}, function(data) {			
			new Chart(document.getElementById("bar-chart"), {
			    type: 'bar',
			    data: {
			      labels: ["생성글 수", "총 조회수", "평균 조회수", "최고 조회수"],
			      datasets: [
			        {
			          label: "",
			          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
			          data: [data.articlesCount,data.totalViews,data.averageViews,data.topViews]
			        }
			      ]
			    },
			    options: {
			      legend: { display: false },
			      title: {
			        display: true,
			        text: '게시물 통계'
			      }
			    }
			});
		}, 'json');	
	}
</script>
<%@ include file="../common/foot.jspf" %>
