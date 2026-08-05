--
-- PostgreSQL database dump
--

\restrict uMuzFYhhxtQ9amKCbhqKnwCENbcREavwvIg0vIaE1xUzJObLwTHkedTV9INcY5h

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_type (
    account_type_id integer NOT NULL,
    account_type_name character varying(30),
    minimum_balance numeric(10,2),
    interest_rate numeric(10,2),
    effective_date date
);


ALTER TABLE public.account_type OWNER TO postgres;

--
-- Name: bank_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_account (
    account_id integer NOT NULL,
    customer_id integer,
    account_type_id integer,
    branch_id integer,
    opening_date date
);


ALTER TABLE public.bank_account OWNER TO postgres;

--
-- Name: bank_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_branch (
    branch_id integer NOT NULL,
    branch_name character varying(20),
    district_name character varying(25),
    branch_manager character varying(20),
    opening_date date
);


ALTER TABLE public.bank_branch OWNER TO postgres;

--
-- Name: bank_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_card (
    card_id integer NOT NULL,
    account_id integer,
    card_number character varying(20),
    card_type character varying(20),
    issue_date date,
    CONSTRAINT bank_card_card_type_check CHECK (((card_type)::text = ANY ((ARRAY['Debit'::character varying, 'Credit'::character varying])::text[])))
);


ALTER TABLE public.bank_card OWNER TO postgres;

--
-- Name: bank_employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_employee (
    employee_id integer NOT NULL,
    branch_id integer,
    employee_name character varying(50),
    employee_position character varying(50),
    employment_date date
);


ALTER TABLE public.bank_employee OWNER TO postgres;

--
-- Name: beneficiary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beneficiary (
    beneficiary_id integer NOT NULL,
    customer_id integer,
    beneficiary_name character varying(100),
    beneficiary_account character varying(30),
    registration_date date
);


ALTER TABLE public.beneficiary OWNER TO postgres;

--
-- Name: branch_target; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch_target (
    target_id integer NOT NULL,
    branch_id integer,
    account_type_id integer,
    target_year integer,
    target_amount numeric(15,2),
    CONSTRAINT branch_target_target_amount_check CHECK ((target_amount > (0)::numeric)),
    CONSTRAINT branch_target_target_year_check CHECK ((target_year >= 2020))
);


ALTER TABLE public.branch_target OWNER TO postgres;

--
-- Name: collateral; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collateral (
    collateral_id integer NOT NULL,
    loan_id integer,
    collateral_type character varying(100),
    collateral_value numeric(15,2),
    registration_date date,
    CONSTRAINT collateral_collateral_value_check CHECK ((collateral_value > (0)::numeric))
);


ALTER TABLE public.collateral OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    currency_id integer NOT NULL,
    currency_code character varying(10),
    currency_name character varying(50),
    exchange_rate numeric(15,4),
    effective_date date,
    CONSTRAINT currency_exchange_rate_check CHECK ((exchange_rate > (0)::numeric))
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    national_id character varying(20),
    customer_name character varying(50),
    customer_type character varying(20),
    registration_date date
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_complaint; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_complaint (
    complaint_id integer NOT NULL,
    customer_id integer,
    employee_id integer,
    complaint_date date,
    complaint_status character varying(20),
    CONSTRAINT customer_complaint_complaint_status_check CHECK (((complaint_status)::text = ANY ((ARRAY['Pending'::character varying, 'Resolved'::character varying, 'Closed'::character varying])::text[])))
);


ALTER TABLE public.customer_complaint OWNER TO postgres;

--
-- Name: deposit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deposit (
    deposit_id integer NOT NULL,
    account_id integer,
    currency_id integer,
    deposit_date date,
    deposit_amount numeric(15,2),
    CONSTRAINT deposit_deposit_amount_check CHECK ((deposit_amount > (0)::numeric))
);


ALTER TABLE public.deposit OWNER TO postgres;

--
-- Name: fixed_deposit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fixed_deposit (
    fixed_deposit_id integer NOT NULL,
    account_id integer,
    currency_id integer,
    principal_amount numeric(15,2),
    maturity_date date,
    CONSTRAINT fixed_deposit_principal_amount_check CHECK ((principal_amount > (0)::numeric))
);


ALTER TABLE public.fixed_deposit OWNER TO postgres;

--
-- Name: guarantor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guarantor (
    guarantor_id integer NOT NULL,
    loan_id integer,
    guarantor_name character varying(100),
    guarantor_phone character varying(15),
    guaranteed_amount numeric(15,2),
    CONSTRAINT guarantor_guaranteed_amount_check CHECK ((guaranteed_amount > (0)::numeric))
);


ALTER TABLE public.guarantor OWNER TO postgres;

--
-- Name: insurance_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance_policy (
    policy_id integer NOT NULL,
    customer_id integer,
    loan_id integer,
    policy_type character varying(100),
    premium_amount numeric(15,2),
    CONSTRAINT insurance_policy_premium_amount_check CHECK ((premium_amount > (0)::numeric))
);


ALTER TABLE public.insurance_policy OWNER TO postgres;

--
-- Name: loan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan (
    loan_id integer NOT NULL,
    customer_id integer,
    loan_type_id integer,
    employee_id integer,
    loan_amount numeric(15,2),
    CONSTRAINT loan_loan_amount_check CHECK ((loan_amount > (0)::numeric))
);


ALTER TABLE public.loan OWNER TO postgres;

--
-- Name: loan_repayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_repayment (
    repayment_id integer NOT NULL,
    loan_id integer,
    account_id integer,
    repayment_date date,
    repayment_amount numeric(15,2),
    CONSTRAINT loan_repayment_repayment_amount_check CHECK ((repayment_amount > (0)::numeric))
);


ALTER TABLE public.loan_repayment OWNER TO postgres;

--
-- Name: loan_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_type (
    loan_type_id integer NOT NULL,
    loan_type_name character varying(100),
    interest_rate numeric(5,2),
    maximum_period_months integer,
    effective_date date,
    CONSTRAINT loan_type_interest_rate_check CHECK ((interest_rate >= (0)::numeric)),
    CONSTRAINT loan_type_maximum_period_months_check CHECK ((maximum_period_months > 0))
);


ALTER TABLE public.loan_type OWNER TO postgres;

--
-- Name: mobile_banking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mobile_banking (
    mobile_banking_id integer NOT NULL,
    customer_id integer,
    account_id integer,
    phone_number character varying(15),
    registration_date date
);


ALTER TABLE public.mobile_banking OWNER TO postgres;

--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawal (
    withdrawal_id integer NOT NULL,
    account_id integer,
    employee_id integer,
    withdrawal_date date,
    withdrawal_amount numeric(15,2),
    CONSTRAINT withdrawal_withdrawal_amount_check CHECK ((withdrawal_amount > (0)::numeric))
);


ALTER TABLE public.withdrawal OWNER TO postgres;

--
-- Data for Name: account_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_type (account_type_id, account_type_name, minimum_balance, interest_rate, effective_date) FROM stdin;
1	Savings Account	10000.00	5.00	2023-01-01
2	Current Account	50000.00	0.00	2023-01-01
3	Student Account	0.00	3.50	2023-01-01
4	Salary Account	1000.00	2.50	2023-01-01
5	Business Account	100000.00	1.50	2023-01-01
6	Fixed Savings	50000.00	6.00	2023-01-01
7	Premium Savings	200000.00	7.00	2023-01-01
8	Junior Account	0.00	4.00	2023-01-01
9	Diaspora Account	10000.00	4.50	2023-01-01
10	Women Account	5000.00	4.20	2023-01-01
11	Youth Account	1000.00	3.80	2023-01-01
12	Joint Account	10000.00	2.80	2023-01-01
13	Investment Account	500000.00	8.00	2023-01-01
14	Corporate Account	1000000.00	1.00	2023-01-01
15	NGO Account	50000.00	2.00	2023-01-01
16	Foreign Currency Account	100000.00	1.20	2023-01-01
17	Gold Account	300000.00	7.50	2023-01-01
18	Silver Account	150000.00	6.50	2023-01-01
19	Platinum Account	500000.00	8.50	2023-01-01
20	Executive Account	1000000.00	9.00	2023-01-01
21	Basic Savings	5000.00	3.00	2023-01-01
22	Family Account	15000.00	3.20	2023-01-01
23	Children Savings	0.00	4.30	2023-01-01
24	Smart Saver	20000.00	4.80	2023-01-01
25	Education Account	1000.00	4.00	2023-01-01
26	Retirement Account	50000.00	6.20	2023-01-01
27	Family Joint	20000.00	3.00	2023-01-01
28	Elite Savings	250000.00	7.20	2023-01-01
29	Diamond Account	750000.00	8.80	2023-01-01
30	Community Account	10000.00	2.50	2023-01-01
31	Farmer Account	2000.00	3.60	2023-01-01
32	Agri Business	100000.00	2.20	2023-01-01
33	Teacher Account	1000.00	3.70	2023-01-01
34	Medical Account	5000.00	3.80	2023-01-01
35	Engineer Account	10000.00	4.00	2023-01-01
36	Payroll Plus	5000.00	2.80	2023-01-01
37	Student Plus	0.00	4.00	2023-01-01
38	Graduate Account	1000.00	3.90	2023-01-01
39	StartUp Account	25000.00	2.50	2023-01-01
40	SME Account	50000.00	2.00	2023-01-01
41	Merchant Account	100000.00	1.80	2023-01-01
42	Trader Account	20000.00	2.40	2023-01-01
43	Digital Account	0.00	3.50	2023-01-01
44	Online Savings	10000.00	4.60	2023-01-01
45	Mobile Account	0.00	3.20	2023-01-01
46	Diaspora Plus	20000.00	5.00	2023-01-01
47	Global Account	50000.00	4.50	2023-01-01
48	USD Account	100000.00	1.50	2023-01-01
49	EUR Account	100000.00	1.40	2023-01-01
50	GBP Account	100000.00	1.60	2023-01-01
51	VIP Account	300000.00	7.80	2023-01-01
52	Prestige Account	400000.00	8.00	2023-01-01
53	Royal Account	600000.00	8.30	2023-01-01
54	Infinity Account	800000.00	8.70	2023-01-01
55	Prime Account	150000.00	6.00	2023-01-01
56	Silver Plus	180000.00	6.80	2023-01-01
57	Gold Plus	350000.00	7.80	2023-01-01
58	Platinum Plus	600000.00	8.90	2023-01-01
59	Executive Plus	1200000.00	9.20	2023-01-01
60	Corporate Plus	1500000.00	1.10	2023-01-01
61	NGO Plus	60000.00	2.20	2023-01-01
62	Association Acc	10000.00	2.60	2023-01-01
63	Church Account	5000.00	2.70	2023-01-01
64	Cooperative Acc	30000.00	2.90	2023-01-01
65	Village Savings	1000.00	3.40	2023-01-01
66	Women Plus	7000.00	4.40	2023-01-01
67	Youth Plus	1000.00	4.10	2023-01-01
68	Teen Account	0.00	4.00	2023-01-01
69	Kids Savings	0.00	4.20	2023-01-01
70	Future Saver	5000.00	4.90	2023-01-01
71	Home Savings	20000.00	5.10	2023-01-01
72	Car Savings	10000.00	4.70	2023-01-01
73	Travel Savings	5000.00	4.50	2023-01-01
74	Holiday Account	3000.00	4.40	2023-01-01
75	Emergency Fund	1000.00	4.60	2023-01-01
76	Secure Savings	25000.00	5.30	2023-01-01
77	Fixed Plus	75000.00	6.50	2023-01-01
78	Long Term Save	100000.00	6.80	2023-01-01
79	Premium Fixed	250000.00	7.20	2023-01-01
80	Investor Plus	600000.00	8.10	2023-01-01
81	Capital Growth	750000.00	8.40	2023-01-01
82	Wealth Account	900000.00	8.60	2023-01-01
83	Legacy Account	1000000.00	8.80	2023-01-01
84	Private Banking	1500000.00	9.10	2023-01-01
85	Business Plus	200000.00	2.00	2023-01-01
86	Enterprise Acc	300000.00	1.90	2023-01-01
87	Commercial Acc	400000.00	1.80	2023-01-01
88	Import Export	500000.00	1.70	2023-01-01
89	Trade Account	150000.00	2.10	2023-01-01
90	Investor Gold	700000.00	8.20	2023-01-01
91	Investor Plat	900000.00	8.70	2023-01-01
92	Executive Gold	1300000.00	9.30	2023-01-01
93	Executive Plat	1500000.00	9.50	2023-01-01
94	Pension Plus	25000.00	5.80	2023-01-01
95	Retire Secure	50000.00	6.10	2023-01-01
96	Future Pension	75000.00	6.30	2023-01-01
97	Secure Future	30000.00	5.70	2023-01-01
98	Family Savings	10000.00	4.30	2023-01-01
99	Family Premium	100000.00	6.70	2023-01-01
100	Legacy Premium	1200000.00	9.00	2023-01-01
\.


--
-- Data for Name: bank_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_account (account_id, customer_id, account_type_id, branch_id, opening_date) FROM stdin;
1	1	1	1	2023-01-12
2	2	2	2	2023-01-20
3	3	3	3	2023-02-10
4	4	4	4	2023-02-22
5	5	5	5	2023-03-05
6	6	6	6	2023-03-25
7	7	7	7	2023-04-08
8	8	8	8	2023-04-18
9	9	9	9	2023-05-02
10	10	10	10	2023-05-15
11	11	11	11	2023-06-01
12	12	12	12	2023-06-15
13	13	13	13	2023-07-05
14	14	14	14	2023-07-20
15	15	15	15	2023-08-01
16	16	16	16	2023-08-15
17	17	17	17	2023-09-01
18	18	18	18	2023-09-12
19	19	19	19	2023-09-25
20	20	20	20	2023-10-05
21	1	5	2	2023-11-15
22	21	2	21	2023-10-18
23	22	5	22	2023-10-26
24	23	1	23	2023-11-05
25	24	4	24	2023-11-14
26	25	7	25	2023-11-28
27	26	3	26	2023-12-08
28	27	6	27	2023-12-19
29	28	8	28	2024-01-04
30	29	10	29	2024-01-17
31	30	2	30	2024-01-29
32	31	11	31	2024-02-10
33	32	9	32	2024-02-22
34	33	12	33	2024-03-07
35	34	15	34	2024-03-18
36	35	14	35	2024-04-02
37	36	13	36	2024-04-15
38	37	16	37	2024-04-28
39	38	18	38	2024-05-11
40	39	17	39	2024-05-26
41	40	20	40	2024-06-08
42	41	5	41	2024-06-21
43	42	4	42	2024-07-04
44	43	7	43	2024-07-18
45	44	2	44	2024-08-01
46	45	6	45	2024-08-15
47	46	10	46	2024-08-29
48	47	3	47	2024-09-12
49	48	1	48	2024-09-27
50	49	19	49	2024-10-10
51	50	8	50	2024-10-25
52	51	11	51	2024-11-08
53	52	5	52	2024-11-20
54	53	9	53	2024-12-03
55	54	14	54	2024-12-17
56	55	16	55	2025-01-06
57	56	18	56	2025-01-18
58	57	12	57	2025-02-01
59	58	15	58	2025-02-16
60	59	20	59	2025-03-01
61	60	2	60	2025-03-15
62	61	6	61	2025-03-29
63	62	3	62	2025-04-11
64	63	10	63	2025-04-25
65	64	17	64	2025-05-09
66	65	7	65	2025-05-23
67	66	1	66	2025-06-06
68	67	4	67	2025-06-20
69	68	8	68	2025-07-03
70	69	13	69	2025-07-17
71	70	19	70	2025-07-31
72	71	11	71	2025-08-14
73	72	5	72	2025-08-28
74	73	9	73	2025-09-12
75	74	6	74	2025-09-25
76	75	18	75	2025-10-09
77	76	12	76	2025-10-24
78	77	14	77	2025-11-07
79	78	2	78	2025-11-21
80	79	16	79	2025-12-05
81	80	20	80	2025-12-18
82	81	1	81	2026-01-08
83	82	3	82	2026-01-22
84	83	7	83	2026-02-05
85	84	11	84	2026-02-19
86	85	15	85	2026-03-05
87	86	5	86	2026-03-19
88	87	8	87	2026-04-02
89	88	17	88	2026-04-16
90	89	19	89	2026-04-30
91	90	13	90	2026-05-14
92	91	6	91	2026-05-28
93	92	10	92	2026-06-11
94	93	2	93	2026-06-25
95	94	9	94	2026-07-09
96	95	4	95	2026-07-23
97	96	12	96	2026-08-06
98	97	18	97	2026-08-20
99	98	14	98	2026-09-03
100	99	20	99	2026-09-17
\.


