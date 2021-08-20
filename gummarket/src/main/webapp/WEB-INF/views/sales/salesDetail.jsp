<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<script>
	
	
	
	//삭제버튼 누르면 alert
	function confirmDel(n) {
	   alert("글을 삭제할까요?");
	   if(confirm("삭제되었습니다.")){
	
	    frm.sNo.value= n;
		frm.submit();
	  
	   }else{
	    return false;
	   }
	  }
	
	//글 수정
	function updateSales(n) {
		frm1.sNo.value=n;
		frm1.submit();
		//location.href='updateSales.do';
	}

	
//------------------------------댓글용-------------------------------//

	//댓글 불러오기 ajax
	$(document).ready(function(){
		// 수정 폼 숨기기
		$('#showComUpdate').hide();
		
		console.log($('#cMainNum'));
		//전체 데이터 출력.
		$.ajax({
			url: 'SelectCommentServ',
			method:'post',
			dataType: 'json',
			data: {
				sNo:$('#cMainNum').val()
			},
			success: itemListFnc,
			error: function () {
				console.log("으악")
			}
	});
		

	let fields = ['cmId', 'cContents'];
	//댓글 조회 콜백함수
	function itemListFnc(data) {
		console.log(data);	
	if(data[0]['cNo']!=0){ //글 있을 때만 보이게 하기 위해 
		
		for (let i = 0; i < data.length; i++) {  
			const divCase = $('<div />').attr('class', 'd-flex justify-content-between').attr("id", data[i]['cNo']);
	         const divMain = $('<div />').attr('class', 'd-flex align-items-center');
	         let img =$('<img />').attr('class', 'rounded-circle').attr('src','img/undraw_profile_1.svg').css({
	               "width": "2rem",
	               "height": "2rem"
	             });
	         let userName = $('<span />').css("font-size","1.5rem").text(data[i]['cmId']).addClass("pl-2");
	         let comment = $('<span />').css({"font-size": "1.5rem","margin-left": "30px" }).text(data[i]['cContents']);
	         divMain.append(img ,userName, comment);
	         
	         console.log(data[i]['cmId']);
	         $(divCase).append(divMain);
	        	 
		         const btnDiv =$('<div />');
		         const delBtn=$('<button />').attr("class", "btn btn-warning mr-2").css("float", "right").text("Delete");
		         const updBtn=$('<button />').attr("class", "btn btn-warning mr-2").css("float", "right").text("Edit");
		         
			         //신고하기(신고하기 어디로???)
			         const reportForm = $('<form/>').attr('action', '#');
			         const reportBtn 
			         	= $('<a />').addClass("btn btn-danger btn-sm")
			         				.attr({
			         					'href':"#",
			         					"data-toggle":"modal",
			         					"data-target":"#reportModal"
			         					})
			         				.append($('<i/>').addClass("fas fa-bullhorn").text('신고하기'));
		         
		         reportForm.append(reportBtn);
		         
		         reportBtn.click();
		         
		         delBtn.click(kill);
				 updBtn.click(update);
		         btnDiv.append(delBtn, updBtn);
		         
	         var mId = "<%=(String)session.getAttribute("mId")%>";
	         console.log(mId);
	         if(mId == data[i]['cmId']){
	        	 
		         $(divCase).append(btnDiv);
	         }
	         if(mId != data[i]['cmId']){
		         $(divCase).append(reportForm);
	         }
	         
	         
		$('#commentsBody').append(divCase);
	}
	      
	}
	}
	
	//댓글 입력 ajax
	$('#reply').on('submit', function (event) {
		event.preventDefault(); //디폴트값은 못들어가게
		let s = $('#reply').serialize();
		console.log(s);

		//폼 전송처리
		$.ajax({
			url: $('#reply').attr('action'), //='../AddItemServ.do'
			method: 'post',
			data: $('#reply').serialize(), //파라미터로 넘김
			dataType: 'json', //받아오는 값
			success: addItemFunc,
			error: function (reject) {
				console.error(reject);
			}
		})
	})
});

	let fields = ['cmId', 'cContents'];
	//입력처리 후 콜백함수
	function addItemFunc(data) { //{itmeNo: ?, itemName:? ......}
		console.log(data)
		const divCase = $('<div />').attr('class', 'd-flex justify-content-between').attr('id',data[cNo]);
	    const divMain = $('<div />').attr('class', 'd-flex align-items-center');
		
	        let img =$('<img />').attr('class', 'rounded-circle').attr('src','img/undraw_profile_1.svg').css({
	              "width": "2rem",
	              "height": "2rem"
	            });
	        let userName = $('<span />').css("font-size","1.5rem").text(data['cmId']);
	        let comment = $('<span />').css({"font-size": "1.5rem","margin-left": "30px" }).text(data['cContents']);
	        divMain.append(img, userName, comment);
	        
	        const btnDiv =$('<div />');
	        const delBtn=$('<button />').attr("class", "btn btn-warning mr-2").css("float", "right").text("Delete");
	        const updBtn=$('<button />').attr("class", "btn btn-warning mr-2").css("float", "right").text("Edit");
	        btnDiv.append(delBtn, updBtn);
	        delBtn.click(kill);
			updBtn.click(update);
	        $(divCase).append(divMain, btnDiv)
		$('#commentsBody').append(divCase);
	     
	}
		

	//댓글 삭제하기
	function kill(e) {
		console.log(e.target.parentNode.parentNode);
		//location.href='../DeleteServ.do?itemNo='+$(this).parent().children().eq(0).text();
		$.ajax({
			url: 'DeleteCommentServ',
			data: {
				cNo: $(this).parent().parent().attr('id')
			},
			success: function () {
				e.target.parentNode.parentNode.remove();
			},
			error: function () {
				alert("삭제에서 에러발생!!")
			}
		})
	}
	
	
	
	//업데이트 폼나오게 테스트! -> 성공!
	function update(e){
		
		let modForm = $("#showComUpdate");
		$(this).parent().append(modForm);
		console.log($(this).parent().parent().children().eq(0).children().eq(2).text());
		let content = $(this).parent().parent().children().eq(0).children().eq(2).text();
		let cNo = $(this).parent().parent().attr('id');// tr의 id값 가져옴~
		/* $(this).children().eq(0).hide(); */
		modForm.show();
		
		$(modForm).find("#cUpdated").val(content);
		$(modForm).find('#cNo').val(cNo);
	}
	
	//업데이트 -> 성공! 이름 
	function updateCom(){
		event.preventDefault(); //디폴트값은 못들어가게
		let s = $('#updateRep').serialize();

		//폼 전송처리
		$.ajax({
			url: $('#updateRep').attr('action'), 
			method: 'post',
			data: $('#updateRep').serialize(), //파라미터로 넘김
			dataType: 'json', //받아오는 값
			success: updateItemFunc,
			error: function (reject) {
				console.error(reject);
			}
		})
	}
	
	function updateItemFunc(data){
		
		$.ajax({
			url: 'UpdateCommentServ',
			data: {
				cNo: $(this).parent().attr('id')
			},
			success: function () {
				$('#'+data.cNo).children().eq(0).children().eq(2).text(data.cContents); //$('#'+data.cNo) :data.cNo를 id로 가진 tr을 가져옴~
				$('#showComUpdate').hide();
			},
			error: function (e) {
				alert("수정에서 에러발생!!")
				console.error(e);
			}
		})
	}
	
	
