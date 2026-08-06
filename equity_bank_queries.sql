-- =========================================================
-- EQUITY_BANK_DB - PART 3 SQL QUERIES (1-20)
-- =========================================================

-- ---------------------------------------------------------
-- QUERY 1 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q1 =====
SELECT
    c.national_id,
    c.customer_name,
    c.customer_type,
    at.account_type_name,
    br.branch_name,
    br.district_name,
    COALESCE(SUM(d.total_deposit),0)      AS total_deposited_amount,
    COALESCE(SUM(w.total_withdrawal),0)   AS total_withdrawn_amount,
    MAX(COALESCE(la.total_loan,0))        AS total_loan_amount,
    MAX(COALESCE(ra.total_repay,0))       AS total_loan_repayment_amount
FROM customer c
INNER JOIN bank_account ba   ON ba.customer_id = c.customer_id
INNER JOIN account_type at   ON at.account_type_id = ba.account_type_id
INNER JOIN bank_branch br    ON br.branch_id = ba.branch_id
INNER JOIN loan l            ON l.customer_id = c.customer_id
LEFT JOIN (SELECT account_id, SUM(deposit_amount) total_deposit FROM deposit GROUP BY account_id) d
       ON d.account_id = ba.account_id
LEFT JOIN (SELECT account_id, SUM(withdrawal_amount) total_withdrawal FROM withdrawal GROUP BY account_id) w
       ON w.account_id = ba.account_id
LEFT JOIN (SELECT customer_id, SUM(loan_amount) total_loan FROM loan GROUP BY customer_id) la
       ON la.customer_id = c.customer_id
LEFT JOIN (SELECT l2.customer_id, SUM(lr.repayment_amount) total_repay
             FROM loan l2 JOIN loan_repayment lr ON lr.loan_id = l2.loan_id
             GROUP BY l2.customer_id) ra
       ON ra.customer_id = c.customer_id
GROUP BY c.national_id, c.customer_name, c.customer_type, at.account_type_name, br.branch_name, br.district_name
HAVING MAX(COALESCE(la.total_loan,0)) > 1000000;

-- ---------------------------------------------------------
-- QUERY 2 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q2 =====
SELECT
    c.national_id,
    c.customer_name,
    c.registration_date,
    at.account_type_name,
    ba.opening_date AS account_opening_date,
    br.branch_name,
    COUNT(d.deposit_id) AS number_of_deposits,
    COALESCE(SUM(d.deposit_amount),0) AS total_deposited_amount
FROM customer c
LEFT JOIN bank_account ba  ON ba.customer_id = c.customer_id
LEFT JOIN account_type at  ON at.account_type_id = ba.account_type_id
LEFT JOIN bank_branch br   ON br.branch_id = ba.branch_id
LEFT JOIN deposit d        ON d.account_id = ba.account_id
GROUP BY c.national_id, c.customer_name, c.registration_date, at.account_type_name, ba.opening_date, br.branch_name
HAVING COUNT(d.deposit_id) < 3;

-- ---------------------------------------------------------
-- QUERY 3 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q3 =====
SELECT
    at.account_type_id,
    at.account_type_name,
    at.minimum_balance,
    at.interest_rate,
    COUNT(DISTINCT ba.account_id) AS number_of_customer_accounts,
    COALESCE(SUM(d.deposit_amount),0)    AS total_deposited_amount,
    COALESCE(SUM(w.withdrawal_amount),0) AS total_withdrawn_amount
FROM bank_account ba
RIGHT JOIN account_type at ON at.account_type_id = ba.account_type_id
LEFT JOIN deposit d    ON d.account_id = ba.account_id
LEFT JOIN withdrawal w ON w.account_id = ba.account_id
GROUP BY at.account_type_id, at.account_type_name, at.minimum_balance, at.interest_rate
HAVING COALESCE(SUM(d.deposit_amount),0) < 5000000;

-- ---------------------------------------------------------
-- QUERY 4 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q4 =====
SELECT
    c.national_id,
    c.customer_name,
    at.account_type_name,
    br.branch_name,
    lt.loan_type_name,
    SUM(l.loan_amount)                    AS total_loan_amount,
    COALESCE(SUM(ra.total_repay),0)       AS total_repayment_amount,
    COALESCE(SUM(ga.total_guarantee),0)   AS total_guaranteed_amount,
    COALESCE(SUM(coa.total_collateral),0) AS total_collateral_value
