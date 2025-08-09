import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ReturnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String transactionIdStr = request.getParameter("transactionId");
        if (transactionIdStr == null) {
            response.sendRedirect("return.jsp");
            return;
        }

        int transactionId = Integer.parseInt(transactionIdStr);

        Connection conn = null;
        PreparedStatement psUpdateTrans = null;
        PreparedStatement psGetBookId = null;
        PreparedStatement psUpdateBookQty = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "Vamsi", "Vamsi@826742");
            conn.setAutoCommit(false);

            // 1. Get book_id for the transaction
            String getBookIdSql = "SELECT book_id FROM transactions WHERE transaction_id = ?";
            psGetBookId = conn.prepareStatement(getBookIdSql);
            psGetBookId.setInt(1, transactionId);
            rs = psGetBookId.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                response.sendRedirect("return.jsp");
                return;
            }
            int bookId = rs.getInt("book_id");
            rs.close();
            psGetBookId.close();

            // 2. Update transaction status to 'returned'
            String updateTransSql = "UPDATE transactions SET status = 'returned' WHERE transaction_id = ?";
            psUpdateTrans = conn.prepareStatement(updateTransSql);
            psUpdateTrans.setInt(1, transactionId);
            psUpdateTrans.executeUpdate();

            // 3. Increase quantity of the book
            String updateBookSql = "UPDATE books SET quantity = quantity + 1 WHERE id = ?";
            psUpdateBookQty = conn.prepareStatement(updateBookSql);
            psUpdateBookQty.setInt(1, bookId);
            psUpdateBookQty.executeUpdate();

            conn.commit();

            // Redirect back to return.jsp
            response.sendRedirect("return.jsp");
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            response.sendRedirect("return.jsp?error=" + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (psUpdateTrans != null) psUpdateTrans.close(); } catch (Exception ignored) {}
            try { if (psGetBookId != null) psGetBookId.close(); } catch (Exception ignored) {}
            try { if (psUpdateBookQty != null) psUpdateBookQty.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
