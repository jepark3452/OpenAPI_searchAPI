package org.jepark.openAPI;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {
	
	// OpenAPI 우편번호 찾기 searchAPI confmKey
	@Value("#{prop['searchAPI.confmKey']}")
	private String searchConfmKey;
	
	// OpenAPI 우편번호 찾기 popupAPI confmKey
	@Value("#{prop['popupAPI.confmKey']}")
	private String popConfmKey;
	
	@RequestMapping(value="/sample/apiSampleJSONP.do")
    public ModelAndView apiSampleJSONP() throws Exception{
		ModelAndView mav = new ModelAndView("/apiSampleJSONP");
		mav.addObject("confmKey", searchConfmKey);
        return mav;
    }
	
	@RequestMapping(value="/sample/apiSampleXML.do")
    public ModelAndView apiSampleXML() throws Exception{
        return new ModelAndView("/apiSampleXML");
    }
	
	@RequestMapping(value="/sample/apiSampleXMLPop.do")
    public ModelAndView apiSampleXMLPop() throws Exception{
        return new ModelAndView("/apiSampleXMLPop");
    }
	
	@RequestMapping(value="/sample/popup/apiSamplePopup.do")
    public ModelAndView apiSamplePopup() throws Exception{
        return new ModelAndView("/popup/apiSamplePopup");
    }
	
	@RequestMapping(value="/sample/getAddrApi.do")
    public void getAddrApi(HttpServletRequest req, ModelMap model, HttpServletResponse response) throws Exception {
		// 요청변수 설정
		String currentPage = req.getParameter("currentPage");
		String countPerPage = req.getParameter("countPerPage");
		String keyword = req.getParameter("keyword");
		// OPEN API 호출 URL 정보 설정
		String apiUrl = "http://www.juso.go.kr/addrlink/addrLinkApi.do?currentPage="+currentPage+"&countPerPage="+countPerPage+"&keyword="+URLEncoder.encode(keyword,"UTF-8")+"&confmKey="+searchConfmKey;
		System.out.println("[apiUrl]: " + apiUrl.toString());
		URL url = new URL(apiUrl);
    	BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
    	StringBuffer sb = new StringBuffer();
    	String tempStr = null;

    	while(true){
    		tempStr = br.readLine();
    		if(tempStr == null) break;
    		sb.append(tempStr);									// 응답결과 XML 저장
    	}
    	br.close();
    	response.setCharacterEncoding("UTF-8");
		response.setContentType("text/xml");
		response.getWriter().write(sb.toString());			// 응답결과 반환
    }
	
}
