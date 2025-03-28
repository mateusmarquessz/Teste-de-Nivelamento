package org.example;


import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.client5.http.fluent.Content;
import org.apache.log4j.BasicConfigurator;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import java.io.*;
import java.nio.file.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class WebScraper {
    private static final String URL_SITE = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos";
    private static final String DOWNLOAD_FOLDER = "downloads";
    private static final String ZIP_FILE = "anexos.zip";



    public static void main(String[] args) {
        try {
            Files.createDirectories(Paths.get(DOWNLOAD_FOLDER));

            Document doc = Jsoup.connect(URL_SITE).get();
            for (Element link : doc.select("a[href$=.pdf]")) {
                String fileUrl = link.absUrl("href");
                String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
                System.out.println("Baixando: " + fileUrl);
                downloadFile(fileUrl, DOWNLOAD_FOLDER + "/" + fileName);
            }
            zipFiles(DOWNLOAD_FOLDER, ZIP_FILE);
            System.out.println("Arquivos compactados em " + ZIP_FILE);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void downloadFile(String fileUrl, String outputPath) throws IOException {
        if (fileUrl.contains("Anexo_I") || fileUrl.contains("Anexo_II")) {
            Content content = Request.get(fileUrl).execute().returnContent();
            try (FileOutputStream fos = new FileOutputStream(outputPath)) {
                fos.write(content.asBytes());
            }
            System.out.println("Arquivo salvo: " + outputPath);
        } else {
            System.out.println("Ignorando arquivo: " + fileUrl);
        }
    }


    private static void zipFiles(String sourceDir, String zipFile) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(zipFile);
             ZipOutputStream zos = new ZipOutputStream(fos)) {
            Files.walk(Paths.get(sourceDir)).filter(Files::isRegularFile).forEach(path -> {
                try {
                    ZipEntry zipEntry = new ZipEntry(path.getFileName().toString());
                    zos.putNextEntry(zipEntry);
                    Files.copy(path, zos);
                    zos.closeEntry();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        }
    }
}
