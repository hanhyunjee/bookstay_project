package kr.ac.spring.review.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import kr.ac.spring.review.vo.ReviewVO;

@Repository("reviewDAO")
public class ReviewDAO {
	@Autowired
	private SqlSession sqlSession;

	public List<ReviewVO> selectReviewByBookNo(int bookNo) throws DataAccessException {
		List<ReviewVO> reviewList =  sqlSession.selectList("mapper.review.selectReviewByBookNo",bookNo);
		return reviewList;
	}

	public void insertReview(ReviewVO reviewVO) {
		sqlSession.insert("mapper.review.insertReview",reviewVO);
		
	}

	public void updateReview(ReviewVO reviewVO) {
		sqlSession.update("mapper.review.updateReview",reviewVO);
	}

	public void deleteReview(int reviewId) {
		sqlSession.delete("mapper.review.deleteReview", reviewId);
	}
	
	// 평균 평점
	public float selectRatingBybookNo(int  bookNo ) {
		float AvgRating= sqlSession.selectOne("mapper.review.selectRatingBybookNo", bookNo);
		return AvgRating;
	}
	// 평점 부과한 유저수
	public int selectRatingNum(int bookNo) {
		int RatingNum= sqlSession.selectOne("mapper.review.selectRatingNum", bookNo);
		return RatingNum;
	}
}
