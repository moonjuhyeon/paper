package com.paper.controller.user;


import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.tree.ExpandVetoException;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.paper.dto.Notice_infoDTO;
import com.paper.dto.Paper_infoDTO;
import com.paper.dto.Writer_infoDTO;
import com.paper.service.INoticeService;
import com.paper.service.IPaperService;
import com.paper.util.CmmUtil;
import com.paper.util.MergeUtil;
import com.paper.util.WgetUtil;


@Controller
public class PaperController {
	private Logger log = Logger.getLogger(this.getClass());
	
	String savePath = "/www/cupbobs_com/papers/originals/";
	
	@Resource(name="PaperService")
	private IPaperService paperService;
	@Resource(name="NoticeService")
	private INoticeService noticeService;

	@RequestMapping(value="paperReg")
	public String userPaperReg(HttpServletRequest req, Model model, HttpSession session) throws Exception{
		log.info(this.getClass().getName() + " userPaperReg Start!!");
		
		String nNo = CmmUtil.nvl(req.getParameter("noticeNo"));
		
		log.info(this.getClass() + " nNo = "+ nNo);
		
		model.addAttribute("nNo",nNo);
		
		nNo = null;
		log.info(this.getClass().getName() + " userPaperReg End!!");
		return "paperReg";
	}
	
	@RequestMapping(value="paperRegProc", method=RequestMethod.POST)
	public String paperRegProc(HttpServletRequest req, HttpServletResponse res, Model model, HttpSession session, @RequestParam("paper") MultipartFile file) throws Exception{
		log.info(this.getClass().getName()+ " .paperRegProc Start!!");
		
		String returnUrl = "";//���������� ��ȯ�� ������ �����̷�Ʈ �Ұ����� ��â ��������
		String msg = "";//��â�� ���ٸ� �� �޼���
		String url = "";//�� �� �̵��� ������
		
		String nNo = CmmUtil.nvl(req.getParameter("nNo"));//���� ��ȣ
		log.info(this.getClass() + " nNo : " + nNo);
		String paperKor = CmmUtil.nvl(req.getParameter("korName"));//�� �ѱ� �̸�
		log.info(this.getClass() + " paperKor : " + paperKor);
		String paperEng = CmmUtil.nvl(req.getParameter("engName"));//�� ���� �̸�
		log.info(this.getClass() + " paperEng : " + paperEng);
		String pType = CmmUtil.nvl(req.getParameter("pType"));//���ι�ǥ���� ������ ��������
		log.info(this.getClass() + " pType : " + pType);
		
		String writerNames[] = CmmUtil.nvlArr(req.getParameterValues("name"));//���ڵ��� �̸�
		for(String writerName : writerNames){
			log.info(this.getClass() + " writerName : " + writerName);
		}
		
		String writerEmails[] = CmmUtil.nvlArr(req.getParameterValues("email"));//���ڵ��� �̸���
		for(String writerEmail : writerEmails){
			log.info(this.getClass() + " writerEmail : " + writerEmail);
		}
		
		String writerBelongs[] = CmmUtil.nvlArr(req.getParameterValues("belong"));//���ڵ��� �Ҽ�
		for(String writerBelong : writerBelongs){
			log.info(this.getClass() + " writerBelong : " + writerBelong);
		}
		
		String userNo = CmmUtil.nvl((String)session.getAttribute("ss_user_no"));//����� ��ȣ
		String reFileName = "";//���� �̸��� �ð����� �ٲ� ����
		String  fileOrgName = CmmUtil.nvl(CmmUtil.fileNameCheck(file.getOriginalFilename()));//���� �̸��� �����ͼ� ��ť�� �˻� �� ��ó��
		log.info(this.getClass() + " fileOrgName : " + fileOrgName);
		
		String extended = fileOrgName.substring(fileOrgName.indexOf("."), fileOrgName.length());//���� Ȯ���� ����
		log.info(this.getClass() + " extended : " + extended);
		if(!extended.equals(".docx")){
			model.addAttribute("msg", ".docx���ϸ� ���ε� ���� �մϴ�.");
			model.addAttribute("url", "noticeList.do");
			return "alert";
		}
		
		String now = new SimpleDateFormat("yyyyMMddhmsS").format(new Date());
		Paper_infoDTO pDTO = new Paper_infoDTO();
		reFileName = savePath + now + extended;
		File newFile = new File(reFileName);
		file.transferTo(newFile);
		pDTO.setNotice_no(nNo);
		pDTO.setPaper_kor(paperKor);
		pDTO.setPaper_eng(paperEng);
		pDTO.setPaper_type(pType);
		pDTO.setUser_no(userNo);
		pDTO.setFile_org_name(fileOrgName);
		pDTO.setFile_path(savePath);
		pDTO.setFile_name(now + extended);
		pDTO.setPaper_ad("N");
		pDTO.setReg_user_no(userNo);
		
		List<Writer_infoDTO> wList = new ArrayList<Writer_infoDTO>();
		if(writerNames.length == writerEmails.length && writerEmails.length == writerBelongs.length 
				&& writerNames.length == writerBelongs.length){
			for(int i = 0; i< writerNames.length;i++){
				Writer_infoDTO wDTO = new Writer_infoDTO();
				wDTO.setNotice_no(nNo);
				wDTO.setWriter_name(writerNames[i]);
				wDTO.setWriter_email(writerEmails[i]);
				wDTO.setWriter_belong(writerBelongs[i]);
				wDTO.setReg_user_no(userNo);
				wList.add(wDTO);
			}
		}
		boolean result = false;
		result = paperService.insertPaperInfoAndWriter(pDTO, wList);
		if(result){
			msg = "��� �����߽��ϴ�.";
			url = "noticeList.do";
			model.addAttribute("msg", msg);
			model.addAttribute("url", url);
			returnUrl  = "alert";
		}else{
			msg = "��� ���� �߽��ϴ�.";
			url = "paperReg.do?nNo=" + nNo;
			model.addAttribute("msg", msg);
			model.addAttribute("url", url);
			returnUrl = "alert";
		}
		wList=null;
		writerBelongs=null;
		writerEmails=null;
		writerNames=null;
		nNo=null;
		userNo=null;
		fileOrgName=null;
		paperEng=null;
		paperKor=null;
		extended=null;
		pType=null;
		
		log.info(this.getClass().getName()+ " .paperRegProc End!!");
		return "alert";
	}
	@RequestMapping(value="paperList")
	public @ResponseBody List<Paper_infoDTO> paperList(@RequestParam(value="nNo") String nNo, @RequestParam(value="pAd") String pAd) throws Exception{
		log.info(this.getClass().getName() + " paperList Start!!");

		log.info(this.getClass().getName() + " nNo : " + nNo);
		log.info(this.getClass().getName() + " pAd : " + pAd);

		Paper_infoDTO pDTO = new Paper_infoDTO();
		pDTO.setNotice_no(nNo);
		pDTO.setPaper_adV(pAd);
		List<Paper_infoDTO> pList = paperService.getPaperList(pDTO);
		
		
		pDTO = null;
		nNo=null;
		pAd=null;
		log.info(this.getClass().getName() + " paperList End!!");
		return pList;
	}
	