--
-- Data for Name: bank_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_branch (branch_id, branch_name, district_name, branch_manager, opening_date) FROM stdin;
1	Kigali Main	Nyarugenge	John Mugisha	2015-01-15
2	Remera	Gasabo	Alice Uwase	2016-03-20
3	Kimironko	Gasabo	Patrick Habimana	2017-05-12
4	Nyamirambo	Nyarugenge	Grace Mukamana	2018-06-25
5	Musanze	Musanze	Eric Niyonzima	2015-08-18
6	Huye	Huye	Olivia Ingabire	2016-09-30
7	Rubavu	Rubavu	Samuel Bizimana	2017-11-05
8	Rusizi	Rusizi	David Nkurunziza	2018-01-22
9	Karongi	Karongi	Hope Umutoni	2019-04-15
10	Nyagatare	Nyagatare	Claude Nsengimana	2020-07-08
11	Rwamagana	Rwamagana	Diane Uwimana	2015-10-14
12	Muhanga	Muhanga	Prince Muhire	2016-12-01
13	Kayonza	Kayonza	Jean Habineza	2017-02-19
14	Bugesera	Bugesera	Ange Uwera	2018-05-27
15	Gicumbi	Gicumbi	Kevin Mugabo	2019-09-11
16	Ngoma	Ngoma	Divine Iradukunda	2020-03-18
17	Gisagara	Gisagara	Emmanuel Muryango	2021-01-10
18	Ruhango	Ruhango	Sandra Mukeshimana	2021-08-24
19	Burera	Burera	Didier Nshimiyimana	2022-02-16
20	Nyabihu	Nyabihu	Gloria Uwamahoro	2022-11-30
21	Kanombe	Kicukiro	J.B Habineza	2023-01-12
22	Gisozi	Gasabo	Sarah Muka	2023-02-04
23	Nyamirambo	Nyarugenge	David Kasongo	2023-02-25
24	Kacyiru	Gasabo	Grace Uwase	2023-03-10
25	Kabeza	Kicukiro	Patrick Mbusa	2023-03-28
26	Kimisagara	Nyarugenge	Aline Uwera	2023-04-15
27	Kabuga	Gasabo	Sam Iradukunda	2023-05-03
28	Kibagabaga	Gasabo	Olivia Niyo	2023-05-26
29	Rebero	Kicukiro	Eric Bahati	2023-06-09
30	Gatenga	Kicukiro	Alice Musabyi	2023-06-30
31	Nyamirama	Kayonza	Mike Brown	2023-07-14
32	Kibungo	Ngoma	J.C Mukendi	2023-07-28
33	Rwamagana E	Rwamagana	Diane Uwase	2023-08-12
34	Mimuri	Kayonza	Jon Smith	2023-09-05
35	Kabarondo	Kayonza	Naomi Ndu	2023-09-22
36	Nyanza C	Nyanza	Didier Habi	2023-10-04
37	Save	Gisagara	Kevin Okello	2023-10-26
38	Kibeho	Nyaruguru	Merv Kasongo	2023-11-09
39	Rusumo	Kirehe	Sandra Uwito	2023-11-28
40	Mahama	Kirehe	Andrew Kato	2023-12-18
41	Byumba E	Gicumbi	Rose Mukanta	2024-01-10
42	Byumba	Gicumbi	Joseph Kalema	2024-01-27
43	Kinihira	Rulindo	Esther Muke	2024-02-08
44	Base	Rulindo	Lucas Martin	2024-02-23
45	Busogo	Musanze	Pierre Dubois	2024-03-11
46	Kinigi	Musanze	Camille Bern	2024-03-29
47	Gisenyi	Rubavu	George Wilson	2024-04-12
48	Nyundo	Rubavu	Priya Patel	2024-05-02
49	Bwishyura	Karongi	Rahul Sharma	2024-05-21
50	Kibuye	Karongi	Anita Singh	2024-06-08
51	Mushubati	Rutsiro	Mohamed Ali	2024-06-24
52	Boneza	Rutsiro	Fatima Hassan	2024-07-15
53	Kirinda	Ngororero	Kevin Byrne	2024-08-03
54	Kabaya	Ngororero	Sophie Laure	2024-08-22
55	Nyange	Ngororero	Victor Nzeyi	2024-09-10
56	Mugina	Kamonyi	Brian Okello	2024-09-29
57	Runda	Kamonyi	Melissa Uwim	2024-10-13
58	Musambira	Kamonyi	Joel Bisimwa	2024-11-01
59	Shyogwe	Muhanga	Emma Johnson	2024-11-20
60	Cyeza	Muhanga	Chris Mutaba	2024-12-07
61	Mugina S	Kamonyi	Char Uwase	2025-01-16
62	Kansi	Huye	Gloria Namu	2025-02-01
63	Tumba	Huye	David Miller	2025-02-18
64	Maraba	Huye	Prince Bahizi	2025-03-05
65	Mugombwa	Gisagara	Linda Achieng	2025-03-23
66	Muko	Musanze	Pat Bisimwa	2025-04-09
67	Rwinkwavu	Kayonza	Olga Ilunga	2025-04-26
68	Nyagatare E	Nyagatare	Claire Uwima	2025-05-12
69	Karama	Bugesera	Jos Mukamana	2025-05-28
70	Ntarama	Bugesera	Yusuf Ibrahim	2025-06-13
71	Ruhuha	Bugesera	Rob Mugisha	2025-06-30
72	Mayange	Bugesera	Soph Williams	2025-07-18
73	Kirehe C	Kirehe	Dan Niyibizi	2025-08-02
74	Gahara	Kirehe	Kevin Musoni	2025-08-21
75	Mugesera	Ngoma	Claude Nshu	2025-09-09
76	Sake	Ngoma	Pat Mugenzi	2025-09-26
77	Kibungo W	Ngoma	Aime Bahati	2025-10-11
78	Rukira	Ngoma	Martha Kab	2025-10-28
79	Rurenge	Ngoma	David Mugabo	2025-11-12
80	Nyagisozi	Nyanza	Emm Kamanzi	2025-11-29
81	Busasamana	Nyanza	Ange Mbabazi	2025-12-10
82	Mukingo	Nyanza	Grace Nishi	2025-12-18
83	Cyanika	Burera	Sam Bizimana	2026-01-08
84	Butaro	Burera	Mich Muka	2026-01-24
85	Kinyababa	Gakenke	Joel Uwiri	2026-02-09
86	Muzo	Gakenke	Pat Rukundo	2026-02-28
87	Rushashi	Gakenke	Alice Mbaba	2026-03-16
88	Rutare	Gicumbi	Denis Ilunga	2026-04-04
89	Mutete	Gicumbi	J.P Bahati	2026-04-20
90	Kivumu	Rutsiro	Olive Muka	2026-05-08
91	Ramba	Ruhango	Kelvin Nsen	2026-05-29
92	Kinazi	Ruhango	Sandra Muka	2026-06-15
93	Bugarama	Rusizi	Moses Ndayi	2026-07-01
94	Kamembe	Rusizi	Pat Uwihore	2026-07-20
95	Muganza	Rusizi	Bella Kasongo	2026-08-06
96	Nyakabuye	Rusizi	Arthur Mugi	2026-08-24
97	Rugerero	Rubavu	Janv Nshimi	2026-09-11
98	Bigogwe	Nyabihu	Chris Uwa	2026-09-29
99	Jenda	Nyabihu	Claude Mbon	2026-10-17
100	Shyira	Nyabihu	Linda Muka	2026-11-03
\.


--
-- Data for Name: bank_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_card (card_id, account_id, card_number, card_type, issue_date) FROM stdin;
1	1	4532000000000001	Debit	2023-02-01
2	2	4532000000000002	Credit	2023-02-10
3	3	4532000000000003	Debit	2023-02-20
4	4	4532000000000004	Credit	2023-03-05
5	5	4532000000000005	Debit	2023-03-15
6	6	4532000000000006	Credit	2023-04-01
7	7	4532000000000007	Debit	2023-04-15
8	8	4532000000000008	Credit	2023-04-25
9	9	4532000000000009	Debit	2023-05-10
10	10	4532000000000010	Credit	2023-05-25
11	11	4532000000000011	Debit	2023-06-10
12	12	4532000000000012	Credit	2023-06-25
13	13	4532000000000013	Debit	2023-07-15
14	14	4532000000000014	Credit	2023-07-30
15	15	4532000000000015	Debit	2023-08-10
16	16	4532000000000016	Credit	2023-08-25
17	17	4532000000000017	Debit	2023-09-10
18	18	4532000000000018	Credit	2023-09-20
19	19	4532000000000019	Debit	2023-10-01
20	20	4532000000000020	Credit	2023-10-15
21	21	4532000000000021	Debit	2023-11-01
22	22	4532000000000022	Credit	2023-11-15
23	23	4532000000000023	Debit	2023-12-01
24	24	4532000000000024	Credit	2023-12-15
25	25	4532000000000025	Debit	2024-01-05
26	26	4532000000000026	Credit	2024-01-20
27	27	4532000000000027	Debit	2024-02-05
28	28	4532000000000028	Credit	2024-02-20
29	29	4532000000000029	Debit	2024-03-05
30	30	4532000000000030	Credit	2024-03-20
31	31	4532000000000031	Debit	2024-04-05
32	32	4532000000000032	Credit	2024-04-20
33	33	4532000000000033	Debit	2024-05-05
34	34	4532000000000034	Credit	2024-05-20
35	35	4532000000000035	Debit	2024-06-05
36	36	4532000000000036	Credit	2024-06-20
37	37	4532000000000037	Debit	2024-07-05
38	38	4532000000000038	Credit	2024-07-20
39	39	4532000000000039	Debit	2024-08-05
40	40	4532000000000040	Credit	2024-08-20
41	41	4532000000000041	Debit	2024-09-05
42	42	4532000000000042	Credit	2024-09-20
43	43	4532000000000043	Debit	2024-10-05
44	44	4532000000000044	Credit	2024-10-20
45	45	4532000000000045	Debit	2024-11-05
46	46	4532000000000046	Credit	2024-11-20
47	47	4532000000000047	Debit	2024-12-05
48	48	4532000000000048	Credit	2024-12-20
49	49	4532000000000049	Debit	2025-01-05
50	50	4532000000000050	Credit	2025-01-20
51	51	4532000000000051	Debit	2025-02-05
52	52	4532000000000052	Credit	2025-02-20
53	53	4532000000000053	Debit	2025-03-05
54	54	4532000000000054	Credit	2025-03-20
55	55	4532000000000055	Debit	2025-04-05
56	56	4532000000000056	Credit	2025-04-20
57	57	4532000000000057	Debit	2025-05-05
58	58	4532000000000058	Credit	2025-05-20
59	59	4532000000000059	Debit	2025-06-05
60	60	4532000000000060	Credit	2025-06-20
61	61	4532000000000061	Debit	2025-07-05
62	62	4532000000000062	Credit	2025-07-20
63	63	4532000000000063	Debit	2025-08-05
64	64	4532000000000064	Credit	2025-08-20
65	65	4532000000000065	Debit	2025-09-05
66	66	4532000000000066	Credit	2025-09-20
67	67	4532000000000067	Debit	2025-10-05
68	68	4532000000000068	Credit	2025-10-20
69	69	4532000000000069	Debit	2025-11-05
70	70	4532000000000070	Credit	2025-11-20
71	71	4532000000000071	Debit	2025-12-05
72	72	4532000000000072	Credit	2025-12-20
73	73	4532000000000073	Debit	2026-01-05
74	74	4532000000000074	Credit	2026-01-20
75	75	4532000000000075	Debit	2026-02-05
76	76	4532000000000076	Credit	2026-02-20
77	77	4532000000000077	Debit	2026-03-05
78	78	4532000000000078	Credit	2026-03-20
79	79	4532000000000079	Debit	2026-04-05
80	80	4532000000000080	Credit	2026-04-20
81	81	4532000000000081	Debit	2026-05-05
82	82	4532000000000082	Credit	2026-05-20
83	83	4532000000000083	Debit	2026-06-05
84	84	4532000000000084	Credit	2026-06-20
85	85	4532000000000085	Debit	2026-07-05
86	86	4532000000000086	Credit	2026-07-20
87	87	4532000000000087	Debit	2026-08-05
88	88	4532000000000088	Credit	2026-08-20
89	89	4532000000000089	Debit	2026-09-05
90	90	4532000000000090	Credit	2026-09-20
91	91	4532000000000091	Debit	2026-10-05
92	92	4532000000000092	Credit	2026-10-20
93	93	4532000000000093	Debit	2026-11-05
94	94	4532000000000094	Credit	2026-11-20
95	95	4532000000000095	Debit	2026-12-05
96	96	4532000000000096	Credit	2026-12-20
97	97	4532000000000097	Debit	2027-01-05
98	98	4532000000000098	Credit	2027-01-20
99	99	4532000000000099	Debit	2027-02-05
100	100	4532000000000100	Credit	2027-02-20
\.


