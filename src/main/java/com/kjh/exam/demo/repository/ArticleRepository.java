package com.kjh.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.kjh.exam.demo.vo.Article;

@Mapper
public interface ArticleRepository {

	public void writeArticle(int loginedMemberId, String title, String body, int boardId, boolean secret);

	public Article getForPrintArticle(int id);

	public List<Article> getForPrintArticles(int boardId, int limitStart, int limitTake, String searchKeywordType, String searchKeyword);

	public void deleteArticle(int id);

	public void modifyArticle(int id, String title, String body, boolean secret);

	public int getLastInsertId();

	public int getArticlesCount(int boardId, String searchKeywordType, String searchKeyword);

	public int increaseHitCount(int id);
	
	public int getHitCount(int id);

	public int increaseGoodReactionPoint(int relId);

	public int increaseBadReactionPoint(int relId);
	
	@Update("""
			<script>
			UPDATE article
			SET goodReactionPoint = goodReactionPoint - 1
			WHERE id = #{relId}
			</script>
				""")
	public int decreaseGoodReactionPoint(int relId);

	@Update("""
			<script>
			UPDATE article
			SET badReactionPoint = badReactionPoint - 1
			WHERE id = #{relId}
			</script>
				""")
	public int decreaseBadReactionPoint(int relId);

	
	@Select("""
			SELECT * FROM article
			WHERE id = #{relId}
			""")
	public Article getArticle(int relId);
	
	

	@Select("""
			SELECT A.*, M.nickname AS extra__writer
			, COUNT(RP.id) AS extra__replyCount
			FROM article AS A
			INNER JOIN `member` AS M
			ON A.memberId = M.id 
			INNER JOIN reply AS RP
			ON A.id = RP.relId
			AND RP.relTypeCode = 'article'
			WHERE A.boardId = #{boardId}
			AND A.goodReactionPoint > 0	
			GROUP BY A.id		
			ORDER BY A.goodReactionPoint DESC
			LIMIT 0,3
			""")
	public List<Article> getForPrintBestArticles(int boardId);

}