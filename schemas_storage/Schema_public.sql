--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_appointment_payments_payment_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_appointment_payments_payment_type AS ENUM (
    'online',
    'cash'
);


ALTER TYPE public.enum_appointment_payments_payment_type OWNER TO postgres;

--
-- Name: enum_bms_promo_codes_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_bms_promo_codes_category AS ENUM (
    'Scans',
    'MHC',
    'HC'
);


ALTER TYPE public.enum_bms_promo_codes_category OWNER TO postgres;

--
-- Name: enum_bms_promo_codes_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_bms_promo_codes_type AS ENUM (
    'Amount',
    'Percentage'
);


ALTER TYPE public.enum_bms_promo_codes_type OWNER TO postgres;

--
-- Name: enum_reward_redeems_redeem_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_reward_redeems_redeem_type AS ENUM (
    'Added',
    'Redeemed'
);


ALTER TYPE public.enum_reward_redeems_redeem_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO postgres;

--
-- Name: account_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_details (
    id integer NOT NULL,
    account_no character varying(255) NOT NULL,
    account_name character varying(255),
    account_type character varying(255) NOT NULL,
    "GST_number" character varying(255),
    "IFSC" character varying(255) NOT NULL,
    account_holder_name character varying(255) NOT NULL,
    bank_name character varying(255) NOT NULL,
    user_guid uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    service_provider_id integer,
    branch character varying(255)
);


ALTER TABLE public.account_details OWNER TO postgres;

--
-- Name: account_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_details_id_seq OWNER TO postgres;

--
-- Name: account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_details_id_seq OWNED BY public.account_details.id;


