<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Import all necessary classes --%>
<%@ page import="org.foodapp.foodapp.User" %>
<%@ page import="org.foodapp.foodapp.Product" %>
<%@ page import="org.foodapp.foodapp.ProductDAO" %>

<%-- Import Apache File Upload libraries --%>
<%@ page import="org.apache.commons.fileupload2.core.*" %>
<%@ page import="org.apache.commons.fileupload2.jakarta.servlet6.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.UUID" %>

<%
    // 1. Admin Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp?error=Access Denied");
        return;
    }

    String redirectURL = "adminManageProducts.jsp";
    ProductDAO productDAO = new ProductDAO();

    // Create a new Product object to hold our form data
    Product product = new Product();
    String action = null;
    String uploadedFileName = null; // Will hold the name of the new file
    FileItem fileItem = null;       // Will hold the file data

    try {
        // 2. Check if the form is a multipart (file upload) form
        if (JakartaServletFileUpload.isMultipartContent(request)) {

            // 3. Configure the file upload processor
            var factory = new DiskFileItemFactory.Builder().get();
            var upload = new JakartaServletFileUpload(factory);

            // 4. Parse the incoming request
            List<FileItem> formItems = upload.parseRequest(request);

            // 5. Loop through all form parts (text fields and file)
            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    // It's a regular text field
                    String fieldName = item.getFieldName();
                    String value = item.getString();

                    if (fieldName.equals("action")) {
                        action = value;
                    } else if (fieldName.equals("id")) {
                        product.setID(Integer.parseInt(value));
                    } else if (fieldName.equals("name")) {
                        product.setName(value);
                    } else if (fieldName.equals("description")) {
                        product.setDescription(value);
                    } else if (fieldName.equals("price")) {
                        product.setPrice(Double.parseDouble(value));
                    } else if (fieldName.equals("category")) {
                        product.setCategory(value);
                    }
                } else {
                    // It's the file!
                    if (item.getSize() > 0) { // Check if a file was actually uploaded
                        fileItem = item; // Save the file item for later
                    }
                }
            }

            // --- 6. Now that we have all data, process the file (if it exists) ---
            if (fileItem != null) {
                // Get the real path to our "uploads" folder
                String uploadPath = application.getRealPath("/") + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir(); // Create /uploads if it doesn't exist

                // Get original filename and extension
                String originalFileName = Paths.get(fileItem.getName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));

                // Create a new, unique filename to prevent overwrites
                uploadedFileName = UUID.randomUUID().toString() + fileExtension;

                // Save the file to disk
                File storeFile = new File(uploadPath + File.separator + uploadedFileName);
                fileItem.write(storeFile.toPath());

                // Set the new filename on our product object
                product.setImageUrl(uploadedFileName);
            }

            // --- 7. Perform the Database Action ---
            if ("add".equals(action)) {
                boolean success = productDAO.addProduct(product);
                if (success) {
                    redirectURL += "?success=Product added successfully!";
                } else {
                    redirectURL += "?error=Failed to add product.";
                }
            } else if ("update".equals(action)) {
                // If no new file was uploaded, we must keep the old image URL
                if (uploadedFileName == null) {
                    Product oldProduct = productDAO.getProductById(product.getId());
                    product.setImageUrl(oldProduct.getImageUrl());
                }

                boolean success = productDAO.updateProduct(product);
                if (success) {
                    redirectURL += "?success=Product updated successfully!";
                } else {
                    redirectURL += "?error=Failed to update product.";
                }
            }

        } else if ("delete".equals(request.getParameter("action"))) {
            // 8. Handle "delete" (which is not a multipart form)
            int productId = Integer.parseInt(request.getParameter("productId"));
            // (Note: This doesn't delete the file from /uploads, just the DB entry)
            boolean success = productDAO.deleteProduct(productId);
            if (success) {
                redirectURL += "?success=Product deleted successfully!";
            } else {
                redirectURL += "?error=Failed to delete product.";
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        redirectURL += "?error=An error occurred: " + e.getMessage();
    }

    // 9. Redirect the admin back
    response.sendRedirect(redirectURL);
%>