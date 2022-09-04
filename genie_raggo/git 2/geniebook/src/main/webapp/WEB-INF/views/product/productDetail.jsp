<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="stock" value="${product.stock}" />
<c:set var="rating" value="${rating}" />
<fmt:formatDate var="pubDate" value="${product.pubYear}"
	pattern="yyyy-MM-dd" />
<%
	request.setCharacterEncoding("UTF-8");
%>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex
			.exec(location.search);
	return results === null ? "" : decodeURIComponent(results[1].replace(
			/\+/g, " "));
}
function reviewList() {
	var bookNo = getParameterByName('bookNo');
	$.getJSON("${contextPath}/review/all/" + bookNo, function(data) {
		var str = "";

		$(data).each(
				function() {
					var loginId = "${pageContext.request.userPrincipal.name}";
					console.log(data);
					//alert("${memberId}");
					var reviewDate = new Date(this.reviewDate);
					reviewDate = reviewDate.toLocaleDateString("ko-US");
					if(loginId == this.memberId){
						str += "<ul><li id='review"+ this.reviewId +"' data-reviewId='" + this.reviewId + "'>"
								+ "<div class='memberId' >" + this.memberId +"님이 작성한 리뷰"+"<i class='fa fa-comment'></i>"
								+ "</div>" + "<span class='date'>" + reviewDate
								+ "</span>" + "</div>"
								+ "<div class='rating'>" + this.rating +"점"+"<i class='fa fa-star'></i>"
								+ "</div>" + "<div class='content' >" + this.content								
								+ "</div>"
								+ "<button type='button' onclick='updatebtn("+ this.reviewId +");' class='btn btn-success' data-toggle='modal' data-target='#updateReviewModal'>수정</button>"
								+ "</li></ul>";
					}else{
						str += "<ul><li id='review"+ this.reviewId +"' data-reviewId='" + this.reviewId + "'>"
							+ "<div class='memberId' >" + this.memberId+"님이 작성한 리뷰"+"<i class='fa fa-comment'></i>"
							+ "</div>" + "<span class='date'>" + reviewDate
							+ "</span>" + "</div>"
							+ "<div class='rating'>" + this.rating+"점"+"<i class='fa fa-star'></i>"
							+ "</div>" + "<div class='content' >" + this.content
							+ "</div>"
							+ "</li></ul>";
					}
					//alert(this.reviewId);
				});

		$('.reviewList').html(str);
	});
}
function insertReview() {
	var bookNo = getParameterByName('bookNo');
	var content = $('#reply').val();
	var memberId = $('#memberId').val();
	var rating = $('#rating').val(); // 화면에 평점 띄우기 위한 변수 추가
	//alert(memberId);
	//alert("content : " + content);
	$.ajax({
		type : "post",
		url : "${contextPath}/review",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}",
					"${_csrf.token}");
		},
		headers : {
			"Content-type" : "application/json",
			"X-HTTP-Method-Override" : "POST"
		},
		dataType : "text",
		data : JSON.stringify({
			memberId : memberId,
			rating : rating, // 평점 추가
			bookNo : bookNo,
			content : content
		}),
		success : function(result) {
			if (result == "insertSuccess") {
				alert('댓글 등록 완료!');
			}
			reviewList();
			$('.rating option:selected').value(); // 평점 선택 결과 출력 
			$('#reply').val('');
		}
	});
}

function updatebtn(no){
	var reviewId = no;
	$('#update_reviewId').val(reviewId);
} 

function updateReview(){
	var reviewId = $('#update_reviewId').val();
	var updateContent = $('#update_review').val();
	
	$.ajax({
		type : "put",
		url : "${contextPath}/review/" + reviewId,
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}",
					"${_csrf.token}");
		},
		headers : {
			"Content-type" : "application/json",
			"X-HTTP-Method-Override" : "PUT"
		},
		data : JSON.stringify({
			reviewId : reviewId,
			content : updateContent
		}),
		dataType : "text",
		success : function(result){
			console.log("result : " + result);
			if(result == "updateSuccess"){
				alert("댓글 수정 완료!");
				$("#updateReviewModal").modal("hide");
				reviewList();
			}
		}
	});
}