--
-- Data for Name: bank_employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_employee (employee_id, branch_id, employee_name, employee_position, employment_date) FROM stdin;
1	1	John Mugisha	Branch Manager	2018-01-10
2	2	Alice Uwase	Loan Officer	2019-03-15
3	3	Patrick Habimana	Account Officer	2020-05-20
4	4	Grace Mukamana	Cashier	2019-07-12
5	5	Eric Niyonzima	Customer Service Officer	2018-09-25
6	6	Olivia Ingabire	Loan Officer	2021-01-18
7	7	Samuel Bizimana	Cashier	2020-04-05
8	8	David Nkurunziza	Account Officer	2019-06-30
9	9	Hope Umutoni	Customer Service Officer	2021-08-14
10	10	Claude Nsengimana	Loan Officer	2022-02-10
11	11	Diane Uwimana	Branch Manager	2017-11-20
12	12	Prince Muhire	Cashier	2020-10-15
13	13	Jean Habineza	Account Officer	2018-12-05
14	14	Ange Uwera	Customer Service Officer	2021-03-22
15	15	Kevin Mugabo	Loan Officer	2022-06-17
16	16	Divine Iradukunda	Cashier	2019-09-09
17	17	Emmanuel Muryango	Account Officer	2020-12-12
18	18	Sandra Mukeshimana	Customer Service Officer	2021-07-25
19	19	Didier Nshimiyimana	Loan Officer	2022-01-30
20	20	Gloria Uwamahoro	Branch Manager	2018-04-18
21	21	Michael Brown	Cashier	2019-02-14
22	22	Sarah Mukamana	Loan Officer	2020-05-11
23	23	David Kasongo	Account Officer	2021-07-22
24	24	Grace Uwase	Branch Manager	2018-11-03
25	25	Patrick Mbusa	Customer Service Officer	2022-01-17
26	26	Aline Uwera	Cashier	2020-08-28
27	27	Samuel Iradukunda	Loan Officer	2019-06-19
28	28	Olivia Niyonzima	Account Officer	2021-04-12
29	29	Eric Bahati	Customer Service Officer	2022-03-05
30	30	Alice Musabyi	Cashier	2018-12-20
31	31	Jonathan Smith	Branch Manager	2017-09-18
32	32	Jean Mukendi	Loan Officer	2020-10-09
33	33	Diane Uwase	Account Officer	2019-01-25
34	34	Kevin Okello	Cashier	2021-02-16
35	35	Naomi Nduwayo	Customer Service Officer	2022-07-03
36	36	Didier Habimana	Loan Officer	2020-04-26
37	37	Merveille Ilunga	Cashier	2019-11-14
38	38	Andrew Kato	Account Officer	2021-08-21
39	39	Sandra Uwitonze	Customer Service Officer	2022-05-09
40	40	Rose Mukanta	Branch Manager	2018-06-30
41	41	Joseph Kalema	Loan Officer	2019-03-27
42	42	Lucas Martin	Cashier	2020-12-08
43	43	Esther Muke	Account Officer	2021-10-19
44	44	Pierre Dubois	Customer Service Officer	2019-09-15
45	45	Camille Bernard	Loan Officer	2022-02-11
46	46	George Wilson	Branch Manager	2018-01-29
47	47	Priya Patel	Cashier	2020-06-18
48	48	Rahul Sharma	Account Officer	2021-11-05
49	49	Anita Singh	Loan Officer	2022-04-23
50	50	Mohamed Ali	Customer Service Officer	2019-08-07
51	51	Fatima Hassan	Cashier	2020-07-26
52	52	Kevin Byrne	Loan Officer	2021-03-10
53	53	Sophie Laurent	Account Officer	2019-12-02
54	54	Victor Nzeyi	Customer Service Officer	2022-08-18
55	55	Brian Okello	Branch Manager	2018-10-12
56	56	Melissa Uwimp	Cashier	2021-05-29
57	57	Joel Bisimwa	Loan Officer	2020-02-13
58	58	Emma Johnson	Account Officer	2019-04-22
59	59	Chris Mutaba	Customer Service Officer	2022-06-06
60	60	David Miller	Cashier	2021-09-27
61	61	Prince Bahizi	Loan Officer	2020-01-31
62	62	Linda Achieng	Account Officer	2019-07-16
63	63	Patrick Bisimwa	Customer Service Officer	2022-03-14
64	64	Olga Ilunga	Branch Manager	2018-05-08
65	65	Claire Uwima	Cashier	2021-01-20
66	66	Yusuf Ibrahim	Loan Officer	2020-09-17
67	67	Robert Mugisha	Account Officer	2019-11-30
68	68	Sophia Williams	Customer Service Officer	2022-07-25
69	69	Daniel Niyibizi	Cashier	2021-12-04
70	70	Kevin Musoni	Loan Officer	2020-03-09
71	71	Claude Nshuti	Branch Manager	2018-04-01
72	72	Patrick Mugenzi	Account Officer	2021-06-11
73	73	Aime Bahati	Customer Service Officer	2022-01-08
74	74	Martha Kabera	Cashier	2019-05-24
75	75	David Mugabo	Loan Officer	2020-10-28
76	76	Emmanuel Kamanzi	Account Officer	2021-02-07
77	77	Ange Mbabazi	Customer Service Officer	2022-09-13
78	78	Grace Nishimwe	Cashier	2019-03-18
79	79	Samuel Bizimana	Loan Officer	2020-08-15
80	80	Micheline Muka	Branch Manager	2018-07-09
81	81	Joel Uwiri	Account Officer	2021-11-23
82	82	Patrick Rukundo	Customer Service Officer	2022-05-18
83	83	Alice Mbabazi	Cashier	2020-12-01
84	84	Denis Ilunga	Loan Officer	2019-02-28
85	85	Jean Bahati	Account Officer	2021-04-09
86	86	Olive Mukankusi	Customer Service Officer	2022-06-30
87	87	Kelvin Nsengi	Branch Manager	2018-08-22
88	88	Sandra Mukamana	Cashier	2020-11-17
89	89	Moses Ndayi	Loan Officer	2019-06-12
90	90	Patrick Uwihore	Account Officer	2021-10-06
91	91	Belinda Kasongo	Customer Service Officer	2022-02-24
92	92	Arthur Mugisha	Cashier	2020-01-15
93	93	Janvier Nshimi	Loan Officer	2019-09-03
94	94	Christine Uwa	Account Officer	2021-07-27
95	95	Claude Mbon	Customer Service Officer	2022-04-14
96	96	Linda Mukarug	Branch Manager	2018-03-19
97	97	Peter Johnson	Cashier	2020-05-06
98	98	James Anderson	Loan Officer	2021-08-31
99	99	Mary Williams	Account Officer	2022-01-26
100	100	Daniel Garcia	Customer Service Officer	2020-09-22
\.


--
-- Data for Name: beneficiary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beneficiary (beneficiary_id, customer_id, beneficiary_name, beneficiary_account, registration_date) FROM stdin;
1	1	Alice Niyonzima	BNF100001	2023-02-10
2	2	Eric Habimana	BNF100002	2023-02-20
3	3	Grace Uwase	BNF100003	2023-03-01
4	4	Patrick Mugisha	BNF100004	2023-03-15
5	5	Olivia Mukamana	BNF100005	2023-03-25
6	6	Samuel Bizimana	BNF100006	2023-04-10
7	7	Hope Ingabire	BNF100007	2023-04-20
8	8	David Nkurunziza	BNF100008	2023-05-05
9	9	Diane Uwimana	BNF100009	2023-05-18
10	10	Claude Nsengimana	BNF100010	2023-06-01
11	11	Kevin Mugabo	BNF100011	2023-06-15
12	12	Ange Uwera	BNF100012	2023-06-30
13	13	Divine Iradukunda	BNF100013	2023-07-15
14	14	Emmanuel Muryango	BNF100014	2023-07-30
15	15	Sandra Mukeshimana	BNF100015	2023-08-10
16	16	Didier Nshimiyimana	BNF100016	2023-08-25
17	17	Gloria Uwamahoro	BNF100017	2023-09-10
18	18	Prince Muhire	BNF100018	2023-09-25
19	19	John Mugisha	BNF100019	2023-10-10
20	20	Alice Uwase	BNF100020	2023-10-25
21	21	Michael Hakizimana	BNF100021	2023-11-10
22	22	Claudine Uwase	BNF100022	2023-11-25
23	23	Robert Ndayisenga	BNF100023	2023-12-10
24	24	Esther Mukamana	BNF100024	2023-12-25
25	25	Samuel Habimana	BNF100025	2024-01-10
26	26	Beatrice Uwamwezi	BNF100026	2024-01-25
27	27	Alex Niyomugabo	BNF100027	2024-02-10
28	28	Peace Ingabire	BNF100028	2024-02-25
29	29	Patrick Nkurunziza	BNF100029	2024-03-10
30	30	Agnes Uwera	BNF100030	2024-03-25
31	31	Emmanuel Bizimana	BNF100031	2024-04-10
32	32	Doreen Mukeshimana	BNF100032	2024-04-25
33	33	Daniel Mugabo	BNF100033	2024-05-10
34	34	Chantal Uwimana	BNF100034	2024-05-25
35	35	Fabrice Mugenzi	BNF100035	2024-06-10
36	36	Alice Uwamahoro	BNF100036	2024-06-25
37	37	Eric Tuyisenge	BNF100037	2024-07-10
38	38	Grace Nyirabazungu	BNF100038	2024-07-25
39	39	David Murenzi	BNF100039	2024-08-10
40	40	Diane Mukamana	BNF100040	2024-08-25
41	41	Kevin Niyonzima	BNF100041	2024-09-10
42	42	Olivia Uwamwezi	BNF100042	2024-09-25
43	43	Prince Habimana	BNF100043	2024-10-10
44	44	Hope Uwase	BNF100044	2024-10-25
45	45	Sandra Mutesi	BNF100045	2024-11-10
46	46	Claude Uwase	BNF100046	2024-11-25
47	47	Divine Nshimiyimana	BNF100047	2024-12-10
48	48	Jean Bosco Mugenzi	BNF100048	2024-12-25
49	49	Ange Mukeshimana	BNF100049	2025-01-10
50	50	Patrick Niyomugabo	BNF100050	2025-01-25
51	51	Emelyne Uwera	BNF100051	2025-02-10
52	52	Moses Bizimana	BNF100052	2025-02-25
53	53	Yvonne Uwimana	BNF100053	2025-03-10
54	54	Samuel Nkurunziza	BNF100054	2025-03-25
55	55	Beatrice Habimana	BNF100055	2025-04-10
56	56	Alexis Mugisha	BNF100056	2025-04-25
57	57	Claudine Ingabire	BNF100057	2025-05-10
58	58	Robert Uwamahoro	BNF100058	2025-05-25
59	59	Esther Niyonzima	BNF100059	2025-06-10
60	60	Michael Uwase	BNF100060	2025-06-25
61	61	Diane Mutesi	BNF100061	2025-07-10
62	62	Kevin Habimana	BNF100062	2025-07-25
63	63	Grace Mukamana	BNF100063	2025-08-10
64	64	David Mugabo	BNF100064	2025-08-25
65	65	Alice Nshimiyimana	BNF100065	2025-09-10
66	66	Eric Bizimana	BNF100066	2025-09-25
67	67	Hope Uwimana	BNF100067	2025-10-10
68	68	Prince Nkurunziza	BNF100068	2025-10-25
69	69	Sandra Ingabire	BNF100069	2025-11-10
70	70	John Uwera	BNF100070	2025-11-25
71	71	Olivia Mukeshimana	BNF100071	2025-12-10
72	72	Daniel Habimana	BNF100072	2025-12-25
73	73	Doreen Mugisha	BNF100073	2026-01-10
74	74	Fabrice Uwase	BNF100074	2026-01-25
75	75	Chantal Niyonzima	BNF100075	2026-02-10
76	76	Emmanuel Nkurunziza	BNF100076	2026-02-25
77	77	Agnes Bizimana	BNF100077	2026-03-10
78	78	Michael Uwamahoro	BNF100078	2026-03-25
79	79	Beatrice Mukamana	BNF100079	2026-04-10
80	80	Robert Mugisha	BNF100080	2026-04-25
81	81	Claudine Uwera	BNF100081	2026-05-10
82	82	Alex Nshimiyimana	BNF100082	2026-05-25
83	83	Peace Uwimana	BNF100083	2026-06-10
84	84	Samuel Habimana	BNF100084	2026-06-25
85	85	Diane Ingabire	BNF100085	2026-07-10
86	86	Kevin Uwase	BNF100086	2026-07-25
87	87	Gloria Mukamana	BNF100087	2026-08-10
88	88	Prince Bizimana	BNF100088	2026-08-25
89	89	Divine Mugabo	BNF100089	2026-09-10
90	90	Jean Claude Uwera	BNF100090	2026-09-25
91	91	Sandra Niyonzima	BNF100091	2026-10-10
92	92	John Habimana	BNF100092	2026-10-25
93	93	Hope Mukeshimana	BNF100093	2026-11-10
94	94	David Uwimana	BNF100094	2026-11-25
95	95	Olivia Mugisha	BNF100095	2026-12-05
96	96	Eric Uwamahoro	BNF100096	2026-12-10
97	97	Grace Bizimana	BNF100097	2026-12-15
98	98	Patrick Uwase	BNF100098	2026-12-20
99	99	Alice Niyonzima	BNF100099	2026-12-25
100	100	Moses Habimana	BNF100100	2026-12-30
\.


