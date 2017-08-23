package com.paper.util;

import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.docx4j.jaxb.Context;
import org.docx4j.openpackaging.contenttype.ContentType;
import org.docx4j.openpackaging.io.SaveToZipFile;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;
import org.docx4j.openpackaging.parts.PartName;
import org.docx4j.openpackaging.parts.WordprocessingML.AlternativeFormatInputPart;
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart;
import org.docx4j.org.apache.poi.util.IOUtils;
import org.docx4j.relationships.Relationship;
import org.docx4j.wml.Br;
import org.docx4j.wml.CTAltChunk;
import org.docx4j.wml.ObjectFactory;
import org.docx4j.wml.P;
import org.docx4j.wml.STBrType;

public class MergeUtil {
    private static long chunk = 0;
    private static final String CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    private static ObjectFactory factory;

    public static void mergeDocx(FileInputStream s1[], FileOutputStream os) throws Exception {
       System.out.println(s1.length);
       if(s1.length>2){
          WordprocessingMLPackage target = WordprocessingMLPackage.load(s1[0]);
            factory = Context.getWmlObjectFactory();
          addPageBreak(target);
          SaveToZipFile saver = new SaveToZipFile(null);
          for(int i =1; i<s1.length;i++){
              insertDocx(target.getMainDocumentPart(), IOUtils.toByteArray(s1[i]));
              if(i<s1.length-1){
                 addPageBreak(target);
              }
                saver = new SaveToZipFile(target);
                System.out.println(i);
          }
          saver.save(os);   
             return;
       }else{
           WordprocessingMLPackage target = WordprocessingMLPackage.load(s1[0]);
            insertDocx(target.getMainDocumentPart(), IOUtils.toByteArray(s1[1]));
          addPageBreak(target);
            SaveToZipFile saver = new SaveToZipFile(target);
            saver.save(os);   
       }
    }

    private static void insertDocx(MainDocumentPart main, byte[] bytes) throws Exception {
            AlternativeFormatInputPart afiPart = new AlternativeFormatInputPart(new PartName("/part" + (chunk++) + ".docx"));
            afiPart.setContentType(new ContentType(CONTENT_TYPE));
            afiPart.setBinaryData(bytes);
            Relationship altChunkRel = main.addTargetPart(afiPart);

            CTAltChunk chunk = Context.getWmlObjectFactory().createCTAltChunk();
            chunk.setId(altChunkRel.getId());

            main.addObject(chunk);
    }
    private static void addPageBreak(WordprocessingMLPackage doc) {
        MainDocumentPart documentPart = doc.getMainDocumentPart();

        Br breakObj = new Br();
        breakObj.setType(STBrType.PAGE);

        P paragraph = factory.createP();
        paragraph.getContent().add(breakObj);
        documentPart.getJaxbElement().getBody().getContent().add(paragraph);
    }
}
