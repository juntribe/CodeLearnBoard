<%--
  Created by IntelliJ IDEA.
  User: jun
  Date: 2021/07/23
  Time: 7:35 오후
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <style>
        .uploadResult {
            width: 100%;
            background-color: gray;
        }
        .uploadResult ul{
            display: flex;
            flex-flow: row;
            justify-content: center;
            align-items: center;
        }
        .uploadResult ul li {
            list-style: none;
            padding: 10px;
            align-content: center;
            text-align: center;
        }
        .uploadResult ul li img{
            width: 100px;
        }
        .uploadResult ul li span {
            color: white;
        }
        .bigPictureWrapper {
            position: absolute;
            display: none;
            justify-content: center;
            align-items: center;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: gray;
            z-index: 100;
            background: rgba(255,255,255,0.5);

        }
        .bigPicture {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .bigPicture img {
            width: 600px;
        }
    </style>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var operForm = $("#operForm");
        $("button[data-oper='modify']").on("click",function (e) {
            operForm.attr("action","/board/modify").submit();
        });
        $("button[data-oper='list']").on("click",function (e) {
            operForm.find("#bno").remove();
            operForm.attr("action","/board/list")
            operForm.submit();

        });
    });
</script>
<%--    <script type="text/javascript">--%>
<%--        $(document).ready(function () {--%>
<%--            console.log(replyService);--%>
<%--        })--%>
<%--    </script>--%>
<%--    <script>--%>
<%--        console.log("===========");--%>
<%--        console.log("JS TEST");--%>

<%--        var bnoValue = '<c:out value="${board.bno}"/> ';--%>