--
-- Data for Name: branch_target; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch_target (target_id, branch_id, account_type_id, target_year, target_amount) FROM stdin;
1	1	1	2024	500000000.00
2	2	2	2024	450000000.00
3	3	3	2024	300000000.00
4	4	4	2024	350000000.00
5	5	5	2024	700000000.00
6	6	6	2024	600000000.00
7	7	7	2024	400000000.00
8	8	8	2024	250000000.00
9	9	9	2024	280000000.00
10	10	10	2024	320000000.00
11	11	11	2024	550000000.00
12	12	12	2024	380000000.00
13	13	13	2024	470000000.00
14	14	14	2024	430000000.00
15	15	15	2024	620000000.00
16	16	16	2024	360000000.00
17	17	17	2024	410000000.00
18	18	18	2024	390000000.00
19	19	19	2024	800000000.00
20	20	20	2024	900000000.00
21	21	21	2025	520000000.00
22	22	22	2025	480000000.00
23	23	23	2025	350000000.00
24	24	24	2025	400000000.00
25	25	25	2025	750000000.00
26	26	26	2025	650000000.00
27	27	27	2025	450000000.00
28	28	28	2025	300000000.00
29	29	29	2025	330000000.00
30	30	30	2025	370000000.00
31	31	31	2025	600000000.00
32	32	32	2025	420000000.00
33	33	33	2025	520000000.00
34	34	34	2025	480000000.00
35	35	35	2025	680000000.00
36	36	36	2025	390000000.00
37	37	37	2025	460000000.00
38	38	38	2025	440000000.00
39	39	39	2025	850000000.00
40	40	40	2025	950000000.00
41	41	41	2026	550000000.00
42	42	42	2026	500000000.00
43	43	43	2026	380000000.00
44	44	44	2026	430000000.00
45	45	45	2026	780000000.00
46	46	46	2026	700000000.00
47	47	47	2026	480000000.00
48	48	48	2026	320000000.00
49	49	49	2026	350000000.00
50	50	50	2026	400000000.00
51	51	51	2026	650000000.00
52	52	52	2026	450000000.00
53	53	53	2026	550000000.00
54	54	54	2026	500000000.00
55	55	55	2026	720000000.00
56	56	56	2026	420000000.00
57	57	57	2026	500000000.00
58	58	58	2026	470000000.00
59	59	59	2026	900000000.00
60	60	60	2026	1000000000.00
61	61	61	2026	580000000.00
62	62	62	2026	530000000.00
63	63	63	2026	400000000.00
64	64	64	2026	450000000.00
65	65	65	2026	820000000.00
66	66	66	2026	720000000.00
67	67	67	2026	520000000.00
68	68	68	2026	350000000.00
69	69	69	2026	380000000.00
70	70	70	2026	430000000.00
71	71	71	2026	700000000.00
72	72	72	2026	480000000.00
73	73	73	2026	600000000.00
74	74	74	2026	550000000.00
75	75	75	2026	800000000.00
76	76	76	2026	450000000.00
77	77	77	2026	530000000.00
78	78	78	2026	500000000.00
79	79	79	2026	950000000.00
80	80	80	2026	1100000000.00
81	81	81	2026	620000000.00
82	82	82	2026	570000000.00
83	83	83	2026	420000000.00
84	84	84	2026	470000000.00
85	85	85	2026	850000000.00
86	86	86	2026	750000000.00
87	87	87	2026	550000000.00
88	88	88	2026	380000000.00
89	89	89	2026	420000000.00
90	90	90	2026	450000000.00
91	91	91	2026	750000000.00
92	92	92	2026	520000000.00
93	93	93	2026	650000000.00
94	94	94	2026	580000000.00
95	95	95	2026	850000000.00
96	96	96	2026	500000000.00
97	97	97	2026	600000000.00
98	98	98	2026	550000000.00
99	99	99	2026	1000000000.00
100	100	100	2026	1200000000.00
\.


--
-- Data for Name: collateral; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collateral (collateral_id, loan_id, collateral_type, collateral_value, registration_date) FROM stdin;
1	1	Vehicle	800000.00	2023-03-01
2	2	Land	5000000.00	2023-03-10
3	3	House	10000000.00	2023-03-20
4	4	Land	25000000.00	2023-04-05
5	5	Vehicle	7000000.00	2023-04-15
6	6	Agricultural Equipment	4000000.00	2023-05-01
7	7	Electronics	1000000.00	2023-05-15
8	8	Jewelry	500000.00	2023-05-25
9	9	Building	15000000.00	2023-06-10
10	10	Land	20000000.00	2023-06-25
11	11	Commercial Building	50000000.00	2023-07-10
12	12	Vehicle	3000000.00	2023-07-25
13	13	Machinery	12000000.00	2023-08-05
14	14	Equipment	6000000.00	2023-08-20
15	15	Land	3000000.00	2023-09-01
16	16	House	8000000.00	2023-09-15
17	17	Vehicle	5000000.00	2023-10-01
18	18	Business Assets	10000000.00	2023-10-10
19	19	Commercial Property	60000000.00	2023-10-20
20	20	Industrial Equipment	75000000.00	2023-11-01
21	21	Vehicle	9000000.00	2023-11-15
22	22	Land	15000000.00	2023-12-01
23	23	House	20000000.00	2023-12-15
24	24	Building	35000000.00	2024-01-05
25	25	Electronics	2000000.00	2024-01-20
26	26	Jewelry	1500000.00	2024-02-05
27	27	Machinery	18000000.00	2024-02-20
28	28	Vehicle	6000000.00	2024-03-05
29	29	Land	12000000.00	2024-03-20
30	30	Commercial Building	70000000.00	2024-04-05
31	31	Equipment	8000000.00	2024-04-20
32	32	House	25000000.00	2024-05-05
33	33	Business Assets	15000000.00	2024-05-20
34	34	Agricultural Equipment	5000000.00	2024-06-05
35	35	Vehicle	11000000.00	2024-06-20
36	36	Industrial Equipment	80000000.00	2024-07-05
37	37	Land	9000000.00	2024-07-20
38	38	Building	45000000.00	2024-08-05
39	39	House	30000000.00	2024-08-20
40	40	Commercial Property	90000000.00	2024-09-05
41	41	Vehicle	7000000.00	2024-09-20
42	42	Machinery	22000000.00	2024-10-05
43	43	Electronics	3000000.00	2024-10-20
44	44	Land	40000000.00	2024-11-05
45	45	Building	55000000.00	2024-11-20
46	46	Jewelry	4000000.00	2024-12-05
47	47	Equipment	10000000.00	2024-12-20
48	48	House	35000000.00	2025-01-05
49	49	Vehicle	12000000.00	2025-01-20
50	50	Commercial Building	100000000.00	2025-02-05
51	51	Land	30000000.00	2025-02-20
52	52	Agricultural Equipment	7000000.00	2025-03-05
53	53	Machinery	25000000.00	2025-03-20
54	54	Industrial Equipment	85000000.00	2025-04-05
55	55	Vehicle	10000000.00	2025-04-20
56	56	Building	60000000.00	2025-05-05
57	57	House	28000000.00	2025-05-20
58	58	Land	18000000.00	2025-06-05
59	59	Business Assets	20000000.00	2025-06-20
60	60	Commercial Property	95000000.00	2025-07-05
61	61	Equipment	9000000.00	2025-07-20
62	62	Vehicle	15000000.00	2025-08-05
63	63	Jewelry	2500000.00	2025-08-20
64	64	Building	70000000.00	2025-09-05
65	65	Land	45000000.00	2025-09-20
66	66	Machinery	30000000.00	2025-10-05
67	67	House	40000000.00	2025-10-20
68	68	Vehicle	8500000.00	2025-11-05
69	69	Commercial Building	110000000.00	2025-11-20
70	70	Industrial Equipment	95000000.00	2025-12-05
71	71	Land	25000000.00	2025-12-20
72	72	Building	65000000.00	2026-01-05
73	73	Electronics	5000000.00	2026-01-20
74	74	Vehicle	14000000.00	2026-02-05
75	75	House	50000000.00	2026-02-20
76	76	Machinery	35000000.00	2026-03-05
77	77	Equipment	12000000.00	2026-03-20
78	78	Land	60000000.00	2026-04-05
79	79	Business Assets	30000000.00	2026-04-20
80	80	Commercial Property	120000000.00	2026-05-05
81	81	Vehicle	9500000.00	2026-05-20
82	82	House	45000000.00	2026-06-05
83	83	Land	35000000.00	2026-06-20
84	84	Building	75000000.00	2026-07-05
85	85	Jewelry	6000000.00	2026-07-20
86	86	Machinery	40000000.00	2026-08-05
87	87	Equipment	15000000.00	2026-08-20
88	88	Vehicle	13000000.00	2026-09-05
89	89	Industrial Equipment	100000000.00	2026-09-20
90	90	Land	55000000.00	2026-10-05
91	91	Building	80000000.00	2026-10-20
92	92	House	60000000.00	2026-11-05
93	93	Commercial Building	130000000.00	2026-11-20
94	94	Vehicle	17000000.00	2026-12-05
95	95	Machinery	45000000.00	2026-12-20
96	96	Business Assets	35000000.00	2027-01-05
97	97	Land	70000000.00	2027-01-20
98	98	Equipment	20000000.00	2027-02-05
99	99	Commercial Property	150000000.00	2027-02-20
100	100	Industrial Equipment	180000000.00	2027-03-05
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (currency_id, currency_code, currency_name, exchange_rate, effective_date) FROM stdin;
1	RWF	Rwandan Franc	1.0000	2023-01-01
2	USD	US Dollar	1300.0000	2023-01-01
3	EUR	Euro	1400.0000	2023-01-01
4	GBP	British Pound	1600.0000	2023-01-01
5	KES	Kenyan Shilling	10.5000	2023-01-01
6	UGX	Ugandan Shilling	0.3500	2023-01-01
7	TZS	Tanzanian Shilling	0.5500	2023-01-01
8	BIF	Burundian Franc	0.6500	2023-01-01
9	ZAR	South African Rand	70.0000	2023-01-01
10	AED	UAE Dirham	354.0000	2023-01-01
11	CNY	Chinese Yuan	180.0000	2023-01-01
12	INR	Indian Rupee	15.5000	2023-01-01
13	JPY	Japanese Yen	9.5000	2023-01-01
14	CAD	Canadian Dollar	950.0000	2023-01-01
15	AUD	Australian Dollar	850.0000	2023-01-01
16	CHF	Swiss Franc	1450.0000	2023-01-01
17	NGN	Nigerian Naira	2.8000	2023-01-01
18	ETB	Ethiopian Birr	24.0000	2023-01-01
19	GHS	Ghanaian Cedi	110.0000	2023-01-01
20	BRL	Brazilian Real	260.0000	2023-01-01
21	MXN	Mexican Peso	68.0000	2023-02-01
22	SEK	Swedish Krona	125.0000	2023-02-14
23	NOK	Norwegian Krone	122.0000	2023-03-05
24	DKK	Danish Krone	188.0000	2023-03-22
25	PLN	Polish Zloty	320.0000	2023-04-10
26	RUB	Russian Ruble	15.5000	2023-04-29
27	TRY	Turkish Lira	34.0000	2023-05-18
28	SAR	Saudi Riyal	347.0000	2023-06-06
29	QAR	Qatari Riyal	357.0000	2023-06-24
30	KWD	Kuwaiti Dinar	4250.0000	2023-07-11
31	BHD	Bahraini Dinar	3450.0000	2023-07-28
32	OMR	Omani Rial	3380.0000	2023-08-15
33	JOD	Jordanian Dinar	1830.0000	2023-09-03
34	LBP	Lebanese Pound	0.0150	2023-09-21
35	ILS	Israeli Shekel	355.0000	2023-10-08
36	PKR	Pakistani Rupee	4.7000	2023-10-26
37	BDT	Bangladeshi Taka	11.9000	2023-11-12
38	LKR	Sri Lankan Rupee	4.2000	2023-11-30
39	NPR	Nepalese Rupee	9.8000	2023-12-18
40	MVR	Maldivian Rufiyaa	84.0000	2024-01-05
41	THB	Thai Baht	36.5000	2024-01-23
42	MYR	Malaysian Ringgit	285.0000	2024-02-11
43	SGD	Singapore Dollar	965.0000	2024-02-28
44	IDR	Indonesian Rupiah	0.0800	2024-03-16
45	PHP	Philippine Peso	23.5000	2024-04-03
46	VND	Vietnamese Dong	0.0520	2024-04-20
47	KHR	Cambodian Riel	0.3200	2024-05-09
48	LAK	Lao Kip	0.0610	2024-05-27
49	MMK	Myanmar Kyat	0.6200	2024-06-14
50	KRW	South Korean Won	0.9600	2024-07-02
51	HKD	Hong Kong Dollar	166.0000	2024-07-19
52	TWD	New Taiwan Dollar	41.0000	2024-08-07
53	MOP	Macanese Pataca	161.0000	2024-08-25
54	NZD	New Zealand Dollar	790.0000	2024-09-13
55	FJD	Fijian Dollar	570.0000	2024-10-01
56	PGK	Papua New Guinean Kina	335.0000	2024-10-18
57	WST	Samoan Tala	470.0000	2024-11-06
58	TOP	Tongan Paanga	550.0000	2024-11-24
59	VUV	Vanuatu Vatu	10.8000	2024-12-12
60	SBD	Solomon Islands Dollar	156.0000	2025-01-02
61	XOF	West African CFA Franc	2.1300	2025-01-21
62	XAF	Central African CFA Franc	2.1300	2025-02-09
63	MAD	Moroccan Dirham	132.0000	2025-02-27
64	DZD	Algerian Dinar	9.6000	2025-03-18
65	TND	Tunisian Dinar	420.0000	2025-04-05
66	LYD	Libyan Dinar	270.0000	2025-04-24
67	EGP	Egyptian Pound	26.5000	2025-05-12
68	SDG	Sudanese Pound	2.2000	2025-05-31
69	SSP	South Sudanese Pound	9.9000	2025-06-17
70	ZMW	Zambian Kwacha	47.0000	2025-07-05
71	MWK	Malawian Kwacha	0.7600	2025-07-24
72	MZN	Mozambican Metical	20.5000	2025-08-12
73	BWP	Botswana Pula	96.0000	2025-08-30
74	NAD	Namibian Dollar	70.0000	2025-09-17
75	SZL	Lilangeni	70.0000	2025-10-06
76	LSL	Lesotho Loti	70.0000	2025-10-24
77	AOA	Angolan Kwanza	1.5500	2025-11-11
78	MUR	Mauritian Rupee	29.5000	2025-11-29
79	SCR	Seychellois Rupee	92.0000	2025-12-18
80	KMF	Comorian Franc	2.8500	2026-01-07
81	CLP	Chilean Peso	1.3500	2026-01-25
82	ARS	Argentine Peso	1.1500	2026-02-12
83	COP	Colombian Peso	0.3300	2026-03-02
84	PEN	Peruvian Sol	355.0000	2026-03-20
85	UYU	Uruguayan Peso	33.0000	2026-04-08
86	PYG	Paraguayan Guarani	0.1700	2026-04-27
87	BOB	Bolivian Boliviano	188.0000	2026-05-15
88	CRC	Costa Rican Colon	2.5500	2026-06-03
89	DOP	Dominican Peso	22.0000	2026-06-22
90	JMD	Jamaican Dollar	8.2000	2026-07-10
91	TTD	Trinidad and Tobago Dollar	192.0000	2026-07-29
92	BBD	Barbadian Dollar	650.0000	2026-08-17
93	BSD	Bahamian Dollar	1300.0000	2026-09-04
94	BZD	Belize Dollar	645.0000	2026-09-23
95	GTQ	Guatemalan Quetzal	167.0000	2026-10-11
96	HNL	Honduran Lempira	52.0000	2026-10-30
97	NIO	Nicaraguan Cordoba	35.0000	2026-11-18
98	CUP	Cuban Peso	54.0000	2026-12-06
99	ALL	Albanian Lek	13.8000	2026-12-21
100	ISK	Icelandic Krona	9.3000	2026-12-31
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (customer_id, national_id, customer_name, customer_type, registration_date) FROM stdin;
1	119980100001	Jean Niyonzima	Individual	2023-01-10
2	119980100002	Alice Mukamana	Individual	2023-01-15
3	119980100003	Eric Habimana	Individual	2023-02-05
4	119980100004	Divine Uwase	Individual	2023-02-18
5	119980100005	Patrick Nshimiyimana	Individual	2023-03-02
6	119980100006	Grace Uwera	Individual	2023-03-20
7	119980100007	Samuel Mugisha	Individual	2023-04-01
8	119980100008	Olivia Iradukunda	Individual	2023-04-10
9	119980100009	Claude Bizimana	Individual	2023-04-25
10	119980100010	Hope Ingabire	Individual	2023-05-08
11	119980100011	Vision Ltd	Company	2023-05-15
12	119980100012	Bright Tech Ltd	Company	2023-05-22
13	119980100013	Green Farm Ltd	Company	2023-06-05
14	119980100014	Alpha Traders Ltd	Company	2023-06-18
15	119980100015	Unity Holdings Ltd	Company	2023-07-01
16	119980100016	David Nkurunziza	Individual	2023-07-12
17	119980100017	Ange Umutoni	Individual	2023-08-04
18	119980100018	Kevin Nsengimana	Individual	2023-08-20
19	119980100019	Diane Uwimana	Individual	2023-09-05
20	119980100020	Rafiki Edouard	Individual	2023-09-26
21	119980234561	Patrick Mugenzi	Individual	2023-10-03
22	119970876512	Grace Uwase	Individual	2023-10-09
23	120010567891	Jean Claude Mukendi	Individual	2023-10-21
24	119991245678	Sarah Nishimwe	Individual	2023-11-02
25	119980987654	Eric Bahati	Individual	2023-11-11
26	120020345678	Olivia Mukamana	Individual	2023-11-18
27	119981234890	Daniel Niyibizi	Individual	2023-11-26
28	119970223344	Aline Uwera	Individual	2023-12-01
29	119991112233	Kevin Mbusa	Individual	2023-12-10
30	120010445566	Alice Musabyimana	Individual	2023-12-21
31	119980778899	Samuel Iradukunda	Individual	2024-01-08
32	119981556677	Brian Okello	Individual	2024-01-14
33	119990334455	Claire Uwimana	Individual	2024-01-29
34	119970998877	Merveille Kasongo	Individual	2024-02-05
35	120010998811	Didier Habimana	Individual	2024-02-12
36	119981445566	Linda Achieng	Individual	2024-02-24
37	119972345678	Claude Nshuti	Individual	2024-03-03
38	119980887766	Ange Mbabazi	Individual	2024-03-18
39	119990123789	Joseph Kalema	Individual	2024-03-27
40	119981998877	Sandra Uwitonze	Individual	2024-04-04
41	119971234123	Emmanuel Kamanzi	Individual	2024-04-15
42	119982345345	Naomi Nduwayo	Individual	2024-04-29
43	119980998123	David Mugabo	Individual	2024-05-06
44	119973456789	Martha Kabera	Individual	2024-05-18
45	119980456123	Prince Bahizi	Individual	2024-05-26
46	119981234321	Olga Ilunga	Individual	2024-06-09
47	119971567890	Jonathan Smith	Individual	2024-06-17
48	119982456789	Sophia Williams	Individual	2024-06-30
49	119980112233	Michael Brown	Individual	2024-07-11
50	119971998877	Emma Johnson	Individual	2024-07-25
51	119982112211	David Miller	Individual	2024-08-02
52	119980765432	Fatima Hassan	Individual	2024-08-15
53	119971445566	Mohamed Ali	Individual	2024-08-24
54	119982334455	Yusuf Ibrahim	Individual	2024-09-01
55	119980667788	Priya Patel	Individual	2024-09-13
56	119971223344	Rahul Sharma	Individual	2024-09-24
57	119982998877	Anita Singh	Individual	2024-10-08
58	119980554433	Kevin Byrne	Individual	2024-10-21
59	119971334455	Sophie Laurent	Individual	2024-10-30
60	119982223344	Pierre Dubois	Individual	2024-11-09
61	119980889900	Lucas Martin	Individual	2024-11-18
62	119971112299	Camille Bernard	Individual	2024-11-29
63	119982778899	George Wilson	Individual	2024-12-07
64	119980332211	Victor Nzeyimana	Individual	2024-12-18
65	119971556600	Esther Mukeshimana	Individual	2025-01-04
66	119982665544	Joel Bisimwa	Individual	2025-01-13
67	119980776655	Chantal Nyiraneza	Individual	2025-01-27
68	119971889900	Christian Mutabazi	Individual	2025-02-06
69	119982443322	Diane Mukantwari	Individual	2025-02-18
70	119980998765	Aime Bahati	Individual	2025-02-28
71	119971667788	Robert Mugisha	Individual	2025-03-09
72	119982887766	Melissa Uwimpuhwe	Individual	2025-03-22
73	119980123654	Josephine Mukamana	Individual	2025-04-02
74	119971998811	Andrew Kato	Individual	2025-04-16
75	119982554433	Gloria Namusoke	Individual	2025-04-27
76	119980665544	Patrick Bisimwa	Individual	2025-05-08
77	119971776655	Charlotte Uwase	Individual	2025-05-19
78	119982001122	Kevin Musoni	Individual	2025-05-30
79	119980889911	Rose Mukantabana	Individual	2025-06-12
80	119971443322	Alpha Holdings Ltd	Company	2025-06-20
81	119982778811	Vision East Ltd	Company	2025-06-27
82	119980224466	Kivu Minerals Ltd	Company	2025-07-05
83	119971887744	Lake View Traders	Company	2025-07-17
84	119982119988	Sunrise Logistics	Company	2025-07-29
85	119980456789	Blue Horizon Ltd	Company	2025-08-06
86	119971223311	Great Lakes Coffee	Company	2025-08-19
87	119982334411	Unity Investments	Company	2025-08-30
88	119980112299	Prime Agro Ltd	Company	2025-09-09
89	119971665544	Future Vision Group	Company	2025-09-20
90	119982443311	Congo Business Hub	Company	2025-09-28
91	119980778811	East Africa Supplies	Company	2025-10-06
92	119971556611	Nova Construction Ltd	Company	2025-10-18
93	119982221133	Bright Solutions Ltd	Company	2025-10-29
94	119980665577	Mugisha Fabrics	Company	2025-11-08
95	119971998822	Alliance Tech Ltd	Company	2025-11-19
96	119982887711	Green Valley Export	Company	2025-11-28
97	119980334422	Cedar Finance Ltd	Company	2025-12-07
98	119971110099	Silver Link Trading	Company	2025-12-16
99	119982776654	Golden Harvest Ltd	Company	2025-12-23
100	119980445533	Atlas Business Group	Company	2025-12-28
\.


