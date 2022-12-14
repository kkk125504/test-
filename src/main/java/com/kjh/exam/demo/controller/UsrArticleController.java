package com.kjh.exam.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kjh.exam.demo.service.ArticleService;
import com.kjh.exam.demo.service.BoardService;
import com.kjh.exam.demo.service.ReactionPointService;
import com.kjh.exam.demo.service.ReplyService;
import com.kjh.exam.demo.util.Ut;
import com.kjh.exam.demo.vo.Article;
import com.kjh.exam.demo.vo.Board;
import com.kjh.exam.demo.vo.Reply;
import com.kjh.exam.demo.vo.ResultData;
import com.kjh.exam.demo.vo.Rq;

@Controller
public class UsrArticleController {

	@Autowired
	private ArticleService articleService;
	@Autowired
	private BoardService boardService;
	@Autowired
	private ReplyService replyService;
	@Autowired
	private ReactionPointService reactionPointService;
	@Autowired
	private Rq rq;

	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, int id) {
			
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);
		
		if(article.isSecret()) {
			if(rq.getLoginedMemberId() != article.getMemberId()) {
				return rq.jsReplaceOnView("ποΈ λΉλ°κΈμλλ€.");
			}
		}
		
		ResultData actorCanMakeReactionRd = reactionPointService.actorCanMakeReaction(rq.getLoginedMemberId(),"article", id);

		model.addAttribute("article", article);
		model.addAttribute("actorCanMakeReactionRd", actorCanMakeReactionRd);
		model.addAttribute("actorCanMakeReaction", actorCanMakeReactionRd.isSuccess());
		
		List<Reply> replies = replyService.getForPrintReplies(rq.getLoginedMember(),"article",id);
		model.addAttribute("replies",replies);
		
		if (actorCanMakeReactionRd.getResultCode().equals("F-2")) {
			int sumReactionPointByMemberId = (int) actorCanMakeReactionRd.getData1();

			if (sumReactionPointByMemberId > 0) {
				model.addAttribute("actorCanCancelGoodReaction", true);
			} else {
				model.addAttribute("actorCanCancelBadReaction", true);
			}
		}
		return "usr/article/detail";
	}

	@RequestMapping("/usr/article/list")
	public String showList(Model model, @RequestParam(defaultValue = "1") int boardId,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int itemsInAPage,
			@RequestParam(defaultValue = "title,body") String searchKeywordType,
			@RequestParam(defaultValue = "") String searchKeyword) {
		Board board = boardService.getBoardById(boardId);

		if (board == null) {
			return rq.jsHistoryBackOnView("μ‘΄μ¬νμ§ μλ κ²μν μλλ€.");
		}				

		List<Article> articles = articleService.getForPrintArticles(rq.getLoginedMemberId(), boardId, page,
				itemsInAPage, searchKeywordType, searchKeyword);
		
		List<Article> bestArticles = articleService.getForPrintBestArticles(boardId);
		if(bestArticles.isEmpty() == false) {
			model.addAttribute("bestArticles", bestArticles);
		}
		
		int articlesCount = articleService.getArticlesCount(boardId, searchKeywordType, searchKeyword);
		int pagesCount = (int) Math.ceil((double) articlesCount / itemsInAPage);
		model.addAttribute("articles", articles);
		model.addAttribute("board", board);
		model.addAttribute("articlesCount", articlesCount);
		model.addAttribute("page", page);
		model.addAttribute("pagesCount", pagesCount);
		return "usr/article/list";
	}

	@RequestMapping("/usr/article/write")
	public String showWrite() {
		return "usr/article/write";
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(String title, String body, int boardId, boolean secret) {

		if (Ut.empty(title)) {
			return rq.jsHistoryBack("μ λͺ©μ μλ ₯ν΄ μ£ΌμΈμ.");
		}
		if (Ut.empty(body)) {
			return rq.jsHistoryBack("λ΄μ©μ μλ ₯ν΄ μ£ΌμΈμ.");
		}
		ResultData<Integer> writeRd = articleService.writeArticle(rq.getLoginedMemberId(), title, body, boardId, secret);

		int id = (int) writeRd.getData1();

		return rq.jsReplace(Ut.f("%dλ² κ²μλ¬Όμ΄ μμ± λμμ΅λλ€.", id), Ut.f("../article/detail?id=%d", id));
	}

	@RequestMapping("/usr/article/modify")
	public String showModify(Model model, int id) {
		
		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);
		model.addAttribute("article", article);

		if (article == null) {
			return rq.jsHistoryBackOnView(Ut.f("%dλ² κ²μλ¬Όμ μ‘΄μ¬νμ§ μμ΅λλ€.", id));
		}

		ResultData actorCanModifyRd = articleService.actorCanModify(rq.getLoginedMemberId(), article);

		if (actorCanModifyRd.isFail()) {
			return rq.jsHistoryBackOnView(actorCanModifyRd.getMsg());
		}
		
		return "usr/article/modify";
	}

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(int id, String title, String body, boolean secret, String replaceUri) {

		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);

		if (article == null) {
			return rq.jsHistoryBack(Ut.f("%dλ² κ²μλ¬Όμ μ‘΄μ¬νμ§ μμ΅λλ€.", id));
		}

		ResultData actorCanModifyRd = articleService.actorCanModify(rq.getLoginedMemberId(), article);
		if (actorCanModifyRd.isFail()) {
			return rq.jsHistoryBack(actorCanModifyRd.getMsg());
		}

		articleService.modifyArticle(id, title, body, secret);
		return rq.jsReplace(Ut.f("%dλ² κ²μλ¬Ό μμ ", id), replaceUri);
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {

		Article article = articleService.getForPrintArticle(rq.getLoginedMemberId(), id);

		if (article == null) {
			return rq.jsHistoryBack(Ut.f("%dλ² κ²μλ¬Όμ μ‘΄μ¬νμ§ μμ΅λλ€.", id));
		}
		if (rq.getLoginedMemberId() != article.getMemberId()) {
			return rq.jsHistoryBack("ν΄λΉ κ²μλ¬Όμ λν μ­μ  κΆνμ΄ μμ΅λλ€.");
		}

		articleService.deleteArticle(id);

		return rq.jsReplace(Ut.f("%dλ² κ²μλ¬Όμ μ­μ  νμ΅λλ€.", id), Ut.f("../article/list?boardId=%d", article.getBoardId()));
	}
	
	@RequestMapping("/usr/article/doIncreaseHitCountRd")
	@ResponseBody
	public ResultData<Integer> doIncreaseHitCount(int id){
		ResultData<Integer> increaseHitCountRd = articleService.increaseHitCount(id);
		if(increaseHitCountRd.isFail()) {
			return increaseHitCountRd;
		}
		int hitCount = articleService.getHitCount(id);
		ResultData<Integer> rd = ResultData.newData(increaseHitCountRd, "hitCount", hitCount);
		rd.setData2("id",id);
		return rd;
	}

}