--
-- Name: account_type_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_type_masters (
    id integer NOT NULL,
    account_type character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.account_type_masters OWNER TO postgres;

--
-- Name: account_type_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_type_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_type_masters_id_seq OWNER TO postgres;

--
-- Name: account_type_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_type_masters_id_seq OWNED BY public.account_type_masters.id;


--
-- Name: address_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address_details (
    id integer NOT NULL,
    address_line_1 character varying(255) NOT NULL,
    address_line_2 character varying(255),
    city integer NOT NULL,
    state integer NOT NULL,
    pincode character varying(255) NOT NULL,
    user_guid uuid,
    is_deleted boolean DEFAULT false,
    is_default boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.address_details OWNER TO postgres;

--
-- Name: address_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.address_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_details_id_seq OWNER TO postgres;

--
-- Name: address_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.address_details_id_seq OWNED BY public.address_details.id;


--
-- Name: agent_auto_assign_backlogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_auto_assign_backlogs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    appointment_id integer NOT NULL,
    appointment_created_date character varying(255) NOT NULL,
    city_id integer NOT NULL,
    appointment_type character varying(255) NOT NULL,
    assigned_to integer NOT NULL,
    assigned_status boolean NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.agent_auto_assign_backlogs OWNER TO postgres;

--
-- Name: agent_auto_assign_backlogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_auto_assign_backlogs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_auto_assign_backlogs_id_seq OWNER TO postgres;

--
-- Name: agent_auto_assign_backlogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_auto_assign_backlogs_id_seq OWNED BY public.agent_auto_assign_backlogs.id;


--
-- Name: agent_auto_assign_daily_limits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_auto_assign_daily_limits (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    today_assigned integer NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.agent_auto_assign_daily_limits OWNER TO postgres;

--
-- Name: agent_auto_assign_daily_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_auto_assign_daily_limits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_auto_assign_daily_limits_id_seq OWNER TO postgres;

--
-- Name: agent_auto_assign_daily_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_auto_assign_daily_limits_id_seq OWNED BY public.agent_auto_assign_daily_limits.id;


--
-- Name: agent_booking_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_booking_mappings (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    status boolean DEFAULT true,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    appointment_id integer,
    "appointmentType" character varying(255)
);


ALTER TABLE public.agent_booking_mappings OWNER TO postgres;

--
-- Name: agent_booking_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_booking_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_booking_mappings_id_seq OWNER TO postgres;

--
-- Name: agent_booking_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_booking_mappings_id_seq OWNED BY public.agent_booking_mappings.id;


--
-- Name: agent_city_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_city_preferences (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    city_id integer NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    is_deleted boolean DEFAULT false
);


ALTER TABLE public.agent_city_preferences OWNER TO postgres;

--
-- Name: agent_city_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_city_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_city_preferences_id_seq OWNER TO postgres;

--
-- Name: agent_city_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_city_preferences_id_seq OWNED BY public.agent_city_preferences.id;


--
-- Name: agent_login_status_trackings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_login_status_trackings (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    login_status boolean NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.agent_login_status_trackings OWNER TO postgres;

--
-- Name: agent_login_status_trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_login_status_trackings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_login_status_trackings_id_seq OWNER TO postgres;

--
-- Name: agent_login_status_trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_login_status_trackings_id_seq OWNED BY public.agent_login_status_trackings.id;


--
-- Name: agent_role_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_role_mappings (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    role_id integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.agent_role_mappings OWNER TO postgres;

--
-- Name: agent_role_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_role_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_role_mappings_id_seq OWNER TO postgres;

--
-- Name: agent_role_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_role_mappings_id_seq OWNED BY public.agent_role_mappings.id;


--
-- Name: agent_role_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent_role_masters (
    id integer NOT NULL,
    department_id integer,
    role_name character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.agent_role_masters OWNER TO postgres;

--
-- Name: agent_role_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agent_role_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_role_masters_id_seq OWNER TO postgres;

--
-- Name: agent_role_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agent_role_masters_id_seq OWNED BY public.agent_role_masters.id;


--
-- Name: agents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agents (
    id integer NOT NULL,
    user_id integer,
    agent_id character varying(255),
    first_name character varying(255),
    login_id character varying(255),
    phone character varying(255) NOT NULL,
    password character varying(255),
    is_active boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    role character varying(255),
    is_logged_in boolean DEFAULT false,
    daily_limit integer,
    is_agent boolean DEFAULT true,
    extension_id character varying(255)
);


ALTER TABLE public.agents OWNER TO postgres;

--
-- Name: agents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.agents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agents_id_seq OWNER TO postgres;

--
-- Name: agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.agents_id_seq OWNED BY public.agents.id;


--
-- Name: appointment_center_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_center_details (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    center_id integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.appointment_center_details OWNER TO postgres;

--
-- Name: appointment_center_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_center_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_center_details_id_seq OWNER TO postgres;

--
-- Name: appointment_center_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_center_details_id_seq OWNED BY public.appointment_center_details.id;


--
-- Name: appointment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_details (
    id integer NOT NULL,
    user_id integer NOT NULL,
    appointment_date timestamp with time zone,
    scan_name character varying(255),
    scan_category character varying(255),
    test_name character varying(255),
    test_category character varying(255),
    city_id integer,
    center_id integer,
    amount character varying(255),
    report character varying(255),
    test_scan_id uuid,
    prescription character varying(255),
    scan_description text,
    booking_for_others boolean DEFAULT false,
    full_name character varying(255),
    "createdBy" integer NOT NULL,
    is_deleted boolean DEFAULT false,
    appointment_status character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    age character varying(255),
    coupon_code character varying(255),
    response_time character varying(255),
    scan_id integer,
    le_owner integer,
    center_scan_price_id integer,
    "agentId" integer DEFAULT '-1'::integer,
    source character varying(255) DEFAULT 'website'::character varying,
    payment_status character varying(255) DEFAULT 'To be Collected'::character varying,
    comments text,
    otp_status character varying(255) DEFAULT '-'::character varying,
    category character varying(255) DEFAULT '-'::character varying,
    pincode character varying(255) DEFAULT '-'::character varying,
    invoice_url character varying(255),
    discount character varying(255) DEFAULT '0'::character varying,
    discount_applied boolean DEFAULT false
);


ALTER TABLE public.appointment_details OWNER TO postgres;

--
-- Name: appointment_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_details_id_seq OWNER TO postgres;

--
-- Name: appointment_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_details_id_seq OWNED BY public.appointment_details.id;


--
-- Name: appointment_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_payments (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    payment_guid uuid NOT NULL,
    payment_type public.enum_appointment_payments_payment_type DEFAULT 'online'::public.enum_appointment_payments_payment_type NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.appointment_payments OWNER TO postgres;

--
-- Name: appointment_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_payments_id_seq OWNER TO postgres;

--
-- Name: appointment_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_payments_id_seq OWNED BY public.appointment_payments.id;


--
-- Name: appointment_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment_reports (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    report_url character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    scan_name character varying(255),
    "appointmentType" character varying(255) DEFAULT 'scans'::character varying
);


ALTER TABLE public.appointment_reports OWNER TO postgres;

--
-- Name: appointment_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_reports_id_seq OWNER TO postgres;

--
-- Name: appointment_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_reports_id_seq OWNED BY public.appointment_reports.id;


--
-- Name: blog_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_categories (
    id integer NOT NULL,
    blog_category character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.blog_categories OWNER TO postgres;

--
-- Name: blog_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blog_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blog_categories_id_seq OWNER TO postgres;

--
-- Name: blog_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blog_categories_id_seq OWNED BY public.blog_categories.id;


--
-- Name: blogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blogs (
    id integer NOT NULL,
    blog_img character varying(255) NOT NULL,
    blog_title character varying(255) NOT NULL,
    blog_author_name character varying(255) NOT NULL,
    blog_category character varying(255) NOT NULL,
    blog_content character varying(255) NOT NULL,
    blog_author_avatar character varying(255) NOT NULL,
    blog_author_title character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.blogs OWNER TO postgres;

--
-- Name: blogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blogs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blogs_id_seq OWNER TO postgres;

--
-- Name: blogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blogs_id_seq OWNED BY public.blogs.id;


--
-- Name: bms_promo_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bms_promo_codes (
    id integer NOT NULL,
    unique_code character varying(255),
    price_value character varying(255),
    type public.enum_bms_promo_codes_type,
    category integer,
    expiry_time timestamp with time zone,
    usage_limit character varying(255),
    promo_code_used character varying(255),
    company_id integer,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.bms_promo_codes OWNER TO postgres;

--
-- Name: bms_promo_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bms_promo_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bms_promo_codes_id_seq OWNER TO postgres;

--
-- Name: bms_promo_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bms_promo_codes_id_seq OWNED BY public.bms_promo_codes.id;


--
-- Name: booking_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_payments (
    id uuid NOT NULL,
    booking_id integer NOT NULL,
    transaction_guid uuid,
    status character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "appointmentType" character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    is_reward_redeemed boolean DEFAULT false,
    promo_code_price_value character varying(255),
    is_promo_code_used boolean DEFAULT false,
    reward_redeems_id integer,
    user_promo_code_limit_id integer,
    promo_code_id integer,
    is_manually_collected boolean DEFAULT false,
    is_expired boolean DEFAULT false
);


ALTER TABLE public.booking_payments OWNER TO postgres;

--
-- Name: cart_bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_bookings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer,
    agent_id integer,
    payment_status character varying(255) DEFAULT 'To be collected'::character varying,
    booking_status character varying(255),
    amount character varying(255) DEFAULT '0'::character varying,
    comments text,
    lead_owner integer,
    response_time character varying(255),
    test_date timestamp with time zone,
    scan_date character varying(255),
    booking_name character varying(255),
    booking_user_id integer,
    cart_status boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    patient_number character varying(255),
    coupon_code character varying(255),
    description text,
    category text,
    source character varying(255),
    sample_collection_method character varying(255),
    discount character varying(255) DEFAULT '0'::character varying,
    discount_applied boolean DEFAULT false
);


ALTER TABLE public.cart_bookings OWNER TO postgres;

--
-- Name: cart_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_bookings_id_seq OWNER TO postgres;

--
-- Name: cart_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_bookings_id_seq OWNED BY public.cart_bookings.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    item_id integer NOT NULL,
    item_type integer NOT NULL,
    is_deleted boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_items_id_seq OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    user_id integer,
    cart_status boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carts_id_seq OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: channel_partner_commissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel_partner_commissions (
    id integer NOT NULL,
    commission_percentage integer NOT NULL,
    channel_partner_id integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.channel_partner_commissions OWNER TO postgres;

--
-- Name: channel_partner_commissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channel_partner_commissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_partner_commissions_id_seq OWNER TO postgres;

--
-- Name: channel_partner_commissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_partner_commissions_id_seq OWNED BY public.channel_partner_commissions.id;


--
-- Name: channel_partner_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel_partner_details (
    id integer NOT NULL,
    user_id integer,
    full_name character varying(255) NOT NULL,
    business_name character varying(255),
    city_id integer,
    verified boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.channel_partner_details OWNER TO postgres;

--
-- Name: channel_partner_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channel_partner_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_partner_details_id_seq OWNER TO postgres;

--
-- Name: channel_partner_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_partner_details_id_seq OWNED BY public.channel_partner_details.id;


--
-- Name: channel_partner_incentives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel_partner_incentives (
    id integer NOT NULL,
    channel_partner_id integer NOT NULL,
    appointment_id integer NOT NULL,
    incentive_amount character varying(255) NOT NULL,
    settlement_id integer NOT NULL,
    settlement_status integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.channel_partner_incentives OWNER TO postgres;

--
-- Name: channel_partner_incentives_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channel_partner_incentives_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_partner_incentives_id_seq OWNER TO postgres;

--
-- Name: channel_partner_incentives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_partner_incentives_id_seq OWNED BY public.channel_partner_incentives.id;


--
-- Name: channel_partner_settlements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel_partner_settlements (
    id integer NOT NULL,
    settlement_amount character varying(255) NOT NULL,
    settlement_status character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.channel_partner_settlements OWNER TO postgres;

--
-- Name: channel_partner_settlements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channel_partner_settlements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_partner_settlements_id_seq OWNER TO postgres;

--
-- Name: channel_partner_settlements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_partner_settlements_id_seq OWNED BY public.channel_partner_settlements.id;


--
-- Name: city_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city_masters (
    id integer NOT NULL,
    state_id integer NOT NULL,
    city_name character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    to_show boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.city_masters OWNER TO postgres;

--
-- Name: city_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_masters_id_seq OWNER TO postgres;

--
-- Name: city_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_masters_id_seq OWNED BY public.city_masters.id;


--
-- Name: company_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_details (
    id integer NOT NULL,
    company_name character varying(255),
    company_email character varying(255),
    overall_discount character varying(255),
    is_validated character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    otp character varying(255)
);


ALTER TABLE public.company_details OWNER TO postgres;

--
-- Name: company_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_details_id_seq OWNER TO postgres;

--
-- Name: company_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_details_id_seq OWNED BY public.company_details.id;


--
-- Name: corporate_otp_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corporate_otp_histories (
    id integer NOT NULL,
    corporate_user_id integer,
    otp_type character varying(255),
    otp character varying(255),
    otp_expiry_time timestamp with time zone DEFAULT (CURRENT_TIMESTAMP + '00:05:00'::interval),
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.corporate_otp_histories OWNER TO postgres;

--
-- Name: corporate_otp_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corporate_otp_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corporate_otp_histories_id_seq OWNER TO postgres;

--
-- Name: corporate_otp_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corporate_otp_histories_id_seq OWNED BY public.corporate_otp_histories.id;


--
-- Name: corporate_packages_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corporate_packages_mappings (
    id integer NOT NULL,
    company_id integer,
    package_id integer,
    mrp_price character varying(255),
    offer_price character varying(255),
    discount_percentage character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.corporate_packages_mappings OWNER TO postgres;

--
-- Name: corporate_packages_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corporate_packages_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corporate_packages_mappings_id_seq OWNER TO postgres;

--
-- Name: corporate_packages_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corporate_packages_mappings_id_seq OWNED BY public.corporate_packages_mappings.id;


--
-- Name: corporate_user_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corporate_user_details (
    id integer NOT NULL,
    user_id integer,
    first_name character varying(255),
    last_name character varying(255),
    email_id character varying(255),
    employee_id character varying(255),
    company_id integer,
    is_blocked boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    is_verified boolean DEFAULT false
);


ALTER TABLE public.corporate_user_details OWNER TO postgres;

--
-- Name: corporate_user_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corporate_user_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corporate_user_details_id_seq OWNER TO postgres;

--
-- Name: corporate_user_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corporate_user_details_id_seq OWNED BY public.corporate_user_details.id;


--
-- Name: customer_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_details (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_name character varying(255),
    state_id character varying(255),
    verified boolean DEFAULT false,
    pincode character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.customer_details OWNER TO postgres;

--
-- Name: customer_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_details_id_seq OWNER TO postgres;

--
-- Name: customer_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_details_id_seq OWNED BY public.customer_details.id;


--
-- Name: customer_savings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_savings (
    id integer NOT NULL,
    user_id integer,
    reference_id integer,
    scan_type integer,
    offer_amount numeric,
    "mrpAmount" numeric,
    saving_amount numeric,
    is_deleted boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.customer_savings OWNER TO postgres;

--
-- Name: customer_savings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_savings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_savings_id_seq OWNER TO postgres;

--
-- Name: customer_savings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_savings_id_seq OWNED BY public.customer_savings.id;


--
-- Name: doctor_appointment_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_appointment_mappings (
    id integer NOT NULL,
    appointment_id integer,
    appointment_type integer,
    created_by integer,
    user_id integer,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.doctor_appointment_mappings OWNER TO postgres;

--
-- Name: doctor_appointment_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_appointment_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_appointment_mappings_id_seq OWNER TO postgres;

--
-- Name: doctor_appointment_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_appointment_mappings_id_seq OWNED BY public.doctor_appointment_mappings.id;


--
-- Name: doctor_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_details (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    doctor_guid uuid,
    doctor_phone character varying(255) DEFAULT 'unique'::character varying,
    doctor_email character varying(255),
    doctor_age character varying(255),
    doctor_gender character varying(255),
    role_id integer,
    avatar character varying(255),
    clinic_name character varying(255),
    experience text,
    educational_qualification character varying(255),
    awards_and_acheivements text,
    field_of_speciality text,
    verified boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.doctor_details OWNER TO postgres;

--
-- Name: doctor_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_details_id_seq OWNER TO postgres;

--
-- Name: doctor_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_details_id_seq OWNED BY public.doctor_details.id;


--
-- Name: doctor_otp_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor_otp_histories (
    id integer NOT NULL,
    doctor_id integer,
    otp character varying(255),
    otp_expiring_time timestamp with time zone DEFAULT (CURRENT_TIMESTAMP + '00:05:00'::interval),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.doctor_otp_histories OWNER TO postgres;

--
-- Name: doctor_otp_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctor_otp_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.doctor_otp_histories_id_seq OWNER TO postgres;

--
-- Name: doctor_otp_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctor_otp_histories_id_seq OWNED BY public.doctor_otp_histories.id;


--
-- Name: frequently_asked_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frequently_asked_questions (
    id integer NOT NULL,
    headers character varying(255),
    faq character varying(255),
    answers text,
    scan_category_id integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    city_id integer DEFAULT '-1'::integer
);


ALTER TABLE public.frequently_asked_questions OWNER TO postgres;

--
-- Name: frequently_asked_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.frequently_asked_questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.frequently_asked_questions_id_seq OWNER TO postgres;

--
-- Name: frequently_asked_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.frequently_asked_questions_id_seq OWNED BY public.frequently_asked_questions.id;


--
-- Name: health_checkup_individual_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_checkup_individual_tests (
    id integer NOT NULL,
    individual_test_name character varying(255),
    service_provider_center_id integer,
    city_id integer,
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.health_checkup_individual_tests OWNER TO postgres;

--
-- Name: health_checkup_individual_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_checkup_individual_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_checkup_individual_tests_id_seq OWNER TO postgres;

--
-- Name: health_checkup_individual_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_checkup_individual_tests_id_seq OWNED BY public.health_checkup_individual_tests.id;


--
-- Name: health_checkup_optional_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_checkup_optional_tests (
    id integer NOT NULL,
    optional_test_name character varying(255),
    optional_subtest character varying(255)[],
    package_id integer,
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    gender character varying(255),
    male boolean DEFAULT false,
    female boolean DEFAULT false,
    others boolean DEFAULT false
);


ALTER TABLE public.health_checkup_optional_tests OWNER TO postgres;

--
-- Name: health_checkup_optional_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_checkup_optional_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_checkup_optional_tests_id_seq OWNER TO postgres;

--
-- Name: health_checkup_optional_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_checkup_optional_tests_id_seq OWNED BY public.health_checkup_optional_tests.id;


--
-- Name: health_checkup_package_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_checkup_package_masters (
    id integer NOT NULL,
    service_provider_center_id integer,
    city_id integer,
    pkg_category_id integer,
    package_name character varying(255),
    scans_offered character varying(255)[],
    test_details json,
    doctor_consultation boolean DEFAULT false,
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    booked_count character varying(255),
    discount_percentage character varying(255),
    is_corporate boolean
);


ALTER TABLE public.health_checkup_package_masters OWNER TO postgres;

--
-- Name: health_checkup_package_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_checkup_package_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_checkup_package_masters_id_seq OWNER TO postgres;

--
-- Name: health_checkup_package_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_checkup_package_masters_id_seq OWNED BY public.health_checkup_package_masters.id;


--
-- Name: health_checkup_test_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_checkup_test_categories (
    id integer NOT NULL,
    test_category_name character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    discount_percentage integer
);


ALTER TABLE public.health_checkup_test_categories OWNER TO postgres;

--
-- Name: health_checkup_test_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_checkup_test_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_checkup_test_categories_id_seq OWNER TO postgres;

--
-- Name: health_checkup_test_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_checkup_test_categories_id_seq OWNED BY public.health_checkup_test_categories.id;


--
-- Name: health_checkup_test_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_checkup_test_masters (
    id integer NOT NULL,
    hc_test_name character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.health_checkup_test_masters OWNER TO postgres;

--
-- Name: health_checkup_test_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_checkup_test_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_checkup_test_masters_id_seq OWNER TO postgres;

--
-- Name: health_checkup_test_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_checkup_test_masters_id_seq OWNED BY public.health_checkup_test_masters.id;


--
-- Name: healthcheckup_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_categories (
    id integer NOT NULL,
    test_category_name character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_categories OWNER TO postgres;

--
-- Name: healthcheckup_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_categories_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_categories_id_seq OWNED BY public.healthcheckup_categories.id;


--
-- Name: healthcheckup_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_packages (
    id integer NOT NULL,
    service_provider_id integer,
    test_category_id integer,
    package_name character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_packages OWNER TO postgres;

--
-- Name: healthcheckup_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_packages_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_packages_id_seq OWNED BY public.healthcheckup_packages.id;


--
-- Name: healthcheckup_packages_test_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_packages_test_mappings (
    id integer NOT NULL,
    package_id integer,
    packages_test_category_id integer,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_packages_test_mappings OWNER TO postgres;

--
-- Name: healthcheckup_packages_test_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_packages_test_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_packages_test_mappings_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_packages_test_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_packages_test_mappings_id_seq OWNED BY public.healthcheckup_packages_test_mappings.id;


--
-- Name: healthcheckup_packages_test_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_packages_test_masters (
    id integer NOT NULL,
    packages_test_category_name character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_packages_test_masters OWNER TO postgres;

--
-- Name: healthcheckup_packages_test_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_packages_test_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_packages_test_masters_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_packages_test_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_packages_test_masters_id_seq OWNED BY public.healthcheckup_packages_test_masters.id;


--
-- Name: healthcheckup_test_parameters_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_test_parameters_mappings (
    id integer NOT NULL,
    package_id integer,
    test_mapping_id integer,
    packages_test_category_id integer,
    packages_sub_test_id integer,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_test_parameters_mappings OWNER TO postgres;

--
-- Name: healthcheckup_test_parameters_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_test_parameters_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_test_parameters_mappings_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_test_parameters_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_test_parameters_mappings_id_seq OWNED BY public.healthcheckup_test_parameters_mappings.id;


--
-- Name: healthcheckup_test_parameters_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcheckup_test_parameters_masters (
    id integer NOT NULL,
    packages_sub_test_name character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.healthcheckup_test_parameters_masters OWNER TO postgres;

--
-- Name: healthcheckup_test_parameters_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.healthcheckup_test_parameters_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.healthcheckup_test_parameters_masters_id_seq OWNER TO postgres;

--
-- Name: healthcheckup_test_parameters_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.healthcheckup_test_parameters_masters_id_seq OWNED BY public.healthcheckup_test_parameters_masters.id;


--
-- Name: india_top_lab_dynamic_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.india_top_lab_dynamic_details (
    id integer NOT NULL,
    service_provider_id integer,
    sp_description character varying(255) NOT NULL,
    usp_brand_1 character varying(255),
    usp_brand_2 character varying(255),
    usp_brand_3 character varying(255),
    rating character varying(255),
    customer_count character varying(255),
    discount_percentage character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.india_top_lab_dynamic_details OWNER TO postgres;

--
-- Name: india_top_lab_dynamic_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.india_top_lab_dynamic_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.india_top_lab_dynamic_details_id_seq OWNER TO postgres;

--
-- Name: india_top_lab_dynamic_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.india_top_lab_dynamic_details_id_seq OWNED BY public.india_top_lab_dynamic_details.id;


--
-- Name: india_top_lab_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.india_top_lab_mappings (
    id integer NOT NULL,
    service_provider_id integer,
    city_id integer,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.india_top_lab_mappings OWNER TO postgres;

--
-- Name: india_top_lab_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.india_top_lab_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.india_top_lab_mappings_id_seq OWNER TO postgres;

--
-- Name: india_top_lab_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.india_top_lab_mappings_id_seq OWNED BY public.india_top_lab_mappings.id;


--
-- Name: indias_top_labs_package_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.indias_top_labs_package_details (
    id integer NOT NULL,
    service_provider_id integer NOT NULL,
    package_id integer NOT NULL,
    banner_image_url character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.indias_top_labs_package_details OWNER TO postgres;

--
-- Name: indias_top_labs_package_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.indias_top_labs_package_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.indias_top_labs_package_details_id_seq OWNER TO postgres;

--
-- Name: indias_top_labs_package_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.indias_top_labs_package_details_id_seq OWNED BY public.indias_top_labs_package_details.id;


--
-- Name: individual_blood_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_blood_tests (
    id integer NOT NULL,
    center_id integer NOT NULL,
    city_id integer NOT NULL,
    test_name character varying(255) NOT NULL,
    mrp_price character varying(255) NOT NULL,
    offer_price character varying(255) NOT NULL,
    b2b_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    home_sample_collection boolean DEFAULT false,
    also_known_as_names character varying(255)[]
);


ALTER TABLE public.individual_blood_tests OWNER TO postgres;

--
-- Name: individual_blood_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.individual_blood_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_blood_tests_id_seq OWNER TO postgres;

--
-- Name: individual_blood_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.individual_blood_tests_id_seq OWNED BY public.individual_blood_tests.id;


--
-- Name: invoice_appointment_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_appointment_mappings (
    id integer NOT NULL,
    invoice_id integer,
    appointment_id integer,
    invoice_status character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    appointment_type character varying(255)
);


ALTER TABLE public.invoice_appointment_mappings OWNER TO postgres;

--
-- Name: invoice_appointment_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoice_appointment_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_appointment_mappings_id_seq OWNER TO postgres;

--
-- Name: invoice_appointment_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_appointment_mappings_id_seq OWNED BY public.invoice_appointment_mappings.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    service_provider_id integer,
    invoice_number character varying(255),
    invoice_date timestamp with time zone,
    due_date timestamp with time zone,
    taxes character varying(255),
    invoice_type character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    invoice_pdf character varying(255),
    appointment_type character varying(255),
    total_amount character varying(255)
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoices_id_seq OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: master_health_checkup_bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_health_checkup_bookings (
    id integer NOT NULL,
    user_id integer,
    sample_collection_date character varying(255),
    city_id integer,
    amount character varying(255),
    scan_date character varying(255),
    center_id integer,
    address_id integer,
    booking_status character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    appointment_id integer,
    le_owner integer,
    description character varying(255),
    coupon_code character varying(255),
    response_time character varying(255),
    "agentId" integer DEFAULT '-1'::integer,
    payment_status character varying(255) DEFAULT 'To be Collected'::character varying,
    comments text,
    type character varying(255) DEFAULT 'master'::character varying,
    source character varying(255) DEFAULT 'website'::character varying,
    otp_status character varying(255) DEFAULT '-'::character varying,
    category character varying(255) DEFAULT '-'::character varying,
    company_id integer,
    invoice_url character varying(255),
    discount character varying(255) DEFAULT '0'::character varying,
    discount_applied boolean DEFAULT false
);


ALTER TABLE public.master_health_checkup_bookings OWNER TO postgres;

--
-- Name: master_health_checkup_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_health_checkup_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_health_checkup_bookings_id_seq OWNER TO postgres;

--
-- Name: master_health_checkup_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_health_checkup_bookings_id_seq OWNED BY public.master_health_checkup_bookings.id;


--
-- Name: master_health_checkup_member_optional_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_health_checkup_member_optional_tests (
    id integer NOT NULL,
    member_id integer,
    optional_test_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    type character varying(255) DEFAULT 'master'::character varying
);


ALTER TABLE public.master_health_checkup_member_optional_tests OWNER TO postgres;

--
-- Name: master_health_checkup_member_optional_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_health_checkup_member_optional_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_health_checkup_member_optional_tests_id_seq OWNER TO postgres;

--
-- Name: master_health_checkup_member_optional_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_health_checkup_member_optional_tests_id_seq OWNED BY public.master_health_checkup_member_optional_tests.id;


--
-- Name: master_health_checkup_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_health_checkup_members (
    id integer NOT NULL,
    master_health_checkup_book_id integer,
    member_name character varying(255),
    member_age character varying(255),
    member_gender character varying(255),
    package_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    type character varying(255) DEFAULT 'master'::character varying
);


ALTER TABLE public.master_health_checkup_members OWNER TO postgres;

--
-- Name: master_health_checkup_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_health_checkup_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_health_checkup_members_id_seq OWNER TO postgres;

--
-- Name: master_health_checkup_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_health_checkup_members_id_seq OWNED BY public.master_health_checkup_members.id;


--
-- Name: master_health_package_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.master_health_package_masters (
    id integer NOT NULL,
    package_details json NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    pkg_name character varying(255),
    actual_price character varying(255),
    bms_price character varying(255)
);


ALTER TABLE public.master_health_package_masters OWNER TO postgres;

--
-- Name: master_health_package_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.master_health_package_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.master_health_package_masters_id_seq OWNER TO postgres;

--
-- Name: master_health_package_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.master_health_package_masters_id_seq OWNED BY public.master_health_package_masters.id;


--
-- Name: optional_test_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.optional_test_categories (
    id integer NOT NULL,
    optional_test_category_name character varying(255),
    optional_test_category_price character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.optional_test_categories OWNER TO postgres;

--
-- Name: optional_test_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.optional_test_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.optional_test_categories_id_seq OWNER TO postgres;

--
-- Name: optional_test_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.optional_test_categories_id_seq OWNED BY public.optional_test_categories.id;


--
-- Name: optional_test_subcategories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.optional_test_subcategories (
    id integer NOT NULL,
    optional_test_subcategory_name character varying(255),
    optional_test_category_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.optional_test_subcategories OWNER TO postgres;

--
-- Name: optional_test_subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.optional_test_subcategories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.optional_test_subcategories_id_seq OWNER TO postgres;

--
-- Name: optional_test_subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.optional_test_subcategories_id_seq OWNED BY public.optional_test_subcategories.id;


--
-- Name: other_scans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.other_scans (
    id integer NOT NULL,
    category_id integer NOT NULL,
    center_id integer NOT NULL,
    city_id integer NOT NULL,
    scan_name character varying(255) NOT NULL,
    mrp_price character varying(255) NOT NULL,
    offer_price character varying(255) NOT NULL,
    b2b_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.other_scans OWNER TO postgres;

--
-- Name: other_scans_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.other_scans_categories (
    id integer NOT NULL,
    category_name character varying(255) NOT NULL,
    mrp_price character varying(255) NOT NULL,
    offer_price character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.other_scans_categories OWNER TO postgres;

--
-- Name: other_scans_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.other_scans_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.other_scans_categories_id_seq OWNER TO postgres;

--
-- Name: other_scans_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.other_scans_categories_id_seq OWNED BY public.other_scans_categories.id;


--
-- Name: other_scans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.other_scans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.other_scans_id_seq OWNER TO postgres;

--
-- Name: other_scans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.other_scans_id_seq OWNED BY public.other_scans.id;


--
-- Name: otp_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_histories (
    id integer NOT NULL,
    user_id integer,
    otp character varying(255),
    otp_expiring_time timestamp with time zone DEFAULT (CURRENT_TIMESTAMP + '00:05:00'::interval),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.otp_histories OWNER TO postgres;

--
-- Name: otp_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otp_histories_id_seq OWNER TO postgres;

--
-- Name: otp_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_histories_id_seq OWNED BY public.otp_histories.id;


--
-- Name: packageS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."packageS" (
    id integer NOT NULL,
    service_provider_id integer,
    package_name character varying(255),
    package_details character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public."packageS" OWNER TO postgres;

--
-- Name: packageS_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."packageS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."packageS_id_seq" OWNER TO postgres;

--
-- Name: packageS_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."packageS_id_seq" OWNED BY public."packageS".id;


--
-- Name: package_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package_tests (
    id integer NOT NULL,
    package_test_name character varying(255),
    test_id integer,
    package_id integer,
    service_provider_id integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.package_tests OWNER TO postgres;

--
-- Name: package_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_tests_id_seq OWNER TO postgres;

--
-- Name: package_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_tests_id_seq OWNED BY public.package_tests.id;


--
-- Name: payment_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_details (
    id integer NOT NULL,
    payment_guid uuid,
    payment_txn_id integer NOT NULL,
    payment_details json NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.payment_details OWNER TO postgres;

--
-- Name: payment_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_details_id_seq OWNER TO postgres;

--
-- Name: payment_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_details_id_seq OWNED BY public.payment_details.id;


--
-- Name: payment_transaction_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_transaction_details (
    id integer NOT NULL,
    transaction_guid uuid,
    payment_data json NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.payment_transaction_details OWNER TO postgres;

--
-- Name: payment_transaction_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_transaction_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_transaction_details_id_seq OWNER TO postgres;

--
-- Name: payment_transaction_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_transaction_details_id_seq OWNED BY public.payment_transaction_details.id;


--
-- Name: promo_code_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promo_code_histories (
    id integer NOT NULL,
    user_id integer NOT NULL,
    booking_id integer NOT NULL,
    booking_type character varying(255) NOT NULL,
    promo_code_used character varying(255) NOT NULL,
    amount_before_promo_code double precision NOT NULL,
    amount_after_promo_code double precision NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    promo_code_claimed integer
);


ALTER TABLE public.promo_code_histories OWNER TO postgres;

--
-- Name: promo_code_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promo_code_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promo_code_histories_id_seq OWNER TO postgres;

--
-- Name: promo_code_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promo_code_histories_id_seq OWNED BY public.promo_code_histories.id;


--
-- Name: reward_redeem_histories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward_redeem_histories (
    id integer NOT NULL,
    user_id integer NOT NULL,
    booking_id integer NOT NULL,
    booking_type character varying(255) DEFAULT 'scans'::character varying NOT NULL,
    redeemed_reward_count integer NOT NULL,
    amount_before_redeem double precision NOT NULL,
    amount_after_redeem double precision NOT NULL,
    is_reward_redeemed boolean DEFAULT false NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.reward_redeem_histories OWNER TO postgres;

--
-- Name: reward_redeem_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reward_redeem_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reward_redeem_histories_id_seq OWNER TO postgres;

--
-- Name: reward_redeem_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reward_redeem_histories_id_seq OWNED BY public.reward_redeem_histories.id;


--
-- Name: reward_redeems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reward_redeems (
    id integer NOT NULL,
    user_id integer,
    reference_id integer,
    scan_type integer,
    rewards_point integer,
    redeem_type public.enum_reward_redeems_redeem_type,
    reward_status boolean,
    is_deleted boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    reward_claimed integer,
    reward_time_estimation timestamp with time zone DEFAULT (CURRENT_TIMESTAMP + '00:05:00'::interval)
);


ALTER TABLE public.reward_redeems OWNER TO postgres;

--
-- Name: reward_redeems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reward_redeems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reward_redeems_id_seq OWNER TO postgres;

--
-- Name: reward_redeems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reward_redeems_id_seq OWNED BY public.reward_redeems.id;


--
-- Name: role_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_masters (
    id integer NOT NULL,
    role character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.role_masters OWNER TO postgres;

--
-- Name: role_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_masters_id_seq OWNER TO postgres;

--
-- Name: role_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_masters_id_seq OWNED BY public.role_masters.id;


--
-- Name: scan_category_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_category_masters (
    id integer NOT NULL,
    scan_category_name character varying(255) NOT NULL,
    scan_price character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.scan_category_masters OWNER TO postgres;

--
-- Name: scan_category_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_category_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_category_masters_id_seq OWNER TO postgres;

--
-- Name: scan_category_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_category_masters_id_seq OWNED BY public.scan_category_masters.id;


--
-- Name: scan_category_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_category_prices (
    id integer NOT NULL,
    scan_category_id integer NOT NULL,
    scan_price character varying(255),
    city_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    striked_price_1 character varying(255),
    striked_price_2 character varying(255)
);


ALTER TABLE public.scan_category_prices OWNER TO postgres;

--
-- Name: scan_category_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_category_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_category_prices_id_seq OWNER TO postgres;

--
-- Name: scan_category_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_category_prices_id_seq OWNED BY public.scan_category_prices.id;


--
-- Name: scan_headings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_headings (
    id integer NOT NULL,
    heading text,
    scan_category_id integer,
    city_id integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.scan_headings OWNER TO postgres;

--
-- Name: scan_headings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_headings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_headings_id_seq OWNER TO postgres;

--
-- Name: scan_headings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_headings_id_seq OWNED BY public.scan_headings.id;


--
-- Name: scan_informations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_informations (
    id integer NOT NULL,
    heading_id integer,
    scan_category_id integer,
    city_id integer,
    title text,
    sub_title text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.scan_informations OWNER TO postgres;

--
-- Name: scan_informations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_informations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_informations_id_seq OWNER TO postgres;

--
-- Name: scan_informations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_informations_id_seq OWNED BY public.scan_informations.id;


--
-- Name: scan_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_masters (
    id integer NOT NULL,
    scan_category_id integer NOT NULL,
    scan_name character varying(255) NOT NULL,
    is_upper boolean,
    scan_guid uuid,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.scan_masters OWNER TO postgres;

--
-- Name: scan_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_masters_id_seq OWNER TO postgres;

--
-- Name: scan_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_masters_id_seq OWNED BY public.scan_masters.id;


--
-- Name: scan_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_prices (
    id integer NOT NULL,
    scan_id integer NOT NULL,
    city_id integer NOT NULL,
    scan_price character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.scan_prices OWNER TO postgres;

--
-- Name: scan_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_prices_id_seq OWNER TO postgres;

--
-- Name: scan_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_prices_id_seq OWNED BY public.scan_prices.id;


--
-- Name: scan_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_tests (
    id integer NOT NULL,
    name character varying(255),
    center_id integer,
    mrp_price character varying(255),
    offer_price character varying(255),
    scan_id integer,
    service_provider_id integer,
    is_deleted boolean,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    b2b_price character varying(255) DEFAULT '100'::character varying
);


ALTER TABLE public.scan_tests OWNER TO postgres;

--
-- Name: scan_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scan_tests_id_seq OWNER TO postgres;

--
-- Name: scan_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_tests_id_seq OWNED BY public.scan_tests.id;


--
-- Name: service_provider_center_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_provider_center_details (
    id integer NOT NULL,
    center_name character varying(255) NOT NULL,
    service_provider_id integer NOT NULL,
    center_city_id integer NOT NULL,
    center_location character varying(255),
    contact_person character varying(255),
    contact_number character varying(255),
    center_address text,
    center_guid uuid,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    otp character varying(255),
    role_id character varying(255) DEFAULT 7
);


ALTER TABLE public.service_provider_center_details OWNER TO postgres;

--
-- Name: service_provider_center_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_provider_center_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_provider_center_details_id_seq OWNER TO postgres;

--
-- Name: service_provider_center_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_provider_center_details_id_seq OWNED BY public.service_provider_center_details.id;


--
-- Name: service_provider_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_provider_details (
    id integer NOT NULL,
    service_provider_name character varying(255),
    bms_rep_name character varying(255),
    email character varying(255),
    otp character varying(255),
    role_id character varying(255) DEFAULT 6,
    mobile_number character varying(255),
    verified boolean DEFAULT false,
    incentive character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    finance_number character varying(255),
    finance_email character varying(255),
    sp_logo character varying(255)
);


ALTER TABLE public.service_provider_details OWNER TO postgres;

--
-- Name: service_provider_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_provider_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_provider_details_id_seq OWNER TO postgres;

--
-- Name: service_provider_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_provider_details_id_seq OWNED BY public.service_provider_details.id;


--
-- Name: service_provider_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_provider_services (
    id integer NOT NULL,
    scan_id integer NOT NULL,
    center_id integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.service_provider_services OWNER TO postgres;

--
-- Name: service_provider_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_provider_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_provider_services_id_seq OWNER TO postgres;

--
-- Name: service_provider_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_provider_services_id_seq OWNED BY public.service_provider_services.id;


--
-- Name: service_test_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_test_category (
    id integer NOT NULL,
    service_provider_id integer,
    test_id integer,
    is_deleted boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.service_test_category OWNER TO postgres;

--
-- Name: service_test_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_test_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_test_category_id_seq OWNER TO postgres;

--
-- Name: service_test_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_test_category_id_seq OWNED BY public.service_test_category.id;


--
-- Name: state_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state_masters (
    id integer NOT NULL,
    state_name character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.state_masters OWNER TO postgres;

--
-- Name: state_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.state_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.state_masters_id_seq OWNER TO postgres;

--
-- Name: state_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.state_masters_id_seq OWNED BY public.state_masters.id;


--
-- Name: status_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_masters (
    id integer NOT NULL,
    status_name character varying(255),
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.status_masters OWNER TO postgres;

--
-- Name: status_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_masters_id_seq OWNER TO postgres;

--
-- Name: status_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_masters_id_seq OWNED BY public.status_masters.id;


--
-- Name: test_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_category (
    id integer NOT NULL,
    test_category_name character varying(255),
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.test_category OWNER TO postgres;

--
-- Name: test_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_category_id_seq OWNER TO postgres;

--
-- Name: test_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_category_id_seq OWNED BY public.test_category.id;


--
-- Name: test_category_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_category_masters (
    id integer NOT NULL,
    test_category_name character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.test_category_masters OWNER TO postgres;

--
-- Name: test_category_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_category_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_category_masters_id_seq OWNER TO postgres;

--
-- Name: test_category_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_category_masters_id_seq OWNED BY public.test_category_masters.id;


--
-- Name: test_masters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_masters (
    id integer NOT NULL,
    test_category_id integer NOT NULL,
    test_name character varying(255) NOT NULL,
    test_guid uuid,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.test_masters OWNER TO postgres;

--
-- Name: test_masters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_masters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_masters_id_seq OWNER TO postgres;

--
-- Name: test_masters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_masters_id_seq OWNED BY public.test_masters.id;


--
-- Name: test_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_prices (
    id integer NOT NULL,
    test_id integer NOT NULL,
    city_id integer NOT NULL,
    test_price character varying(255) NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.test_prices OWNER TO postgres;

--
-- Name: test_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_prices_id_seq OWNER TO postgres;

--
-- Name: test_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_prices_id_seq OWNED BY public.test_prices.id;


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testimonials (
    id integer NOT NULL,
    cname character varying(255),
    cmobile character varying(255),
    cemail character varying(255),
    city character varying(255),
    cmessage text,
    scan_type character varying(255),
    status integer,
    created_at timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.testimonials OWNER TO postgres;

--
-- Name: testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.testimonials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.testimonials_id_seq OWNER TO postgres;

--
-- Name: testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.testimonials_id_seq OWNED BY public.testimonials.id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    id integer NOT NULL,
    test_name character varying(255),
    test_category_id integer,
    mrp_price character varying(255),
    offer_price character varying(255),
    is_deleted boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_id_seq OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- Name: update_history_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.update_history_mappings (
    id integer NOT NULL,
    updated_by integer,
    updated_time timestamp with time zone NOT NULL,
    coupon_code character varying(255),
    customer_name character varying(255),
    appointment_status character varying(255),
    comments text,
    appointment_id integer,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    summary json,
    "appointmentType" character varying(255)
);


ALTER TABLE public.update_history_mappings OWNER TO postgres;

--
-- Name: update_history_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.update_history_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.update_history_mappings_id_seq OWNER TO postgres;

--
-- Name: update_history_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.update_history_mappings_id_seq OWNED BY public.update_history_mappings.id;


--
-- Name: user_promo_code_limits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_promo_code_limits (
    id integer NOT NULL,
    user_id integer NOT NULL,
    usage_limit character varying(255),
    promo_code_used character varying(255),
    promocode_time_estimation timestamp with time zone,
    price_value character varying(255),
    promo_code_claimed character varying(255),
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.user_promo_code_limits OWNER TO postgres;

--
-- Name: user_promo_code_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_promo_code_limits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_promo_code_limits_id_seq OWNER TO postgres;

--
-- Name: user_promo_code_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_promo_code_limits_id_seq OWNED BY public.user_promo_code_limits.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_guid uuid,
    is_blocked boolean DEFAULT false,
    role_id integer,
    user_mobile character varying(255) NOT NULL,
    user_email character varying(255),
    email_verified boolean DEFAULT false,
    is_deleted boolean DEFAULT false,
    password character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: youtube_urls_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.youtube_urls_details (
    id integer NOT NULL,
    category character varying(255) NOT NULL,
    youtube_url character varying(255) NOT NULL,
    priority integer NOT NULL,
    is_deleted boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.youtube_urls_details OWNER TO postgres;

--
-- Name: youtube_urls_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.youtube_urls_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.youtube_urls_details_id_seq OWNER TO postgres;

--
-- Name: youtube_urls_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.youtube_urls_details_id_seq OWNED BY public.youtube_urls_details.id;


--
-- Name: account_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details ALTER COLUMN id SET DEFAULT nextval('public.account_details_id_seq'::regclass);


--
-- Name: account_type_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type_masters ALTER COLUMN id SET DEFAULT nextval('public.account_type_masters_id_seq'::regclass);


--
-- Name: address_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address_details ALTER COLUMN id SET DEFAULT nextval('public.address_details_id_seq'::regclass);


--
-- Name: agent_auto_assign_backlogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_auto_assign_backlogs ALTER COLUMN id SET DEFAULT nextval('public.agent_auto_assign_backlogs_id_seq'::regclass);


--
-- Name: agent_auto_assign_daily_limits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_auto_assign_daily_limits ALTER COLUMN id SET DEFAULT nextval('public.agent_auto_assign_daily_limits_id_seq'::regclass);


--
-- Name: agent_booking_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_booking_mappings ALTER COLUMN id SET DEFAULT nextval('public.agent_booking_mappings_id_seq'::regclass);


--
-- Name: agent_city_preferences id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_city_preferences ALTER COLUMN id SET DEFAULT nextval('public.agent_city_preferences_id_seq'::regclass);


--
-- Name: agent_login_status_trackings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_login_status_trackings ALTER COLUMN id SET DEFAULT nextval('public.agent_login_status_trackings_id_seq'::regclass);


--
-- Name: agent_role_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_role_mappings ALTER COLUMN id SET DEFAULT nextval('public.agent_role_mappings_id_seq'::regclass);


--
-- Name: agent_role_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_role_masters ALTER COLUMN id SET DEFAULT nextval('public.agent_role_masters_id_seq'::regclass);


--
-- Name: agents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agents ALTER COLUMN id SET DEFAULT nextval('public.agents_id_seq'::regclass);


--
-- Name: appointment_center_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_center_details ALTER COLUMN id SET DEFAULT nextval('public.appointment_center_details_id_seq'::regclass);


--
-- Name: appointment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_details ALTER COLUMN id SET DEFAULT nextval('public.appointment_details_id_seq'::regclass);


--
-- Name: appointment_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_payments ALTER COLUMN id SET DEFAULT nextval('public.appointment_payments_id_seq'::regclass);


--
-- Name: appointment_reports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_reports ALTER COLUMN id SET DEFAULT nextval('public.appointment_reports_id_seq'::regclass);


--
-- Name: blog_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories ALTER COLUMN id SET DEFAULT nextval('public.blog_categories_id_seq'::regclass);


--
-- Name: blogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blogs ALTER COLUMN id SET DEFAULT nextval('public.blogs_id_seq'::regclass);


--
-- Name: bms_promo_codes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bms_promo_codes ALTER COLUMN id SET DEFAULT nextval('public.bms_promo_codes_id_seq'::regclass);


--
-- Name: cart_bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_bookings ALTER COLUMN id SET DEFAULT nextval('public.cart_bookings_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: channel_partner_commissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_commissions ALTER COLUMN id SET DEFAULT nextval('public.channel_partner_commissions_id_seq'::regclass);


--
-- Name: channel_partner_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_details ALTER COLUMN id SET DEFAULT nextval('public.channel_partner_details_id_seq'::regclass);


--
-- Name: channel_partner_incentives id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_incentives ALTER COLUMN id SET DEFAULT nextval('public.channel_partner_incentives_id_seq'::regclass);


--
-- Name: channel_partner_settlements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_settlements ALTER COLUMN id SET DEFAULT nextval('public.channel_partner_settlements_id_seq'::regclass);


--
-- Name: city_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_masters ALTER COLUMN id SET DEFAULT nextval('public.city_masters_id_seq'::regclass);


--
-- Name: company_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_details ALTER COLUMN id SET DEFAULT nextval('public.company_details_id_seq'::regclass);


--
-- Name: corporate_otp_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_otp_histories ALTER COLUMN id SET DEFAULT nextval('public.corporate_otp_histories_id_seq'::regclass);


--
-- Name: corporate_packages_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_packages_mappings ALTER COLUMN id SET DEFAULT nextval('public.corporate_packages_mappings_id_seq'::regclass);


--
-- Name: corporate_user_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_user_details ALTER COLUMN id SET DEFAULT nextval('public.corporate_user_details_id_seq'::regclass);


--
-- Name: customer_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_details ALTER COLUMN id SET DEFAULT nextval('public.customer_details_id_seq'::regclass);


--
-- Name: customer_savings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_savings ALTER COLUMN id SET DEFAULT nextval('public.customer_savings_id_seq'::regclass);


--
-- Name: doctor_appointment_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_appointment_mappings ALTER COLUMN id SET DEFAULT nextval('public.doctor_appointment_mappings_id_seq'::regclass);


--
-- Name: doctor_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_details ALTER COLUMN id SET DEFAULT nextval('public.doctor_details_id_seq'::regclass);


--
-- Name: doctor_otp_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_otp_histories ALTER COLUMN id SET DEFAULT nextval('public.doctor_otp_histories_id_seq'::regclass);


--
-- Name: frequently_asked_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frequently_asked_questions ALTER COLUMN id SET DEFAULT nextval('public.frequently_asked_questions_id_seq'::regclass);


--
-- Name: health_checkup_individual_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_individual_tests ALTER COLUMN id SET DEFAULT nextval('public.health_checkup_individual_tests_id_seq'::regclass);


--
-- Name: health_checkup_optional_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_optional_tests ALTER COLUMN id SET DEFAULT nextval('public.health_checkup_optional_tests_id_seq'::regclass);


--
-- Name: health_checkup_package_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_package_masters ALTER COLUMN id SET DEFAULT nextval('public.health_checkup_package_masters_id_seq'::regclass);


--
-- Name: health_checkup_test_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_test_categories ALTER COLUMN id SET DEFAULT nextval('public.health_checkup_test_categories_id_seq'::regclass);


--
-- Name: health_checkup_test_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_test_masters ALTER COLUMN id SET DEFAULT nextval('public.health_checkup_test_masters_id_seq'::regclass);


--
-- Name: healthcheckup_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_categories ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_categories_id_seq'::regclass);


--
-- Name: healthcheckup_packages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_packages_id_seq'::regclass);


--
-- Name: healthcheckup_packages_test_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages_test_mappings ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_packages_test_mappings_id_seq'::regclass);


--
-- Name: healthcheckup_packages_test_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages_test_masters ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_packages_test_masters_id_seq'::regclass);


--
-- Name: healthcheckup_test_parameters_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_test_parameters_mappings ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_test_parameters_mappings_id_seq'::regclass);


--
-- Name: healthcheckup_test_parameters_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_test_parameters_masters ALTER COLUMN id SET DEFAULT nextval('public.healthcheckup_test_parameters_masters_id_seq'::regclass);


--
-- Name: india_top_lab_dynamic_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.india_top_lab_dynamic_details ALTER COLUMN id SET DEFAULT nextval('public.india_top_lab_dynamic_details_id_seq'::regclass);


--
-- Name: india_top_lab_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.india_top_lab_mappings ALTER COLUMN id SET DEFAULT nextval('public.india_top_lab_mappings_id_seq'::regclass);


--
-- Name: indias_top_labs_package_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indias_top_labs_package_details ALTER COLUMN id SET DEFAULT nextval('public.indias_top_labs_package_details_id_seq'::regclass);


--
-- Name: individual_blood_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_blood_tests ALTER COLUMN id SET DEFAULT nextval('public.individual_blood_tests_id_seq'::regclass);


--
-- Name: invoice_appointment_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_appointment_mappings ALTER COLUMN id SET DEFAULT nextval('public.invoice_appointment_mappings_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: master_health_checkup_bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_bookings ALTER COLUMN id SET DEFAULT nextval('public.master_health_checkup_bookings_id_seq'::regclass);


--
-- Name: master_health_checkup_member_optional_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_member_optional_tests ALTER COLUMN id SET DEFAULT nextval('public.master_health_checkup_member_optional_tests_id_seq'::regclass);


--
-- Name: master_health_checkup_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_members ALTER COLUMN id SET DEFAULT nextval('public.master_health_checkup_members_id_seq'::regclass);


--
-- Name: master_health_package_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_package_masters ALTER COLUMN id SET DEFAULT nextval('public.master_health_package_masters_id_seq'::regclass);


--
-- Name: optional_test_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.optional_test_categories ALTER COLUMN id SET DEFAULT nextval('public.optional_test_categories_id_seq'::regclass);


--
-- Name: optional_test_subcategories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.optional_test_subcategories ALTER COLUMN id SET DEFAULT nextval('public.optional_test_subcategories_id_seq'::regclass);


--
-- Name: other_scans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_scans ALTER COLUMN id SET DEFAULT nextval('public.other_scans_id_seq'::regclass);


--
-- Name: other_scans_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_scans_categories ALTER COLUMN id SET DEFAULT nextval('public.other_scans_categories_id_seq'::regclass);


--
-- Name: otp_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_histories ALTER COLUMN id SET DEFAULT nextval('public.otp_histories_id_seq'::regclass);


--
-- Name: packageS id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."packageS" ALTER COLUMN id SET DEFAULT nextval('public."packageS_id_seq"'::regclass);


--
-- Name: package_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_tests ALTER COLUMN id SET DEFAULT nextval('public.package_tests_id_seq'::regclass);


--
-- Name: payment_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details ALTER COLUMN id SET DEFAULT nextval('public.payment_details_id_seq'::regclass);


--
-- Name: payment_transaction_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transaction_details ALTER COLUMN id SET DEFAULT nextval('public.payment_transaction_details_id_seq'::regclass);


--
-- Name: promo_code_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_code_histories ALTER COLUMN id SET DEFAULT nextval('public.promo_code_histories_id_seq'::regclass);


--
-- Name: reward_redeem_histories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_redeem_histories ALTER COLUMN id SET DEFAULT nextval('public.reward_redeem_histories_id_seq'::regclass);


--
-- Name: reward_redeems id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_redeems ALTER COLUMN id SET DEFAULT nextval('public.reward_redeems_id_seq'::regclass);


--
-- Name: role_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_masters ALTER COLUMN id SET DEFAULT nextval('public.role_masters_id_seq'::regclass);


--
-- Name: scan_category_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_category_masters ALTER COLUMN id SET DEFAULT nextval('public.scan_category_masters_id_seq'::regclass);


--
-- Name: scan_category_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_category_prices ALTER COLUMN id SET DEFAULT nextval('public.scan_category_prices_id_seq'::regclass);


--
-- Name: scan_headings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_headings ALTER COLUMN id SET DEFAULT nextval('public.scan_headings_id_seq'::regclass);


--
-- Name: scan_informations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_informations ALTER COLUMN id SET DEFAULT nextval('public.scan_informations_id_seq'::regclass);


--
-- Name: scan_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_masters ALTER COLUMN id SET DEFAULT nextval('public.scan_masters_id_seq'::regclass);


--
-- Name: scan_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_prices ALTER COLUMN id SET DEFAULT nextval('public.scan_prices_id_seq'::regclass);


--
-- Name: scan_tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_tests ALTER COLUMN id SET DEFAULT nextval('public.scan_tests_id_seq'::regclass);


--
-- Name: service_provider_center_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_center_details ALTER COLUMN id SET DEFAULT nextval('public.service_provider_center_details_id_seq'::regclass);


--
-- Name: service_provider_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_details ALTER COLUMN id SET DEFAULT nextval('public.service_provider_details_id_seq'::regclass);


--
-- Name: service_provider_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_services ALTER COLUMN id SET DEFAULT nextval('public.service_provider_services_id_seq'::regclass);


--
-- Name: service_test_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_test_category ALTER COLUMN id SET DEFAULT nextval('public.service_test_category_id_seq'::regclass);


--
-- Name: state_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state_masters ALTER COLUMN id SET DEFAULT nextval('public.state_masters_id_seq'::regclass);


--
-- Name: status_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_masters ALTER COLUMN id SET DEFAULT nextval('public.status_masters_id_seq'::regclass);


--
-- Name: test_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_category ALTER COLUMN id SET DEFAULT nextval('public.test_category_id_seq'::regclass);


--
-- Name: test_category_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_category_masters ALTER COLUMN id SET DEFAULT nextval('public.test_category_masters_id_seq'::regclass);


--
-- Name: test_masters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_masters ALTER COLUMN id SET DEFAULT nextval('public.test_masters_id_seq'::regclass);


--
-- Name: test_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_prices ALTER COLUMN id SET DEFAULT nextval('public.test_prices_id_seq'::regclass);


--
-- Name: testimonials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testimonials ALTER COLUMN id SET DEFAULT nextval('public.testimonials_id_seq'::regclass);


--
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- Name: update_history_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.update_history_mappings ALTER COLUMN id SET DEFAULT nextval('public.update_history_mappings_id_seq'::regclass);


--
-- Name: user_promo_code_limits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_promo_code_limits ALTER COLUMN id SET DEFAULT nextval('public.user_promo_code_limits_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: youtube_urls_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.youtube_urls_details ALTER COLUMN id SET DEFAULT nextval('public.youtube_urls_details_id_seq'::regclass);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (id);


--
-- Name: account_type_masters account_type_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_type_masters
    ADD CONSTRAINT account_type_masters_pkey PRIMARY KEY (id);


--
-- Name: address_details address_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address_details
    ADD CONSTRAINT address_details_pkey PRIMARY KEY (id);


--
-- Name: agent_auto_assign_backlogs agent_auto_assign_backlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_auto_assign_backlogs
    ADD CONSTRAINT agent_auto_assign_backlogs_pkey PRIMARY KEY (id);


--
-- Name: agent_auto_assign_daily_limits agent_auto_assign_daily_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_auto_assign_daily_limits
    ADD CONSTRAINT agent_auto_assign_daily_limits_pkey PRIMARY KEY (id);


--
-- Name: agent_booking_mappings agent_booking_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_booking_mappings
    ADD CONSTRAINT agent_booking_mappings_pkey PRIMARY KEY (id);


--
-- Name: agent_city_preferences agent_city_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_city_preferences
    ADD CONSTRAINT agent_city_preferences_pkey PRIMARY KEY (id);


--
-- Name: agent_login_status_trackings agent_login_status_trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_login_status_trackings
    ADD CONSTRAINT agent_login_status_trackings_pkey PRIMARY KEY (id);


--
-- Name: agent_role_mappings agent_role_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_role_mappings
    ADD CONSTRAINT agent_role_mappings_pkey PRIMARY KEY (id);


--
-- Name: agent_role_masters agent_role_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent_role_masters
    ADD CONSTRAINT agent_role_masters_pkey PRIMARY KEY (id);


--
-- Name: agents agents_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_phone_key UNIQUE (phone);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: appointment_center_details appointment_center_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_center_details
    ADD CONSTRAINT appointment_center_details_pkey PRIMARY KEY (id);


--
-- Name: appointment_details appointment_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_details
    ADD CONSTRAINT appointment_details_pkey PRIMARY KEY (id);


--
-- Name: appointment_payments appointment_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_payments
    ADD CONSTRAINT appointment_payments_pkey PRIMARY KEY (id);


--
-- Name: appointment_reports appointment_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment_reports
    ADD CONSTRAINT appointment_reports_pkey PRIMARY KEY (id);


--
-- Name: blog_categories blog_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: bms_promo_codes bms_promo_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bms_promo_codes
    ADD CONSTRAINT bms_promo_codes_pkey PRIMARY KEY (id);


--
-- Name: booking_payments booking_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_payments
    ADD CONSTRAINT booking_payments_pkey PRIMARY KEY (id);


--
-- Name: cart_bookings cart_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_bookings
    ADD CONSTRAINT cart_bookings_pkey PRIMARY KEY (id);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: channel_partner_commissions channel_partner_commissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_commissions
    ADD CONSTRAINT channel_partner_commissions_pkey PRIMARY KEY (id);


--
-- Name: channel_partner_details channel_partner_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_details
    ADD CONSTRAINT channel_partner_details_pkey PRIMARY KEY (id);


--
-- Name: channel_partner_incentives channel_partner_incentives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_incentives
    ADD CONSTRAINT channel_partner_incentives_pkey PRIMARY KEY (id);


--
-- Name: channel_partner_settlements channel_partner_settlements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel_partner_settlements
    ADD CONSTRAINT channel_partner_settlements_pkey PRIMARY KEY (id);


--
-- Name: city_masters city_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_masters
    ADD CONSTRAINT city_masters_pkey PRIMARY KEY (id);


--
-- Name: company_details company_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_details
    ADD CONSTRAINT company_details_pkey PRIMARY KEY (id);


--
-- Name: corporate_otp_histories corporate_otp_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_otp_histories
    ADD CONSTRAINT corporate_otp_histories_pkey PRIMARY KEY (id);


--
-- Name: corporate_packages_mappings corporate_packages_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_packages_mappings
    ADD CONSTRAINT corporate_packages_mappings_pkey PRIMARY KEY (id);


--
-- Name: corporate_user_details corporate_user_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_user_details
    ADD CONSTRAINT corporate_user_details_pkey PRIMARY KEY (id);


--
-- Name: customer_details customer_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_details
    ADD CONSTRAINT customer_details_pkey PRIMARY KEY (id);


--
-- Name: customer_savings customer_savings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_savings
    ADD CONSTRAINT customer_savings_pkey PRIMARY KEY (id);


--
-- Name: doctor_appointment_mappings doctor_appointment_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_appointment_mappings
    ADD CONSTRAINT doctor_appointment_mappings_pkey PRIMARY KEY (id);


--
-- Name: doctor_details doctor_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_details
    ADD CONSTRAINT doctor_details_pkey PRIMARY KEY (id);


--
-- Name: doctor_otp_histories doctor_otp_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor_otp_histories
    ADD CONSTRAINT doctor_otp_histories_pkey PRIMARY KEY (id);


--
-- Name: frequently_asked_questions frequently_asked_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frequently_asked_questions
    ADD CONSTRAINT frequently_asked_questions_pkey PRIMARY KEY (id);


--
-- Name: health_checkup_individual_tests health_checkup_individual_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_individual_tests
    ADD CONSTRAINT health_checkup_individual_tests_pkey PRIMARY KEY (id);


--
-- Name: health_checkup_optional_tests health_checkup_optional_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_optional_tests
    ADD CONSTRAINT health_checkup_optional_tests_pkey PRIMARY KEY (id);


--
-- Name: health_checkup_package_masters health_checkup_package_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_package_masters
    ADD CONSTRAINT health_checkup_package_masters_pkey PRIMARY KEY (id);


--
-- Name: health_checkup_test_categories health_checkup_test_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_test_categories
    ADD CONSTRAINT health_checkup_test_categories_pkey PRIMARY KEY (id);


--
-- Name: health_checkup_test_masters health_checkup_test_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_checkup_test_masters
    ADD CONSTRAINT health_checkup_test_masters_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_categories healthcheckup_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_categories
    ADD CONSTRAINT healthcheckup_categories_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_packages healthcheckup_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages
    ADD CONSTRAINT healthcheckup_packages_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_packages_test_mappings healthcheckup_packages_test_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages_test_mappings
    ADD CONSTRAINT healthcheckup_packages_test_mappings_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_packages_test_masters healthcheckup_packages_test_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_packages_test_masters
    ADD CONSTRAINT healthcheckup_packages_test_masters_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_test_parameters_mappings healthcheckup_test_parameters_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_test_parameters_mappings
    ADD CONSTRAINT healthcheckup_test_parameters_mappings_pkey PRIMARY KEY (id);


--
-- Name: healthcheckup_test_parameters_masters healthcheckup_test_parameters_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcheckup_test_parameters_masters
    ADD CONSTRAINT healthcheckup_test_parameters_masters_pkey PRIMARY KEY (id);


--
-- Name: india_top_lab_dynamic_details india_top_lab_dynamic_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.india_top_lab_dynamic_details
    ADD CONSTRAINT india_top_lab_dynamic_details_pkey PRIMARY KEY (id);


--
-- Name: india_top_lab_mappings india_top_lab_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.india_top_lab_mappings
    ADD CONSTRAINT india_top_lab_mappings_pkey PRIMARY KEY (id);


--
-- Name: indias_top_labs_package_details indias_top_labs_package_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indias_top_labs_package_details
    ADD CONSTRAINT indias_top_labs_package_details_pkey PRIMARY KEY (id);


--
-- Name: individual_blood_tests individual_blood_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_blood_tests
    ADD CONSTRAINT individual_blood_tests_pkey PRIMARY KEY (id);


--
-- Name: invoice_appointment_mappings invoice_appointment_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_appointment_mappings
    ADD CONSTRAINT invoice_appointment_mappings_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: master_health_checkup_bookings master_health_checkup_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_bookings
    ADD CONSTRAINT master_health_checkup_bookings_pkey PRIMARY KEY (id);


--
-- Name: master_health_checkup_member_optional_tests master_health_checkup_member_optional_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_member_optional_tests
    ADD CONSTRAINT master_health_checkup_member_optional_tests_pkey PRIMARY KEY (id);


--
-- Name: master_health_checkup_members master_health_checkup_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_checkup_members
    ADD CONSTRAINT master_health_checkup_members_pkey PRIMARY KEY (id);


--
-- Name: master_health_package_masters master_health_package_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.master_health_package_masters
    ADD CONSTRAINT master_health_package_masters_pkey PRIMARY KEY (id);


--
-- Name: optional_test_categories optional_test_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.optional_test_categories
    ADD CONSTRAINT optional_test_categories_pkey PRIMARY KEY (id);


--
-- Name: optional_test_subcategories optional_test_subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.optional_test_subcategories
    ADD CONSTRAINT optional_test_subcategories_pkey PRIMARY KEY (id);


--
-- Name: other_scans_categories other_scans_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_scans_categories
    ADD CONSTRAINT other_scans_categories_pkey PRIMARY KEY (id);


--
-- Name: other_scans other_scans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_scans
    ADD CONSTRAINT other_scans_pkey PRIMARY KEY (id);


--
-- Name: otp_histories otp_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_histories
    ADD CONSTRAINT otp_histories_pkey PRIMARY KEY (id);


--
-- Name: packageS packageS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."packageS"
    ADD CONSTRAINT "packageS_pkey" PRIMARY KEY (id);


--
-- Name: package_tests package_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package_tests
    ADD CONSTRAINT package_tests_pkey PRIMARY KEY (id);


--
-- Name: payment_details payment_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_details
    ADD CONSTRAINT payment_details_pkey PRIMARY KEY (id);


--
-- Name: payment_transaction_details payment_transaction_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_transaction_details
    ADD CONSTRAINT payment_transaction_details_pkey PRIMARY KEY (id);


--
-- Name: promo_code_histories promo_code_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_code_histories
    ADD CONSTRAINT promo_code_histories_pkey PRIMARY KEY (id);


--
-- Name: reward_redeem_histories reward_redeem_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_redeem_histories
    ADD CONSTRAINT reward_redeem_histories_pkey PRIMARY KEY (id);


--
-- Name: reward_redeems reward_redeems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reward_redeems
    ADD CONSTRAINT reward_redeems_pkey PRIMARY KEY (id);


--
-- Name: role_masters role_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_masters
    ADD CONSTRAINT role_masters_pkey PRIMARY KEY (id);


--
-- Name: scan_category_masters scan_category_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_category_masters
    ADD CONSTRAINT scan_category_masters_pkey PRIMARY KEY (id);


--
-- Name: scan_category_prices scan_category_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_category_prices
    ADD CONSTRAINT scan_category_prices_pkey PRIMARY KEY (id);


--
-- Name: scan_headings scan_headings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_headings
    ADD CONSTRAINT scan_headings_pkey PRIMARY KEY (id);


--
-- Name: scan_informations scan_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_informations
    ADD CONSTRAINT scan_informations_pkey PRIMARY KEY (id);


--
-- Name: scan_masters scan_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_masters
    ADD CONSTRAINT scan_masters_pkey PRIMARY KEY (id);


--
-- Name: scan_prices scan_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_prices
    ADD CONSTRAINT scan_prices_pkey PRIMARY KEY (id);


--
-- Name: scan_tests scan_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_tests
    ADD CONSTRAINT scan_tests_pkey PRIMARY KEY (id);


--
-- Name: service_provider_center_details service_provider_center_details_contact_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_center_details
    ADD CONSTRAINT service_provider_center_details_contact_number_key UNIQUE (contact_number);


--
-- Name: service_provider_center_details service_provider_center_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_center_details
    ADD CONSTRAINT service_provider_center_details_pkey PRIMARY KEY (id);


--
-- Name: service_provider_details service_provider_details_mobile_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_details
    ADD CONSTRAINT service_provider_details_mobile_number_key UNIQUE (mobile_number);


--
-- Name: service_provider_details service_provider_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_details
    ADD CONSTRAINT service_provider_details_pkey PRIMARY KEY (id);


--
-- Name: service_provider_services service_provider_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_provider_services
    ADD CONSTRAINT service_provider_services_pkey PRIMARY KEY (id);


--
-- Name: service_test_category service_test_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_test_category
    ADD CONSTRAINT service_test_category_pkey PRIMARY KEY (id);


--
-- Name: state_masters state_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state_masters
    ADD CONSTRAINT state_masters_pkey PRIMARY KEY (id);


--
-- Name: status_masters status_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_masters
    ADD CONSTRAINT status_masters_pkey PRIMARY KEY (id);


--
-- Name: test_category_masters test_category_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_category_masters
    ADD CONSTRAINT test_category_masters_pkey PRIMARY KEY (id);


--
-- Name: test_category test_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_category
    ADD CONSTRAINT test_category_pkey PRIMARY KEY (id);


--
-- Name: test_masters test_masters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_masters
    ADD CONSTRAINT test_masters_pkey PRIMARY KEY (id);


--
-- Name: test_prices test_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_prices
    ADD CONSTRAINT test_prices_pkey PRIMARY KEY (id);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: update_history_mappings update_history_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.update_history_mappings
    ADD CONSTRAINT update_history_mappings_pkey PRIMARY KEY (id);


--
-- Name: user_promo_code_limits user_promo_code_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_promo_code_limits
    ADD CONSTRAINT user_promo_code_limits_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_user_mobile_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_mobile_key UNIQUE (user_mobile);


--
-- Name: youtube_urls_details youtube_urls_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.youtube_urls_details
    ADD CONSTRAINT youtube_urls_details_pkey PRIMARY KEY (id);


--
-- Name: agent_id_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX agent_id_appointment_details_index ON public.appointment_details USING btree ("agentId");


--
-- Name: appointment_date_update_history_mapping_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_date_update_history_mapping_index ON public.appointment_details USING btree (appointment_date);


--
-- Name: appointment_id_appointment_reports_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_id_appointment_reports_index ON public.appointment_reports USING btree (appointment_id);


--
-- Name: appointment_id_booking_payments_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_id_booking_payments_index ON public.booking_payments USING btree (booking_id);


--
-- Name: appointment_id_update_history_mapping_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_id_update_history_mapping_index ON public.update_history_mappings USING btree (appointment_id);


--
-- Name: appointment_status_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_status_appointment_details_index ON public.appointment_details USING btree (appointment_status);


--
-- Name: appointment_type_update_history_mapping_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX appointment_type_update_history_mapping_index ON public.update_history_mappings USING btree ("appointmentType");


--
-- Name: booking_status_master_health_checkup_bookings_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_status_master_health_checkup_bookings_index ON public.master_health_checkup_bookings USING btree (booking_status);


--
-- Name: center_id_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX center_id_appointment_details_index ON public.appointment_details USING btree (center_id);


--
-- Name: city_id_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX city_id_appointment_details_index ON public.appointment_details USING btree (city_id);


--
-- Name: city_id_master_health_checkup_bookings_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX city_id_master_health_checkup_bookings_index ON public.master_health_checkup_bookings USING btree (city_id);


--
-- Name: created_at_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX created_at_appointment_details_index ON public.appointment_details USING btree ("createdAt");


--
-- Name: created_at_master_health_checkup_bookings_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX created_at_master_health_checkup_bookings_index ON public.master_health_checkup_bookings USING btree ("createdAt");


--
-- Name: sp_center_mobile_unique_sp_center_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sp_center_mobile_unique_sp_center_details ON public.service_provider_center_details USING btree (contact_number);


--
-- Name: sp_center_sp_id_sp_center_details; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sp_center_sp_id_sp_center_details ON public.service_provider_center_details USING btree (service_provider_id);


--
-- Name: sp_mobile_unique_sp_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX sp_mobile_unique_sp_details_index ON public.service_provider_details USING btree (mobile_number);


--
-- Name: updated_at_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX updated_at_appointment_details_index ON public.appointment_details USING btree ("updatedAt");


--
-- Name: updated_at_master_health_checkup_bookings_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX updated_at_master_health_checkup_bookings_index ON public.master_health_checkup_bookings USING btree ("updatedAt");


--
-- Name: user_id_appointment_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_id_appointment_details_index ON public.appointment_details USING btree (user_id);


--
-- Name: user_id_customer_details_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_id_customer_details_index ON public.customer_details USING btree (user_id);


--
-- Name: user_id_master_health_checkup_bookings_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_id_master_health_checkup_bookings_index ON public.master_health_checkup_bookings USING btree (user_id);


--
-- Name: user_mobile_unique_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_mobile_unique_index ON public.users USING btree (user_mobile);


--
-- PostgreSQL database dump complete
--

