package com.kjh.exam.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrAPITestController {
	
	@RequestMapping("/usr/test/APITest")	
	public String APITest(){
		return "usr/test/APITest";
	}

}