FROM customer c
INNER JOIN loan l          ON l.customer_id = c.customer_id
INNER JOIN loan_type lt    ON lt.loan_type_id = l.loan_type_id
INNER JOIN bank_account ba ON ba.customer_id = c.customer_id
INNER JOIN account_type at ON at.account_type_id = ba.account_type_id
INNER JOIN bank_branch br  ON br.branch_id = ba.branch_id
LEFT JOIN (SELECT loan_id, SUM(repayment_amount) total_repay FROM loan_repayment GROUP BY loan_id) ra
       ON ra.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(guaranteed_amount) total_guarantee FROM guarantor GROUP BY loan_id) ga
       ON ga.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(collateral_value) total_collateral FROM collateral GROUP BY loan_id) coa
       ON coa.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, at.account_type_name, br.branch_name, lt.loan_type_name
HAVING SUM(l.loan_amount) > 10000000;

-- ---------------------------------------------------------
-- QUERY 5 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q5 =====
SELECT
    c.national_id,
    c.customer_name,
    ba.opening_date AS account_opening_date,
    at.account_type_name,
    COUNT(d.deposit_id) AS number_of_deposits,
    COALESCE(SUM(d.deposit_amount),0)    AS total_deposited_amount,
    COALESCE(SUM(w.withdrawal_amount),0) AS total_withdrawn_amount
FROM bank_account ba
LEFT JOIN customer c        ON c.customer_id = ba.customer_id
LEFT JOIN account_type at   ON at.account_type_id = ba.account_type_id
LEFT JOIN deposit d         ON d.account_id = ba.account_id
LEFT JOIN withdrawal w      ON w.account_id = ba.account_id
GROUP BY c.national_id, c.customer_name, ba.opening_date, at.account_type_name
HAVING COALESCE(SUM(w.withdrawal_amount),0) > COALESCE(SUM(d.deposit_amount),0);

-- ---------------------------------------------------------
-- QUERY 6 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q6 =====
SELECT
    c.national_id,
    c.customer_name,
    bc.card_number,
    bc.card_type,
    at.account_type_name,
    COUNT(d.deposit_id) AS number_of_deposits,
    COALESCE(SUM(d.deposit_amount),0)    AS total_deposited_amount,
    COALESCE(SUM(w.withdrawal_amount),0) AS total_withdrawn_amount
FROM deposit d
RIGHT JOIN bank_card bc     ON bc.account_id = d.account_id
LEFT JOIN bank_account ba   ON ba.account_id = bc.account_id
LEFT JOIN customer c        ON c.customer_id = ba.customer_id
LEFT JOIN account_type at   ON at.account_type_id = ba.account_type_id
LEFT JOIN withdrawal w      ON w.account_id = bc.account_id
GROUP BY c.national_id, c.customer_name, bc.card_number, bc.card_type, at.account_type_name
HAVING COALESCE(SUM(d.deposit_amount),0) > 1000000;

-- ---------------------------------------------------------
-- QUERY 7 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q7 =====
SELECT
    c.national_id,
    c.customer_name,
    lt.loan_type_name,
    l.loan_amount,
    lt.interest_rate,
    lt.maximum_period_months,
    COUNT(lr.repayment_id) AS number_of_repayments,
    COALESCE(SUM(lr.repayment_amount),0) AS total_repayment_amount,
    (l.loan_amount - COALESCE(SUM(lr.repayment_amount),0)) AS outstanding_loan_balance
FROM customer c
INNER JOIN loan l       ON l.customer_id = c.customer_id
INNER JOIN loan_type lt ON lt.loan_type_id = l.loan_type_id
LEFT JOIN loan_repayment lr ON lr.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, lt.loan_type_name, l.loan_id, l.loan_amount, lt.interest_rate, lt.maximum_period_months
HAVING (l.loan_amount - COALESCE(SUM(lr.repayment_amount),0)) > 0;

