package web;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

	private static final String SAVE_DIR = "C:/workspace/party/images";

	// POST, PUT, DELETE 등의 요청에 대해서는 405 Method Not Allowed 반환
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String requestedFile = request.getPathInfo();
		File file = new File(SAVE_DIR, URLDecoder.decode(requestedFile, "UTF-8"));
		
		if (!file.exists()) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
			return;
		}
		
		String contentType = getServletContext().getMimeType(file.getName());
		// MIME가 image/ 아니면 404 반환
		if (contentType == null || !contentType.startsWith("image")) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404.
			return;
		}
		
		response.setContentType(contentType);
		response.setContentLengthLong(file.length());
			
		Files.copy(file.toPath(), response.getOutputStream());
    }
}
