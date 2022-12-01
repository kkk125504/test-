package com.kjh.exam.demo.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kjh.exam.demo.service.AdminStatisticsService;

@Controller
public class AdminStatisticsController {
	@Autowired
	private AdminStatisticsService adminStatisticsService;

	@RequestMapping("adm/statistics/article")
	@ResponseBody
	public Map getStatisticsData(String startDate, String lastDate,@RequestParam(defaultValue = "0") int boardId) {
		return adminStatisticsService.getStatisticsByArticle(startDate, lastDate, boardId);
	}
}
