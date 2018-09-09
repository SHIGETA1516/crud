<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.util.*,com.newsclan.crud.*"%>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
<%
	request.setCharacterEncoding("UTF-8");
	String username, passwd, sql;
	Connection conn=DB.getConnection();
	username = request.getParameter("username");
	passwd = request.getParameter("passwd");
	String rand = request.getParameter("rand");
	if (rand != null && rand.equals(session.getAttribute("rand"))){
		session.setAttribute("rand",null); 
		if (Tools.login_cyoc(username, passwd)) {
			sql = "SELECT  * from t_students where 学号=? ";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, username);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				session.setAttribute("user_id", rs.getInt("学号"));
				session.setAttribute("user_name", rs.getString("姓名"));
			}
			sql = "SELECT  `right` from "+Config.sysPrefix+"privilege where user_id=?";
			int user_id = rs.getInt("id");
			DB.close(rs);
			DB.close(pstmt);

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				session.setAttribute(rs.getString(1), true);
			}
			DB.close(rs);
			DB.close(pstmt);
			response.sendRedirect("index.jsp");
		}else{
			session.invalidate();
			response.sendRedirect("login_cyoc.jsp");
		}
	} else {
		System.out.println(1);
		%>
		<form method="post" action="login_cyoc.jsp">
		<table align=center>

			<tr>
				<td>账号:</td>
				<td><input name="username" size="15"></td>
			</tr>
			<tr>

				<td>密码:</td>
				<td><input name="passwd" size="15" type=password> </td>
			</tr>
			<tr>

				<td><img src="rand.jsp" onclick="this.src='rand.jsp?'+Math.random();"></td>
				<td><input name="rand" size="15" type=text > <input
					type="submit" value="进入" name="B1"></td>
			</tr>

		</table>
		</form>
		<%
	}
	DB.close(conn);
%>
