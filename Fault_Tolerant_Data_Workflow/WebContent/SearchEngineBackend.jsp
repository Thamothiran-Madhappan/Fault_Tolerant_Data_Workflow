<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "com.browser.Database.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.time.LocalDateTime" %>
<%@ page import = "java.time.format.DateTimeFormatter" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search | Backend</title>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<style>
.filterable {
    margin-top: 15px;
}
.filterable .panel-heading .pull-right {
    margin-top: -20px;
}
.filterable .filters input[disabled] {
    background-color: transparent;
    border: none;
    cursor: auto;
    box-shadow: none;
    padding: 0;
    height: auto;
}
.filterable .filters input[disabled]::-webkit-input-placeholder {
    color: #333;
}
.filterable .filters input[disabled]::-moz-placeholder {
    color: #333;
}
.filterable .filters input[disabled]:-ms-input-placeholder {
    color: #333;
}

</style>
</head>
<body>
<%
String email = session.getAttribute("email").toString();
String search = request.getParameter("search");
System.out.println("The Searched Keyword is: "+search);

DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm:ss");  
LocalDateTime now = LocalDateTime.now();  
System.out.println(dtf.format(now));
String tt = dtf.format(now);
System.out.println(tt);

int ans = 0;
Connection con;
con = DatabaseConnection.createConnection();
try{
	PreparedStatement ps = con.prepareStatement("insert into activity values(?,?,?)");
	ps.setString(1, search);
	ps.setString(2, tt);
	ps.setString(3, email);
	ans = ps.executeUpdate();
}catch(Exception e){
	e.printStackTrace();
}


try{
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("select * from serverdata where content like '%"+search+"%' or domain like '%"+search+"%'");
	

%>

<div class="container">
    <h3>Search Results</h3>
    <hr style="background:blue; ">
    
    <div class="row">
        <div class="panel panel-primary filterable">
            <div class="panel-heading">
                <h3 class="panel-title">Search Results Based on the user Search</h3>
                <div class="pull-right">
                    <button class="btn btn-default btn-xs btn-filter"><span class="glyphicon glyphicon-filter"></span> Filter</button>
                </div>
            </div>
            <table class="table">
                <thead>
                    <tr class="filters">
                        <th><input type="text" class="form-control" placeholder="S.no" disabled></th>
                        <th><input type="text" class="form-control" placeholder="Domain Name" disabled></th>
                        <th><input type="text" class="form-control" placeholder="Related Data" disabled></th>
                         <th><input type="text" class="form-control" placeholder="Book Marks" disabled></th>
                      <!--  <th><input type="text" class="form-control" placeholder="Date and Time" disabled></th> 
                        <th><input type="text" class="form-control" placeholder="Status" disabled></th> 
                        <th><input type="text" class="form-control" placeholder="Faculty" disabled></th>   -->
                    </tr>
                </thead>
                <tbody>
                <%
                int i = 1;
                while(rs.next()){
                	                
                %>
                    <tr>
                        <td><%=i %></td>
                        <td><%=rs.getString("domain") %></td>
                        <td><%=rs.getString("content") %></td>
                        
                        <td><a href="BookMarks.jsp?domain=<%=rs.getString("domain") %>&filename=<%=rs.getString("filename") %>">Add to Bookmarks</a></td>
               
                    </tr>
                    <%
                    i++;
                    session.setAttribute("filename1", rs.getString("filename"));
                }
				}catch(Exception e){
					e.printStackTrace();
				}
                 %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
$(document).ready(function(){
    $('.filterable .btn-filter').click(function(){
        var $panel = $(this).parents('.filterable'),
        $filters = $panel.find('.filters input'),
        $tbody = $panel.find('.table tbody');
        if ($filters.prop('disabled') == true) {
            $filters.prop('disabled', false);
            $filters.first().focus();
        } else {
            $filters.val('').prop('disabled', true);
            $tbody.find('.no-result').remove();
            $tbody.find('tr').show();
        }
    });

    $('.filterable .filters input').keyup(function(e){
        /* Ignore tab key */
        var code = e.keyCode || e.which;
        if (code == '9') return;
        /* Useful DOM data and selectors */
        var $input = $(this),
        inputContent = $input.val().toLowerCase(),
        $panel = $input.parents('.filterable'),
        column = $panel.find('.filters th').index($input.parents('th')),
        $table = $panel.find('.table'),
        $rows = $table.find('tbody tr');
        /* Dirtiest filter function ever ;) */
        var $filteredRows = $rows.filter(function(){
            var value = $(this).find('td').eq(column).text().toLowerCase();
            return value.indexOf(inputContent) === -1;
        });
        /* Clean previous no-result if exist */
        $table.find('tbody .no-result').remove();
        /* Show all rows, hide filtered ones (never do that outside of a demo ! xD) */
        $rows.show();
        $filteredRows.hide();
        /* Prepend no-result row if all rows are filtered */
        if ($filteredRows.length === $rows.length) {
            $table.find('tbody').prepend($('<tr class="no-result text-center"><td colspan="'+ $table.find('.filters th').length +'">No result found</td></tr>'));
        }
    });
});

</script>



</body>
</html>