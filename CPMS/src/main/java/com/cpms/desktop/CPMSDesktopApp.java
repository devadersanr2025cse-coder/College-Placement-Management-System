package com.cpms.desktop;

import com.cpms.util.DBConnection;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.datatransfer.StringSelection;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.sql.Connection;

public class CPMSDesktopApp extends JFrame {

    private static final String APP_URL = "http://localhost:8080/CPMS/";
    private static final String TOMCAT_DIR = "C:\\apache-tomcat-10.1.61";

    private JLabel dbStatusLabel;
    private JLabel serverStatusLabel;
    private JButton launchAppBtn;
    private JButton startServerBtn;
    private JButton stopServerBtn;

    public CPMSDesktopApp() {
        setTitle("College Placement Management System (CPMS) — Desktop Hub");
        setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        setSize(780, 560);
        setLocationRelativeTo(null);
        setResizable(false);

        // Confirmation on window close
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                int option = JOptionPane.showConfirmDialog(
                        CPMSDesktopApp.this,
                        "Do you want to exit CPMS Desktop Hub and stop background services?",
                        "Exit Confirmation",
                        JOptionPane.YES_NO_CANCEL_OPTION,
                        JOptionPane.QUESTION_MESSAGE
                );
                if (option == JOptionPane.YES_OPTION) {
                    stopTomcatServer();
                    System.exit(0);
                } else if (option == JOptionPane.NO_OPTION) {
                    System.exit(0); // exit GUI only, leave server running
                }
            }
        });

        initUI();
        startHealthCheckThread();
    }

    private void initUI() {
        JPanel root = new JPanel(new BorderLayout());
        root.setBackground(new Color(248, 250, 252));

        // Header Panel (Navy Banner)
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBackground(new Color(15, 23, 42)); // Navy-900
        headerPanel.setBorder(new EmptyBorder(20, 24, 20, 24));

        JLabel titleLabel = new JLabel("CPMS Desktop Application");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 22));
        titleLabel.setForeground(Color.WHITE);

        JLabel subtitleLabel = new JLabel("Unified Enterprise Placement Portal • Student | Officer | Recruiter");
        subtitleLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        subtitleLabel.setForeground(new Color(148, 163, 184)); // Slate-400

        JPanel titleBox = new JPanel(new GridLayout(2, 1, 0, 4));
        titleBox.setOpaque(false);
        titleBox.add(titleLabel);
        titleBox.add(subtitleLabel);

        headerPanel.add(titleBox, BorderLayout.WEST);

        // Status Indicators Panel (Header Right)
        JPanel statusBox = new JPanel(new GridLayout(2, 1, 0, 4));
        statusBox.setOpaque(false);

        dbStatusLabel = new JLabel("● Database: Checking...");
        dbStatusLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        dbStatusLabel.setForeground(new Color(251, 191, 36));

        serverStatusLabel = new JLabel("● Engine: Checking...");
        serverStatusLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        serverStatusLabel.setForeground(new Color(251, 191, 36));

        statusBox.add(dbStatusLabel);
        statusBox.add(serverStatusLabel);
        headerPanel.add(statusBox, BorderLayout.EAST);

        root.add(headerPanel, BorderLayout.NORTH);

        // Body Panel
        JPanel bodyPanel = new JPanel();
        bodyPanel.setLayout(new BoxLayout(bodyPanel, BoxLayout.Y_AXIS));
        bodyPanel.setOpaque(false);
        bodyPanel.setBorder(new EmptyBorder(20, 24, 20, 24));

        // Primary Action: Launch Desktop Window
        JPanel launchPanel = new JPanel(new BorderLayout());
        launchPanel.setBackground(Color.WHITE);
        launchPanel.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(226, 232, 240), 1),
                new EmptyBorder(18, 20, 18, 20)
        ));

        JPanel launchText = new JPanel(new GridLayout(2, 1, 0, 4));
        launchText.setOpaque(false);
        JLabel mainLaunchTitle = new JLabel("CPMS Desktop Window (App Mode)");
        mainLaunchTitle.setFont(new Font("Segoe UI", Font.BOLD, 16));
        mainLaunchTitle.setForeground(new Color(15, 23, 42));

        JLabel mainLaunchDesc = new JLabel("Opens in a borderless, dedicated native window with full dashboard controls.");
        mainLaunchDesc.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        mainLaunchDesc.setForeground(new Color(100, 116, 139));

        launchText.add(mainLaunchTitle);
        launchText.add(mainLaunchDesc);
        launchPanel.add(launchText, BorderLayout.WEST);

        launchAppBtn = new JButton("Launch Desktop App");
        launchAppBtn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        launchAppBtn.setBackground(new Color(29, 78, 216)); // CPMS Blue
        launchAppBtn.setForeground(Color.WHITE);
        launchAppBtn.setFocusPainted(false);
        launchAppBtn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        launchAppBtn.setPreferredSize(new Dimension(190, 45));
        launchAppBtn.addActionListener(e -> launchDesktopWindow(APP_URL));

        launchPanel.add(launchAppBtn, BorderLayout.EAST);
        bodyPanel.add(launchPanel);
        bodyPanel.add(Box.createVerticalStrut(16));

        // Quick Direct Portal Buttons
        JPanel portalsPanel = new JPanel(new GridLayout(1, 3, 14, 0));
        portalsPanel.setOpaque(false);

        portalsPanel.add(createRoleCard("Student Portal", "Arun Kumar (CSE)", "student@cpms.test", "Student@123",
                new Color(239, 246, 255), new Color(29, 78, 216), "student/dashboard"));

        portalsPanel.add(createRoleCard("Placement Officer", "Dr. Sarah Jenkins", "officer@cpms.test", "Officer@123",
                new Color(254, 249, 195), new Color(161, 98, 7), "officer/dashboard"));

        portalsPanel.add(createRoleCard("Company Recruiter", "Elena Vance (Example Tech)", "recruiter@example.com", "Recruiter@123",
                new Color(236, 253, 245), new Color(4, 120, 87), "recruiter/dashboard"));

        bodyPanel.add(portalsPanel);
        bodyPanel.add(Box.createVerticalStrut(16));

        // Server Controls Panel
        JPanel serverControlPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        serverControlPanel.setOpaque(false);

        startServerBtn = new JButton("Start Engine");
        startServerBtn.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        startServerBtn.addActionListener(e -> startTomcatServer());

        stopServerBtn = new JButton("Stop Engine");
        stopServerBtn.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        stopServerBtn.addActionListener(e -> stopTomcatServer());

        JButton openBrowserBtn = new JButton("Open in Default Browser");
        openBrowserBtn.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        openBrowserBtn.addActionListener(e -> {
            try {
                Desktop.getDesktop().browse(URI.create(APP_URL));
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Could not open browser: " + ex.getMessage());
            }
        });

        serverControlPanel.add(startServerBtn);
        serverControlPanel.add(stopServerBtn);
        serverControlPanel.add(openBrowserBtn);

        bodyPanel.add(serverControlPanel);

        root.add(bodyPanel, BorderLayout.CENTER);

        // Footer
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.CENTER));
        footer.setBackground(Color.WHITE);
        footer.setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, new Color(226, 232, 240)));
        JLabel footerLabel = new JLabel("College Placement Management System (CPMS) • Version 2.0 Enterprise Desktop");
        footerLabel.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        footerLabel.setForeground(new Color(148, 163, 184));
        footer.add(footerLabel);

        root.add(footer, BorderLayout.SOUTH);

        setContentPane(root);
    }

    private JPanel createRoleCard(String title, String user, String email, String pass,
                                  Color bgColor, Color accentColor, String path) {
        JPanel card = new JPanel();
        card.setLayout(new BoxLayout(card, BoxLayout.Y_AXIS));
        card.setBackground(Color.WHITE);
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(226, 232, 240), 1),
                new EmptyBorder(14, 14, 14, 14)
        ));

        JLabel titleLbl = new JLabel(title);
        titleLbl.setFont(new Font("Segoe UI", Font.BOLD, 14));
        titleLbl.setForeground(accentColor);
        card.add(titleLbl);

        JLabel userLbl = new JLabel(user);
        userLbl.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        userLbl.setForeground(new Color(71, 85, 105));
        card.add(userLbl);

        card.add(Box.createVerticalStrut(8));

        JLabel emailLbl = new JLabel(email);
        emailLbl.setFont(new Font("Consolas", Font.PLAIN, 11));
        emailLbl.setForeground(new Color(100, 116, 139));
        card.add(emailLbl);

        JLabel passLbl = new JLabel("Password: " + pass);
        passLbl.setFont(new Font("Consolas", Font.PLAIN, 11));
        passLbl.setForeground(new Color(100, 116, 139));
        card.add(passLbl);

        card.add(Box.createVerticalStrut(12));

        JPanel btnRow = new JPanel(new GridLayout(1, 2, 6, 0));
        btnRow.setOpaque(false);

        JButton copyBtn = new JButton("Copy");
        copyBtn.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        copyBtn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        copyBtn.addActionListener(e -> {
            Toolkit.getDefaultToolkit().getSystemClipboard().setContents(
                    new StringSelection(email + "\t" + pass), null
            );
            JOptionPane.showMessageDialog(this, "Copied credentials for " + title + " to clipboard!", "Copied", JOptionPane.INFORMATION_MESSAGE);
        });

        JButton openBtn = new JButton("Open");
        openBtn.setFont(new Font("Segoe UI", Font.BOLD, 11));
        openBtn.setBackground(accentColor);
        openBtn.setForeground(Color.WHITE);
        openBtn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        openBtn.addActionListener(e -> launchDesktopWindow(APP_URL + path));

        btnRow.add(copyBtn);
        btnRow.add(openBtn);
        card.add(btnRow);

        return card;
    }

    private void launchDesktopWindow(String url) {
        String[] edgePaths = {
                "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
                "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
                "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
                "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
        };

        String chosen = null;
        for (String p : edgePaths) {
            if (new File(p).exists()) {
                chosen = p;
                break;
            }
        }

        try {
            if (chosen != null) {
                String profileDir = System.getenv("LOCALAPPDATA") + "\\CPMS_DesktopProfile";
                ProcessBuilder pb = new ProcessBuilder(
                        chosen,
                        "--app=" + url,
                        "--user-data-dir=" + profileDir,
                        "--window-size=1400,900"
                );
                pb.start();
            } else {
                Desktop.getDesktop().browse(URI.create(url));
            }
        } catch (IOException e) {
            JOptionPane.showMessageDialog(this, "Failed to launch application: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void startTomcatServer() {
        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", "cd /d " + TOMCAT_DIR + "\\bin && catalina.bat run");
                pb.environment().put("JAVA_HOME", "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.5.8-hotspot");
                pb.start();
                SwingUtilities.invokeLater(() -> JOptionPane.showMessageDialog(this, "Server startup initiated. Please wait 5 seconds.", "Starting", JOptionPane.INFORMATION_MESSAGE));
            } catch (Exception ex) {
                SwingUtilities.invokeLater(() -> JOptionPane.showMessageDialog(this, "Failed to start server: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE));
            }
        }).start();
    }

    private void stopTomcatServer() {
        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder("cmd.exe", "/c", "cd /d " + TOMCAT_DIR + "\\bin && shutdown.bat");
                pb.environment().put("JAVA_HOME", "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.5.8-hotspot");
                pb.start();
            } catch (Exception ignored) {}
        }).start();
    }

    private void startHealthCheckThread() {
        Thread t = new Thread(() -> {
            while (true) {
                boolean dbOk = false;
                try (Connection c = DBConnection.getConnection()) {
                    dbOk = (c != null && !c.isClosed());
                } catch (Exception ignored) {}

                boolean serverOk = false;
                try {
                    HttpURLConnection conn = (HttpURLConnection) new URL(APP_URL).openConnection();
                    conn.setConnectTimeout(1500);
                    conn.setReadTimeout(1500);
                    conn.setRequestMethod("GET");
                    serverOk = (conn.getResponseCode() == 200 || conn.getResponseCode() == 302);
                } catch (Exception ignored) {}

                final boolean finalDb = dbOk;
                final boolean finalServer = serverOk;

                SwingUtilities.invokeLater(() -> {
                    if (finalDb) {
                        dbStatusLabel.setText("● MySQL: Connected");
                        dbStatusLabel.setForeground(new Color(34, 197, 94)); // Green
                    } else {
                        dbStatusLabel.setText("● MySQL: Offline");
                        dbStatusLabel.setForeground(new Color(239, 68, 68)); // Red
                    }

                    if (finalServer) {
                        serverStatusLabel.setText("● Engine: Online");
                        serverStatusLabel.setForeground(new Color(34, 197, 94)); // Green
                        launchAppBtn.setEnabled(true);
                    } else {
                        serverStatusLabel.setText("● Engine: Offline");
                        serverStatusLabel.setForeground(new Color(239, 68, 68)); // Red
                    }
                });

                try {
                    Thread.sleep(3000);
                } catch (InterruptedException ignored) {}
            }
        });
        t.setDaemon(true);
        t.start();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {}
            new CPMSDesktopApp().setVisible(true);
        });
    }
}

