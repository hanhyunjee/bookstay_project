package kr.ac.spring.product.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.ac.spring.product.service.ProductService;
import kr.ac.spring.product.vo.ProductVO;
import kr.ac.spring.review.service.ReviewService;
import net.sf.json.JSONObject;

@Controller
public class ProductControllerImpl implements ProductController {
	@Autowired
	private ProductService productService;

	@Autowired 
	private ReviewService reviewService;  // 평균 평점 구하려고 리뷰 서비스 빈 주입
	
	// 세션 이용시 추가
	// HttpSession session=request.getSession();
	// session.setAttribute("productVO", productVO);
	@Override
	@RequestMapping(value = "/productDetail", method = RequestMethod.GET)
	public ModelAndView productDetail(@RequestParam("bookNo") int bookNo, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
//		String viewName = (String) request.getAttribute("viewName"); 
		float AvgRating = reviewService.selectRatingBybookNo(bookNo);  // 책번호로 평균 평점 구하기
		int ratingNum = reviewService.selectRatingNum(bookNo);
		System.out.println("평점:" +AvgRating);
		System.out.println("참여한 사람 수 : " + ratingNum);
		ProductVO product = productService.bookDetail(bookNo);
		HashMap<String, String> categories = new HashMap<String, String>();
		
		String[][] categories_String = { { "novel1", "나라별소설" }, { "novel2", "고전/문학" }, { "novel3", "장르소설" },
				{ "poem1", "한국시" }, { "poem2", "외국시" }, { "poem3", "여행 에세이" }, { "selfDevelopment1", "대화/협상" },
				{ "selfDevelopment2", "자기능력계발" }, { "liberal1", "인문일반" }, { "liberal2", "심리" }, { "liberal3", "철학" },
				{ "child1", "어린이(공통)" }, { "child2", "초등" }, };
		
		for (String[] c : categories_String) {
			categories.put(c[0], c[1]);
		}
		String category = product.getCategory();        // novel1을 뽑아와서
		String realCategory = categories.get(category); // novel1(key) 에 해당하는 나라별소설(value)를 가져온다 
		
		
		
//		System.out.println("imageFileName : " + product.getImageFileName());
		ModelAndView mav = new ModelAndView();
		mav.addObject("ratingNum",ratingNum);
		mav.addObject("rating", AvgRating);
		mav.addObject("product", product);   
		mav.addObject("category", realCategory); 
		System.out.println(mav.getViewName());    
		addProductInQuick(bookNo,product,session);  // 최근 본 상품목록에 추가
		return mav;                                                 
	}   
	
	
	@RequestMapping(value = "/category/{categoryName}/{categoryNum}", method = RequestMethod.GET)   // "/category/novel/1" , 1은 나라별소설 2는 고전소설 3은 장르소설
	public ModelAndView productByCategory(@PathVariable("categoryName") String categoryName, @PathVariable("categoryNum") String num, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String category = categoryName+num;  // novel1 => product 테이블의 category 컬럼 참고
		HashMap<String, String> categories = new HashMap<String, String>();
		
		String[][] categories_String = { { "novel1", "나라별소설" }, { "novel2", "고전/문학" }, { "novel3", "장르소설" },
				{ "poem1", "한국시" }, { "poem2", "외국시" }, { "poem3", "여행 에세이" }, { "selfDevelopment1", "대화/협상" },
				{ "selfDevelopment2", "자기능력계발" }, { "liberal1", "인문일반" }, { "liberal2", "심리" }, { "liberal3", "철학" },
				{ "child1", "어린이(공통)" }, { "child2", "초등" }, };
		
		for (String[] c : categories_String) {
			categories.put(c[0], c[1]);
		}
		String realCategory = categories.get(category); // novel1(key) 에 해당하는 나라별소설(value)를 가져온다
		System.out.println(realCategory);
		List<ProductVO> productList = productService.listProductByCategory(category);
		ModelAndView mav = new ModelAndView("productByCategory");
		mav.addObject("productList", productList);
		mav.addObject("category",realCategory);
		return mav;   // 이것도 viewName 지정 안했는데 정상 출력..
	}

