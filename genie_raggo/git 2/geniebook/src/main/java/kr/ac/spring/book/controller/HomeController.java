package kr.ac.spring.book.controller;


import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.ac.spring.product.service.ProductService;
import kr.ac.spring.product.vo.ProductVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@Autowired						
	ProductService productService;  // productService 빈 주입

	@RequestMapping(value = "/", method = RequestMethod.GET)  // "/" 호출시 핸들러 실행
	public String home(Model model) throws Exception {

		List<ProductVO> productList = productService.listRecommendation();  // 랜덤한 도서가 출력되도록하는 sql문 실행
		
		model.addAttribute("productList", productList);      
		return "home";                                        // home.jsp에 sql문 실행한 결과를 보내줌
	}
	
}
