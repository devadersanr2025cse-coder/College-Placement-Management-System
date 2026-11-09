package com.cpms.service;

import com.cpms.dao.ReportDAO;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

public class ReportService {

    private final ReportDAO reportDAO;

    public ReportService() {
        this.reportDAO = new ReportDAO();
    }

    public byte[] generatePlacementSummaryPdf(int officerUserId) throws IOException {
        Map<String, Object> overall = reportDAO.getOverallPlacementStats();
        List<Map<String, Object>> deptStats = reportDAO.getDepartmentWisePlacementStats();
        List<Map<String, Object>> companyStats = reportDAO.getCompanyWisePlacements();

        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                PDType1Font boldFont = new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);
                PDType1Font regularFont = new PDType1Font(Standard14Fonts.FontName.HELVETICA);

                float y = 780;

                // Title Banner
                cs.beginText();
                cs.setFont(boldFont, 18);
                cs.newLineAtOffset(50, y);
                cs.showText("COLLEGE PLACEMENT MANAGEMENT SYSTEM");
                cs.endText();

                y -= 25;
                cs.beginText();
                cs.setFont(boldFont, 14);
                cs.newLineAtOffset(50, y);
                cs.showText("Official Executive Placement Report");
                cs.endText();

                y -= 15;
                cs.beginText();
                cs.setFont(regularFont, 10);
                cs.newLineAtOffset(50, y);
                cs.showText("Generated On: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm:ss")));
                cs.endText();

                // Separator Line
                y -= 15;
                cs.moveTo(50, y);
                cs.lineTo(550, y);
                cs.stroke();

                // Overall Statistics Section
                y -= 25;
                cs.beginText();
                cs.setFont(boldFont, 12);
                cs.newLineAtOffset(50, y);
                cs.showText("1. OVERALL PLACEMENT METRICS");
                cs.endText();

                y -= 18;
                cs.beginText();
                cs.setFont(regularFont, 10);
                cs.newLineAtOffset(60, y);
                cs.showText("Total Registered Students: " + overall.getOrDefault("registeredStudents", 0) +
                            "  |  Total Placed Students: " + overall.getOrDefault("placedStudents", 0) +
                            "  |  Placement Rate: " + overall.getOrDefault("placementPercentage", 0) + "%");
                cs.endText();

                y -= 15;
                cs.beginText();
                cs.setFont(regularFont, 10);
                cs.newLineAtOffset(60, y);
                cs.showText("Active Job Postings: " + overall.getOrDefault("activeJobs", 0) +
                            "  |  Total Partner Companies: " + overall.getOrDefault("totalCompanies", 0) +
                            "  |  Applications Processed: " + overall.getOrDefault("totalApplications", 0));
                cs.endText();

                // Department Statistics Section
                y -= 30;
                cs.beginText();
                cs.setFont(boldFont, 12);
                cs.newLineAtOffset(50, y);
                cs.showText("2. DEPARTMENT-WISE PLACEMENT BREAKDOWN");
                cs.endText();

                y -= 18;
                cs.beginText();
                cs.setFont(boldFont, 9);
                cs.newLineAtOffset(60, y);
                cs.showText(String.format("%-42s %-12s %-12s %-10s", "Department", "Registered", "Placed", "Placement %"));
                cs.endText();

                for (Map<String, Object> dept : deptStats) {
                    y -= 14;
                    if (y < 80) break; // page limit check
                    cs.beginText();
                    cs.setFont(regularFont, 9);
                    cs.newLineAtOffset(60, y);
                    String deptName = (String) dept.get("departmentName");
                    if (deptName.length() > 38) deptName = deptName.substring(0, 35) + "...";
                    cs.showText(String.format("%-42s %-12s %-12s %-10s%%",
                            deptName,
                            dept.get("registeredStudents"),
                            dept.get("placedStudents"),
                            dept.get("placementPercentage")));
                    cs.endText();
                }

                // Company Placement Statistics Section
                y -= 30;
                if (y > 100) {
                    cs.beginText();
                    cs.setFont(boldFont, 12);
                    cs.newLineAtOffset(50, y);
                    cs.showText("3. TOP HIRING PARTNERS");
                    cs.endText();

                    y -= 18;
                    cs.beginText();
                    cs.setFont(boldFont, 9);
                    cs.newLineAtOffset(60, y);
                    cs.showText(String.format("%-35s %-25s %-12s %-12s", "Company Name", "Industry", "Offers", "Max LPA"));
                    cs.endText();

                    for (Map<String, Object> comp : companyStats) {
                        y -= 14;
                        if (y < 60) break;
                        cs.beginText();
                        cs.setFont(regularFont, 9);
                        cs.newLineAtOffset(60, y);
                        String compName = (String) comp.get("companyName");
                        if (compName.length() > 30) compName = compName.substring(0, 28) + "...";
                        String ind = (String) comp.getOrDefault("industry", "N/A");
                        if (ind == null) ind = "N/A";
                        if (ind.length() > 20) ind = ind.substring(0, 18) + "...";
                        BigDecimal pkg = (BigDecimal) comp.get("highestPackage");

                        cs.showText(String.format("%-35s %-25s %-12s %-12s",
                                compName,
                                ind,
                                comp.get("hiredCount"),
                                pkg != null ? pkg.toString() + " LPA" : "N/A"));
                        cs.endText();
                    }
                }

                // Footer
                cs.beginText();
                cs.setFont(regularFont, 8);
                cs.newLineAtOffset(50, 30);
                cs.showText("Official Document | College Placement Cell - Confidential");
                cs.endText();
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            document.save(baos);

            reportDAO.logReportHistory(officerUserId, "PLACEMENT_SUMMARY", "PDF", "memory_download");
            return baos.toByteArray();
        }
    }

    public byte[] generatePlacementSummaryExcel(int officerUserId) throws IOException {
        Map<String, Object> overall = reportDAO.getOverallPlacementStats();
        List<Map<String, Object>> deptStats = reportDAO.getDepartmentWisePlacementStats();
        List<Map<String, Object>> companyStats = reportDAO.getCompanyWisePlacements();

        try (Workbook workbook = new XSSFWorkbook()) {
            // Style setup
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);

            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);

            // 1. Sheet: Overall Metrics
            Sheet summarySheet = workbook.createSheet("Placement Overview");
            Row r0 = summarySheet.createRow(0);
            Cell c0 = r0.createCell(0);
            c0.setCellValue("CPMS Placement Overview Report");
            c0.setCellStyle(titleStyle);

            Row r1 = summarySheet.createRow(1);
            r1.createCell(0).setCellValue("Generated at: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));

            String[][] metrics = {
                    {"Total Registered Students", String.valueOf(overall.getOrDefault("registeredStudents", 0))},
                    {"Total Placed Students", String.valueOf(overall.getOrDefault("placedStudents", 0))},
                    {"Placement Percentage (%)", overall.getOrDefault("placementPercentage", 0) + "%"},
                    {"Active Job Drives", String.valueOf(overall.getOrDefault("activeJobs", 0))},
                    {"Registered Partner Companies", String.valueOf(overall.getOrDefault("totalCompanies", 0))},
                    {"Total Applications Received", String.valueOf(overall.getOrDefault("totalApplications", 0))},
                    {"Pending Academic Verifications", String.valueOf(overall.getOrDefault("pendingVerifications", 0))}
            };

            Row headerRow = summarySheet.createRow(3);
            Cell h1 = headerRow.createCell(0);
            h1.setCellValue("Metric");
            h1.setCellStyle(headerStyle);
            Cell h2 = headerRow.createCell(1);
            h2.setCellValue("Value");
            h2.setCellStyle(headerStyle);

            int rowIdx = 4;
            for (String[] m : metrics) {
                Row r = summarySheet.createRow(rowIdx++);
                r.createCell(0).setCellValue(m[0]);
                r.createCell(1).setCellValue(m[1]);
            }
            summarySheet.autoSizeColumn(0);
            summarySheet.autoSizeColumn(1);

            // 2. Sheet: Department-wise
            Sheet deptSheet = workbook.createSheet("Department Stats");
            Row deptHeader = deptSheet.createRow(0);
            String[] deptCols = {"Department Name", "Code", "Total Students", "Registered", "Placed", "Placement %"};
            for (int i = 0; i < deptCols.length; i++) {
                Cell cell = deptHeader.createCell(i);
                cell.setCellValue(deptCols[i]);
                cell.setCellStyle(headerStyle);
            }

            int deptRowIdx = 1;
            for (Map<String, Object> dept : deptStats) {
                Row r = deptSheet.createRow(deptRowIdx++);
                r.createCell(0).setCellValue((String) dept.get("departmentName"));
                r.createCell(1).setCellValue((String) dept.get("departmentCode"));
                r.createCell(2).setCellValue(((Number) dept.get("totalStudents")).intValue());
                r.createCell(3).setCellValue(((Number) dept.get("registeredStudents")).intValue());
                r.createCell(4).setCellValue(((Number) dept.get("placedStudents")).intValue());
                r.createCell(5).setCellValue(((Number) dept.get("placementPercentage")).doubleValue());
            }
            for (int i = 0; i < deptCols.length; i++) {
                deptSheet.autoSizeColumn(i);
            }

            // 3. Sheet: Company Placements
            Sheet compSheet = workbook.createSheet("Company Hiring");
            Row compHeader = compSheet.createRow(0);
            String[] compCols = {"Company Name", "Industry", "Jobs Posted", "Total Applicants", "Hired Count", "Max Package (LPA)"};
            for (int i = 0; i < compCols.length; i++) {
                Cell cell = compHeader.createCell(i);
                cell.setCellValue(compCols[i]);
                cell.setCellStyle(headerStyle);
            }

            int compRowIdx = 1;
            for (Map<String, Object> comp : companyStats) {
                Row r = compSheet.createRow(compRowIdx++);
                r.createCell(0).setCellValue((String) comp.get("companyName"));
                r.createCell(1).setCellValue((String) comp.getOrDefault("industry", ""));
                r.createCell(2).setCellValue(((Number) comp.get("jobsPosted")).intValue());
                r.createCell(3).setCellValue(((Number) comp.get("totalApplicants")).intValue());
                r.createCell(4).setCellValue(((Number) comp.get("hiredCount")).intValue());
                BigDecimal pkg = (BigDecimal) comp.get("highestPackage");
                r.createCell(5).setCellValue(pkg != null ? pkg.doubleValue() : 0.0);
            }
            for (int i = 0; i < compCols.length; i++) {
                compSheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);

            reportDAO.logReportHistory(officerUserId, "PLACEMENT_SUMMARY", "EXCEL", "memory_download");
            return baos.toByteArray();
        }
    }
}