<%--        replyService.getList({bno:bnoValue,page:1},function (list){--%>
<%--            for (var i = 0, len=list.length||0; i<len; i++){--%>
<%--                console.log(list[i]);--%>
<%--            }--%>
<%--        })--%>
<%--        replyService.add (--%>
<%--            {reply:"js TEST",replyer:"tester",bno : bnoValue},function (result){--%>
<%--                alert("Result :" + result);--%>
<%--            }--%>
<%--        )--%>
<%--        replyService.remove(23,function (count){--%>
<%--            console.log(count);--%>
<%--            if (count ==="success"){--%>
<%--                alert("REMOVED");--%>
<%--            }--%>
<%--        }, function (err){--%>
<%--            alert("error...");--%>
<%--        })--%>
<%--        replyService.update({--%>
<%--            rno : 22,--%>
<%--            bno : bnoValue,--%>
<%--            reply : "Modified Reply..."--%>
<%--        }, function (result){--%>
<%--            alert("수정 완료")--%>
<%--        });--%>
<%--        replyService.get(10,function (data){--%>
<%--            console.log(data);--%>
<%--        })--%>
<%--    </script>--%>
    <script>
        $(document).ready(function (){
            var bnoValue = '<c:out value="${board.bno}"/> ';
            var replyUL=$(".chat");

            showList(1);
            function showList(page){
                console.log("show list" + page);
                replyService.getList({bno:bnoValue,page:page||1},function (replyCnt,list){
                    console.log("replyCnt:" + replyCnt);
                    console.log("list :" + list);
                    console.log(list);
                    if (page === -1){
                        pageNum = Math.ceil(replyCnt/10.0);
                        showList(pageNum);
                        return;
                    }
                    var str ="";
                    if (list == null || list.length === 0){
                        return;
                    }
                    for (var i = 0, len=list.length|| 0; i<len; i++){
                       str +=" <li class='left clearfix' data-rno='" +list[i].rno+"'>";
                       str +=" <div><div class='header'><strong class='primary-font'>" +
                           list[i].replyer+"</strong>";
                       str +=" <small class='pull-right text-muted'>" +
                        replyService.displayTime(list[i].replyDate)+"</small></div>";

                       str +=" <p>"+ list[i].reply +" </p></div></li>";
                    }

                    replyUL.html(str);
                    showReplyPage(replyCnt);


                }) // end function
            } // end showList
            var modal =$(".modal");
            var modalInputReply = modal.find("input[name='reply']");
            var modalInputReplyer = modal.find("input[name='replyer']");
            var modalInputReplyDate = modal.find("input[name='replyDate']");

            var modalModBtn = $("#modalModBtn");
            var modalRemoveBtn =$("#modalRemoveBtn")
            var modalRegisterBtn =$("#modalRegisterBtn");
            $("#addReplyBtn").on("click",function (e){
                modal.find("input").val("");
                modalInputReplyDate.closest("div").hide();
                modal.find("button[id !='modalCloseBtn']").hide();

                modalRegisterBtn.show();
                $(".modal").modal("show");
            })
            modalRegisterBtn.on("click",function (e){
                var reply ={
                    reply : modalInputReply.val(),
                    replyer : modalInputReplyer.val(),
                    bno : bnoValue
                };
                replyService.add(reply,function (result){
                    alert(result);

                    modal.find("input").val("");
                    modal.modal("hide");
                    // showList(1);
                    showList(-1);
                });
            })
            $(".chat").on("click","li", function (e){
                var rno =$(this).data("rno");
                replyService.get(rno,function (reply){
                    modalInputReply.val(reply.reply);
                    modalInputReplyer.val(reply.replyer);
                    modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
                    modal.data("rno",reply.rno);

                    modal.find("button[id !='modalCloseBtn']").hide();
                    modalModBtn.show();
                    modalRemoveBtn.show();
                    modalInputReplyDate.show();

                    $(".modal").modal("show");
                })
            })
            modalModBtn.on("click",function (e){
                var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
                replyService.update(reply,function (result){
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                })
            })
            modalRemoveBtn.on("click", function (e){
                var rno= modal.data("rno");
                replyService.remove(rno,function (result){
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                })
            })
            var pageNum = 1;
            var replyPageFooter = $(".panel-footer");
            function showReplyPage(replyCnt){
                var endNum = Math.ceil(pageNum/10.0) * 10;
                var startNum = endNum - 9;

                var prev = startNum !==1;
                var next = false;
                if (endNum * 10 >= replyCnt){
                    endNum= Math.ceil(replyCnt/10.0);
                }
                if (endNum * 10 <replyCnt){
                    next = true;
                }
                var str ="<ul class='pagination pull-right'>";
                if (prev){
                    str +="<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";

                }
                for (var i=startNum; i<=endNum; i++){

                    var active = pageNum == i? "active" : "";
                    str += "<li class='page-item "+ active +" '><a class='page-link' href='" +i+"'>"+i+"</a></li>";
                }
                if (next){
                    str += "<li class='page-item'><a class='page-link' href='" +(endNum + 1)+"'>Next</a></li>";
                }
                str +="</ul></div>";
                console.log("출력 값:"+str);
                replyPageFooter.html(str);
            }
            replyPageFooter.on("click","li a",function (e){
                e.preventDefault();
                console.log("page click");

                var targetPageNum =$(this).attr("href");
                console.log("targetPageNum :" + targetPageNum);
                pageNum =targetPageNum;
                showList(pageNum);
            })
            var bno ='<c:out value="${board.bno}"/> ';
            $.getJSON("/board/getAttachList", {bno:bno}, function (arr){
                console.log(arr);
                var str = "";
                $(arr).each(function (i,attach){
                    if (attach.fileType){
                        var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                        str +="<img src='/display?fileName="+fileCallPath+"'>";
                        str +="</div></li>";
                    }else {
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                        str += "<span>" + attach.fileName+"</span><br>";
                        str += "<img src='/resources/image/attach1.png'>";
                        str += "</div></li>";
                    }
                    $(".uploadResult ul").html(str);
                })
            })
            $(".uploadResult").on("click","li",function (e){
                console.log("view image");
                var liObj = $(this);
                var path =encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_"+liObj.data("filename"));

                if (liObj.data("type")){
                    showImage(path.replace(new RegExp(/\\/g),"/"));
                }else {
                    self.location = "/download?fileName="+path
                }

            })
            function showImage(fileCallPath){
                // alert(fileCallPath);
                $(".bigPictureWrapper").css("display","flex").show();
                $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>")
                    .animate({width:'100%',height:'100%'}, 1000);
            }
            $(".bigPictureWrapper").on("click",function (e){
                $(".bigPicture").animate({width: '0%', height: '0%'},1000);
                setTimeout(() =>{
                    $(".bigPictureWrapper").hide();
                },1000);
            })

        })


    </script>
