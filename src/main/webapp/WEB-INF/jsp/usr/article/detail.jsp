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
			ReOfRe__list();
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
	var replyIds = [];
	var index = 0;
	function replyList() {
 	 var replyContent = "";
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
			  if(data.data1 == null){
			  replyContent += "";
			  return;
  			  }
 			 $(data.data1).each(function(){
			  var loginedMemberId = ${rq.loginedMemberId};
			  var replyMemberId= this.memberId;
			  var params__reply = '\''+this.id+'/'+this.regDate+'/'+this.body+'/'+this.extra__writerName+'\'';			
			  replyIds[index] = this.id;
  			  index++;
			  replyContent += '<div class="divider"></div>';
			  replyContent += '<div id = "reply'+ this.id +'">';
			  replyContent += '<div><span class="font-extrabold">';
			  replyContent += this.extra__writerName +'</span>';
			  
			  //댓글 삭제, 수정버튼
			  if(loginedMemberId == replyMemberId){
			  replyContent += '<button class="ml-4" onclick="Reply__ModifyForm('+params__reply+');">수정</button>';			   
			  replyContent += '<button class="ml-2" onclick="Reply__delete('+this.id+');">삭제</button>';
			  }

			  //답글쓰기 버튼 노출
			  if(${rq.isLogined()}){
			  replyContent += '<button class="ml-20" onclick="ReOfRe__WriteForm('+this.id+')">답글쓰기</button>';
			  }
			  replyContent += '</div>';
	   		  replyContent += '<div><span class="font-extrabold">'+this.regDate +'</span></div>';
			  replyContent += '<div><span class="input input-bordered w-full max-w-xs">';  
			  replyContent += this.body+'</span></div>';  
   			  replyContent += '</div>';
   			  
			  replyContent += '<div id="ReOfRe__writeForm'+this.id+'"></div>';
			  
			   // 댓글의 댓글 리스트
			   replyContent += '<div id= re'+this.id+'></div>';
			  	});  
			   $('.replyList').html(replyContent);
				        }
					  });
				}
	
		function ReOfRe__list(){
		  if(replyIds.length > 0){
		  for(let i  = 0; i < replyIds.length; i++){	
		  var replyId = replyIds[i];
		  var rorContent = "";
	    	$.ajax({
	          type: "GET",
	          url: "../reply/getReplies",
	          dataType: "json",
	      	  async : false,
	      	  data : { "relId" : replyId , "relTypeCode" : "reply"},
	          error: function() {
	            console.log('통신실패!!');
	          },
	          success: function(data) {
	          	
	          	if(data.data1 == null){
	            return;
	          	}
          
          	$(data.data1).each(function(){
          	var loginedMemberId = ${rq.loginedMemberId};
   			var replyMemberId= this.memberId;
            rorContent += '<div class="ml-12 mt-2" id = "reply'+ this.id +'">'
            rorContent += '<div><span class="font-extrabold">↳&nbsp;&nbsp;'
            rorContent += this.extra__writerName +'</span>';
           
            if(loginedMemberId == replyMemberId){ 			  
            	rorContent += '<button class="ml-2" onclick="Reply__delete('+this.id+');">삭제</button>';
  			  }
            rorContent += '</div>';          	
            rorContent += '<div><span class="mx-8">';  
            rorContent += this.body+'</span></div>';
            rorContent += '</div>';           
            });
            $('#re'+replyId).html(rorContent);   
            }
   			   });
 		  }
	  }  
	}
  
	function Reply__Write() {  
	  $.get('../reply/doWrite', {
	  relId : params.id,
	  relTypeCode : $('input[name=relTypeCode]').val(),
	  body : $('textarea[name=body]').val()
	  }, function(data) {
	  if(data.fail){
	  alert(data.msg);
	  	}	  
	  }, 'json');	
	  replyList();
	  ReOfRe__list();
	}
	
	function ReOfRe__Write(replyId) {
	  $.get('../reply/doWrite', {
	  relId : replyId,
	  relTypeCode : 'reply',
	  body : $('input[name=ReOfRe'+replyId+']').val()
	  }, function(data) {
	  if(data.fail){
	  alert(data.msg);
	  }
	  replyList();
	  ReOfRe__list();
	  }, 'json');	
	}
	
	function ReOfRe__WriteForm(replyId) {
  		var content = '<div>답글쓰기 : <input name="ReOfRe'+replyId+'" type="text" class="input input-bordered input-lg mt-2"/>';
  		content += '<button type="button" class="mx-4" onclick="ReOfRe__Write('+replyId+')">작성</button>';
  		content += '<button type="button" onclick="replyList(); ReOfRe__list();">취소</button></div>';
  		$('#ReOfRe__writeForm'+replyId).html(content);
	}
  
 function Reply__ModifyForm(params__reply) {	 	
	   var params__replySplit = params__reply.split('/');
	   var replyId = params__replySplit[0];
	   var regDate = params__replySplit[1];
	   var body = params__replySplit[2];
	   var replyWriter = params__replySplit[3];

	   var replyModifyContent= '';
	   replyModifyContent += '<form>'
	   replyModifyContent += '<div>';
	   replyModifyContent += '<span class="font-extrabold">';
	   replyModifyContent += replyWriter +'</span>';		  				 		 		 
	   replyModifyContent += '</div>';
	   replyModifyContent += '<div><span class="font-extrabold">'+ regDate +'</span></div>';
	   replyModifyContent += '<div>';
	   replyModifyContent += '<input type="hidden" name="id" value="'+replyId+'"/>';
	   replyModifyContent += '<input class="input input-bordered w-full max-w-xs" name="body" value="'+body+'"/>';
	   replyModifyContent += '<button type="button" onclick="Reply__Modify(form);">수정</button>';
	   replyModifyContent += '<button type="button" onclick="replyList(); ReOfRe__list();">취소</button>';
	   replyModifyContent += '</form>';
	   
	   $('#reply'+replyId).html(replyModifyContent);   
 	}
	
	//댓글 삭제
	function Reply__delete(id) {
	  $.get('../reply/doDelete', {
	  id : id,
	  ajaxMode : 'Y'
	  }, function(data) {  	  
	  }, 'json');
	  replyList();
      ReOfRe__list();
	}
	
	//댓글 작성
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
		    ReOfRe__list();
		}, 'json');	
	}	
	// 댓글 수정 폼
	function Reply__Modify(form) {					
		$.get('../reply/doModify', {
			id : form.id.value,
			body : form.body.value
		}, function(data) {
			if(data.fail){
				alert(data.data.msg);
				return;
			}
			replyList();
		    ReOfRe__list();
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
						<a class ="mx-4 btn-text-link btn btn-active btn-ghost" href="modify?id=${article.id }&replaceUri=${rq.encodedCurrentUri}">수정</a>				
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