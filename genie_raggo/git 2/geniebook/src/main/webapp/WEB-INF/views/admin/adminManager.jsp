<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<style type="text/css">
table {
	text-align: center;
}

button {
	border-radius: 10px;
	background: #ca5d42;
	border: medium none;
	border-radius: 4;
	color: #FFFFFF;
	font-family: 'Roboto', sans-serif;
	padding: 4px 15px;
}
</style>
<meta charset="UTF-8">
<script type="text/javascript">
	function member_search() {

		location.href = "member_search?id=" + $("#member_search").val();
	}
	function sendMail_All() {

		location.href = "mailSending/all";
	}

	// 삭제 js
	function deleteConfirm(no){
		if(confirm("정말 삭제하시겠습니까?")){
			location.href="deleteProduct?bookNo="+no;
		} else {
			alert("삭제가 취소되었습니다.");
		}
	}
	function on_refresh(a,b){
		refresh(a);
		refresh(b);
	}
	function refresh(no){
		if(no > 0){
			alert('완료되었습니다.');
			location.href="adminManager";
		}else if(no == 0){
			alert('취소되었습니다.');
			location.href="adminManager";
		}
	}
</script>
</head>
<body onload="on_refresh(${deleteStatus},${insertStatus})">  <!-- 상품삭제, 등록시 새로고침 -->
 <!--category-tab-->
   <script type="text/javascript">
               function member() {
                  var member = document.getElementById("member");
                  var product = document.getElementById("product");
                  member.style.display = "block";
                  product.style.display = "none";
               }
               function product() {
                  var member = document.getElementById("member");
                  var product = document.getElementById("product");
                  member.style.display = "none";
                  product.style.display = "block";
               }
      </script>

   <div class="container">
      <div class="col-12">
         <ul class="nav nav-tabs">
            <li class="active"><a href="#member" data-toggle="tab"
               onclick="member();">회원관리</a></li>
            <li><a href="#product" data-toggle="tab" onclick="product();">상품관리</a></li>
         </ul>
      </div>
      <div class="tab_content">
         <div class="tab-pane fade active in" id="member">
            <div class="member-details">
               <p>
               <p>
                  <!--member-details-->
               <div class="view-member">
                  회원 ID <input type="text" id="member_search">
                  <button type="button" onClick="member_search()">검색</button>

                  <button type="button" onClick="sendMail_All()">모든 회원 메일 전송</button>

                  <table class="table" border="0"
                     style="margin-left: auto; margin-right: auto;">

                     <tr
                        style="background: #ca5d42; border: medium none; border-radius: 0; color: #FFFFFF; font-family: 'Roboto', sans-serif; padding: 6px 25px;">
                        <th>ID</th>
                        <th>이름</th>
                        <th>총 누적 금액</th>
                        <th>핸드폰 번호</th>
                        <th>메일 수신 여부</th>
                        <th></th>
                     </tr>
                     <c:forEach var="memberVO" items="${memberList}">
                        <tr >
                           <td>${memberVO.id}</td>
                           <td>${memberVO.name}</td>
                           <td>${memberVO.acc_Price}원</td>
                           <td>${memberVO.phoneNum}</td>
                           <td>${memberVO.receive_email}</td>
                           <td><button type="button" id=memberDetail onclick="location.href='memberDetail?id=${memberVO.id}'" class="button">
                           		상세보기</button></td>
                        </tr>
                     </c:forEach>

                  </table>
               </div>
            </div>
         </div>
         <div class="tab-pane fade" id="product">
            <div class="product-details">
               <!--product-details-->
               <div class="view-product"> <!-- 상품검색 -->
                  <form name="frmSearch" action="${formAction}" method="get">
						<select id="searchType" name="searchType" style = "width : 120px; height : 30px; margin-right : 0px; ">
							<option value="">검색조건</option>
							<option value="/geniebook/admin/adminbyTitle">책제목</option> 
							<option value="/geniebook/admin/adminbyCategory">카테고리</option>
							<option value="/geniebook/admin/adminbyWriter">작가</option>
							<option value="/geniebook/admin/adminbyPublisher">출판사</option>
						</select>
						<input name="searchWord" class="search_box" type="text" style = "margin-bottom : 0px;" > 
						<input type="submit" name="search" class="btn btn-default get"  value="검 색" onClick="searchType()"  style = "margin-bootom : 20px;">
						<c:if test= "${searchType == '/geniebook/admin/adminbyTitle'}">
					<h2 class="title text-center">"제목"에대해 "${searchWord }"(으)로 검색한 결과입니다. </h2>
					</c:if>
					<c:if test= "${searchType == '/geniebook/admin/adminbyCategory'}">
					<h2 class="title text-center">"카테고리"에대해 "${searchWord }"(으)로 검색한 결과입니다. </h2>
					</c:if>
					<c:if test= "${searchType == '/geniebook/admin/adminbyWriter'}">
					<h2 class="title text-center">"작가"에대해 "${searchWord }"(으)로 검색한 결과입니다. </h2>
					</c:if>
					<c:if test= "${searchType == '/geniebook/admin/adminbyPublisher'}">
					<h2 class="title text-center">"출판사"에대해 "${searchWord }"(으)로 검색한 결과입니다. </h2>
					</c:if>
					</form> 
					<script src="http://code.jquery.com/jquery-latest.min.js"></script>
					<script>
					    $(function() {
					        function searchType()
					        {
					            const formAction = $('#searchType').val();
					            if (!formAction || formAction == "") {
					                alert('옵션을 선택하세요!');
					                return false;
					            }
					
					            $('form[name=frmSearch]').attr('action', formAction);
					            $('form[name=frmSearch]').submit();
					            console.log(formAction);
					        }
					        $('input[name=search]').on('click', searchType);
					    });
					</script><!-- 상품검색끝 -->
                  <table class="table" border="0"
                     style="margin-left: auto; margin-right: auto;">

                     <tr
                        style="background: #ca5d42; border: medium none; border-radius: 0; color: #FFFFFF; font-family: 'Roboto', sans-serif; padding: 6px 25px;">
                        <th>ID</th>
                        <th>카테고리</th>
                        <th>책 이름</th>
                        <th>작가</th>
                        <th>출판사</th>
                        <th>가격</th>
                        <th><!-- <i class="fa fa-angle-down"></i><i class="fa fa-angle-up"></i> -->재고</th>
                        <th colspan="2"><button type="button"
                              style="float=right; background: white; border: medium none; border-radius: 0; color: #ca5d42; font-family: 'Roboto', sans-serif; padding: 4px 15px; border-radius: 10px;"
                              id="addProduct" onclick="location.href='addProductForm'" >
                              <b>상품 추가</b>
                           </button></th>
                     </tr>
                     <c:forEach var="productVO" items="${productList}">
                        <tr>
                           <td>${productVO.bookNo}</td>
                           <td>${productVO.category}</td>
                           <td>${productVO.bookName}</td>
                           <td>${productVO.writer}</td>
                           <td>${productVO.publisher}</td>
                           <td>${productVO.price}</td>
                           <td>${productVO.stock}</td>
                           <td><button type="button" id=productDetail
                                 onclick="location.href='productDetail?bookNo=${productVO.bookNo}'">더보기</button></td>
                           <td><button type="button" id=deleteProduct
                                 onclick="deleteConfirm(${productVO.bookNo})">삭제</button></td>
                        </tr>
                     </c:forEach>

                  </table>
               </div>
            </div>
         </div>
      </div>
   </div>
</body>
