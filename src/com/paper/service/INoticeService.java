package com.paper.service;

import java.util.List;

import com.paper.dto.Notice_infoDTO;

public interface INoticeService {

	public List<Notice_infoDTO> getNoticeList() throws Exception;

}