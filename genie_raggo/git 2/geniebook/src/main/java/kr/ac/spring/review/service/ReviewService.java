package kr.ac.spring.review.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.spring.board.dao.BoardDAO;
import kr.ac.spring.review.dao.ReviewDAO;
import kr.ac.spring.review.vo.ReviewVO;

@Service("reviewService")
public class ReviewService {
	@Autowired
	ReviewDAO reviewDAO;
	
	public List<ReviewVO> selectReviewByBookNo(int bookNo) throws Exception {
		List<ReviewVO> reviewList = reviewDAO.selectReviewByBookNo(bookNo);
		return reviewList;
	}

	public void insertReview(ReviewVO reviewVO) throws Exception{
		 reviewDAO.insertReview(reviewVO);
	}

	public void updateReview(ReviewVO reviewVO) {
		reviewDAO.updateReview(reviewVO);
	}

	public void deleteReview(int reviewId) {
		reviewDAO.deleteReview(reviewId);
	}
	// 평균 평점 구하기
	public float selectRatingBybookNo(int  bookNo) {
		return reviewDAO.selectRatingBybookNo(bookNo);
	}
	// 평점 부여한 유저수 구하기
	public int selectRatingNum(int  bookNo) {
		return reviewDAO.selectRatingNum(bookNo);
	}
}