</head>

<body>

<div id="wrapper">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.html">SB Admin v2.0</a>
        </div>
        <!-- /.navbar-header -->

        <ul class="nav navbar-top-links navbar-right">
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-envelope fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-messages">
                    <li>
                        <a href="#">
                            <div>
                                <strong>John Smith</strong>
                                <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                            </div>
                            <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <strong>John Smith</strong>
                                <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                            </div>
                            <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <strong>John Smith</strong>
                                <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                            </div>
                            <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a class="text-center" href="#">
                            <strong>Read All Messages</strong>
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </li>
                </ul>
                <!-- /.dropdown-messages -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-tasks fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-tasks">
                    <li>
                        <a href="#">
                            <div>
                                <p>
                                    <strong>Task 1</strong>
                                    <span class="pull-right text-muted">40% Complete</span>
                                </p>
                                <div class="progress progress-striped active">
                                    <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%">
                                        <span class="sr-only">40% Complete (success)</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <p>
                                    <strong>Task 2</strong>
                                    <span class="pull-right text-muted">20% Complete</span>
                                </p>
                                <div class="progress progress-striped active">
                                    <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 20%">
                                        <span class="sr-only">20% Complete</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <p>
                                    <strong>Task 3</strong>
                                    <span class="pull-right text-muted">60% Complete</span>
                                </p>
                                <div class="progress progress-striped active">
                                    <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%">
                                        <span class="sr-only">60% Complete (warning)</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <p>
                                    <strong>Task 4</strong>
                                    <span class="pull-right text-muted">80% Complete</span>
                                </p>
                                <div class="progress progress-striped active">
                                    <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
                                        <span class="sr-only">80% Complete (danger)</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a class="text-center" href="#">
                            <strong>See All Tasks</strong>
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </li>
                </ul>
                <!-- /.dropdown-tasks -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-bell fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-alerts">
                    <li>
                        <a href="#">
                            <div>
                                <i class="fa fa-comment fa-fw"></i> New Comment
                                <span class="pull-right text-muted small">4 minutes ago</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <i class="fa fa-twitter fa-fw"></i> 3 New Followers
                                <span class="pull-right text-muted small">12 minutes ago</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <i class="fa fa-envelope fa-fw"></i> Message Sent
                                <span class="pull-right text-muted small">4 minutes ago</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <i class="fa fa-tasks fa-fw"></i> New Task
                                <span class="pull-right text-muted small">4 minutes ago</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#">
                            <div>
                                <i class="fa fa-upload fa-fw"></i> Server Rebooted
                                <span class="pull-right text-muted small">4 minutes ago</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a class="text-center" href="#">
                            <strong>See All Alerts</strong>
                            <i class="fa fa-angle-right"></i>
                        </a>
                    </li>
                </ul>
                <!-- /.dropdown-alerts -->
            </li>
            <!-- /.dropdown -->
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                    </li>
                    <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                    </li>
                    <li class="divider"></li>
                    <li><a href="login.html"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                    </li>
                </ul>
                <!-- /.dropdown-user -->
            </li>
            <!-- /.dropdown -->
        </ul>
        <!-- /.navbar-top-links -->

        <div class="navbar-default sidebar" role="navigation">
            <div class="sidebar-nav navbar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="sidebar-search">
                        <div class="input-group custom-search-form">
                            <input type="text" class="form-control" placeholder="Search...">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                        </div>
                        <!-- /input-group -->
                    </li>
                    <li>
                        <a href="./list"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> Charts<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="flot.html">Flot Charts</a>
                            </li>
                            <li>
                                <a href="morris.html">Morris.js Charts</a>
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="tables.html"><i class="fa fa-table fa-fw"></i> Tables</a>
                    </li>
                    <li>
                        <a href="forms.html"><i class="fa fa-edit fa-fw"></i> Forms</a>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-wrench fa-fw"></i> UI Elements<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="panels-wells.html">Panels and Wells</a>
                            </li>
                            <li>
                                <a href="buttons.html">Buttons</a>
                            </li>
                            <li>
                                <a href="notifications.html">Notifications</a>
                            </li>
                            <li>
                                <a href="typography.html">Typography</a>
                            </li>
                            <li>
                                <a href="icons.html"> Icons</a>
                            </li>
                            <li>
                                <a href="grid.html">Grid</a>
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-sitemap fa-fw"></i> Multi-Level Dropdown<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="#">Second Level Item</a>
                            </li>
                            <li>
                                <a href="#">Second Level Item</a>
                            </li>
                            <li>
                                <a href="#">Third Level <span class="fa arrow"></span></a>
                                <ul class="nav nav-third-level">
                                    <li>
                                        <a href="#">Third Level Item</a>
                                    </li>
                                    <li>
                                        <a href="#">Third Level Item</a>
                                    </li>
                                    <li>
                                        <a href="#">Third Level Item</a>
                                    </li>
                                    <li>
                                        <a href="#">Third Level Item</a>
                                    </li>
                                </ul>
                                <!-- /.nav-third-level -->
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-files-o fa-fw"></i> Sample Pages<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="blank.html">Blank Page</a>
                            </li>
                            <li>
                                <a href="login.html">Login Page</a>
                            </li>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </ul>
            </div>
            <!-- /.sidebar-collapse -->
        </div>
        <!-- /.navbar-static-side -->
    </nav>

    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Board Read Page</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        글 내용
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-lg-6">
                            <form id="operForm" action="/board/modify" method="get">
                                <input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/> ">
                                <input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}'/> ">
                                <input type="hidden" id="amount" name="amount" value="<c:out value='${cri.amount}'/> ">
                                <input type="hidden" id="keyword" name="keyword" value="<c:out value='${cri.keyword}'/> ">
                                <input type="hidden" id="type" name="type" value="<c:out value='${cri.type}'/> ">
                                    <div class="form-group">
                                        <label>글 번호</label>
                                        <input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
                                    </div>
                                <div class="form-group">
                                    <label>제목</label>
                                    <input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
                                </div>
                                    <div class="form-group">
                                        <label>내용</label>
                                        <textarea class="form-control" rows="3" name="content"  readonly="readonly"><c:out value="${board.content}"/> </textarea>
                                    </div>
                                    <div class="form-group">
                                        <label>작성자</label>
                                        <input class="form-control" name="writer" readonly="readonly" value="<c:out value='${board.writer}'/> ">
                                    </div>


                                    <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/> '">수정</button>
                                    <button data-oper="list" class="btn btn-default" onclick="location.href='/board/list'">list</button>
                            </form>
                            </div>
                            <!-- /.col-lg-6 (nested) -->
                        </div>
                    </div>
                </div>

            </div>
            <!-- /.col-lg-12 -->
        </div>
        <div class="bigPictureWrapper">
            <div class="bigPicture">

            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="panel panel-default">

                    <div class="panel-heading">File</div>
                    <%-- /.panel-heading    --%>
                    <div class="panel-body">

                        <div class="uploadResult">
                            <ul>

                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <%--            /.panel--%>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <i class="fa fa-comment fa-fw"></i>Reply
                        <button id='addReplyBtn' class="btn btn-primary btn-xs pull-right">New Reply</button>
                    </div>
                    <%--      /.panel-heading          --%>

                    <div class="panel-body">
                        <ul class="chat">
                            <%--         start reply                     --%>
                            <li class="left clearfix" data-rno="12">
                                <div>

                                </div>
                            </li>
                            <%--                        end reply--%>
                        </ul>
                        <%--                    /. end ul--%>
                    </div>
                    <%--                .panel .char-panel--%>
                    <div class="panel-footer">

                    </div>
                </div>
            </div>
        </div>

    </div>
    <!-- /#page-wrapper -->
</div>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">

                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name="replyer" value="replyer">
                </div>
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name="reply" value="NewReply!!!">
                </div>
                <div class="form-group">
                    <label>Reply Date</label>
                    <input class="form-control" name="replyDate" value="">
                </div>
            </div>
            <div class="modal-footer">
                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                <button type="button" id="modalRegisterBtn"  class="btn btn-primary">Register</button>
                <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

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

