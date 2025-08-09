import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");

        boolean loginSuccess = false;
        int dbUserId = 0;

        // Check for default admin credentials first
        if ("admin".equals(role) && "admin".equals(userId) && "admin".equals(password)) {
            loginSuccess = true;
            dbUserId = 0;  // You can set admin's userId as 0 or any special value
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

                String sql = "SELECT id FROM users WHERE id = ? AND password = ? AND role = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, userId);
                ps.setString(2, password);
                ps.setString(3, role);

                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    loginSuccess = true;
                    dbUserId = rs.getInt("id");  // Use id from DB
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (!loginSuccess) {
            response.setContentType("text/html");
            response.getWriter().println("<script type=\"text/javascript\">");
            response.getWriter().println("alert('Invalid credentials or role!');");
            response.getWriter().println("location='login.jsp';");
            response.getWriter().println("</script>");
            return;
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("Id", dbUserId);  // Capital I
            session.setAttribute("role", role);

            if (role.equals("admin")) {
                response.sendRedirect("dashboard_admin.jsp");
            } else {
                response.sendRedirect("dashboard_user.jsp");
            }
        }
    }
}
