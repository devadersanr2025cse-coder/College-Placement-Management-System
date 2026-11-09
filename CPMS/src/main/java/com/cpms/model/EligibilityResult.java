package com.cpms.model;

import java.util.ArrayList;
import java.util.List;

public class EligibilityResult {
    private boolean eligible;
    private List<String> reasons = new ArrayList<>();

    public EligibilityResult() {
        this.eligible = true;
    }

    public EligibilityResult(boolean eligible, String reason) {
        this.eligible = eligible;
        if (reason != null && !reason.isBlank()) {
            this.reasons.add(reason);
        }
    }

    public boolean isEligible() {
        return eligible;
    }

    public void setEligible(boolean eligible) {
        this.eligible = eligible;
    }

    public List<String> getReasons() {
        return reasons;
    }

    public void setReasons(List<String> reasons) {
        this.reasons = reasons;
    }

    public void addReason(String reason) {
        this.reasons.add(reason);
        this.eligible = false;
    }

    public String getReasonString() {
        if (eligible) {
            return "Eligible";
        }
        return String.join("; ", reasons);
    }
}

