<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LOGIN</title>

    <style>
        html {
            height: 100%;
        }

        body {
            height: 100%;
            margin: 0;
            padding: 0;
            background-color: #FFCC00;
        }

        em {
            display: block;
            text-align: center;
            color: #a90329;
            visibility: hidden;
            margin-top: 6px;
            padding: 0 1px;
            font-style: normal;
            font-size: 12px;
        }

        .my-custom-scrollbar {
            position: relative;
            height: 600px;
        }

        .table-wrapper-scroll-y {
            display: block;
        }
    </style>
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="css/open-iconic-bootstrap.css"/>
</head>
<body>
<div class="container h-100">
    <div class="row h-100">
        <div class="col-sm-3 col-md-3 col-xl-3 my-auto">
            <div class="card card-block mx-auto">
                <div id="loginForm" class="card-body">
                    <h2 class="text-center mb-4"></h2>
                    <div class="form-group">
                        <label for="inputEmailForm" class="sr-only form-control-label">nick</label>
                        <div class="mx-auto col-sm-10">
                            <input type="text" class="form-control" name="login" id="inputNameForm"
                                   placeholder="name" autocomplete="off"
                                   required="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPhoneForm" class="sr-only form-control-label">phone</label>
                        <div class="mx-auto col-sm-10">
                            <input type="text" class="form-control" name="password" id="inputPhoneForm"
                                   placeholder="phone number" autocomplete="off"
                                   required="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmailForm" class="sr-only form-control-label">Email</label>
                        <div class="mx-auto col-sm-10">
                            <input type="text" class="form-control" name="password" id="inputEmailForm"
                                   placeholder="e-mail" autocomplete="off"
                                   required="">
                            <em id="info-bubble-login">template</em>
                        </div>
                    </div>
                    <div class="mx-auto col-sm-10 pb-3 pt-5">
                        <button id="login-btn" type="submit" class="btn btn-outline-primary btn-sm btn-block">
                            Send
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-9 col-md-9 col-xl-9 my-auto">
            <div class="card card-block mx-auto h-100">
                <div id="logindfgfdForm" class="card-body table-wrapper-scroll-y my-custom-scrollbar overflow-auto">
                    <table id="user-table" class="table table-striped">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Phone number</th>
                            <th>Email</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $('#login-btn').click(function () {
        if (!$.trim($('#inputEmailForm').val()) == "" && !$.trim($('#inputPhoneForm').val()) == "") {
            sendData(false);
        }
    });

    function sendData(update) {

        var url = window.location.href + "get";

        if (update === true) {
            var data = "";
        } else {
            var name = document.getElementById("inputNameForm").value;
            var phone = document.getElementById("inputPhoneForm").value;
            var email = document.getElementById("inputEmailForm").value;
            var data = "name=" + name + "&phone=" + phone + "&email=" + email;
        }

        $.ajax({
            url: url,
            type: 'post',
            data: data,
            success: function (response, status, xhr) {
                var obj = response;
                if (obj.response != 0) {
                    return;
                }
                addTrToTable(obj);
            }
        });
    }

    function addTrToTable(obj) {
        document.getElementById("inputNameForm").value = "";
        document.getElementById("inputPhoneForm").value = "";
        document.getElementById("inputEmailForm").value = "";

        var count = obj.list.length;
        if (count > 0) {
            document.getElementById("user-table").getElementsByTagName('tbody')[0].innerHTML = "";
            for (var i = 0; i < count; i++) {
                var htmlInsert = '<tr>' +
                    '<td>' + obj.list[i].name + '</td>' +
                    '<td>' + obj.list[i].phoneNumber + '</a></td>' +
                    '<td>' + obj.list[i].email + '</td></tr>';

                var placeToInsert = document.getElementById("user-table").getElementsByTagName('tbody')[0];
                placeToInsert.insertAdjacentHTML('afterbegin', htmlInsert);
            }
        }
    }

    window.onload = function () {
        setTimeout(function () {
            sendData(true);
        }, 1000);
    }
</script>
</body>
</html>