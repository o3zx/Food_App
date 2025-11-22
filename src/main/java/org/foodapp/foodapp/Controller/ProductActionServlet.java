package org.foodapp.foodapp.Controller;

import org.foodapp.foodapp.Product;
import org.foodapp.foodapp.ProductDAO;
import org.foodapp.foodapp.User;

import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.servlet6.JakartaServletFileUpload;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet("/adminProductAction")
public class ProductActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Access Denied");
            return;
        }

        String redirectURL = "adminManageProducts.jsp";
        ProductDAO productDAO = new ProductDAO();
        Product product = new Product();

        String action = null;
        String manualUrl = null; // To hold the text URL
        FileItem fileItem = null;
        String deleteIdStr = null;

        try {
            if (JakartaServletFileUpload.isMultipartContent(request)) {
                var factory = new DiskFileItemFactory.Builder().get();
                var upload = new JakartaServletFileUpload(factory);
                List<FileItem> formItems = upload.parseRequest(request);

                for (FileItem item : formItems) {
                    if (item.isFormField()) {
                        String fieldName = item.getFieldName();
                        String value = item.getString();

                        if (fieldName.equals("action")) action = value;
                        else if (fieldName.equals("id")) product.setID(Integer.parseInt(value));
                        else if (fieldName.equals("name")) product.setName(value);
                        else if (fieldName.equals("description")) product.setDescription(value);
                        else if (fieldName.equals("price")) product.setPrice(Double.parseDouble(value));
                        else if (fieldName.equals("category")) product.setCategory(value);
                        else if (fieldName.equals("productId")) deleteIdStr = value;
                            // Capture the manual URL text field
                        else if (fieldName.equals("imageUrl")) manualUrl = value;
                    } else {
                        if (item.getSize() > 0) fileItem = item;
                    }
                }

                // --- HYBRID IMAGE LOGIC ---
                if (fileItem != null) {
                    // 1. If File Uploaded -> Save to Disk
                    String uploadPath = getServletContext().getRealPath("/") + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    String originalFileName = Paths.get(fileItem.getName()).getFileName().toString();
                    String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    String savedFileName = UUID.randomUUID().toString() + fileExtension;

                    fileItem.write(new File(uploadPath + File.separator + savedFileName).toPath());
                    product.setImageUrl(savedFileName); // Save "123.jpg"

                } else if (manualUrl != null && !manualUrl.trim().isEmpty()) {
                    // 2. If No File, but URL Text exists -> Save URL
                    product.setImageUrl(manualUrl); // Save "https://..."
                }
                // ---------------------------

                if ("add".equals(action)) {
                    boolean success = productDAO.addProduct(product);
                    redirectURL += success ? "?success=Product added!" : "?error=Failed.";
                } else if ("update".equals(action)) {
                    if (product.getImageUrl() == null) {
                        // If no new file AND no new URL, keep old one
                        Product oldProduct = productDAO.getProductById(product.getId());
                        product.setImageUrl(oldProduct.getImageUrl());
                    }
                    boolean success = productDAO.updateProduct(product);
                    redirectURL += success ? "?success=Updated!" : "?error=Failed.";
                } else if ("delete".equals(action) && deleteIdStr != null) {
                    boolean success = productDAO.deleteProduct(Integer.parseInt(deleteIdStr));
                    redirectURL += success ? "?success=Deleted!" : "?error=Failed.";
                }
            }
            // ... (keep your existing 'else' block for simple delete actions) ...

        } catch (Exception e) {
            e.printStackTrace();
            redirectURL += "?error=Error: " + e.getMessage();
        }

        response.sendRedirect(redirectURL);
    }
}