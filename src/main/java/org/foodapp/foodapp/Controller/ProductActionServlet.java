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

@WebServlet("/adminProductAction") // Maps to the URL "/adminProductAction"
public class ProductActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Admin Authentication Check
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Access Denied");
            return;
        }

        String redirectURL = "adminManageProducts.jsp";
        ProductDAO productDAO = new ProductDAO();

        // Objects to hold data
        Product product = new Product();
        String action = null;
        String uploadedFileName = null;
        FileItem fileItem = null;
        // We need a separate variable for delete IDs since they might come from a non-multipart form
        String deleteIdStr = null;

        try {
            // 2. Check if it is a File Upload request (Multipart)
            if (JakartaServletFileUpload.isMultipartContent(request)) {

                // Configure upload
                var factory = new DiskFileItemFactory.Builder().get();
                var upload = new JakartaServletFileUpload(factory);
                List<FileItem> formItems = upload.parseRequest(request);

                // Loop through fields
                for (FileItem item : formItems) {
                    if (item.isFormField()) {
                        // Text Fields
                        String fieldName = item.getFieldName();
                        String value = item.getString();

                        if (fieldName.equals("action")) action = value;
                        else if (fieldName.equals("id")) product.setID(Integer.parseInt(value));
                        else if (fieldName.equals("name")) product.setName(value);
                        else if (fieldName.equals("description")) product.setDescription(value);
                        else if (fieldName.equals("price")) product.setPrice(Double.parseDouble(value));
                        else if (fieldName.equals("category")) product.setCategory(value);
                        else if (fieldName.equals("productId")) deleteIdStr = value; // Handle delete in multipart if needed
                    } else {
                        // File Field
                        if (item.getSize() > 0) {
                            fileItem = item;
                        }
                    }
                }

                // --- Process File if it exists ---
                if (fileItem != null) {
                    String uploadPath = getServletContext().getRealPath("/") + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    String originalFileName = Paths.get(fileItem.getName()).getFileName().toString();
                    String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    uploadedFileName = UUID.randomUUID().toString() + fileExtension;

                    File storeFile = new File(uploadPath + File.separator + uploadedFileName);
                    fileItem.write(storeFile.toPath());

                    product.setImageUrl(uploadedFileName);
                }

                // --- Execute Database Action ---
                if ("add".equals(action)) {
                    boolean success = productDAO.addProduct(product);
                    redirectURL += success ? "?success=Product added!" : "?error=Failed to add product.";
                } else if ("update".equals(action)) {
                    if (uploadedFileName == null) {
                        // Keep old image if no new one uploaded
                        Product oldProduct = productDAO.getProductById(product.getId());
                        product.setImageUrl(oldProduct.getImageUrl());
                    }
                    boolean success = productDAO.updateProduct(product);
                    redirectURL += success ? "?success=Product updated!" : "?error=Failed to update product.";
                } else if ("delete".equals(action)) {
                    // Sometimes delete comes as multipart depending on the form
                    if (deleteIdStr != null) {
                        boolean success = productDAO.deleteProduct(Integer.parseInt(deleteIdStr));
                        redirectURL += success ? "?success=Deleted!" : "?error=Failed to delete.";
                    }
                }

            } else {
                // 3. Handle Regular Form Requests (like Delete button)
                // This block runs if the form did NOT have enctype="multipart/form-data"
                action = request.getParameter("action");
                if ("delete".equals(action)) {
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    boolean success = productDAO.deleteProduct(productId);
                    redirectURL += success ? "?success=Product deleted!" : "?error=Failed to delete product.";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectURL += "?error=Error: " + e.getMessage();
        }

        // 4. Redirect
        response.sendRedirect(redirectURL);
    }
}