--
-- Data for Name: customer_complaint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_complaint (complaint_id, customer_id, employee_id, complaint_date, complaint_status) FROM stdin;
1	1	1	2023-03-05	Resolved
2	2	2	2023-03-12	Pending
3	3	3	2023-03-20	Closed
4	4	4	2023-04-02	Resolved
5	5	5	2023-04-15	Pending
6	6	6	2023-04-28	Closed
7	7	7	2023-05-10	Resolved
8	8	8	2023-05-22	Pending
9	9	9	2023-06-05	Closed
10	10	10	2023-06-18	Resolved
11	11	11	2023-07-01	Pending
12	12	12	2023-07-15	Closed
13	13	13	2023-08-02	Resolved
14	14	14	2023-08-18	Pending
15	15	15	2023-09-01	Closed
16	16	16	2023-09-15	Resolved
17	17	17	2023-10-02	Pending
18	18	18	2023-10-18	Closed
19	19	19	2023-11-01	Resolved
20	20	20	2023-11-15	Pending
21	21	21	2023-12-01	Closed
22	22	22	2023-12-15	Resolved
23	23	23	2023-12-28	Pending
24	24	24	2024-01-10	Closed
25	25	25	2024-01-25	Resolved
26	26	26	2024-02-10	Pending
27	27	27	2024-02-25	Closed
28	28	28	2024-03-10	Resolved
29	29	29	2024-03-25	Pending
30	30	30	2024-04-10	Closed
31	31	31	2024-04-25	Resolved
32	32	32	2024-05-10	Pending
33	33	33	2024-05-25	Closed
34	34	34	2024-06-10	Resolved
35	35	35	2024-06-25	Pending
36	36	36	2024-07-10	Closed
37	37	37	2024-07-25	Resolved
38	38	38	2024-08-10	Pending
39	39	39	2024-08-25	Closed
40	40	40	2024-09-10	Resolved
41	41	41	2024-09-25	Pending
42	42	42	2024-10-10	Closed
43	43	43	2024-10-25	Resolved
44	44	44	2024-11-10	Pending
45	45	45	2024-11-25	Closed
46	46	46	2024-12-10	Resolved
47	47	47	2024-12-25	Pending
48	48	48	2025-01-10	Closed
49	49	49	2025-01-25	Resolved
50	50	50	2025-02-10	Pending
51	51	51	2025-02-25	Closed
52	52	52	2025-03-10	Resolved
53	53	53	2025-03-25	Pending
54	54	54	2025-04-10	Closed
55	55	55	2025-04-25	Resolved
56	56	56	2025-05-10	Pending
57	57	57	2025-05-25	Closed
58	58	58	2025-06-10	Resolved
59	59	59	2025-06-25	Pending
60	60	60	2025-07-10	Closed
61	61	61	2025-07-25	Resolved
62	62	62	2025-08-10	Pending
63	63	63	2025-08-25	Closed
64	64	64	2025-09-10	Resolved
65	65	65	2025-09-25	Pending
66	66	66	2025-10-10	Closed
67	67	67	2025-10-25	Resolved
68	68	68	2025-11-10	Pending
69	69	69	2025-11-25	Closed
70	70	70	2025-12-10	Resolved
71	71	71	2025-12-25	Pending
72	72	72	2026-01-10	Closed
73	73	73	2026-01-25	Resolved
74	74	74	2026-02-10	Pending
75	75	75	2026-02-25	Closed
76	76	76	2026-03-10	Resolved
77	77	77	2026-03-25	Pending
78	78	78	2026-04-10	Closed
79	79	79	2026-04-25	Resolved
80	80	80	2026-05-10	Pending
81	81	81	2026-05-25	Closed
82	82	82	2026-06-10	Resolved
83	83	83	2026-06-25	Pending
84	84	84	2026-07-10	Closed
85	85	85	2026-07-25	Resolved
86	86	86	2026-08-10	Pending
87	87	87	2026-08-25	Closed
88	88	88	2026-09-10	Resolved
89	89	89	2026-09-25	Pending
90	90	90	2026-10-10	Closed
91	91	91	2026-10-25	Resolved
92	92	92	2026-11-10	Pending
93	93	93	2026-11-25	Closed
94	94	94	2026-12-10	Resolved
95	95	95	2026-12-15	Pending
96	96	96	2026-12-20	Closed
97	97	97	2026-12-22	Resolved
98	98	98	2026-12-25	Pending
99	99	99	2026-12-28	Closed
100	100	100	2026-12-30	Resolved
\.


--
-- Data for Name: deposit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deposit (deposit_id, account_id, currency_id, deposit_date, deposit_amount) FROM stdin;
1	1	1	2023-01-15	50000.00
2	2	2	2023-01-25	1000.00
3	3	3	2023-02-15	1500.00
4	4	4	2023-02-28	2000.00
5	5	5	2023-03-10	75000.00
6	6	6	2023-03-30	300000.00
7	7	7	2023-04-12	250000.00
8	8	8	2023-04-22	80000.00
9	9	9	2023-05-05	1200.00
10	10	10	2023-05-18	5000.00
11	11	11	2023-06-05	9000.00
12	12	12	2023-06-20	7000.00
13	13	13	2023-07-10	600000.00
14	14	14	2023-07-25	4000.00
15	15	15	2023-08-05	3500.00
16	16	16	2023-08-20	2500.00
17	17	17	2023-09-05	450000.00
18	18	18	2023-09-15	300000.00
19	19	19	2023-09-30	10000.00
20	20	20	2023-10-10	15000.00
21	1	1	2023-10-18	25000.00
22	2	2	2023-10-25	800.00
23	5	1	2023-11-02	150000.00
24	7	7	2023-11-15	300000.00
25	3	3	2023-11-28	2500.00
26	10	10	2023-12-10	7000.00
27	15	15	2023-12-22	5000.00
28	22	1	2024-01-09	120000.00
29	23	21	2024-01-18	8500.00
30	24	5	2024-02-02	68000.00
31	25	2	2024-02-16	2500.00
32	26	14	2024-03-01	10000.00
33	27	20	2024-03-15	22000.00
34	28	8	2024-03-28	150000.00
35	29	4	2024-04-11	6000.00
36	30	12	2024-04-25	4500.00
37	31	16	2024-05-08	32000.00
38	32	1	2024-05-20	90000.00
39	33	24	2024-06-05	5200.00
40	34	18	2024-06-19	40000.00
41	35	30	2024-07-02	18000.00
42	36	9	2024-07-16	3500.00
43	37	6	2024-07-30	500000.00
44	38	22	2024-08-12	12500.00
45	39	13	2024-08-25	450000.00
46	40	1	2024-09-10	100000.00
47	41	11	2024-09-24	7200.00
48	42	19	2024-10-08	25000.00
49	43	17	2024-10-21	550000.00
50	44	3	2024-11-06	1800.00
51	45	25	2024-11-18	9500.00
52	46	26	2024-12-02	12000.00
53	47	27	2024-12-17	6000.00
54	48	28	2025-01-07	250000.00
55	49	29	2025-01-20	70000.00
56	50	1	2025-02-03	35000.00
57	51	31	2025-02-18	9000.00
58	52	32	2025-03-02	4800.00
59	53	33	2025-03-16	8200.00
60	54	34	2025-03-30	14000.00
61	55	35	2025-04-12	500000.00
62	56	36	2025-04-28	11000.00
63	57	37	2025-05-13	7500.00
64	58	38	2025-05-29	6500.00
65	59	39	2025-06-14	17000.00
66	60	40	2025-06-27	25000.00
67	61	41	2025-07-12	15000.00
68	62	42	2025-07-28	18000.00
69	63	43	2025-08-11	9800.00
70	64	44	2025-08-26	6200.00
71	65	45	2025-09-09	8500.00
72	66	46	2025-09-23	350000.00
73	67	47	2025-10-08	75000.00
74	68	48	2025-10-22	4200.00
75	69	49	2025-11-05	15000.00
76	70	50	2025-11-19	250000.00
77	71	51	2025-12-03	20000.00
78	72	52	2025-12-18	18000.00
79	73	53	2026-01-08	32000.00
80	74	54	2026-01-22	60000.00
81	75	55	2026-02-05	250000.00
82	76	56	2026-02-19	45000.00
83	77	57	2026-03-05	16000.00
84	78	58	2026-03-19	100000.00
85	79	59	2026-04-02	9500.00
86	80	60	2026-04-16	24000.00
87	81	61	2026-05-01	180000.00
88	82	62	2026-05-15	35000.00
89	83	63	2026-05-29	14000.00
90	84	64	2026-06-12	8000.00
91	85	65	2026-06-26	27000.00
92	86	66	2026-07-10	39000.00
93	87	67	2026-07-24	120000.00
94	88	68	2026-08-07	54000.00
95	89	69	2026-08-21	6300.00
96	90	70	2026-09-04	98000.00
97	91	71	2026-09-18	42000.00
98	92	72	2026-10-02	7600.00
99	93	73	2026-10-16	22000.00
100	94	74	2026-10-30	135000.00
\.