function deleteReview(){
	var reviewId = $('#update_reviewId').val();
	
	$.ajax({
		type : "delete",
		url : "${contextPath}/review/" + reviewId,
		beforeSend : function(xhr) {
			xhr.setRequestHeader("${_csrf.headerName}",
					"${_csrf.token}");
		},
		headers : {
			"Content-type" : "application/json",
			"X-HTTP-Method-Override" : "DELETE"
		},
		dataType : "text",
		success : function(result){
			console.log("result : " + result);
			if(result == "deleteSuccess"){
				alert("댓글 삭제 완료!");
				$("#updateReviewModal").modal("hide");
				reviewList();
			}
		}
	});
}
	function backToList(obj) {
		obj.action = "${contextPath}/board/listboards";
		obj.submit();
	}

	function go_to_cart(){
		var url = "api/cart/add/${product.bookNo}/"+$("#quantity").val();
		
		if(${pageContext.request.userPrincipal.name == null}){
			alert('로그인이 필요합니다.');
			location.href='login';
		}else{
			if(confirm('장바구니에 추가하시겠습니까?')){
			location.href=url;
			}
		}
	}
</script>

<div class="container">
	<div class="row">
		<div class="col-sm-9 padding-right">
			<div class="product-details">
				<!--product-details-->
				<div class="col-sm-5">
					<div class="view-product">
						<c:if test="${not empty product.imageFileName}">
							<img src="${contextPath}/download2.do?imageFileName=${product.imageFileName}"
								id="image" style="width: 280px; height: auto;" />
						</c:if>
					</div>
				</div>

				<div class="col-sm-7">
					<div class="product-information">
						<!--/product-information-->
						<h2>${product.bookName}</h2>
						
						<p>${product.writer}</p>
						<p>
							 <b>평점(참여한 유저수${ratingNum }) : </b>
						</p>
						<c:choose> 
							<c:when test="${rating == 5}">
								<img src="<c:url value="/resources/images/product-details/5_star.png"/>"/>
							</c:when> 
							<c:when test="${rating > 4   && rating < 5 }">
								<img src="<c:url value="/resources/images/product-details/4.5_star.png"/>"/>
							</c:when> 
							<c:when  test="${rating == 4}">
								<img src="<c:url value="/resources/images/product-details/4_star.png"/>"/>
							</c:when>
							<c:when test="${rating >3   && rating < 4 }">
								<img src="<c:url value="/resources/images/product-details/3.5_star.png"/>"/>
							</c:when>
							<c:when test="${rating == 3 }">
								<img src="<c:url value="/resources/images/product-details/3_star.png"/>"/>
							</c:when>
							<c:when test="${rating > 2   && rating < 3 }">
								<img src="<c:url value="/resources/images/product-details/2.5_star.png"/>"/>
							</c:when>
							<c:when test="${rating == 2 }">
								<img src="<c:url value="/resources/images/product-details/2_star.png"/>"/>
							</c:when>
							<c:when test="${rating > 1   && rating < 2 }">
								<img src="<c:url value="/resources/images/product-details/1.5_star.png"/>"/>
							</c:when>
							<c:when test="${rating == 1  }">
								<img src="<c:url value="/resources/images/product-details/1_star.png"/>"/>
							</c:when>
							<c:otherwise>
								<img src="<c:url value="/resources/images/product-details/0_star.png"/>"/>
							</c:otherwise> 
						</c:choose> 
						<br>
							<span> <span>${product.price}원</span> <label>수량:</label>
							<!-- <input type="text" value="1" id="quantity"/> -->
							<input type="number" value="1" name="stock" id="quantity"> <!-- 카운터기능구현 -->
							<c:if test="${pageContext.request.userPrincipal.name != 'admin'&& stock>0}">
							<button type="button" class="btn btn-fefault cart" onclick="go_to_cart()">
								<i class="fa fa-shopping-cart"></i> 장바구니
							</button>
							</c:if>
							<c:if test="${stock == 0 }"><button type ="button" class="btn btn-fefault cart" onclick="alert('재고가 없습니다. 빠른 시일내에 추가하겠습니다.');return false;">
							 <i class="fa fa-shopping-cart"></i> 장바구니</button></c:if>
						</span>
						<input id="price" type="hidden" value="${product.price}"/>
						
						
						
						<p>
							<b>남은 재고:</b> ${product.stock } <br>
							<c:if test="${0 < stock && stock < 5 }"><b style="color : red;">재고가 얼마 남지않았습니다!</b></c:if>
							<c:if test="${stock == 0 }"><b style="color : red;">재고가 없습니다! 빠른시일내에 추가하겠습니다</b></c:if>
						</p>
						<br>
						<p>
							<b>출판사:</b> ${product.publisher}
						</p>
						<br>
						<p>
							<b>출간날짜:</b> ${pubDate}
						</p>
					
						<p>
							<b>카테고리 : ${category} </b>
						</p>
						<p>
							<b id="point"></b>
							<script>
							   a = document.querySelector('#point');
							   a.innerText = ('적립가능한 포인트 : ' + ($("#price").val() * 0.02).toString() +'P') ;
						   </script>
						</p>
					</div>
					<!--/product-information-->
				</div>
			</div>

			<!--/product-details-->
			<div class="category-tab shop-details-tab">
				<!--category-tab-->
				<script type="text/javascript">
					function detail() {
						var detail = document.getElementById("reviews");
						detail.style.display = "none";
					}
					function review() {
						var review = document.getElementById("reviews");
						review.style.display = "block";
					}
				</script>
				<div class="col-sm-12">
					<ul class="nav nav-tabs">
						<li class="active"><a href="#details" onclick="detail();"
							data-toggle="tab">Details</a></li>
						<li><a href="#reviews" data-toggle="tab" onclick="review();">Review</a></li>
					</ul>
				</div>
				<div class="tab-content">
					<div class="tab-pane fade active in" id="details">
						${product.description }</div>

						<div class="tab-pane fade" id="reviews"
							style="margin: 0 auto; display: none;">
							
							
						<!-- 여기부터 댓글주석 -->


							<section class="content container-fluid">
								<div class="col-lg-12">
									<div class="box box-primary">
										<div class="box-header with-border">
											<h3 class="box-title">리뷰 작성</h3>
										</div>
										<div class="box-body">
											<c:if test="${pageContext.request.userPrincipal.name != null }">
												<div class="form-group">
													<label for="memberId">댓글 작성자</label><br> <input type="hidden"
														class="form-control" id="memberId" name="memberId"
														style="border: 0;" value="${pageContext.request.userPrincipal.name}" disabled> 
														<label >${pageContext.request.userPrincipal.name}님</label>
												</div>
												<div class="form-group">
													<label for="content">댓글 내용</label> 
													<div class="rating_div">
														<select class="ratingSelect" id="rating">
															<option value="">별점을 선택해주세요</option>
															<option value="0">최악</option>
															<option value="1">싫다</option>
															<option value="2">별로</option>
															<option value="3">보통</option>
															<option value="4">좋다</option>
															<option value="5">최고</option>
														</select>
													</div>
													<input type="text" class="form-control" id="reply" name="content"
														placeholder="댓글 내용을 입력해주세요." style="width: 100%;">
												</div>
												<div class="form-group">
													<a class="btn btn-primary" onclick="insertReview();">댓글 저장</a>
												</div>
											</c:if>
											<c:if test="${pageContext.request.userPrincipal.name == null  }">
												<label> <a href="${contextPath }/login">로그인</a> 하셔야 댓글을 작성할 수 있습니다. </label>
											</c:if>
										</div>
										<div class="box-footer">
											<section class="reviewList">
												<script>
													reviewList();
												</script>
											</section>
										</div>
									</div>
								</div>
							</section>
							
							<div class="modal fade" id="updateReviewModal" role="dialog">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">&times;</button>
											<h4 class="modal-title">댓글 수정창</h4>
										</div>
										<div class="modal-body">
											<div class="form-group">
													<label for="reviewId">댓글 번호</label> <input type="text"
														class="form-control" id="update_reviewId" name="reviewId"
														style="border: 0;" disabled>
											</div>
											<div class="form-group">
													<label for="memberId">댓글 작성자</label> <input type="text"
														class="form-control" id="update_memberId" name="memberId"
														style="border: 0;" value="${pageContext.request.userPrincipal.name}" disabled>
											</div>
											<div class="form-group">
												<label for="content">댓글 내용</label> <input type="text"
														class="form-control" id="update_review" name="content"
														placeholder="댓글 내용을 입력해주세요." style="width: 100%;">
											</div>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default pull-left" data-dismiss="modal">닫기</button>
											<button type="button" class="btn btn-success" onclick="updateReview();">수정</button>
											<button type="button" class="btn btn-danger" onclick="deleteReview();">삭제</button>
										</div>
									</div>
								</div>
							</div>
							<!-- 여기까지 댓글 주석  -->
							
							
							
						</div>

					</div>
				</div>
				<!--/category-tab-->
			</div>
		</div>
	</div>
</div>