-- ---------------------------------------------------------
-- QUERY 8 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q8 =====
SELECT
    c.national_id,
    c.customer_name,
    lt.loan_type_name,
    e.employee_name,
    br.branch_name,
    COUNT(DISTINCT g.guarantor_id) AS number_of_guarantors,
    COALESCE(ga.total_guarantee,0) AS total_guaranteed_amount,
    COUNT(DISTINCT col.collateral_id) AS number_of_collateral_records,
    COALESCE(coa.total_collateral,0) AS total_collateral_value
FROM customer c
INNER JOIN loan l          ON l.customer_id = c.customer_id
INNER JOIN loan_type lt    ON lt.loan_type_id = l.loan_type_id
INNER JOIN bank_employee e ON e.employee_id = l.employee_id
INNER JOIN bank_branch br  ON br.branch_id = e.branch_id
LEFT JOIN guarantor g       ON g.loan_id = l.loan_id
LEFT JOIN collateral col    ON col.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(guaranteed_amount) total_guarantee FROM guarantor GROUP BY loan_id) ga
       ON ga.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(collateral_value) total_collateral FROM collateral GROUP BY loan_id) coa
       ON coa.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, lt.loan_type_name, e.employee_name, br.branch_name, l.loan_id,
         ga.total_guarantee, coa.total_collateral
HAVING COALESCE(coa.total_collateral,0) > 2000000;

-- ---------------------------------------------------------
-- QUERY 9 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q9 =====
SELECT
    e.employee_id,
    e.employee_name,
    e.employee_position,
    br.branch_name,
    br.district_name,
    COUNT(l.loan_id) AS number_of_loans_processed,
    COALESCE(SUM(l.loan_amount),0) AS total_loan_amount,
    COALESCE(AVG(l.loan_amount),0) AS average_loan_amount
FROM loan l
RIGHT JOIN bank_employee e ON e.employee_id = l.employee_id
LEFT JOIN bank_branch br   ON br.branch_id = e.branch_id
GROUP BY e.employee_id, e.employee_name, e.employee_position, br.branch_name, br.district_name
HAVING COALESCE(AVG(l.loan_amount),0) > 500000;

-- ---------------------------------------------------------
-- QUERY 10 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q10 =====
SELECT
    c.national_id,
    c.customer_name,
    l.loan_id,
    lt.loan_type_name,
    l.loan_amount,
    COALESCE(SUM(lr.repayment_amount),0) AS total_repayment_amount,
    SUM(g.guaranteed_amount) AS total_guaranteed_amount,
    COALESCE(SUM(col.collateral_value),0) AS total_collateral_value
FROM customer c
INNER JOIN loan l         ON l.customer_id = c.customer_id
INNER JOIN loan_type lt   ON lt.loan_type_id = l.loan_type_id
INNER JOIN guarantor g    ON g.loan_id = l.loan_id
LEFT JOIN loan_repayment lr ON lr.loan_id = l.loan_id
LEFT JOIN collateral col    ON col.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, l.loan_id, lt.loan_type_name, l.loan_amount
HAVING SUM(g.guaranteed_amount) > 100000;

-- ---------------------------------------------------------
-- QUERY 11 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q11 =====
SELECT
    c.national_id,
    c.customer_name,
    l.loan_id,
    l.loan_amount,
    COUNT(lr.repayment_id) AS number_of_repayments,
    COALESCE(SUM(lr.repayment_amount),0) AS total_repayment_amount,
    (l.loan_amount - COALESCE(SUM(lr.repayment_amount),0)) AS outstanding_balance
FROM loan l
LEFT JOIN customer c        ON c.customer_id = l.customer_id
LEFT JOIN loan_repayment lr ON lr.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, l.loan_id, l.loan_amount
HAVING (l.loan_amount - COALESCE(SUM(lr.repayment_amount),0)) > 500000;

-- ---------------------------------------------------------
-- QUERY 12 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q12 =====
SELECT
    br.branch_id,
    br.branch_name,
    br.district_name,
    br.branch_manager,
    COUNT(DISTINCT ba.account_id) AS number_of_customer_accounts,
    COALESCE(SUM(d.deposit_amount),0) AS total_deposited_amount,
    COALESCE(AVG(d.deposit_amount),0) AS average_deposit_amount,
    COALESCE(MAX(d.deposit_amount),0) AS maximum_deposit_amount,
    COALESCE(MIN(d.deposit_amount),0) AS minimum_deposit_amount