	@RequestMapping(value="paperAdUpdate")
	public @ResponseBody List<Paper_infoDTO> paperAdUpdate(@RequestParam(value="nNo") String nNo, @RequestParam(value="pNo") String pNo, @RequestParam(value="pAd") String pAd, @RequestParam(value="pAdV") String pAdV)throws Exception{
		log.info(this.getClass().getName() + " paperAdUpdate Start!!");
		
		log.info(this.getClass().getName() + " nNo : " + nNo);
		log.info(this.getClass().getName() + " pNo : " + pNo);
		log.info(this.getClass().getName() + " pAd : " + pAd);
		// AD ���� ���� UPDATE ������ ���� AD ��
		log.info(this.getClass().getName() + " pAdV : " + pAdV);
		// ���� �����ִ� ������ �� AD��
		
		Paper_infoDTO pDTO = new Paper_infoDTO();
		pDTO.setPaper_no(pNo);
		pDTO.setNotice_no(nNo);
		pDTO.setPaper_ad(pAd);
		// UPDATE�� ��� DTO
		pDTO.setPaper_adV(pAdV);
		// SELECT�� ��� DTO
		List<Paper_infoDTO> pList = paperService.getUpdatePaperList(pDTO);
		// ���񽺿��� UPDATE �� SELECT �� ���� ����
		
		pDTO = null;
		nNo=null;
		pNo=null;
		pAd=null;
		pAdV=null;
		log.info(this.getClass().getName() + " paperAdUpdate End!!");
		return pList;
	}
	@RequestMapping(value="mergeDocxPage")
	public String mergeDockPage(HttpServletRequest req, Model model) throws Exception{
		log.info(this.getClass().getName() + " mergeDocxPage Start!!");
		String nNo = CmmUtil.nvl(req.getParameter("nNo"));
		String adV = CmmUtil.nvl(req.getParameter("adV"));
		// �հݵ� ���� SELECT �� �� �ֵ��� adV�� ����
		log.info(this.getClass().getName() + " nNo = "+nNo);
		log.info(this.getClass().getName() + " adV = "+adV);
		Paper_infoDTO pDTO = new Paper_infoDTO();
		pDTO.setNotice_no(nNo);
		pDTO.setPaper_adV(adV);
		
		List<Paper_infoDTO> pList = paperService.getPaperList(pDTO);
		
		model.addAttribute("pList", pList);
		pList=null;
		nNo=null;
		adV=null;
		log.info(this.getClass().getName() + " mergeDocxPage End!!");
		return "admin/adminPaperMergePop";
	}
	@RequestMapping(value="downloadDocx")
	public @ResponseBody String downloadDocx(HttpServletRequest req, Model model) throws Exception{
		log.info(this.getClass().getName()+ "downloadDocx Start!!");
		
		String nNo = CmmUtil.nvl(req.getParameter("nNo"));
		String fileNames[] = req.getParameterValues("downFileName");
		// Values�� ������� fileName���� �迭�� �޾� ��
		String inputUrl = "http://www.cupbobs.com/papers/";
		String outputPath = "/www/papers/"+nNo;
//		String outputPath = "C:\\www\\"+nNo;
		File mkDir = new File(outputPath);
		
		if(mkDir.exists()){
			WgetUtil.delFile(outputPath);
		}
		
		mkDir.mkdirs();
		
		for(String fileName : fileNames){
			WgetUtil.wget(inputUrl+fileName, outputPath);
		}
		log.info(this.getClass().getName()+ "downloadDocx End!!");
		
		return "Success";
	}
	
