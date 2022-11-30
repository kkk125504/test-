<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="ARTICLE" />
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>
	<script>
		const params = {};
		params.id = parseInt('${param.id}');
		params.resultTypeCode = 'article';
	</script>
	
	<script>
		//게시물 조회수 관련
		function ArticleDetail__increaseHitCount() {
			const localStorageKey = 'article__' + params.id + '__alreadyView';
			
			if(localStorage.getItem(localStorageKey)){
				return;
			}
			
			localStorage.setItem(localStorageKey,true);
			
			$.get('../article/doIncreaseHitCountRd', {
				id : params.id,
				ajaxMode : 'Y'
			}, function(data) {
				$('.article-detail__hit-count').empty().html(data.data1);
			}, 'json');			
		}
		
		$(function() {
			// 실전코드
			//ArticleDetail__increaseHitCount();
			// 연습코드
			setTimeout(ArticleDetail__increaseHitCount, 2000);
			replyList();
		})
	</script>
	<script>
	//댓글 관련
	var replyWrite__submitDone = false;
	
	function ReplyWrite__submitForm(form){
		if(replyWrite__submitDone){
			alert('이미 처리중 입니다.');
			return;
		}
		form.body.value = form.body.value.trim();
		if(form.body.value.length==0){
			alert('댓글을 작성 해주세요.');
			form.body.focus();
			return;
		}
		replyWrite__submitDone = true;
		form.submit();		
	}
		
	//댓글리스트 출력
// 	function replyList() {		
// 		$.get('../reply/getReplies', {
// 			relId : params.id,
// 			relTypeCode : 'article',
// 			ajaxMode : 'Y'
// 		}, function(data) {
// 			var replyContent = "";
// 			if(data.data1.length < 1){
// 				replyContent += "댓글이 존재 하지 않습니다.";
// 			}
// 			$(data.data1).each(function(){
// 				var loginedMemberId = ${rq.loginedMemberId};
// 				var replyMemberId= this.memberId;				
//  				replyContent += '<div class="divider"></div>';
// 				replyContent += '<div class= "reply'+ this.id+'">'
// 				replyContent += '<div><span>';
// 				replyContent += this.extra__writerName +'</span></div>';
// 				replyContent += '<div class="bg-base-300 rounded-box "><span class="mx-8">';				
// 				replyContent += this.body+'</span></div>';							
//  				if(loginedMemberId == replyMemberId){
//  					replyContent +='<button class="btn" onclick="Reply__ModifyForm('+this.id +','+this.extra__writerName+','+this.body+')">수정</button>';
//  					replyContent +='<button class="btn" onclick="Reply__Delete('+ this.id +')">삭제</button>';
// 				}
//  				replyContent += '</div>';
//  				replyContent += '</div>';
 				
//  				$.get('../reply/getReplies', {
//  					relId : this.id,
//  					relTypeCode : 'reply',
//  					ajaxMode : 'Y'
//  				}, function(data) {
//  					replyContent += '<div>연결성공</div>';
//  				},'json');
 				
// 			});
// 			$('.replyList').html(replyContent);
// 		}, 'json');			
// 	}	
	//
	function replyList() {	
	      $.ajax({
	        type: "GET",
	        url: "../reply/getReplies",
	        dataType: "json",
	    	async : false,
	    	data : {"relId" : params.id, "relTypeCode" : "article"},
	        error: function() {
	          console.log('통신실패!!');
	        },
	        success: function(data) {
	        	var replyContent = "";
	 			if(data.data1.length < 1){
	 				replyContent += "댓글이 존재 하지 않습니다.";
	 			}
	 			$(data.data1).each(function(){
	 				var loginedMemberId = ${rq.loginedMemberId};
	 				var replyMemberId= this.memberId;				
	  				replyContent += '<div class="divider"></div>';
	 				replyContent += '<div class= "reply'+ this.id+'">'
	 				replyContent += '<div><span>';
	 				replyContent += this.extra__writerName +'</span></div>';
	 				replyContent += '<div class="bg-base-300 rounded-box "><span class="mx-8">';				
	 				replyContent += this.body+'</span></div>';							
	  				if(loginedMemberId == replyMemberId){
	  					replyContent +='<button class="btn btn-outline btn-xs" onclick="Reply__ModifyForm('+this.id +','+this.extra__writerName+','+this.body+')">수정</button>';
	  					replyContent +='<button class="btn btn-outline btn-xs" onclick="Reply__Delete('+ this.id +')">삭제</button>';
	 				}
	  				replyContent += '</div>';
	  				
	  				$.get('../reply/getReplies', {
 					relId : this.id,
 					relTypeCode : 'reply',
 					ajaxMode : 'Y'
 					}, function(data) {
 						replyContent += '<div>연결성공</div>';
						console.log('실행!!');
 					},'json');	        
	      });
	 			$('.replyList').html(replyContent); 
	 			console.log(replyContent);
		}	        
	   })
	}