//--------------- 신고하기 & 좋아요------------------
	$(document).ready(function () {
	//set up function on submit the form for report
    $("#itemReportBtn").click(function () {
   
    	 //set up a function for onSubmit
        $('#fhReport').on('submit', function (e) {
            e.preventDefault();
            
            //let s = $('#fhReport').serialize();
            
            //processing form submit;
            $.ajax({
                url: $('#fhReport').attr('action'), //'../AddItemServlet.do'
                method: 'post',
                //data: $('#fhReport').serialize(),
                data: {category: $('#itemCategory').text(),
                		rWhy: $('#fhReport input[name="reason"]').val(),
                		mainNo: $('#fhReport #fhNo').val()
                },
                dataType: 'json',
                success: function(response){
                	alert("신고가 접수 되었습니다. 감사합니다 :) ");
            		$('#closeRModal').click();
                },
                error: function (reject) {
                    console.log(reject);
                }

            });
        });
        
    });
    
    
		$('#likeFrm').on('submit', function (e) {
    		
    		e.preventDefault();
	        
    		$.ajax({
	            url: $('#likeFrm').attr('action'), //'../AddItemServlet.do'
	            method: 'post',
	            //data: $('#likeFrm').serialize(),
	            data: {mainNo: $('#likeFrm #mainNo').val()},
	            success: function(response){
	            	alert("게시글 좋아요 눌렀어요 :) ");
    				$('#likeBtn').css("background-color", "RGB(146, 168, 209)");
    				$('#likeText').html(" Liked It!");
    				$('#likeBTNicon').css("color", "#F7CAC9");
	            	let a = parseInt($('#likeNum').text())+1;
	            	$('#likeNum').html(a);
	            	
	            },
	            error: function (reject) {
	                console.log(reject);
	            }
	    }); 
    });
});

	
</script>

<body id="page-top">

