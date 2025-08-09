import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("Role");

        // Password length check (server-side)
        if (password == null || password.length() < 4 || password.length() > 8) {
            out.println("<script>alert('Password must be between 4 and 8 characters!'); window.location='register.jsp';</script>");
            return;
        }

        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");

            String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    out.println("<script>");
                    out.println("alert('Registration Successful! Your Admission ID is: " + userId + " Keep it safe your Further use');");
                    out.println("window.location='login.jsp';");
                    out.println("</script>");
                }
            } else {
                out.println("<script>alert('Registration Failed!'); window.location='register.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace(); // for server logs
            out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); window.location='register.jsp';</script>");
        } finally {
            try { if (con != null) {
				con.close();
			} } catch (Exception ignored) {}
        }
    }
}
