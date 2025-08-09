import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/BorrowBookServlet")
public class BorrowBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int BORROW_PERIOD_DAYS = 5;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("Id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = (int) session.getAttribute("Id");

        Connection conn = null;
        PreparedStatement psCheckQty = null;
        PreparedStatement psUpdateQty = null;
        PreparedStatement psInsertTrans = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
            conn.setAutoCommit(false);

            psCheckQty = conn.prepareStatement("SELECT quantity FROM books WHERE id = ? FOR UPDATE");
            psCheckQty.setInt(1, bookId);
            rs = psCheckQty.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("Book not found.");
                conn.rollback();
                return;
            }

            int quantity = rs.getInt("quantity");
            if (quantity <= 0) {
                response.getWriter().println("Book not available for borrowing.");
                conn.rollback();
                return;
            }
            rs.close();
            psCheckQty.close();

            psUpdateQty = conn.prepareStatement("UPDATE books SET quantity = quantity - 1 WHERE id = ?");
            psUpdateQty.setInt(1, bookId);
            psUpdateQty.executeUpdate();

            LocalDate startDate = LocalDate.now();
            LocalDate dueDate = startDate.plusDays(BORROW_PERIOD_DAYS);

            psInsertTrans = conn.prepareStatement(
            	    "INSERT INTO transactions(user_id, book_id, transaction_type, start_date, due_date, status) VALUES (?, ?, ?, ?, ?, ?)"
            	);
            	psInsertTrans.setInt(1, userId);
            	psInsertTrans.setInt(2, bookId);
            	psInsertTrans.setString(3, "borrowed");
            	psInsertTrans.setDate(4, java.sql.Date.valueOf(startDate));
            	psInsertTrans.setDate(5, java.sql.Date.valueOf(dueDate));
            	psInsertTrans.setString(6, "active");

            	psInsertTrans.executeUpdate();


            conn.commit();

            response.sendRedirect("activeBooks.jsp?message=Book Borrowed Successfully");
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (psCheckQty != null) psCheckQty.close(); } catch (SQLException ignored) {}
            try { if (psUpdateQty != null) psUpdateQty.close(); } catch (SQLException ignored) {}
            try { if (psInsertTrans != null) psInsertTrans.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