--
-- Data for Name: fixed_deposit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fixed_deposit (fixed_deposit_id, account_id, currency_id, principal_amount, maturity_date) FROM stdin;
1	1	1	500000.00	2024-01-15
2	2	2	2000.00	2024-02-10
3	3	3	3000.00	2024-03-20
4	4	4	5000.00	2024-04-05
5	5	5	800000.00	2024-05-15
6	6	6	1000000.00	2024-06-01
7	7	7	750000.00	2024-06-20
8	8	8	400000.00	2024-07-10
9	9	9	10000.00	2024-07-25
10	10	10	15000.00	2024-08-05
11	11	11	25000.00	2024-08-20
12	12	12	18000.00	2024-09-01
13	13	13	2000000.00	2024-09-15
14	14	14	50000.00	2024-10-01
15	15	15	30000.00	2024-10-15
16	16	16	45000.00	2024-11-01
17	17	17	900000.00	2024-11-15
18	18	18	700000.00	2024-12-01
19	19	19	60000.00	2024-12-15
20	20	20	100000.00	2025-01-05
21	21	21	250000.00	2025-02-15
22	22	22	750000.00	2025-03-01
23	23	23	120000.00	2025-03-20
24	24	24	500000.00	2025-04-05
25	25	25	900000.00	2025-04-20
26	26	26	150000.00	2025-05-05
27	27	27	3000000.00	2025-05-20
28	28	28	450000.00	2025-06-05
29	29	29	80000.00	2025-06-20
30	30	30	600000.00	2025-07-05
31	31	31	1000000.00	2025-07-20
32	32	32	350000.00	2025-08-05
33	33	33	2500000.00	2025-08-20
34	34	34	700000.00	2025-09-05
35	35	35	150000.00	2025-09-20
36	36	36	400000.00	2025-10-05
37	37	37	850000.00	2025-10-20
38	38	38	1200000.00	2025-11-05
39	39	39	550000.00	2025-11-20
40	40	40	2000000.00	2025-12-05
41	41	41	650000.00	2025-12-20
42	42	42	300000.00	2026-01-05
43	43	43	950000.00	2026-01-20
44	44	44	5000000.00	2026-02-05
45	45	45	750000.00	2026-02-20
46	46	46	250000.00	2026-03-05
47	47	47	1800000.00	2026-03-20
48	48	48	600000.00	2026-04-05
49	49	49	100000.00	2026-04-20
50	50	50	4000000.00	2026-05-05
51	51	51	850000.00	2026-05-20
52	52	52	300000.00	2026-06-05
53	53	53	1500000.00	2026-06-20
54	54	54	700000.00	2026-07-05
55	55	55	250000.00	2026-07-20
56	56	56	900000.00	2026-08-05
57	57	57	3500000.00	2026-08-20
58	58	58	500000.00	2026-09-05
59	59	59	200000.00	2026-09-20
60	60	60	6000000.00	2026-10-05
61	61	61	750000.00	2026-10-20
62	62	62	400000.00	2026-11-05
63	63	63	2200000.00	2026-11-20
64	64	64	900000.00	2026-12-05
65	65	65	350000.00	2026-12-20
66	66	66	1800000.00	2027-01-05
67	67	67	700000.00	2027-01-20
68	68	68	3000000.00	2027-02-05
69	69	69	450000.00	2027-02-20
70	70	70	5000000.00	2027-03-05
71	71	71	800000.00	2027-03-20
72	72	72	250000.00	2027-04-05
73	73	73	1200000.00	2027-04-20
74	74	74	600000.00	2027-05-05
75	75	75	3500000.00	2027-05-20
76	76	76	950000.00	2027-06-05
77	77	77	400000.00	2027-06-20
78	78	78	2500000.00	2027-07-05
79	79	79	700000.00	2027-07-20
80	80	80	150000.00	2027-08-05
81	81	81	5000000.00	2027-08-20
82	82	82	850000.00	2027-09-05
83	83	83	300000.00	2027-09-20
84	84	84	2000000.00	2027-10-05
85	85	85	750000.00	2027-10-20
86	86	86	450000.00	2027-11-05
87	87	87	3500000.00	2027-11-20
88	88	88	900000.00	2027-12-05
89	89	89	250000.00	2027-12-20
90	90	90	6000000.00	2028-01-05
91	91	91	800000.00	2028-01-20
92	92	92	500000.00	2028-02-05
93	93	93	2500000.00	2028-02-20
94	94	94	700000.00	2028-03-05
95	95	95	350000.00	2028-03-20
96	96	96	4000000.00	2028-04-05
97	97	97	950000.00	2028-04-20
98	98	98	600000.00	2028-05-05
99	99	99	3000000.00	2028-05-20
100	100	100	1000000.00	2028-06-05
\.


--
-- Data for Name: guarantor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guarantor (guarantor_id, loan_id, guarantor_name, guarantor_phone, guaranteed_amount) FROM stdin;
1	1	Jean Claude Habimana	0781000001	300000.00
2	2	Alice Mukamana	0781000002	1000000.00
3	3	Eric Niyonzima	0781000003	500000.00
4	4	Grace Uwera	0781000004	5000000.00
5	5	Patrick Bizimana	0781000005	2000000.00
6	6	Olivia Ingabire	0781000006	1500000.00
7	7	Samuel Mugisha	0781000007	400000.00
8	8	Hope Uwase	0781000008	250000.00
9	9	David Nkurunziza	0781000009	3000000.00
10	10	Diane Mukeshimana	0781000010	4000000.00
11	11	Kevin Mugabo	0781000011	10000000.00
12	12	Ange Uwera	0781000012	600000.00
13	13	Divine Iradukunda	0781000013	2500000.00
14	14	Emmanuel Muryango	0781000014	1500000.00
15	15	Sandra Uwimana	0781000015	500000.00
16	16	Didier Nshimiyimana	0781000016	1000000.00
17	17	Gloria Uwamahoro	0781000017	1200000.00
18	18	Prince Muhire	0781000018	2500000.00
19	19	Claude Nsengimana	0781000019	15000000.00
20	20	John Mugisha	0781000020	20000000.00
21	21	Michael Hakizimana	0781000021	3500000.00
22	22	Claudine Uwase	0781000022	7000000.00
23	23	Robert Ndayisenga	0781000023	1000000.00
24	24	Esther Mukamana	0781000024	8000000.00
25	25	Samuel Habimana	0781000025	500000.00
26	26	Beatrice Uwamwezi	0781000026	2000000.00
27	27	Alex Niyomugabo	0781000027	6000000.00
28	28	Peace Ingabire	0781000028	3000000.00
29	29	Patrick Nkurunziza	0781000029	900000.00
30	30	Agnes Uwera	0781000030	12000000.00
31	31	Emmanuel Bizimana	0781000031	5000000.00
32	32	Doreen Mukeshimana	0781000032	2500000.00
33	33	Daniel Mugabo	0781000033	7000000.00
34	34	Chantal Uwimana	0781000034	1500000.00
35	35	Fabrice Mugenzi	0781000035	4000000.00
36	36	Alice Uwamahoro	0781000036	10000000.00
37	37	Eric Tuyisenge	0781000037	800000.00
38	38	Grace Nyirabazungu	0781000038	5000000.00
39	39	David Murenzi	0781000039	2000000.00
40	40	Diane Mukamana	0781000040	15000000.00
41	41	Kevin Niyonzima	0781000041	3000000.00
42	42	Olivia Uwamwezi	0781000042	6000000.00
43	43	Prince Habimana	0781000043	1200000.00
44	44	Hope Ingabire	0781000044	9000000.00
45	45	Sandra Mutesi	0781000045	4000000.00
46	46	Claude Uwase	0781000046	700000.00
47	47	Divine Nshimiyimana	0781000047	5000000.00
48	48	Jean Bosco Mugenzi	0781000048	11000000.00
49	49	Ange Mukeshimana	0781000049	2500000.00
50	50	Patrick Niyomugabo	0781000050	8000000.00
51	51	Emelyne Uwera	0781000051	3000000.00
52	52	Moses Bizimana	0781000052	6000000.00
53	53	Yvonne Uwimana	0781000053	1500000.00
54	54	Samuel Nkurunziza	0781000054	20000000.00
55	55	Beatrice Habimana	0781000055	5000000.00
56	56	Alexis Mugisha	0781000056	2500000.00
57	57	Claudine Ingabire	0781000057	7000000.00
58	58	Robert Uwamahoro	0781000058	1200000.00
59	59	Esther Niyonzima	0781000059	4000000.00
60	60	Michael Uwase	0781000060	10000000.00
61	61	Diane Mutesi	0781000061	3500000.00
62	62	Kevin Habimana	0781000062	6000000.00
63	63	Grace Mukamana	0781000063	2000000.00
64	64	David Mugabo	0781000064	9000000.00
65	65	Alice Nshimiyimana	0781000065	5000000.00
66	66	Eric Bizimana	0781000066	13000000.00
67	67	Hope Uwimana	0781000067	3000000.00
68	68	Prince Nkurunziza	0781000068	7000000.00
69	69	Sandra Ingabire	0781000069	1500000.00
70	70	John Uwera	0781000070	18000000.00
71	71	Olivia Mukeshimana	0781000071	4500000.00
72	72	Daniel Habimana	0781000072	8000000.00
73	73	Doreen Mugisha	0781000073	2500000.00
74	74	Fabrice Uwase	0781000074	6000000.00
75	75	Chantal Niyonzima	0781000075	10000000.00
76	76	Emmanuel Nkurunziza	0781000076	3500000.00
77	77	Agnes Bizimana	0781000077	7000000.00
78	78	Michael Uwamahoro	0781000078	2000000.00
79	79	Beatrice Mukamana	0781000079	9000000.00
80	80	Robert Mugisha	0781000080	15000000.00
81	81	Claudine Uwera	0781000081	4000000.00
82	82	Alex Nshimiyimana	0781000082	8000000.00
83	83	Peace Uwimana	0781000083	3000000.00
84	84	Samuel Habimana	0781000084	12000000.00
85	85	Diane Ingabire	0781000085	5000000.00
86	86	Kevin Uwase	0781000086	2500000.00
87	87	Gloria Mukamana	0781000087	7000000.00
88	88	Prince Bizimana	0781000088	10000000.00
89	89	Divine Mugabo	0781000089	3500000.00
90	90	Jean Claude Uwera	0781000090	20000000.00
91	91	Sandra Niyonzima	0781000091	6000000.00
92	92	John Habimana	0781000092	4000000.00
93	93	Hope Mukeshimana	0781000093	9000000.00
94	94	David Uwimana	0781000094	3000000.00
95	95	Olivia Mugisha	0781000095	15000000.00
96	96	Eric Uwamahoro	0781000096	5000000.00
97	97	Grace Bizimana	0781000097	8000000.00
98	98	Patrick Uwase	0781000098	2500000.00
99	99	Alice Niyonzima	0781000099	12000000.00
100	100	Moses Habimana	0781000100	6000000.00
\.


--
-- Data for Name: insurance_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurance_policy (policy_id, customer_id, loan_id, policy_type, premium_amount) FROM stdin;
1	1	1	Loan Protection Insurance	15000.00
2	2	2	Life Insurance	25000.00
3	3	3	Health Insurance	18000.00
4	4	4	Property Insurance	50000.00
5	5	5	Vehicle Insurance	35000.00
6	6	6	Loan Protection Insurance	22000.00
7	7	7	Business Insurance	40000.00
8	8	8	Health Insurance	12000.00
9	9	9	Property Insurance	60000.00
10	10	10	Life Insurance	30000.00
11	11	11	Corporate Insurance	100000.00
12	12	12	Loan Protection Insurance	20000.00
13	13	13	Equipment Insurance	45000.00
14	14	14	Business Insurance	55000.00
15	15	15	Health Insurance	15000.00
16	16	16	Life Insurance	28000.00
17	17	17	Vehicle Insurance	32000.00
18	18	18	Property Insurance	70000.00
19	19	19	Corporate Insurance	120000.00
20	20	20	Loan Protection Insurance	90000.00
21	21	21	Life Insurance	25000.00
22	22	22	Health Insurance	18000.00
23	23	23	Loan Protection Insurance	30000.00
24	24	24	Property Insurance	65000.00
25	25	25	Vehicle Insurance	40000.00
26	26	26	Business Insurance	55000.00
27	27	27	Health Insurance	15000.00
28	28	28	Life Insurance	35000.00
29	29	29	Corporate Insurance	95000.00
30	30	30	Loan Protection Insurance	45000.00
31	31	31	Equipment Insurance	50000.00
32	32	32	Property Insurance	75000.00
33	33	33	Vehicle Insurance	38000.00
34	34	34	Business Insurance	60000.00
35	35	35	Health Insurance	20000.00
36	36	36	Life Insurance	30000.00
37	37	37	Loan Protection Insurance	50000.00
38	38	38	Corporate Insurance	110000.00
39	39	39	Property Insurance	80000.00
40	40	40	Vehicle Insurance	42000.00
41	41	41	Business Insurance	70000.00
42	42	42	Health Insurance	22000.00
43	43	43	Life Insurance	36000.00
44	44	44	Loan Protection Insurance	60000.00
45	45	45	Equipment Insurance	48000.00
46	46	46	Property Insurance	90000.00
47	47	47	Corporate Insurance	130000.00
48	48	48	Vehicle Insurance	45000.00
49	49	49	Business Insurance	75000.00
50	50	50	Health Insurance	25000.00
51	51	51	Life Insurance	40000.00
52	52	52	Loan Protection Insurance	55000.00
53	53	53	Property Insurance	85000.00
54	54	54	Vehicle Insurance	50000.00
55	55	55	Business Insurance	65000.00
56	56	56	Health Insurance	28000.00
57	57	57	Corporate Insurance	150000.00
58	58	58	Equipment Insurance	60000.00
59	59	59	Life Insurance	42000.00
60	60	60	Loan Protection Insurance	70000.00
61	61	61	Property Insurance	95000.00
62	62	62	Vehicle Insurance	52000.00
63	63	63	Business Insurance	80000.00
64	64	64	Health Insurance	30000.00
65	65	65	Life Insurance	45000.00
66	66	66	Loan Protection Insurance	75000.00
67	67	67	Corporate Insurance	160000.00
68	68	68	Equipment Insurance	70000.00
69	69	69	Property Insurance	100000.00
70	70	70	Vehicle Insurance	55000.00
71	71	71	Business Insurance	90000.00
72	72	72	Health Insurance	32000.00
73	73	73	Life Insurance	50000.00
74	74	74	Loan Protection Insurance	80000.00
75	75	75	Property Insurance	120000.00
76	76	76	Vehicle Insurance	60000.00
77	77	77	Business Insurance	95000.00
78	78	78	Health Insurance	35000.00
79	79	79	Corporate Insurance	180000.00
80	80	80	Equipment Insurance	85000.00
81	81	81	Life Insurance	55000.00
82	82	82	Loan Protection Insurance	90000.00
83	83	83	Property Insurance	130000.00
84	84	84	Vehicle Insurance	65000.00
85	85	85	Business Insurance	100000.00
86	86	86	Health Insurance	38000.00
87	87	87	Life Insurance	60000.00
88	88	88	Loan Protection Insurance	95000.00
89	89	89	Corporate Insurance	200000.00
90	90	90	Equipment Insurance	100000.00
91	91	91	Property Insurance	150000.00
92	92	92	Vehicle Insurance	70000.00
93	93	93	Business Insurance	120000.00
94	94	94	Health Insurance	40000.00
95	95	95	Life Insurance	65000.00
96	96	96	Loan Protection Insurance	100000.00
97	97	97	Property Insurance	160000.00
98	98	98	Corporate Insurance	220000.00
99	99	99	Equipment Insurance	110000.00
100	100	100	Loan Protection Insurance	125000.00
\.