<!-- Begin Page Content -->
	<div class="container-fluid" >
	<div class="continer my-auto pl-4 pb-3">
	<!-- 카테고리마다 타이틀 변경 -주윤 -->
			<c:if test="${list[0].sCategory == 'clothing' }">
			<p id="itemCategory" class="h3 mb-0 mt-5 ml-5" style="color: rgb(255, 190, 83); font-weight: 900;">  의류/하네스</p>
			</c:if>
			<c:if test="${list[0].sCategory == 'food' }">
			<p id="itemCategory" class="h3 mb-0 mt-5 ml-5" style="color: rgb(255, 190, 83); font-weight: 900;">  사료/간식</p>
			</c:if>
			<c:if test="${list[0].sCategory == 'other' }">
			<p id="itemCategory" class="h3 mb-0 mt-5 ml-5" style="color: rgb(255, 190, 83); font-weight: 900;">  그 외 용품</p>
			</c:if>
			<c:if test="${list[0].sCategory == 'giveaway' }">
			<p id="itemCategory" class="h3 mb-0 mt-5 ml-5" style="color: rgb(255, 190, 83); font-weight: 900;">  나눔</p>
			</c:if>
	</div>
		<!-- DataTales Example -->
		<div class="card shadow mb-4"  style="margin-left: 4rem; margin-right: 4rem">
			<!-- card title + btns  -->
			<div class="card-header py-3">
				<h3 class="m-0 font-weight-bold text-dark" style="text-align: center;" >${list[0].sTitle }
				 <!-- 로그인세션확인해서 본인만 글 수정하고 삭제 가능하도록 -->
				  <c:if test="${session.mId == list[0].mId}">
					<button class="btn btn-sm" id="deleteBtn" onclick="confirmDel(${list[0].sNo})" style="background-color: rgb(255, 190, 83);  color:rgb(255, 255, 255); float:right;"><i class="far fa-trash-alt"></i> 글 삭제</button>
					<button class="btn btn-sm mr-3" id="updateBtn" onclick="updateSales(${list[0].sNo})" style="background-color: rgb(255, 190, 83); color:rgb(255, 255, 255); float:right;"><i class="far fa-edit"></i> 글 수정</button>
				  </c:if> 

				 </h3>	
			</div>
			<!-- End of card title + btns  -->
			
			<div class="card-body">
				<!-- 여기에 이미지도 넣기 -->
				<div>
					<img class="card-img-top" src="img/salesImg/${list[0].sImg }" alt="상품이미지" width="80%" height="80%"/>
				</div>
				<br>
				<p>
				<h6 class="m-0 font-weight-bold text-primary">
					<span>조회 수 : ${list[0].sHit }</span> |
					<span><i class="far fa-thumbs-up"></i> <span id="likeNum">${list[0].sLike }</span></span>
					</h6>
				<p></p>
				<br />
				<p></p>
				<div class="card shadow mb-4">
					<div class="card-header py-3">${list[0].sTitle }</div>
						<div class="card-body">
							<i class="fas fa-user-check"></i>판매자 : ${list[0].mId }<br><br>
							<i class="far fa-calendar"></i>언제 샀어요? : ${list[0].sPurchasedDate }<br><br>
							<i class="far fa-clock"></i>얼마나 썼어요? : ${list[0].sUseDays }<br><br>
							<i class="fas fa-question"></i>왜 팔아요?: ${list[0].sReason }<br><br>
							<i class="fas fa-paw"></i>제품 상태는요? 상세하게 기술해주세요~ : ${list[0].sCondition }<br><br>
							<i class="fas fa-tags"></i>얼마에 구매하셨나요?(새 상품 판매가격) : ${list[0].sPrice }<br><br>
							<i class="fas fa-dollar-sign"></i>얼마에 판매하시나요? : ${list[0].sNetPrice }<br><br>
							<i class="far fa-calendar-check"></i>업로드일자 ${list[0].sDate }
						</div>
				</div>
				<p></p>
						<!-- 댓글조회 -->
			<div class="card shadow mb-4">
				
				
				    <div class="card-header">
				        <h3>Comments</h3>
				    </div>
				
					<div class="card-body" >
				       <div id="commentsBody">
					</div>
				</div>
			</div>
			
				<!-- 댓글 입력 -->
				<div class="card mb-2">
					<div class="card-header bg-light">
					     <i class="fa fa-comment fa"></i> REPLY
					</div>
					<div class="card-body">
						<form id="reply" action="CommentInsertServ" method="post">
							<ul class="list-group list-group-flush">
							    <li class="list-group-item">
							    <img class="rounded-circle" src="img/undraw_profile_1.svg" style="width: 2.5rem; height:2.5rem;"><span class="pl-3" style="font-size: 2rem;">${nickname }</span>
							<p></p>
								<input type="hidden" id="cMainNum" name="cMainNum" value="${list[0].sNo }">
								<textarea class="form-control" id="cContent" name="cContent" rows="3"></textarea>
								<button type="submit" class="btn btn-dark mt-3">post reply</button>
							    </li>
							</ul>
						</form>
					</div>
				</div>
			
		
				 
				 <hr>
					<!-- 댓글 수정하면 보이게 -->
			<div id="showComUpdate">
				<form id="updateRep" name="updateRep" action="UpdateCommentServ" method="post">
					<input type="hidden" id="cNo" name="cNo">
					<input type="text" id="cUpdated" name="cContents">
					<button type="submit" id="updated" name="updated" class="btn btn-md mr-5" style="background-color: rgb(255, 190, 83);  color:rgb(255, 255, 255);" onclick="updateCom()">수정하기!</button>
				</form>
			</div>
			</div>
			
			
			<br>
			<div class="pb-3 mx-auto d-flex"  style="align-items: center;">
				<!-- To do style again -->
				<!-- Like btn form -->
			<form id="likeFrm" name="likeFrm" action="UpdSalesLikeServlet" method="post">
					<input type="hidden" id="mainNo" name="mainNo" value="${list[0].sNo }">
					<button class="btn btn-md mr-5" type="submit" id="likeBtn" style="background-color: rgb(255, 190, 83); color:rgb(255, 255, 255);">
					<i class="fab fa-gratipay" id="likeBTNicon"></i><span id="likeText"> 좋아요!</span></button>
       		</form>		
				<form id="payFrm" name="payFrm" method="post" action="makePayment.doBB">
				<input type="hidden" id="saleNo" name="saleNo" value="${list[0].sNo }">
				<button class="btn btn-md mr-5" type="submit" style="background-color: rgb(255, 190, 83);  color:rgb(255, 255, 255);">
				<i class="far fa-credit-card"></i> 결제하기</button>
				</form>
				<a class="btn btn-danger btn-md" href="#" data-toggle="modal"
					data-target="#reportModal"><i class="fas fa-bullhorn"></i> 신고하기</a>

				
			</div>
				
				
	</div><!--  End of DataTales Example -->
				 
				  
				
			
		
			
		
			
		</div>
		
		<!-- 
		메인으로 가기 버튼
		<div align="center">
		To do style again
			&nbsp;&nbsp;&nbsp;<button class="btn btn-secondary" style="float: right;" onclick="location.href='home.do'">To Main</button> &nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<button class="btn btn-secondary" style="float: right;" onclick="location.href='salesListAll.do'">To List</button>&nbsp;&nbsp;&nbsp;
		</div>
		 -->
		<form id="frm" name="frm" action="deleteSales.do" method="post">
			<input type= "hidden" id="sNo" name="sNo">
		</form>
		<form id="frm1" name="frm1" action="updateSalesForm.do" method="post">
			<input type= "hidden" id="sNo" name="sNo">
		</form>
		
	
	<!-- /.container-fluid -->
	
	<!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>
    <!-- write btn-->
	<a style="position: fixed;
	  right: 1rem;
	  bottom: 4rem;
	  display: inline;
	  width: 2.75rem;
	  height: 2.75rem;
	  text-align: center;
	  color: #fff;
	  background: rgb(252, 221, 33);
	  line-height: 46px;
	  border-radius: 0.35rem" href="salesInsertForm.do">
	        <i class="fas fa-edit"></i>
    </a>

    <!-- Logout Modal-->
    <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                    <a class="btn btn-primary" href="login.html">Logout</a>
                </div>
            </div>
        </div>
    </div>
	
 <!-- report moral -->
    <div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel"><i class="fas fa-bullhorn"></i> 이 게시글을 신고하시겠습니까?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                	<form id="fhReport" name="fhReport" action="FhItemReportServlet" method="post">
                <div class="modal-body">
						  <input type="radio" id="bannedItem" name="reason" value="banItem">
						  <label for="bannedItem">판매금지 품목이에요</label><br>
						  <input type="radio" id="notSecondHand" name="reason" value="notForSecondhand">
						  <label for="notSecondHand">중고거래 게시글이 아니에요</label><br>
						  <input type="radio" id="repeated" name="reason" value="repeated">
						  <label for="repeated">중복 게시글이에요</label><br>
						  <input type="radio" id="profSeller" name="reason" value="profSeller">
						  <label for="profSeller">전문 판매업자 같아요</label><br>
						  <input type="radio" id="scam" name="reason" value="scam">
						  <label for="scam">사기 글이에요</label><br>
						  <input type="radio" id="notSecondHand" name="reason" value="notForSecondhand">
						  <label for="notSecondHand">기타 이유</label><br>
						  <input type="hidden" id="fhNo" name="fhNo" value="${item.fhNo }">
                </div>
                
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" id="closeRModal" data-dismiss="modal">취소</button>
                    <button class="btn btn-danger" type="submit" id="itemReportBtn"><i class="far fa-angry"></i> 신고</button>
                </div>
					</form>
            </div>
        </div>
    </div>
	<!-- End of report modal -->
	
</body>
</html>