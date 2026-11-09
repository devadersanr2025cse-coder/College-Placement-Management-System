package com.cpms.test;

import com.cpms.model.User;
import com.cpms.service.AuthService;

public class PasswordVerificationTest {

    public static void main(String[] args) {
        AuthService authService = new AuthService();

        System.out.println("--- TESTING ALL THREE LOGINS ---");
        String[][] tests = {
            {"officer@cpms.test", "Officer@123"},
            {"student@cpms.test", "Student@123"},
            {"recruiter@example.com", "Recruiter@123"}
        };

        for (String[] t : tests) {
            User u = authService.login(t[0], t[1]);
            System.out.println("Login " + t[0] + " with '" + t[1] + "' => " +
                (u != null ? ("SUCCESS [Name: " + u.getFullName() + ", Role: " + u.getRole() + "]") : "FAILED"));
        }
    }
}