	@Override
	@RequestMapping("/productAll")
	public ModelAndView productAll(HttpServletRequest request) throws Exception {
		System.out.println("productAll");
		
		String viewName = (String) request.getAttribute("viewName");
		System.out.println("viewName : " +viewName);
		List<ProductVO> productList = productService.listProductAll();
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("productList", productList);
		System.out.println("viewName : " + mav.getView());
		return mav;
		
	}
	
	@RequestMapping(value="/keywordSearch",method = RequestMethod.GET,produces = "application/text; charset=utf8")
	public @ResponseBody String keywordSearch(@RequestParam("keyword") String keyword,
			                                  HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		System.out.println(keyword);
		if(keyword == null || keyword.equals(""))
		   return null ;
	
		keyword = keyword.toUpperCase();
	    List<String> keywordList =productService.keywordSearch(keyword);
	    
	 // 최종 완성될 JSONObject 선언(전체)
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("keyword", keywordList);
		 		
	    String jsonInfo = jsonObject.toString();
	    System.out.println(jsonInfo);
	    return jsonInfo ;
	}
	
	@RequestMapping(value="/searchProductbyTitle" ,method = RequestMethod.GET)
	public ModelAndView searchProductbyTitle(@RequestParam("searchWord") String searchWord, @RequestParam("searchType") String searchType,
			                       HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		List<ProductVO> productList= productService.searchProductbyTitle(searchWord);
		ModelAndView mav = new ModelAndView("productAll");
		mav.addObject("searchType",searchType);
		mav.addObject("searchWord",searchWord);
		mav.addObject("productList", productList);
		return mav;
		}
	
	@RequestMapping(value="/searchProductbyWriter" ,method = RequestMethod.GET)
	public ModelAndView searchProductbyWriter(@RequestParam("searchWord") String searchWord, @RequestParam("searchType") String searchType,
			                       HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		List<ProductVO> productList= productService.searchProductbyWriter(searchWord);
		ModelAndView mav = new ModelAndView("productAll");
		mav.addObject("searchType",searchType);
		mav.addObject("searchWord",searchWord);
		mav.addObject("productList", productList);
		return mav;
		}
	
	// 퀵메뉴에 최근본상품들 추가
	private void addProductInQuick(int BookNo,ProductVO productVo,HttpSession session){
		boolean already_existed=false;
		List<ProductVO> quickProductList; //최근 본 상품 저장 ArrayList
		quickProductList=(ArrayList<ProductVO>)session.getAttribute("quickProductList");
		
		if(quickProductList!=null){          // 최근 본 상품목록이 있다면,
			if(quickProductList.size() < 4){ //미리본 상품 리스트에 상품개수가 세개 이하인 경우
				for(int i=0; i<quickProductList.size();i++){ 
					ProductVO _goodsBean=(ProductVO)quickProductList.get(i); // 상품 목록을 가져온다
					if(BookNo==_goodsBean.getBookNo()){  // 이미 존재하는 상품인지 비교 
						already_existed=true;            // 존재하면 true 
						break;
					}
				}
				if(already_existed==false){              // false이면 
					quickProductList.add(productVo);     // 상품 정보를 목록에 저장 
				}
			}
			
		}else{                                // 최근 본 상품목록이 없다면, 
			quickProductList =new ArrayList<ProductVO>();
			quickProductList.add(productVo);  // 새로 생성하여 목록에 저장 
			
		}
		System.out.println("quickProductList : " + quickProductList);
		session.setAttribute("quickProductList",quickProductList);  // 최근 본 상품 리스트를 세션에 저장
		session.setAttribute("quickProductListNum", quickProductList.size());  // 최근 본 상품 갯수를 세션에 저장
	}
	
	
		
	}

