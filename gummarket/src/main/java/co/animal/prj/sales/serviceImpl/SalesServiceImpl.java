package co.animal.prj.sales.serviceImpl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import co.animal.prj.common.DataSource;
import co.animal.prj.sales.service.SalesService;
import co.animal.prj.sales.service.SalesServiceMapper;
import co.animal.prj.sales.vo.SalesVO;

public class SalesServiceImpl implements SalesService {
	private SqlSession sqlSession = DataSource.getInstance().openSession(true);
	
	private SalesServiceMapper map = sqlSession.getMapper(SalesServiceMapper.class);
	@Override
	public List<SalesVO> salesSelectList() {
		// TODO Auto-generated method stub
		return map.salesSelectList();
	}

	@Override
	public List<SalesVO> salesSelect(SalesVO vo) {
		// TODO Auto-generated method stub
		return map.salesSelect(vo);
	}

	@Override
	public int salesUpdate(SalesVO vo) {
		// TODO Auto-generated method stub
		return map.salesUpdate(vo);
	}

	@Override
	public int salesDelete(SalesVO vo) {
		// TODO Auto-generated method stub
		return map.salesDelete(vo);
	}

	@Override
	public int salesInsert(SalesVO vo) {
		// TODO Auto-generated method stub
		return map.salesInsert(vo);
	}

	@Override
	public List<SalesVO> salesListTOP10() {
		// TODO top 10 인기상품 조회하기
		return map.salesListTOP10();
	}

}
