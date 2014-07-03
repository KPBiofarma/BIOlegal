<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageLoginCloned.aspx.cs" Inherits="BioPM.PageLoginCloned" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="ThemeBucket">
    <link rel="shortcut icon" href="images/favicon.html">

    <title>Login</title>

    <!--Core CSS -->
    <link href="Scripts/UserPanel/bs3/css/bootstrap.min.css" rel="stylesheet">
    <link href="Scripts/UserPanel/css/bootstrap-reset.css" rel="stylesheet">
    <link href="Scripts/UserPanel/assets/font-awesome/css/font-awesome.css" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="Scripts/UserPanel/css/style.css" rel="stylesheet">
    <link href="Scripts/UserPanel/css/style-responsive.css" rel="stylesheet" />

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="js/ie8/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
</head>

  <body class="login-body">

    <div class="container">

      <form runat="server" class="form-signin">
        <h2 class="form-signin-heading">sign in now</h2>
        <div class="login-wrap">
            <div class="user-login-info">
                <asp:TextBox ID="txtUsername" class="form-control" runat="server" placeholder="User ID" autofocus></asp:TextBox>
                <asp:TextBox ID="txtPassword" type="password" runat="server" class="form-control" placeholder="Password"></asp:TextBox>
            </div>
            <label class="checkbox">
                
                <span class="pull-right">
                    <a data-toggle="modal" href="#myModal"> Forgot Password?</a>

                </span>
            </label>
            <asp:Button ID="btnLogin" runat="server" Text="Sign In" class="btn btn-lg btn-login btn-block"></asp:Button>

        </div>

          <!-- Modal -->
          <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
              <div class="modal-dialog">
                  <div class="modal-content">
                      <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                          <h4 class="modal-title">Forgot Password ?</h4>
                      </div>
                      <div class="modal-body">
                          <p>Enter your e-mail address below to reset your password.</p>
                          <asp:TextBox ID="txtEmail" runat="server" placeholder="Email" class="form-control placeholder-no-fix"></asp:TextBox>

                      </div>
                      <div class="modal-footer">
                          <asp:Button ID="btnCancel" runat="server" data-dismiss="modal" class="btn btn-default" Text="Cancel"></asp:Button>
                          <asp:Button ID="btnSubmit" runat="server" class="btn btn-success" Text="Submit"></asp:Button>
                      </div>
                  </div>
              </div>
          </div>
          <!-- modal -->

      </form>

    </div>



    <!-- Placed js at the end of the document so the pages load faster -->

    <!--Core js-->
    <script src="Scripts/UserPanel/js/lib/jquery.js"></script>
    <script src="Scripts/UserPanel/bs3/js/bootstrap.min.js"></script>

  </body>
</html>
