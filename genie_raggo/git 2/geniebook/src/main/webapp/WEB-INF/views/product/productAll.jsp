<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="price" value = "${product.price }"/>
<c:set var="stock" value = "${product.stock }"/>

<section>
	<div class="container">
		<div class="row">
			<div class="col-sm-9 padding-right">
				<div class="features_items">
					<!--features_items-->
					<c:if test="${empty searchWord }">
					<h2 class="title text-center">Features Items</h2>
					</c:if>
					<c:if test= "${searchType == '/geniebook/searchProductbyWriter'}">
					<h3 class="title text-center"><i class="fa fa-search-plus"></i>작가명"에대해 "${searchWord }"으로 검색한 결과입니다. </h3>
					</c:if>
					<c:if test= "${searchType == '/geniebook/searchProductbyTitle'}">
					<h3 class="title text-center"><i class="fa fa-search-plus"></i>"제목"에대해 "${searchWord }"으로 검색한 결과입니다. </h3>
					</c:if>
					<c:if test="${empty productList }">
					<h2 class="title text-center">검색 결과가 없습니다!</h2>
					</c:if>
					<c:forEach var="product" items="${productList}">
						<div class="col-sm-4">
							<div class="product-image-wrapper">
								<div class="single-products">
									<div class="productinfo text-center">
										<c:if test="${not empty product.imageFileName}">
											<img src="${contextPath}/download2.do?imageFileName=${product.imageFileName}"
												id="image" style="height: 300px;" />
										</c:if>
										<h2>${product.price}원</h2>
										<p>${product.bookName}</p>
										<a
											href="${contextPath}/productDetail?bookNo=${product.bookNo}"
											class="btn btn-default"><i class="fa fa-search"></i>상세 보기</a>
									
									</div>
									<div class="product-overlay">
										<div class="overlay-content">
											<h3>${product.bookName}</h3>
											<p>${product.writer }<p>
											<p>남은 재고 : ${product.stock}권</p>											
												
											<a
												href="${contextPath}/productDetail?bookNo=${product.bookNo}"
												class="btn btn-default add-to-cart"><i
												class="fa fa-search"></i>상세보기</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>


				</div>
				<!--features_items-->



			</div>

		</div>
		
	</div>
</section>