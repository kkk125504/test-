package com.kjh.exam.demo.repository;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AdminStatisticsRepository {
	@Select("""			
			<script>
			SELECT IFNULL(COUNT(*),0) AS articlesCount, 
			IFNULL(SUM(hitCount),0) AS totalViews, 
			IFNULL(AVG(hitCount),0) AS averageViews, 
			IFNULL(MAX(hitCount),0) AS topViews 
			FROM article
			WHERE regDate BETWEEN CONCAT(#{startDate}, ' 00:00:00') AND CONCAT(#{lastDate}, ' 23:59:59')
			<if test="boardId != 0">	
			AND boardId = #{boardId}
			</if>
			</script>
			""")	
	Map getStatisticsByArticle(String startDate, String lastDate, int boardId);
}