	@RequestMapping(value="mergeDocxProc")
	public String mergeDockProc(HttpServletRequest req, Model model) throws Exception{
		log.info(this.getClass().getName() + " mergeDocxProc Start!!");
		String nNo = CmmUtil.nvl(req.getParameter("nNo"));
		String fileNames[] = req.getParameterValues("fileName");
		// Values�� ������� fileName���� �迭�� �޾� ��
		String outPath = "/www/papers/"+nNo+"/merged/";
		String outFile = nNo + ".docx";
		// �����ؾ� �� Ȯ���ڴ� .docx 
		Notice_infoDTO nDTO = new Notice_infoDTO();
		nDTO.setNotice_no(nNo);
		nDTO.setFile_name(outFile);
		nDTO.setFile_path(outPath);
		noticeService.updateMergeFile(nDTO);
		// NOTICE_INFO ���̺� �ش� ������ ���յ� ���� �̸��� ��θ� �����ϱ� ���� UPDATE���� ����
		File mkDir = new File(outPath);
		
		if(mkDir.exists()){
			WgetUtil.delFile(outPath);
		}
		mkDir.mkdirs();

		MergeUtil.mergeDocx(MergeUtil.inputFiles(fileNames), new FileOutputStream(new File(outPath+outFile)));
		// MergeUtil �� mergeDocx �޼ҵ�� fileNames�� ����� ����� ������ ���� ��
		// ������ ���� �� outPath�� outFile�� ���� �� ������ �̸��� ��θ� ������ ��
		
		model.addAttribute("url", "adminMergeDownPop.do?nNo="+nNo);
		model.addAttribute("msg", "���տϷ�");
		
		log.info(this.getClass().getName() + " mergeDocxProc End!!");
		return "admin/userAlert";
	}
	@RequestMapping(value="updatePaperAdCheck")
	public @ResponseBody String updatePaperAdCheck(@RequestParam(value="nNo") String nNo, @RequestParam(value="allupAd") String allupAd, @RequestParam(value="upCheck[]") String[] upCheck)throws Exception{
		log.info(this.getClass().getName()+ " updatePaperAdCheck Start!!");
		
		Paper_infoDTO pDTO = new Paper_infoDTO();
		pDTO.setNotice_no(nNo);
		pDTO.setPaper_ad(allupAd);
		pDTO.setAllCheck(upCheck);
		System.out.println(nNo);
		System.out.println(allupAd);
		for (String s : upCheck){
			System.out.println(s);
		}
		
		paperService.updateCheckAd(pDTO);
		
		pDTO=null;
		nNo=null;
		upCheck=null;
		log.info(this.getClass().getName()+ " updatePaperAdCheck End!!");
		return "Success";
	}
	@RequestMapping(value="filetest")
	public String fileTest(HttpServletRequest req, HttpServletResponse resp, Model model, HttpSession session) throws Exception{
		log.info(this.getClass() + ".filetest start!!!");
		
		log.info(this.getClass() + ".filetest end!!!");
		return "fileDownloadTest";
	}
}
