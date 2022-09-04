package kr.ac.spring.file.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.coobird.thumbnailator.Thumbnails;

@Controller
public class FileDownloadController {
	private static final String BOARD_IMAGE_REPO = "resource/images/upload";
	private static final String PRODUCT_IMAGE_REPO = "resources/images/BookImg";
	private static final String CURR_IMAGE_REPO = "C:\\shopping\\file_repo";
	

	@RequestMapping("/download.do")
	protected void download(@RequestParam("imageFileName") String imageFileName, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String path = request.getSession().getServletContext().getRealPath(BOARD_IMAGE_REPO);
		String downFile = path + "/" + imageFileName;
		File file = new File(downFile);

		response.setHeader("Cache-Control", "no-cache");
		response.addHeader("Content-disposition", "attachment; fileName=" + imageFileName);
		FileInputStream in = new FileInputStream(file);
		byte[] buffer = new byte[1024 * 8];
		while (true) {
			int count = in.read(buffer);
			if (count == -1)
				break;
			out.write(buffer, 0, count);
		}
		in.close();
		out.close();
	}
	
	@RequestMapping("/download2.do")
	protected void download2(@RequestParam("imageFileName") String imageFileName, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String path = request.getSession().getServletContext().getRealPath(PRODUCT_IMAGE_REPO);
		String downFile = path + "/" + imageFileName;
		File file = new File(downFile);

		response.setHeader("Cache-Control", "no-cache");
		response.addHeader("Content-disposition", "attachment; fileName=" + imageFileName);
		FileInputStream in = new FileInputStream(file);
		byte[] buffer = new byte[1024 * 8];
		while (true) {
			int count = in.read(buffer);
			if (count == -1)
				break;
			out.write(buffer, 0, count);
		}
		in.close();
		out.close();
	}
	// 퀵메뉴의 썸네일 이미지
	@RequestMapping("/thumbnails")
	protected void thumbnails(@RequestParam("imageFileName") String imageFileName,
                            	@RequestParam("bookNo") String bookNo,
			                 HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath=CURR_IMAGE_REPO+"\\"+bookNo+"\\"+imageFileName;
		File image=new File(filePath);
		
//		int lastIndex = imageFileName.lastIndexOf(".");
//		String fileName = imageFileName.substring(0,lastIndex);
		if (image.exists()) { 
			Thumbnails.of(image).size(121,154).outputFormat("png").toOutputStream(out);
		}
		byte[] buffer = new byte[1024 * 8];
		out.write(buffer);
		out.close();
	}

}