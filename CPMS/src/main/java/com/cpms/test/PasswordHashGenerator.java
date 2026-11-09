package com.cpms.test;

import com.cpms.util.PasswordUtil;

public class PasswordHashGenerator {

    public static void main(String[] args) {

        String password = "Admin@123";

        String hash = PasswordUtil.hashPassword(password);

        System.out.println("Generated hash: " + hash);

        boolean verified =
                PasswordUtil.checkPassword(password, hash);

        System.out.println("Password verification: " + verified);
    }
}