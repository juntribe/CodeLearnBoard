<%--
  Created by IntelliJ IDEA.
  User: jun
  Date: 2021/08/18
  Time: 1:47 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">


    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

    <script>
        $(document).ready(function (e){
            var csrfHeaderName ="${_csrf.headerName}";
            var csrfTokenValue ="${_csrf.token}";
            var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
            var maxSize = 5242880;
            function checkExtension(fileName,fileSize){
                if (fileSize >= maxSize){
                    alert("파일 사이즈 초과");
                    return false;
                }
                if (regex.test(fileName)){
                    alert("해당 종류의 파일은 업로드할수 없습니다");
                    return false;
                }
                return true;
            }
            $("input[type='file']").change(function (e){

            var formData = new FormData();

            var inputFile =$("input[name='uploadFile']");

            var files = inputFile[0].files;

            console.log(files);

            for (var i=0; i<files.length; i++){
                if (!checkExtension(files[i].name, files[i].size)){
                    return false;
                }
                formData.append("uploadFile",files[i]);
            }
            $.ajax({
                url : '/uploadAjaxAction',
                processData : false,
                contentType : false,
                beforeSend :function (xhr){
                    xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
                },
                data : formData,
                type : 'POST',
                dataType:'json',
                success : function (result){
                    console.log(result);
                    showUploadResult(result);
                }
            }); //$.ajax
            })
            var formObj = $("form[role='form']");
            $("button[type='submit']").on("click",function (e){
                e.preventDefault();
                console.log("submit clicked");
                var str ="";
                $(".uploadResult ul li").each(function (i,obj){
                    var jobj =$(obj);
                    console.log(jobj);

                    str +="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                    str +="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                    str +="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                    str +="<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";

                })
                formObj.append(str).submit();
            })
            function showUploadResult(uploadResultArr){
                if (!uploadResultArr || uploadResultArr.length === 0){return;}
                var uploadUL = $(".uploadResult ul");
                var str = "";
                $(uploadResultArr).each(function (i,obj){
                    if (obj.image){
                        var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
                        str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
                        str +="<div>";
                        str += "<span>" + obj.fileName+"</span>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"/' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str +="<img src='/display?fileName="+fileCallPath+"'>";
                        str += "</div></li>";

                    }else {
                        // str += "<li>" + obj.fileName + "</li>";
                        var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
                        var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                        str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
                        str +="<div>"
                        str += "<span>" + obj.fileName+"</span>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"/' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str +="<img src='/resources/image/attach1.png'>"
                        str +="</div></li>";

                    }
                });
                uploadUL.append(str);
            }
            $(".uploadResult").on("click","button",function (e){
                console.log("delete file");

                var targetFile = $(this).data("file");
                var type = $(this).data("type");
                var targetLi =$(this).closest("li");

                $.ajax({
                    url : '/deleteFile',
                    data : {fileName: targetFile, type:type},
                    beforeSend :function (xhr){
                        xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
                    },
                    dataType: 'text',
                    type: 'POST',
                    success: function (result){
                        alert(result);
                        targetLi.remove();
                    }
                })
            })

        })
    </script>

</head>

<body>

<div id="wrapper">

    <%@include file="/WEB-INF/views/includes/header.jsp"%>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">글 등록 페이지</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        글 작성
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <form role="form" action="/board/register" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <div class="form-group">
                                        <label>제목</label>
                                        <input class="form-control" name="title" required>
                                    </div>
                                    <div class="form-group">
                                        <label>내용</label>
                                        <textarea class="form-control" rows="3" name="content" required></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label>작성자</label>
                                        <input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
                                    </div>


                                    <button type="submit" class="btn btn-primary">등록</button>
                                    <button type="reset" class="btn btn-danger">취소</button>
                                </form>
                            </div>
                            <!-- /.col-lg-6 (nested) -->
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="bigPictureWrapper">
            <div class="bigPicture">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">

                    <div class="panel-heading">File Attach</div>
                <%-- /.panel-heading    --%>
                    <div class="panel-body">
                        <div class="form-group uploadDiv">
                            <input type="file" name="uploadFile" multiple>
                        </div>
                        <div class="uploadResult">
                            <ul>

                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <!-- /#page-wrapper -->

</div>

<!-- /#wrapper -->

<!-- jQuery -->
<script src="/resources/vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/resources/dist/js/sb-admin-2.js"></script>

</body>
</html>

