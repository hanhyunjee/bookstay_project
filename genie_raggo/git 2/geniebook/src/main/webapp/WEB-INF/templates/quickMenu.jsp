<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<script>
	
	
	var array_index=0;
	var SERVER_URL="${contextPath}/thumbnails";
	function fn_show_next_product(){  /* 다음 버튼 클릭시 실행 */
		var img_sticky=document.getElementById("img_sticky");
		var cur_product_num=document.getElementById("cur_product_num"); 
		var _h_bookNo=document.frm_sticky.h_bookNo;
		var _h_product_fileName=document.frm_sticky.h_product_fileName;
		if(array_index <_h_bookNo.length-1) /* 최근 본 상품 리스트의 개수보다 작으면 */
			array_index++;                  /* 1씩 늘림 */
		 	
		var bookNo=_h_bookNo[array_index].value;             
		var fileName=_h_product_fileName[array_index].value;  /* 퀵메뉴의 페이지가 1이었다면, 두번째 배열 */
		img_sticky.src=SERVER_URL+"?bookNo="+bookNo+"&imageFileName="+fileName;  /* 이미지 주소 설정 */
		cur_product_num.innerHTML=array_index+1; /* 퀵메뉴의 페이지를 1증가 */
	}
/* 맨처음 array_index=0에서 시작. 
 * 함수 실행
 * array_index가 최근 본 상품 개수보다 작으므로 증가하지 않음.
 * 상품 리스트 배열의 0번째 인덱스를 가져옴
 * 페이지 숫자를 나타내는 cur_product_num의 텍스트를 1로 늘림
 */

 function fn_show_previous_product(){ // 이전 버튼 눌렀을 때 이전에 봤던 상품 보여준다
	var img_sticky=document.getElementById("img_sticky");
	var cur_product_num=document.getElementById("cur_product_num"); // 퀵메뉴 페이지 넘버
	var _h_bookNo=document.frm_sticky.h_bookNo;
	var _h_product_fileName=document.frm_sticky.h_product_fileName;
	
	if(array_index >0) // 페이지가 넘어가야하므로 마이너스
		array_index--;
	
	var bookNo=_h_bookNo[array_index].value;
	var fileName=_h_product_fileName[array_index].value;
	img_sticky.src=SERVER_URL+"?bookNo="+bookNo+"&imageFileName="+fileName;
	cur_product_num.innerHTML=array_index+1;  /* -1 같은데 확인필요 */
}

function productDetail(){ // 클릭 시 책 상세 페이지로 넘어감
	var cur_product_num=document.getElementById("cur_product_num");
	arrIdx=cur_product_num.innerHTML-1;
	
	var img_sticky=document.getElementById("img_sticky");
	var h_bookNo=document.frm_sticky.h_bookNo; // form name=frm_sticky 안의 h_bookNo, 즉 
	var len=h_bookNo.length; // 가져온 bookNo의 길이
	
	if(len>1){
		bookNo=h_bookNo[arrIdx].value; // 개수가 1개 초과하면 배열로 정리 
	}else{
		bookNo=h_bookNo.value; // 아니라면 1개 등장
	}
	
	
	var formObj=document.createElement("form");
	var i_bookNo = document.createElement("input"); 
    
	i_bookNo.name="bookNo";
	i_bookNo.value=bookNo;
	
    formObj.appendChild(i_bookNo);
    document.body.appendChild(formObj); 
    formObj.method="get";
    formObj.action="${contextPath}/productDetail?bookNo="+bookNo;
    formObj.submit();
	
	
}
</script>  
 
<body>
	 <!-- 장바구니,큐앤에이, 마이페이지 바로가기 -->
    <div id="sticky"  >
	<ul>
		<li ><a href="${contextPath }/board/listboards">
		   <img	width="24" height="24" src="${contextPath}/resources/images/home/free-icon-qa-6369389.png">
				Q&A
		</a></li>
		<c:if test="${pageContext.request.userPrincipal.name != null  }">
		<li><a href="${contextPath }/memberInfo_ui">
		   <img width="24" height="24" src="${contextPath}/resources/images/home/account.png">
				myPage
		</a></li>
		<li><a href="${contextPath }/cart">
		   <img	width="24" height="24" src="${contextPath}/resources/images/home/shopping-cart.png">
				Cart
		 </a></li>
		</c:if>
	</ul>
	<!-- 바로가기 끝 -->
	<div class="recent">
		<h3>최근 본 상품</h3>
		  <ul>
		<!--   상품이 없습니다. -->
		<!-- choose 안에 when if 문처럼 사용 -->
		 <c:choose>
			<c:when test="${ empty quickProductList }">
				     <strong>상품이 없습니다.</strong>
			</c:when>
			<c:otherwise>
	       <form name="frm_sticky">	        
		      <c:forEach var="item" items="${quickProductList }" varStatus="itemNum">
		         <c:choose>
		           <c:when test="${itemNum.count==1 }"> <!-- 최근 본 상품이 1개라도 있으면 썸네일 뜬다 -->
			      <a href="javascript:productDetail();">
			  	         <img width="75" height="95" id="img_sticky"  
			                 src="${contextPath}/thumbnails?bookNo=${item.bookNo}&imageFileName=${item.imageFileName}"> <!--  이미지 썸네일  -->
			      </a>
			        <input type="hidden"  name="h_bookNo" value="${item.bookNo}" />
			        <input type="hidden" name="h_product_fileName" value="${item.imageFileName}" />
			      <br>
			      </c:when>
			      <c:otherwise>
			        <input type="hidden"  name="h_bookNo" value="${item.bookNo}" />
			        <input type="hidden" name="h_product_fileName" value="${item.imageFileName}" />
			      </c:otherwise>
			      </c:choose>
		     </c:forEach>
		   </c:otherwise>
	      </c:choose>
		 </ul>
    	 </form>		 
	</div>
	 <div>
	 <c:choose>
	    <c:when test="${ empty quickProductList }">
		    <h5>  &nbsp; &nbsp;  0/0  &nbsp; </h5>
	    </c:when>
	    <c:otherwise>
           <h5><a  href='javascript:fn_show_previous_product();'> 이전 </a> &nbsp;  <span id="cur_product_num">1</span>/${quickProductListNum} 
            &nbsp; <a href='javascript:fn_show_next_product();'> 다음 </a> </h5>
       </c:otherwise>
       </c:choose>
    </div>
</div>
</body>
</html>
 
