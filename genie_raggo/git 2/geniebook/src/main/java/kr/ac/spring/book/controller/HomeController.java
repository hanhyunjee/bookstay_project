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
	ProductService productService;  // productService �� ����

	@RequestMapping(value = "/", method = RequestMethod.GET)  // "/" ȣ��� �ڵ鷯 ����
	public String home(Model model) throws Exception {

		List<ProductVO> productList = productService.listRecommendation();  // ������ ������ ��µǵ����ϴ� sql�� ����
		
		model.addAttribute("productList", productList);      
		return "home";                                        // home.jsp�� sql�� ������ ����� ������
	}
	
}