FROM deposit d
RIGHT JOIN bank_account ba ON ba.account_id = d.account_id
RIGHT JOIN bank_branch br  ON br.branch_id = ba.branch_id
GROUP BY br.branch_id, br.branch_name, br.district_name, br.branch_manager
HAVING COALESCE(SUM(d.deposit_amount),0) < 20000000;

-- ---------------------------------------------------------
-- QUERY 13 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q13 =====
SELECT
    c.national_id,
    c.customer_name,
    at.account_type_name,
    br.branch_name,
    cur.currency_name,
    COUNT(d.deposit_id) AS number_of_deposits,
    SUM(d.deposit_amount) AS total_deposited_amount,
    COALESCE(SUM(w.total_withdrawal),0) AS total_withdrawn_amount,
    (SUM(d.deposit_amount) - COALESCE(SUM(w.total_withdrawal),0)) AS net_account_movement
FROM customer c
INNER JOIN bank_account ba ON ba.customer_id = c.customer_id
INNER JOIN account_type at ON at.account_type_id = ba.account_type_id
INNER JOIN bank_branch br  ON br.branch_id = ba.branch_id
INNER JOIN deposit d       ON d.account_id = ba.account_id
INNER JOIN currency cur    ON cur.currency_id = d.currency_id
LEFT JOIN (SELECT account_id, SUM(withdrawal_amount) total_withdrawal FROM withdrawal GROUP BY account_id) w
       ON w.account_id = ba.account_id
GROUP BY c.national_id, c.customer_name, at.account_type_name, br.branch_name, cur.currency_name
HAVING (SUM(d.deposit_amount) - COALESCE(SUM(w.total_withdrawal),0)) > 1000000;

-- ---------------------------------------------------------
-- QUERY 14 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q14 =====
SELECT
    c.national_id,
    c.customer_name,
    ba.account_id,
    COALESCE(SUM(d.deposit_amount),0)    AS total_deposited_amount,
    COALESCE(SUM(w.withdrawal_amount),0) AS total_withdrawn_amount,
    ROUND(
      COALESCE(SUM(w.withdrawal_amount),0) / NULLIF(SUM(d.deposit_amount),0) * 100
    ,2) AS withdrawal_percentage
FROM bank_account ba
LEFT JOIN customer c   ON c.customer_id = ba.customer_id
LEFT JOIN deposit d    ON d.account_id = ba.account_id
LEFT JOIN withdrawal w ON w.account_id = ba.account_id
GROUP BY c.national_id, c.customer_name, ba.account_id
HAVING COALESCE(SUM(d.deposit_amount),0) > 0
   AND ROUND(COALESCE(SUM(w.withdrawal_amount),0) / NULLIF(SUM(d.deposit_amount),0) * 100,2) > 10;

-- ---------------------------------------------------------
-- QUERY 15 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q15 =====
SELECT
    br.branch_id,
    br.branch_name,
    br.district_name,
    br.branch_manager,
    at.account_type_name,
    bt.target_year,
    bt.target_amount,
    COALESCE(SUM(d.deposit_amount),0) AS total_deposited_amount,
    COALESCE(SUM(w.total_withdrawal),0) AS total_withdrawn_amount,
    (COALESCE(SUM(d.deposit_amount),0) - COALESCE(SUM(w.total_withdrawal),0)) AS net_deposits
FROM deposit d
RIGHT JOIN bank_account ba ON ba.account_id = d.account_id
RIGHT JOIN branch_target bt ON bt.branch_id = ba.branch_id AND bt.account_type_id = ba.account_type_id
LEFT JOIN bank_branch br   ON br.branch_id = bt.branch_id
LEFT JOIN account_type at  ON at.account_type_id = bt.account_type_id
LEFT JOIN (SELECT account_id, SUM(withdrawal_amount) total_withdrawal FROM withdrawal GROUP BY account_id) w
       ON w.account_id = ba.account_id
