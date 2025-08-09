

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddBookServlet")
public class AddBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookName = request.getParameter("bookName");
        String alternateTitle = request.getParameter("alternateTitle");
        String author = request.getParameter("author");
        String language = request.getParameter("language");
        String publisher = request.getParameter("publisher");
        int copies = Integer.parseInt(request.getParameter("copies"));
        @SuppressWarnings("unused")
		String[] categories = request.getParameterValues("categories");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "root", "your_password");

            String sql = "INSERT INTO books (title, alternateTitle, author, language, publisher, quantity, available_quantity, added_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookName);
            pstmt.setString(2, alternateTitle);
            pstmt.setString(3, author);
            pstmt.setString(4, language);
            pstmt.setString(5, publisher);
            pstmt.setInt(6, copies);
            pstmt.setInt(7, copies);
            pstmt.setTimestamp(8, new Timestamp(new Date().getTime()));
            pstmt.executeUpdate();

            // To handle categories, you would need a separate join table (e.g., book_categories)
            // and additional logic to insert entries for each selected category.
            // This is a simplified example.

            // Redirect back to the AddBook.jsp to show the updated table and clear the form
            response.sendRedirect("add_book.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to an error page
        } finally {
            try { if (pstmt != null) {
				pstmt.close();
			} } catch (Exception e) {}
            try { if (conn != null) {
				conn.close();
			} } catch (Exception e) {}
        }
    }
}