--
-- Data for Name: loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan (loan_id, customer_id, loan_type_id, employee_id, loan_amount) FROM stdin;
1	1	1	2	500000.00
2	2	2	3	2500000.00
3	3	3	4	800000.00
4	4	4	5	15000000.00
5	5	5	6	5000000.00
6	6	6	7	3000000.00
7	7	7	8	600000.00
8	8	8	9	400000.00
9	9	9	10	4500000.00
10	10	10	11	7000000.00
11	11	11	12	20000000.00
12	12	12	13	1000000.00
13	13	13	14	6000000.00
14	14	14	15	3500000.00
15	15	15	16	900000.00
16	16	16	17	2000000.00
17	17	17	18	2500000.00
18	18	18	19	5000000.00
19	19	19	20	30000000.00
20	20	20	1	50000000.00
21	21	21	2	3500000.00
22	22	22	3	7500000.00
23	23	23	4	1200000.00
24	24	24	5	15000000.00
25	25	25	6	500000.00
26	26	26	7	2500000.00
27	27	27	8	9000000.00
28	28	28	9	4500000.00
29	29	29	10	800000.00
30	30	30	11	20000000.00
31	31	31	12	6000000.00
32	32	32	13	3000000.00
33	33	33	14	10000000.00
34	34	34	15	1500000.00
35	35	35	16	5000000.00
36	36	36	17	12000000.00
37	37	37	18	700000.00
38	38	38	19	25000000.00
39	39	39	20	4000000.00
40	40	40	1	18000000.00
41	41	41	2	6000000.00
42	42	42	3	3500000.00
43	43	43	4	900000.00
44	44	44	5	22000000.00
45	45	45	6	7500000.00
46	46	46	7	1300000.00
47	47	47	8	5000000.00
48	48	48	9	16000000.00
49	49	49	10	3000000.00
50	50	50	11	10000000.00
51	51	51	12	4500000.00
52	52	52	13	8000000.00
53	53	53	14	2000000.00
54	54	54	15	35000000.00
55	55	55	16	6000000.00
56	56	56	17	2500000.00
57	57	57	18	15000000.00
58	58	58	19	700000.00
59	59	59	20	5000000.00
60	60	60	1	30000000.00
61	61	61	2	4000000.00
62	62	62	3	9000000.00
63	63	63	4	1200000.00
64	64	64	5	18000000.00
65	65	65	6	7500000.00
66	66	66	7	25000000.00
67	67	67	8	3000000.00
68	68	68	9	6000000.00
69	69	69	10	1000000.00
70	70	70	11	14000000.00
71	71	71	12	5500000.00
72	72	72	13	22000000.00
73	73	73	14	800000.00
74	74	74	15	3500000.00
75	75	75	16	17000000.00
76	76	76	17	9000000.00
77	77	77	18	4500000.00
78	78	78	19	28000000.00
79	79	79	20	6500000.00
80	80	80	1	2000000.00
81	81	81	2	11000000.00
82	82	82	3	5000000.00
83	83	83	4	750000.00
84	84	84	5	30000000.00
85	85	85	6	6000000.00
86	86	86	7	15000000.00
87	87	87	8	2500000.00
88	88	88	9	8000000.00
89	89	89	10	45000000.00
90	90	90	11	7000000.00
91	91	91	12	1000000.00
92	92	92	13	25000000.00
93	93	93	14	5500000.00
94	94	94	15	12000000.00
95	95	95	16	3500000.00
96	96	96	17	18000000.00
97	97	97	18	9000000.00
98	98	98	19	4000000.00
99	99	99	20	60000000.00
100	100	100	1	15000000.00
\.


--
-- Data for Name: loan_repayment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_repayment (repayment_id, loan_id, account_id, repayment_date, repayment_amount) FROM stdin;
1	1	1	2023-03-01	15000.00
2	2	2	2023-03-10	50000.00
3	3	3	2023-03-20	25000.00
4	4	4	2023-04-05	100000.00
5	5	5	2023-04-15	75000.00
6	6	6	2023-05-01	60000.00
7	7	7	2023-05-15	20000.00
8	8	8	2023-05-25	18000.00
9	9	9	2023-06-10	90000.00
10	10	10	2023-06-25	120000.00
11	11	11	2023-07-10	200000.00
12	12	12	2023-07-25	40000.00
13	13	13	2023-08-05	150000.00
14	14	14	2023-08-20	80000.00
15	15	15	2023-09-01	30000.00
16	16	16	2023-09-15	50000.00
17	17	17	2023-10-01	70000.00
18	18	18	2023-10-10	110000.00
19	19	19	2023-10-20	250000.00
20	20	20	2023-11-01	300000.00
21	21	21	2023-11-15	45000.00
22	22	22	2023-12-01	80000.00
23	23	23	2023-12-15	35000.00
24	24	24	2024-01-05	120000.00
25	25	25	2024-01-20	60000.00
26	26	26	2024-02-05	25000.00
27	27	27	2024-02-20	150000.00
28	28	28	2024-03-05	90000.00
29	29	29	2024-03-20	45000.00
30	30	30	2024-04-05	200000.00
31	31	31	2024-04-20	75000.00
32	32	32	2024-05-05	50000.00
33	33	33	2024-05-20	180000.00
34	34	34	2024-06-05	65000.00
35	35	35	2024-06-20	100000.00
36	36	36	2024-07-05	250000.00
37	37	37	2024-07-20	30000.00
38	38	38	2024-08-05	140000.00
39	39	39	2024-08-20	55000.00
40	40	40	2024-09-05	200000.00
41	41	41	2024-09-20	85000.00
42	42	42	2024-10-05	45000.00
43	43	43	2024-10-20	130000.00
44	44	44	2024-11-05	70000.00
45	45	45	2024-11-20	250000.00
46	46	46	2024-12-05	90000.00
47	47	47	2024-12-20	40000.00
48	48	48	2025-01-05	160000.00
49	49	49	2025-01-20	60000.00
50	50	50	2025-02-05	300000.00
51	51	51	2025-02-20	75000.00
52	52	52	2025-03-05	110000.00
53	53	53	2025-03-20	50000.00
54	54	54	2025-04-05	220000.00
55	55	55	2025-04-20	80000.00
56	56	56	2025-05-05	45000.00
57	57	57	2025-05-20	150000.00
58	58	58	2025-06-05	95000.00
59	59	59	2025-06-20	60000.00
60	60	60	2025-07-05	350000.00
61	61	61	2025-07-20	70000.00
62	62	62	2025-08-05	120000.00
63	63	63	2025-08-20	55000.00
64	64	64	2025-09-05	200000.00
65	65	65	2025-09-20	85000.00
66	66	66	2025-10-05	40000.00
67	67	67	2025-10-20	170000.00
68	68	68	2025-11-05	75000.00
69	69	69	2025-11-20	260000.00
70	70	70	2025-12-05	100000.00
71	71	71	2025-12-20	50000.00
72	72	72	2026-01-05	180000.00
73	73	73	2026-01-20	65000.00
74	74	74	2026-02-05	250000.00
75	75	75	2026-02-20	90000.00
76	76	76	2026-03-05	45000.00
77	77	77	2026-03-20	130000.00
78	78	78	2026-04-05	70000.00
79	79	79	2026-04-20	300000.00
80	80	80	2026-05-05	95000.00
81	81	81	2026-05-20	55000.00
82	82	82	2026-06-05	200000.00
83	83	83	2026-06-20	85000.00
84	84	84	2026-07-05	40000.00
85	85	85	2026-07-20	150000.00
86	86	86	2026-08-05	60000.00
87	87	87	2026-08-20	250000.00
88	88	88	2026-09-05	100000.00
89	89	89	2026-09-20	50000.00
90	90	90	2026-10-05	180000.00
91	91	91	2026-10-20	70000.00
92	92	92	2026-11-05	300000.00
93	93	93	2026-11-20	95000.00
94	94	94	2026-12-05	45000.00
95	95	95	2026-12-20	160000.00
96	96	96	2027-01-05	80000.00
97	97	97	2027-01-20	220000.00
98	98	98	2027-02-05	65000.00
99	99	99	2027-02-20	350000.00
100	100	100	2027-03-05	120000.00
\.


--
-- Data for Name: loan_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_type (loan_type_id, loan_type_name, interest_rate, maximum_period_months, effective_date) FROM stdin;
1	Personal Loan	12.50	36	2023-01-01
2	Business Loan	10.00	60	2023-01-01
3	Education Loan	8.50	48	2023-01-01
4	Home Loan	9.00	240	2023-01-01
5	Vehicle Loan	11.00	72	2023-01-01
6	Agriculture Loan	7.50	84	2023-01-01
7	Emergency Loan	14.00	24	2023-01-01
8	Salary Advance Loan	13.00	12	2023-01-01
9	SME Loan	10.50	60	2023-01-01
10	Investment Loan	9.50	120	2023-01-01
11	Construction Loan	8.75	180	2023-01-01
12	Medical Loan	12.00	36	2023-01-01
13	Technology Loan	10.25	48	2023-01-01
14	Equipment Loan	11.75	72	2023-01-01
15	Microfinance Loan	15.00	24	2023-01-01
16	Youth Loan	6.50	60	2023-01-01
17	Women Empowerment Loan	7.00	72	2023-01-01
18	Agribusiness Loan	8.25	96	2023-01-01
19	Corporate Loan	9.25	120	2023-01-01
20	Special Development Loan	5.50	180	2023-01-01
21	Green Energy Loan	7.25	120	2023-02-01
22	Solar Panel Loan	6.75	84	2023-02-15
23	Livestock Loan	8.00	60	2023-03-01
24	Poultry Loan	8.50	36	2023-03-18
25	Fishing Loan	8.75	48	2023-04-02
26	Retail Business Loan	10.75	60	2023-04-20
27	Wholesale Loan	10.25	72	2023-05-05
28	Export Loan	9.50	96	2023-05-21
29	Import Finance Loan	9.75	84	2023-06-10
30	Working Capital Loan	10.50	36	2023-06-28
31	Cash Flow Loan	11.00	24	2023-07-14
32	Bridge Loan	12.25	18	2023-07-30
33	Startup Loan	8.75	60	2023-08-15
34	Innovation Loan	8.00	72	2023-09-02
35	Research Loan	7.75	84	2023-09-19
36	School Fees Loan	10.00	24	2023-10-07
37	University Loan	8.25	60	2023-10-25
38	Laptop Loan	9.25	24	2023-11-11
39	Tuition Loan	8.50	48	2023-11-29
40	Professional Loan	9.75	60	2023-12-18
41	Civil Servant Loan	9.00	84	2024-01-08
42	Teacher Loan	8.50	72	2024-01-25
43	Doctor Loan	7.50	120	2024-02-12
44	Engineer Loan	8.25	96	2024-03-01
45	Police Loan	9.25	72	2024-03-19
46	Military Loan	8.75	84	2024-04-05
47	Housing Renovation	9.50	120	2024-04-23
48	Furniture Loan	11.50	36	2024-05-10
49	Appliance Loan	11.25	24	2024-05-28
50	Wedding Loan	12.00	36	2024-06-15
51	Travel Loan	11.75	24	2024-07-03
52	Holiday Loan	12.50	18	2024-07-20
53	Relocation Loan	10.50	48	2024-08-08
54	Rental Deposit Loan	11.00	24	2024-08-26
55	Commercial Vehicle	10.25	84	2024-09-12
56	Motorcycle Loan	11.50	48	2024-10-01
57	Taxi Loan	10.75	60	2024-10-18
58	Bus Purchase Loan	9.50	120	2024-11-06
59	Truck Loan	9.75	120	2024-11-24
60	Fleet Finance Loan	8.75	180	2024-12-12
61	Coffee Farmer Loan	7.25	84	2025-01-02
62	Tea Farmer Loan	7.00	84	2025-01-20
63	Maize Farmer Loan	7.75	48	2025-02-08
64	Rice Farmer Loan	7.50	60	2025-02-26
65	Irrigation Loan	6.75	96	2025-03-15
66	Greenhouse Loan	7.50	72	2025-04-02
67	Farm Equipment Loan	8.25	96	2025-04-20
68	Dairy Farm Loan	7.80	84	2025-05-08
69	Pig Farming Loan	8.40	60	2025-05-26
70	Bee Keeping Loan	7.20	48	2025-06-14
71	Hotel Development	8.90	180	2025-07-02
72	Restaurant Loan	9.80	72	2025-07-20
73	Hospitality Loan	9.20	96	2025-08-08
74	Tourism Loan	8.60	120	2025-08-26
75	Factory Expansion	8.75	180	2025-09-14
76	Manufacturing Loan	9.00	120	2025-10-02
77	Warehouse Loan	8.50	120	2025-10-20
78	Logistics Loan	9.10	96	2025-11-08
79	ICT Business Loan	8.25	84	2025-11-26
80	Software Loan	8.00	72	2025-12-14
81	Clinic Loan	8.75	120	2026-01-03
82	Pharmacy Loan	9.00	72	2026-01-21
83	Dental Practice Loan	8.50	96	2026-02-09
84	Beauty Salon Loan	10.75	48	2026-02-27
85	Fashion Business	10.50	60	2026-03-17
86	Tailoring Loan	9.75	48	2026-04-04
87	Printing Business	9.50	60	2026-04-22
88	Media Business Loan	9.25	72	2026-05-10
89	Cinema Loan	9.75	84	2026-05-28
90	Sports Club Loan	8.90	96	2026-06-16
91	Mining Loan	8.75	180	2026-07-04
92	Water Project Loan	7.25	180	2026-07-22
93	Community Loan	6.75	120	2026-08-09
94	Cooperative Loan	7.00	96	2026-08-27
95	NGO Project Loan	6.50	120	2026-09-15
96	Infrastructure Loan	7.50	240	2026-10-03
97	Municipal Loan	7.25	240	2026-10-21
98	Export Expansion	8.50	120	2026-11-08
99	Import Credit Loan	9.00	84	2026-11-26
100	Strategic Growth	7.75	180	2026-12-15
\.