GROUP BY br.branch_id, br.branch_name, br.district_name, br.branch_manager, at.account_type_name, bt.target_year, bt.target_amount
HAVING COALESCE(SUM(d.deposit_amount),0) < bt.target_amount;

-- ---------------------------------------------------------
-- QUERY 16 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q16 =====
SELECT
    e.employee_id,
    e.employee_name,
    e.employee_position,
    br.branch_name,
    COALESCE(wa.n_withdrawals,0)  AS number_of_withdrawals_processed,
    COALESCE(wa.total_withdrawn,0) AS total_withdrawn_amount,
    COALESCE(la.n_loans,0)        AS number_of_loans_processed,
    COALESCE(la.total_loan,0)     AS total_loan_amount,
    COALESCE(ca.n_complaints,0)   AS number_of_complaints_handled,
    COALESCE(ca.n_unresolved,0)   AS number_of_unresolved_complaints
FROM bank_employee e
INNER JOIN bank_branch br ON br.branch_id = e.branch_id
INNER JOIN (SELECT employee_id, COUNT(*) n_withdrawals, SUM(withdrawal_amount) total_withdrawn
              FROM withdrawal GROUP BY employee_id) wa ON wa.employee_id = e.employee_id
INNER JOIN (SELECT employee_id, COUNT(*) n_loans, SUM(loan_amount) total_loan
              FROM loan GROUP BY employee_id) la ON la.employee_id = e.employee_id
LEFT JOIN (SELECT employee_id, COUNT(*) n_complaints,
                  COUNT(*) FILTER (WHERE complaint_status <> 'Resolved') n_unresolved
             FROM customer_complaint GROUP BY employee_id) ca ON ca.employee_id = e.employee_id
WHERE wa.n_withdrawals > 5
  AND la.total_loan > 1000000;