//	
	
	function Reply__Write() {				
		$.get('../reply/doWrite', {
			relId : params.id,
			relTypeCode : $('input[name=relTypeCode]').val(),
			body : $('textarea[name=body]').val()
		}, function(data) {
			if(data.fail){
				alert(data.data.msg);
				return;
			}
			replyList();
		}, 'json');	
	}	
	
	function Reply__ModifyForm(replyId,writerName,body) {		
		
		var	replyReplaceContent= "<div>gggggggggggggggg</div>";
		
		$('.reply'+replyId).replaceWith(replyReplaceContent);
	}
	function Reply__Delete(replyId) {				
		$.get('../reply/doDelete', {
			id : replyId
		}, function(data) {
			if(data.fail){
				alert(data.data.msg);
				return;
			}
			replyList();
		}, 'json');	
	}	

	</script>
	
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<div class="table-box-type-1">
				<table>
					<colgroup>
						<col width="200" />
					</colgroup>	
					<tbody>		
						<tr>
							<th class="bg-gray-200">번호</th><td><span class="badge">${article.id }</span></td>						
						</tr>
						<tr>
							<th class="bg-gray-200">작성날짜</th><td>${article.regDate }</td>						
						</tr>
						<tr>
							<th class="bg-gray-200">수정날짜</th><td>${article.updateDate }</td>						
						</tr>
						<tr>
							<th class="bg-gray-200">제목</th><td>${article.title }</td>						
						</tr>
						<tr>
							<th class="bg-gray-200">내용</th>
							<td>
								<div class="toast-ui-viewer">
									<script type="text/x-template">${article.body}</script>
								</div>
							</td>					
						</tr>
						<tr>
							<th class="bg-gray-200">작성자</th><td>${article.extra__writer }</td>						
						</tr>
						<tr>
							<th class="bg-gray-200">조회수</th>
							<td>
							<span class="badge article-detail__hit-count">${article.hitCount }</span>							   
							</td>						
						</tr>
						<tr>
							<th class="bg-gray-200">추천 수</th>
							<td>
							<span class="btn btn-active btn-sm">${article.goodReactionPoint }</span>
							<c:if test="${actorCanMakeReaction}">
								<span>&nbsp;</span>
									<a href="/usr/reactionPoint/doGoodReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}" class="btn btn-outline btn-xs">좋아요 👍</a>
								<span>&nbsp;</span>
									<a href="/usr/reactionPoint/doBadReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}" class="btn btn-outline btn-xs">싫어요 👎</a>
							</c:if>
							
							<c:if test="${actorCanCancelGoodReaction}">
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doCancelGoodReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri} "
									class="btn btn-xs btn-primary"
								>좋아요 👍</a>
								<span>&nbsp;</span>
								<a onclick="alert(this.title); return false;" title="좋아요를 취소해주세요" href="#" class="btn btn-outline btn-xs">싫어요
									👎</a>
							</c:if>
							
							<c:if test="${actorCanCancelBadReaction}">
								<span>&nbsp;</span>
								<a onclick="alert(this.title); return false;" title="싫어요를 먼저 취소해주세요" href="#" class="btn btn-outline btn-xs">좋아요
									👍</a>
								<span>&nbsp;</span>
								<a href="/usr/reactionPoint/doCancelBadReaction?relTypeCode=article&relId=${param.id}&replaceUri=${rq.encodedCurrentUri}"
									class="btn btn-xs btn-primary">싫어요 👎</a>
							</c:if>
							</td>						
						</tr>
					</tbody>								
				</table>
				
				<div class= "btns flex justify-end">					
					<c:if test= "${article.extra__actorCanDelete}" >					
						<a class ="mx-4 btn-text-link btn btn-active btn-ghost" href="modify?id=${article.id }">수정</a>				
					</c:if>	
					
					<c:if test= "${article.extra__actorCanDelete}" >
						<a class ="btn-text-link btn btn-active btn-ghost" onclick="if(confirm('삭제하시겠습니까?') == false) return false;" href="doDelete?id=${article.id }">삭제</a>								
					</c:if>	
					<c:if test= "${not empty param.listUri}" >			
						<a class ="btn-text-link btn btn-active btn-ghost mx-4" href="${param.listUri}">뒤로가기</a>
					</c:if>
					<c:if test= "${empty param.listUri}" >			
						<button class ="btn-text-link btn btn-active btn-ghost mx-4" onclick="history.back();">뒤로가기</button>
					</c:if>			
				</div>
			</div>
		</div>
	</section>
	<section class="mt-5">
		<div class="container mx-auto px-3">
			<h2>댓글 작성</h2>
			<c:if test="${rq.logined }">
				<form class="table-box-type-1" >
					<input type="hidden" name="relTypeCode" value="article" />
					<input type="hidden" name="relId" value="${param.id}" />
					<table class="table w-full">
						<colgroup>
							<col width="200" />
						</colgroup>	
						<tbody>
							<tr>
								<th>작성자</th>
								<td>${rq.loginedMember.nickname }</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
									<textarea class="textarea textarea-bordered w-full" type="text" name="body"
										placeholder="댓글을 입력해주세요" rows="5"/></textarea>
								</td>
							</tr>
							<tr>
								<th></th>
								<td>
									<button class="btn btn-active btn-ghost" type="button" onclick="Reply__Write()">댓글작성</button>
								</td>
							</tr>
						</tbody>	
					</table>
				</form>
			</c:if>
			<c:if test="${rq.notLogined}">
				<a class="btn-text-link btn btn-active btn-ghost" href="${rq.loginUri}">로그인</a> 후 이용해주세요
			</c:if>
		</div>
	</section>
	
	<section class="mt-5">
	<div class="container mx-auto px-3">
		<h2>댓글 리스트(${replies.size() })</h2>
		<div class="replyList">
<!-- 		ajax로 리스팅 -->	
		</div>
	</div>
	</section>
<%@ include file="../common/foot.jspf" %>