--
-- Data for Name: mobile_banking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mobile_banking (mobile_banking_id, customer_id, account_id, phone_number, registration_date) FROM stdin;
1	1	1	0782000001	2023-02-05
2	2	2	0782000002	2023-02-15
3	3	3	0782000003	2023-02-25
4	4	4	0782000004	2023-03-10
5	5	5	0782000005	2023-03-20
6	6	6	0782000006	2023-04-05
7	7	7	0782000007	2023-04-18
8	8	8	0782000008	2023-04-30
9	9	9	0782000009	2023-05-12
10	10	10	0782000010	2023-05-28
11	11	11	0782000011	2023-06-12
12	12	12	0782000012	2023-06-28
13	13	13	0782000013	2023-07-12
14	14	14	0782000014	2023-07-28
15	15	15	0782000015	2023-08-12
16	16	16	0782000016	2023-08-28
17	17	17	0782000017	2023-09-12
18	18	18	0782000018	2023-09-28
19	19	19	0782000019	2023-10-12
20	20	20	0782000020	2023-10-28
21	21	21	0782100021	2023-11-10
22	22	22	0782100022	2023-11-25
23	23	23	0782100023	2023-12-10
24	24	24	0782100024	2023-12-25
25	25	25	0782100025	2024-01-10
26	26	26	0782100026	2024-01-25
27	27	27	0782100027	2024-02-10
28	28	28	0782100028	2024-02-25
29	29	29	0782100029	2024-03-10
30	30	30	0782100030	2024-03-25
31	31	31	0782100031	2024-04-10
32	32	32	0782100032	2024-04-25
33	33	33	0782100033	2024-05-10
34	34	34	0782100034	2024-05-25
35	35	35	0782100035	2024-06-10
36	36	36	0782100036	2024-06-25
37	37	37	0782100037	2024-07-10
38	38	38	0782100038	2024-07-25
39	39	39	0782100039	2024-08-10
40	40	40	0782100040	2024-08-25
41	41	41	0782100041	2024-09-10
42	42	42	0782100042	2024-09-25
43	43	43	0782100043	2024-10-10
44	44	44	0782100044	2024-10-25
45	45	45	0782100045	2024-11-10
46	46	46	0782100046	2024-11-25
47	47	47	0782100047	2024-12-10
48	48	48	0782100048	2024-12-25
49	49	49	0782100049	2025-01-10
50	50	50	0782100050	2025-01-25
51	51	51	0782100051	2025-02-10
52	52	52	0782100052	2025-02-25
53	53	53	0782100053	2025-03-10
54	54	54	0782100054	2025-03-25
55	55	55	0782100055	2025-04-10
56	56	56	0782100056	2025-04-25
57	57	57	0782100057	2025-05-10
58	58	58	0782100058	2025-05-25
59	59	59	0782100059	2025-06-10
60	60	60	0782100060	2025-06-25
61	61	61	0782100061	2025-07-10
62	62	62	0782100062	2025-07-25
63	63	63	0782100063	2025-08-10
64	64	64	0782100064	2025-08-25
65	65	65	0782100065	2025-09-10
66	66	66	0782100066	2025-09-25
67	67	67	0782100067	2025-10-10
68	68	68	0782100068	2025-10-25
69	69	69	0782100069	2025-11-10
70	70	70	0782100070	2025-11-25
71	71	71	0782100071	2025-12-10
72	72	72	0782100072	2025-12-25
73	73	73	0782100073	2026-01-10
74	74	74	0782100074	2026-01-25
75	75	75	0782100075	2026-02-10
76	76	76	0782100076	2026-02-25
77	77	77	0782100077	2026-03-10
78	78	78	0782100078	2026-03-25
79	79	79	0782100079	2026-04-10
80	80	80	0782100080	2026-04-25
81	81	81	0782100081	2026-05-10
82	82	82	0782100082	2026-05-25
83	83	83	0782100083	2026-06-10
84	84	84	0782100084	2026-06-25
85	85	85	0782100085	2026-07-10
86	86	86	0782100086	2026-07-25
87	87	87	0782100087	2026-08-10
88	88	88	0782100088	2026-08-25
89	89	89	0782100089	2026-09-10
90	90	90	0782100090	2026-09-25
91	91	91	0782100091	2026-10-10
92	92	92	0782100092	2026-10-25
93	93	93	0782100093	2026-11-10
94	94	94	0782100094	2026-11-25
95	95	95	0782100095	2026-12-05
96	96	96	0782100096	2026-12-10
97	97	97	0782100097	2026-12-15
98	98	98	0782100098	2026-12-20
99	99	99	0782100099	2026-12-25
100	100	100	0782100100	2026-12-30
\.


--
-- Data for Name: withdrawal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.withdrawal (withdrawal_id, account_id, employee_id, withdrawal_date, withdrawal_amount) FROM stdin;
1	1	1	2023-02-01	10000.00
2	2	2	2023-02-10	500.00
3	3	3	2023-02-20	800.00
4	4	4	2023-03-05	15000.00
5	5	5	2023-03-15	25000.00
6	6	6	2023-04-01	100000.00
7	7	7	2023-04-15	50000.00
8	8	8	2023-04-25	12000.00
9	9	9	2023-05-10	700.00
10	10	10	2023-05-25	2000.00
11	11	11	2023-06-10	3000.00
12	12	12	2023-06-25	4500.00
13	13	13	2023-07-15	200000.00
14	14	14	2023-07-30	3500.00
15	15	15	2023-08-10	2500.00
16	16	16	2023-08-25	4000.00
17	17	17	2023-09-10	150000.00
18	18	18	2023-09-20	90000.00
19	19	19	2023-10-01	6000.00
20	20	20	2023-10-15	8000.00
21	21	21	2024-01-05	12000.00
22	22	22	2024-01-15	25000.00
23	23	23	2024-01-25	7500.00
24	24	24	2024-02-05	18000.00
25	25	25	2024-02-15	30000.00
26	26	26	2024-02-25	4500.00
27	27	27	2024-03-05	60000.00
28	28	28	2024-03-15	15000.00
29	29	29	2024-03-25	9000.00
30	30	30	2024-04-05	35000.00
31	31	31	2024-04-15	50000.00
32	32	32	2024-04-25	12000.00
33	33	33	2024-05-05	22000.00
34	34	34	2024-05-15	7000.00
35	35	35	2024-05-25	45000.00
36	36	36	2024-06-05	100000.00
37	37	37	2024-06-15	8000.00
38	38	38	2024-06-25	65000.00
39	39	39	2024-07-05	17000.00
40	40	40	2024-07-15	25000.00
41	41	41	2024-07-25	90000.00
42	42	42	2024-08-05	3500.00
43	43	43	2024-08-15	15000.00
44	44	44	2024-08-25	40000.00
45	45	45	2024-09-05	55000.00
46	46	46	2024-09-15	12000.00
47	47	47	2024-09-25	3000.00
48	48	48	2024-10-05	75000.00
49	49	49	2024-10-15	20000.00
50	50	50	2024-10-25	6000.00
51	51	51	2024-11-05	13000.00
52	52	52	2024-11-15	45000.00
53	53	53	2024-11-25	8500.00
54	54	54	2024-12-05	95000.00
55	55	55	2024-12-15	25000.00
56	56	56	2025-01-05	4000.00
57	57	57	2025-01-15	70000.00
58	58	58	2025-01-25	15000.00
59	59	59	2025-02-05	30000.00
60	60	60	2025-02-15	5000.00
61	61	61	2025-02-25	85000.00
62	62	62	2025-03-05	12000.00
63	63	63	2025-03-15	45000.00
64	64	64	2025-03-25	9000.00
65	65	65	2025-04-05	60000.00
66	66	66	2025-04-15	18000.00
67	67	67	2025-04-25	35000.00
68	68	68	2025-05-05	7500.00
69	69	69	2025-05-15	55000.00
70	70	70	2025-05-25	10000.00
71	71	71	2025-06-05	25000.00
72	72	72	2025-06-15	80000.00
73	73	73	2025-06-25	15000.00
74	74	74	2025-07-05	40000.00
75	75	75	2025-07-15	6500.00
76	76	76	2025-07-25	90000.00
77	77	77	2025-08-05	20000.00
78	78	78	2025-08-15	5000.00
79	79	79	2025-08-25	35000.00
80	80	80	2025-09-05	70000.00
81	81	81	2025-09-15	12000.00
82	82	82	2025-09-25	45000.00
83	83	83	2025-10-05	10000.00
84	84	84	2025-10-15	30000.00
85	85	85	2025-10-25	75000.00
86	86	86	2025-11-05	15000.00
87	87	87	2025-11-15	50000.00
88	88	88	2025-11-25	8000.00
89	89	89	2025-12-05	60000.00
90	90	90	2025-12-15	25000.00
91	91	91	2026-01-05	9000.00
92	92	92	2026-01-15	45000.00
93	93	93	2026-02-05	70000.00
94	94	94	2026-02-15	12000.00
95	95	95	2026-03-05	30000.00
96	96	96	2026-03-15	85000.00
97	97	97	2026-04-05	15000.00
98	98	98	2026-05-05	55000.00
99	99	99	2026-06-05	25000.00
100	100	100	2026-07-05	100000.00
\.


--
-- Name: account_type account_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type
    ADD CONSTRAINT account_type_pkey PRIMARY KEY (account_type_id);


--
-- Name: bank_account bank_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_pkey PRIMARY KEY (account_id);


--
-- Name: bank_branch bank_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_branch
    ADD CONSTRAINT bank_branch_pkey PRIMARY KEY (branch_id);


--
-- Name: bank_card bank_card_card_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_card
    ADD CONSTRAINT bank_card_card_number_key UNIQUE (card_number);


--
-- Name: bank_card bank_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_card
    ADD CONSTRAINT bank_card_pkey PRIMARY KEY (card_id);


--
-- Name: bank_employee bank_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_employee
    ADD CONSTRAINT bank_employee_pkey PRIMARY KEY (employee_id);


--
-- Name: beneficiary beneficiary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiary
    ADD CONSTRAINT beneficiary_pkey PRIMARY KEY (beneficiary_id);


--
-- Name: branch_target branch_target_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_target
    ADD CONSTRAINT branch_target_pkey PRIMARY KEY (target_id);


--
-- Name: collateral collateral_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collateral
    ADD CONSTRAINT collateral_pkey PRIMARY KEY (collateral_id);


--
-- Name: currency currency_currency_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_currency_code_key UNIQUE (currency_code);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (currency_id);


--
-- Name: customer_complaint customer_complaint_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_complaint
    ADD CONSTRAINT customer_complaint_pkey PRIMARY KEY (complaint_id);


--
-- Name: customer customer_national_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_national_id_key UNIQUE (national_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: deposit deposit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_pkey PRIMARY KEY (deposit_id);


--
-- Name: fixed_deposit fixed_deposit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixed_deposit
    ADD CONSTRAINT fixed_deposit_pkey PRIMARY KEY (fixed_deposit_id);


--
-- Name: guarantor guarantor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guarantor
    ADD CONSTRAINT guarantor_pkey PRIMARY KEY (guarantor_id);


--
-- Name: insurance_policy insurance_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_policy
    ADD CONSTRAINT insurance_policy_pkey PRIMARY KEY (policy_id);


--
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (loan_id);


--
-- Name: loan_repayment loan_repayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayment
    ADD CONSTRAINT loan_repayment_pkey PRIMARY KEY (repayment_id);


--
-- Name: loan_type loan_type_loan_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_type
    ADD CONSTRAINT loan_type_loan_type_name_key UNIQUE (loan_type_name);


--
-- Name: loan_type loan_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_type
    ADD CONSTRAINT loan_type_pkey PRIMARY KEY (loan_type_id);


--
-- Name: mobile_banking mobile_banking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_banking
    ADD CONSTRAINT mobile_banking_pkey PRIMARY KEY (mobile_banking_id);


--
-- Name: withdrawal withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_pkey PRIMARY KEY (withdrawal_id);


--
-- Name: bank_account bank_account_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.account_type(account_type_id);


--
-- Name: bank_account bank_account_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.bank_branch(branch_id);


--
-- Name: bank_account bank_account_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: bank_card bank_card_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_card
    ADD CONSTRAINT bank_card_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: beneficiary beneficiary_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiary
    ADD CONSTRAINT beneficiary_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: branch_target branch_target_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_target
    ADD CONSTRAINT branch_target_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.account_type(account_type_id);


--
-- Name: branch_target branch_target_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_target
    ADD CONSTRAINT branch_target_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.bank_branch(branch_id);


--
-- Name: collateral collateral_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collateral
    ADD CONSTRAINT collateral_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(loan_id);


--
-- Name: customer_complaint customer_complaint_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_complaint
    ADD CONSTRAINT customer_complaint_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: customer_complaint customer_complaint_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_complaint
    ADD CONSTRAINT customer_complaint_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.bank_employee(employee_id);


--
-- Name: deposit deposit_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: deposit deposit_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deposit
    ADD CONSTRAINT deposit_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currency(currency_id);


--
-- Name: fixed_deposit fixed_deposit_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixed_deposit
    ADD CONSTRAINT fixed_deposit_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: fixed_deposit fixed_deposit_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fixed_deposit
    ADD CONSTRAINT fixed_deposit_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currency(currency_id);


--
-- Name: guarantor guarantor_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guarantor
    ADD CONSTRAINT guarantor_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(loan_id);


--
-- Name: insurance_policy insurance_policy_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_policy
    ADD CONSTRAINT insurance_policy_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: insurance_policy insurance_policy_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance_policy
    ADD CONSTRAINT insurance_policy_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(loan_id);


--
-- Name: loan loan_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: loan loan_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.bank_employee(employee_id);


--
-- Name: loan loan_loan_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_loan_type_id_fkey FOREIGN KEY (loan_type_id) REFERENCES public.loan_type(loan_type_id);


--
-- Name: loan_repayment loan_repayment_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayment
    ADD CONSTRAINT loan_repayment_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: loan_repayment loan_repayment_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayment
    ADD CONSTRAINT loan_repayment_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(loan_id);


--
-- Name: mobile_banking mobile_banking_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_banking
    ADD CONSTRAINT mobile_banking_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: mobile_banking mobile_banking_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_banking
    ADD CONSTRAINT mobile_banking_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: withdrawal withdrawal_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.bank_account(account_id);


--
-- Name: withdrawal withdrawal_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.bank_employee(employee_id);


--
-- PostgreSQL database dump complete
--

\unrestrict uMuzFYhhxtQ9amKCbhqKnwCENbcREavwvIg0vIaE1xUzJObLwTHkedTV9INcY5h