-- ---------------------------------------------------------
-- QUERY 17 (LEFT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q17 =====
SELECT
    c.national_id,
    c.customer_name,
    COUNT(DISTINCT ba.account_id)   AS number_of_bank_accounts,
    COUNT(DISTINCT bc.card_id)      AS number_of_bank_cards,
    COUNT(DISTINCT bf.beneficiary_id) AS number_of_beneficiaries,
    COUNT(DISTINCT mb.mobile_banking_id) AS number_of_mobile_banking_registrations,
    COUNT(DISTINCT fd.fixed_deposit_id)  AS number_of_fixed_deposits,
    COALESCE(SUM(DISTINCT fd.principal_amount),0) AS placeholder
FROM customer c
LEFT JOIN bank_account ba   ON ba.customer_id = c.customer_id
LEFT JOIN bank_card bc      ON bc.account_id = ba.account_id
LEFT JOIN beneficiary bf    ON bf.customer_id = c.customer_id
LEFT JOIN mobile_banking mb ON mb.customer_id = c.customer_id
LEFT JOIN fixed_deposit fd  ON fd.account_id = ba.account_id
LEFT JOIN loan l            ON l.customer_id = c.customer_id
LEFT JOIN loan_repayment lr ON lr.loan_id = l.loan_id
LEFT JOIN insurance_policy ip ON ip.customer_id = c.customer_id
GROUP BY c.national_id, c.customer_name
HAVING 1=1;

-- ---------------------------------------------------------
-- QUERY 18 (RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q18 =====
SELECT
    c.national_id,
    c.customer_name,
    at.account_type_name,
    COUNT(DISTINCT ba.account_id) AS number_of_accounts,
    COUNT(DISTINCT bc.card_id)    AS number_of_cards,
    COUNT(DISTINCT bf.beneficiary_id) AS number_of_beneficiaries,
    COUNT(DISTINCT mb.mobile_banking_id) AS number_of_mobile_banking_registrations,
    COALESCE(SUM(d.deposit_amount),0)  AS total_deposited_amount,
    COALESCE(SUM(w.withdrawal_amount),0) AS total_withdrawn_amount
FROM bank_card bc
RIGHT JOIN bank_account ba ON ba.account_id = bc.account_id
LEFT JOIN customer c       ON c.customer_id = ba.customer_id
LEFT JOIN account_type at  ON at.account_type_id = ba.account_type_id
LEFT JOIN beneficiary bf   ON bf.customer_id = c.customer_id
LEFT JOIN mobile_banking mb ON mb.customer_id = c.customer_id
LEFT JOIN deposit d        ON d.account_id = ba.account_id
LEFT JOIN withdrawal w     ON w.account_id = ba.account_id
GROUP BY c.national_id, c.customer_name, at.account_type_name
HAVING (COUNT(DISTINCT ba.account_id) + COUNT(DISTINCT bc.card_id) + COUNT(DISTINCT bf.beneficiary_id) + COUNT(DISTINCT mb.mobile_banking_id)) > 1;

-- ---------------------------------------------------------
-- QUERY 19 (INNER JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q19 =====
SELECT
    c.national_id,
    c.customer_name,
    lt.loan_type_name,
    e.employee_name,
    br.branch_name,
    l.loan_amount,
    COUNT(lr.repayment_id) AS number_of_repayments,
    SUM(lr.repayment_amount) AS total_repayment_amount,
    COALESCE(ga.total_guarantee,0) AS total_guaranteed_amount,
    COALESCE(coa.total_collateral,0) AS total_collateral_value,
    COALESCE(ipa.total_premium,0) AS total_insurance_premiums,
    (l.loan_amount - SUM(lr.repayment_amount)) AS outstanding_loan_balance
FROM customer c
INNER JOIN loan l           ON l.customer_id = c.customer_id
INNER JOIN loan_type lt     ON lt.loan_type_id = l.loan_type_id
INNER JOIN bank_employee e  ON e.employee_id = l.employee_id
INNER JOIN bank_branch br   ON br.branch_id = e.branch_id
INNER JOIN loan_repayment lr ON lr.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(guaranteed_amount) total_guarantee FROM guarantor GROUP BY loan_id) ga
       ON ga.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(collateral_value) total_collateral FROM collateral GROUP BY loan_id) coa
       ON coa.loan_id = l.loan_id
LEFT JOIN (SELECT loan_id, SUM(premium_amount) total_premium FROM insurance_policy GROUP BY loan_id) ipa
       ON ipa.loan_id = l.loan_id
GROUP BY c.national_id, c.customer_name, lt.loan_type_name, e.employee_name, br.branch_name, l.loan_id, l.loan_amount,
         ga.total_guarantee, coa.total_collateral, ipa.total_premium
HAVING COUNT(lr.repayment_id) > 2
   AND (l.loan_amount - SUM(lr.repayment_amount)) > 0;

-- ---------------------------------------------------------
-- QUERY 20 (INNER + LEFT + RIGHT JOIN, GROUP BY, HAVING)
-- ---------------------------------------------------------
-- ===== Q20 =====
SELECT
    c.national_id,
    c.customer_name,
    c.customer_type,
    at.account_type_name,
    br.branch_name,
    br.district_name,
    e.employee_name,
    cur.currency_name,
    lt.loan_type_name,
    COUNT(DISTINCT ba.account_id) AS number_of_accounts,
    COALESCE(da.n_deposits,0)     AS number_of_deposits,
    COALESCE(da.total_deposit,0)  AS total_deposited_amount,
    COALESCE(wa.total_withdrawn,0) AS total_withdrawn_amount,
    COALESCE(la.total_loan,0)     AS total_loan_amount,
    COALESCE(ra.total_repay,0)    AS total_repayment_amount,
    COALESCE(ga.total_guarantee,0) AS total_guaranteed_amount,
    COALESCE(coa.total_collateral,0) AS total_collateral_value,
    COALESCE(cda.n_cards,0)       AS number_of_cards,
    COALESCE(bfa.n_beneficiaries,0) AS number_of_beneficiaries,
    COALESCE(mba.n_mobile,0)      AS number_of_mobile_banking_registrations,
    COALESCE(fda.total_principal,0) AS total_fixed_deposit_principal,
    COALESCE(ipa.total_premium,0) AS total_insurance_premiums,
    COALESCE(cca.n_complaints,0)  AS number_of_complaints,
    bt.target_amount,
    ROUND(COALESCE(da.total_deposit,0) / NULLIF(bt.target_amount,0) * 100,2) AS branch_performance_percentage
FROM customer c
INNER JOIN bank_account ba ON ba.customer_id = c.customer_id
INNER JOIN account_type at ON at.account_type_id = ba.account_type_id
INNER JOIN bank_branch br  ON br.branch_id = ba.branch_id
LEFT JOIN loan l           ON l.customer_id = c.customer_id
LEFT JOIN loan_type lt     ON lt.loan_type_id = l.loan_type_id
LEFT JOIN bank_employee e  ON e.employee_id = l.employee_id
LEFT JOIN currency cur     ON cur.currency_id = (SELECT MIN(currency_id) FROM deposit dd WHERE dd.account_id = ba.account_id)
LEFT JOIN (SELECT account_id, COUNT(*) n_deposits, SUM(deposit_amount) total_deposit FROM deposit GROUP BY account_id) da
       ON da.account_id = ba.account_id
LEFT JOIN (SELECT account_id, SUM(withdrawal_amount) total_withdrawn FROM withdrawal GROUP BY account_id) wa
       ON wa.account_id = ba.account_id
LEFT JOIN (SELECT customer_id, SUM(loan_amount) total_loan FROM loan GROUP BY customer_id) la
       ON la.customer_id = c.customer_id
LEFT JOIN (SELECT l2.customer_id, SUM(lr.repayment_amount) total_repay
             FROM loan l2 JOIN loan_repayment lr ON lr.loan_id = l2.loan_id
             GROUP BY l2.customer_id) ra ON ra.customer_id = c.customer_id
LEFT JOIN (SELECT l2.customer_id, SUM(g.guaranteed_amount) total_guarantee
             FROM loan l2 JOIN guarantor g ON g.loan_id = l2.loan_id
             GROUP BY l2.customer_id) ga ON ga.customer_id = c.customer_id
LEFT JOIN (SELECT l2.customer_id, SUM(col.collateral_value) total_collateral
             FROM loan l2 JOIN collateral col ON col.loan_id = l2.loan_id
             GROUP BY l2.customer_id) coa ON coa.customer_id = c.customer_id
LEFT JOIN (SELECT account_id, COUNT(*) n_cards FROM bank_card GROUP BY account_id) cda
       ON cda.account_id = ba.account_id
LEFT JOIN (SELECT customer_id, COUNT(*) n_beneficiaries FROM beneficiary GROUP BY customer_id) bfa
       ON bfa.customer_id = c.customer_id
LEFT JOIN (SELECT customer_id, COUNT(*) n_mobile FROM mobile_banking GROUP BY customer_id) mba
       ON mba.customer_id = c.customer_id
LEFT JOIN (SELECT account_id, SUM(principal_amount) total_principal FROM fixed_deposit GROUP BY account_id) fda
       ON fda.account_id = ba.account_id
LEFT JOIN (SELECT customer_id, SUM(premium_amount) total_premium FROM insurance_policy GROUP BY customer_id) ipa
       ON ipa.customer_id = c.customer_id
LEFT JOIN (SELECT customer_id, COUNT(*) n_complaints FROM customer_complaint GROUP BY customer_id) cca
       ON cca.customer_id = c.customer_id
RIGHT JOIN branch_target bt ON bt.branch_id = br.branch_id
GROUP BY c.national_id, c.customer_name, c.customer_type, at.account_type_name, br.branch_name, br.district_name,
         e.employee_name, cur.currency_name, lt.loan_type_name, da.n_deposits, da.total_deposit,
         wa.total_withdrawn, la.total_loan, ra.total_repay, ga.total_guarantee, coa.total_collateral,
         cda.n_cards, bfa.n_beneficiaries, mba.n_mobile, fda.total_principal, ipa.total_premium,
         cca.n_complaints, bt.target_amount
HAVING COALESCE(la.total_loan,0) > COALESCE(ra.total_repay,0)
   AND COALESCE(da.total_deposit,0) > 0
   AND (COALESCE(la.total_loan,0) - COALESCE(ra.total_repay,0)) > 0
ORDER BY br.district_name, br.branch_name, c.customer_name, la.total_loan;
