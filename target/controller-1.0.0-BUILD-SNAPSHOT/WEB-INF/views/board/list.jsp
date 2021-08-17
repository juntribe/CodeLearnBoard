<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SB Admin 2 - Bootstrap Admin Theme</title>

  <!-- Bootstrap Core CSS -->
  <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- MetisMenu CSS -->
  <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

  <!-- DataTables CSS -->
  <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

  <!-- DataTables Responsive CSS -->
  <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

  <!-- Custom CSS -->
  <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

  <!-- Custom Fonts -->
  <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">


  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>


<script type="text/javascript">
  $(document).ready(function (){
    var result = '<c:out value="${result}"/>';
    checkModal(result);
    history.replaceState({},null,null);
    function checkModal(result){
      if (result === '' || history.state){
        return;
      }
      if (result == 'success'){
        $(".modal-body").html("정상적으로 처리 되었습니다.");
      }else if (parseInt(result) >0){
        $(".modal-body").html("게시글 " + parseInt(result) + "번이 등록 되었습니다.");
      }

      $("#myModal").modal("show");
    }
    $("#regBtn").on("click",function (){
      self.location="/board/register";
    });
    var actionForm =$("#actionForm");
    $(".paginate_button a").on("click",function (e) {
      e.preventDefault();
      console.log('click');
      actionForm.find("input[name='pageNum']").val($(this).attr("href"));
      actionForm.submit();
    });
    $(".move").on("click",function (e) {
      e.preventDefault();
      actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
      actionForm.attr("action","/board/get");
      actionForm.submit();

    })
    var searchForm = $("#searchForm");
    $("#searchForm button").on("click", function (e) {
      if (!searchForm.find("option:selected").val()){
        alert("검색종류를 선택하세요")
        return false;
      }
      if (!searchForm.find("input[name='keyword']").val()){
        alert("키워드를 입력하세요")
        return false;
      }
      searchForm.find("input[name='pageNum']").val("1");
      e.preventDefault();
      searchForm.submit();
    })
  });

</script>

</head>

<body>

<div id="wrapper">

  <!-- Navigation -->
  <%@include file="/WEB-INF/views/includes/header.jsp"%>
  <div id="page-wrapper">
    <div class="row">

      <div class="col-lg-12">
        <h1 class="page-header">Tables</h1>
      </div>
      <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
    <div class="row">
      <div class="col-lg-12">
        <div class="panel panel-default">
          <div class="panel-heading">
            Board List Pages
            <button id="regBtn" type="button" class="btn btn-xs pull-right">글 쓰기</button>
          </div>
          <!-- /.panel-heading -->

          <div class="panel-body">
            <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">
              <thead>
              <tr>
                <th>#번</th>
                <th>아아아</th>
                <th>Platform(s)</th>
                <th>Engine version</th>
                <th>CSS grade</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach items="${list}" var="board">
                <tr>
                  <td><c:out value="${board.bno}"/></td>
                  <td>
                    <a class="move" href="<c:out value="${board.bno}"/> ">
                    <c:out value="${board.title}"/>
                    <b>[ <c:out value="${board.replyCnt}"/> ] </b>
                    </a></td>
                  <td><c:out value="${board.writer}"/></td>
                  <td><fmt:formatDate value="${board.regdate }" pattern="yyyy-MM-dd"/> </td>
                  <td><fmt:formatDate value="${board.updateDate }" pattern="yyyy-MM-dd"/> </td>
                </tr>
              </c:forEach>
              </tbody>

            </table>
            <div class="row">
              <div class="col-lg-12">
                <form action="/board/list" id="searchForm" method="get">
                  <select name="type">
                    <option value="" <c:out value="${pageMaker.cri.type == null?'selected':''}"/>>--</option>
                    <option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
                    <option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
                    <option value="W" <c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
                    <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 or 내용</option>
                    <option value="W" <c:out value="${pageMaker.cri.type eq 'TW'?'selected':''}"/>>제목 or 작성자</option>
                    <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC'?'selected':''}"/>>제목 or 내용 or 작성자</option>
                  </select>
                  <input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'/>
                  <input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>'/>
                  <input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>'/>
                  <button class="btn btn-default">Serach</button>
                </form>
              </div>
            </div>

            <div class="pull-right">
              <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                  <li class="paginate_button previous">
                    <a href="${pageMaker.startPage -1}">Previous</a>
                  </li>
                </c:if>
                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                  <li class="paginate_button ${pageMaker.cri.pageNum == num ? "active":""} ">
                    <a href="${num}">${num}</a>
                  </li>
                </c:forEach>

                <c:if test="${pageMaker.next}">
                  <li class="paginate_button next"><a href="${pageMaker.endPage +1}">Next</a></li>
                </c:if>
              </ul>
              <form id="actionForm" action="/board/list" method="get">
                <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/> '>
                <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/> '>
              </form>
            </div>

            <!-- /.table-responsive -->
          <!-- /.panel-body -->
        </div>

        <!-- /.panel -->
      </div>
      <!-- /.col-lg-12 -->
    </div>
  </div>
  <!-- /#page-wrapper -->
</div>
<!-- /#wrapper -->
  <!-- Modal -->
  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title" id="myModalLabel">Modal title</h4>
        </div>
        <div class="modal-body">
          처리가 완료 되었습니다.
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>

  <!-- /.modal -->
<!-- jQuery -->
<script src="/resources/vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

<!-- DataTables JavaScript -->
<script src="/resources/vendor/datatables/js/jquery.dataTables.min.js"></script>
<script src="/resources/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
<script src="/resources/vendor/datatables-responsive/dataTables.responsive.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/resources/dist/js/sb-admin-2.js"></script>

<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script>
  $(document).ready(function() {
    // $('#dataTables-example').DataTable({
    //   responsive: true
    // });
    $(".sidebar-nav")
    .attr("class","sidebar-nav navbar-collapse collapse")
    .attr("aria-expanded", "false")
    .attr("style","height:1px");
  });
</script>
</div>
</body>

</html>
