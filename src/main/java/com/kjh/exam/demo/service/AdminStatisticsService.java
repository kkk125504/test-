package com.kjh.exam.demo.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kjh.exam.demo.repository.AdminStatisticsRepository;

@Service
public class AdminStatisticsService {
	@Autowired
	private AdminStatisticsRepository adminStatisticsRepository;

	public Map getStatisticsByArticle(String startDate, String lastDate, int boardId) {
		Map statisticsMapByArticle = adminStatisticsRepository.getStatisticsByArticle(startDate, lastDate, boardId);
		return statisticsMapByArticle;
	}
}
