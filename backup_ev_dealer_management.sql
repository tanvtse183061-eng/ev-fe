--
-- PostgreSQL database dump
--

\restrict h8AdwPP9XCHu7xKpFTjZnH8l4dcKrtoFid3DXcShG2pwFhCB1ehO6UiawBc20pb

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(20),
    date_of_birth date,
    address text,
    city character varying(100),
    province character varying(100),
    postal_code character varying(20),
    credit_score integer,
    preferred_contact_method character varying(50),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: installment_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.installment_plans (
    plan_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    customer_id uuid,
    total_amount numeric(12,2) NOT NULL,
    down_payment_amount numeric(12,2) NOT NULL,
    loan_amount numeric(12,2) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    loan_term_months integer NOT NULL,
    monthly_payment_amount numeric(10,2) NOT NULL,
    first_payment_date date,
    last_payment_date date,
    plan_status character varying(50) DEFAULT 'active'::character varying,
    finance_company character varying(255),
    contract_number character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.installment_plans OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_number character varying(100) NOT NULL,
    quotation_id uuid,
    customer_id uuid,
    user_id uuid,
    inventory_id uuid,
    order_date date NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    total_amount numeric(12,2),
    deposit_amount numeric(12,2),
    balance_amount numeric(12,2),
    payment_method character varying(50),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: customer_debt_report; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_debt_report AS
 SELECT c.customer_id,
    (((c.first_name)::text || ' '::text) || (c.last_name)::text) AS customer_name,
    c.email,
    c.phone,
    count(o.order_id) AS total_orders,
    sum(o.total_amount) AS total_purchases,
    sum(o.balance_amount) AS outstanding_balance,
    count(ip.plan_id) AS active_installments,
    sum(ip.loan_amount) AS total_loan_amount,
    max(o.order_date) AS last_order_date
   FROM ((public.customers c
     LEFT JOIN public.orders o ON ((c.customer_id = o.customer_id)))
     LEFT JOIN public.installment_plans ip ON (((o.order_id = ip.order_id) AND ((ip.plan_status)::text = 'active'::text))))
  GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.phone;


ALTER VIEW public.customer_debt_report OWNER TO postgres;

--
-- Name: customer_feedbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_feedbacks (
    feedback_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_id uuid,
    order_id uuid,
    rating integer,
    feedback_type character varying(50) DEFAULT 'general'::character varying,
    message text NOT NULL,
    response text,
    status character varying(50) DEFAULT 'open'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT customer_feedbacks_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.customer_feedbacks OWNER TO postgres;

--
-- Name: customer_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_payments (
    payment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    customer_id uuid,
    payment_number character varying(100) NOT NULL,
    payment_date date NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_type character varying(50),
    payment_method character varying(100),
    reference_number character varying(100),
    status character varying(50) DEFAULT 'pending'::character varying,
    processed_by uuid,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customer_payments OWNER TO postgres;

--
-- Name: dealer_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_contracts (
    contract_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    contract_number character varying(100) NOT NULL,
    contract_type character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    territory character varying(255),
    commission_rate numeric(5,2),
    minimum_sales_target numeric(15,2),
    contract_status character varying(50) DEFAULT 'active'::character varying,
    signed_date date,
    contract_file_url character varying(500),
    contract_file_path character varying(500),
    terms_and_conditions text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_contracts OWNER TO postgres;

--
-- Name: dealer_discount_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_discount_policies (
    policy_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    variant_id integer,
    policy_name character varying(255) NOT NULL,
    description text,
    discount_percent numeric(5,2),
    discount_amount numeric(12,2),
    start_date date NOT NULL,
    end_date date NOT NULL,
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_discount_policies OWNER TO postgres;

--
-- Name: dealer_installment_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_installment_plans (
    plan_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    invoice_id uuid,
    total_amount numeric(15,2) NOT NULL,
    down_payment_amount numeric(15,2) NOT NULL,
    loan_amount numeric(15,2) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    loan_term_months integer NOT NULL,
    monthly_payment_amount numeric(12,2) NOT NULL,
    first_payment_date date,
    last_payment_date date,
    plan_status character varying(50) DEFAULT 'active'::character varying,
    finance_company character varying(255),
    contract_number character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_installment_plans OWNER TO postgres;

--
-- Name: dealer_installment_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_installment_schedules (
    schedule_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plan_id uuid,
    installment_number integer NOT NULL,
    due_date date NOT NULL,
    amount numeric(12,2) NOT NULL,
    principal_amount numeric(12,2),
    interest_amount numeric(12,2),
    status character varying(50) DEFAULT 'pending'::character varying,
    paid_date date,
    paid_amount numeric(12,2),
    late_fee numeric(12,2) DEFAULT 0,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_installment_schedules OWNER TO postgres;

--
-- Name: dealer_invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_invoices (
    invoice_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    invoice_number character varying(100) NOT NULL,
    dealer_order_id uuid,
    evm_staff_id uuid,
    invoice_date date NOT NULL,
    due_date date NOT NULL,
    subtotal numeric(15,2) NOT NULL,
    tax_amount numeric(12,2) DEFAULT 0,
    discount_amount numeric(12,2) DEFAULT 0,
    total_amount numeric(15,2) NOT NULL,
    status character varying(50) DEFAULT 'issued'::character varying,
    payment_terms_days integer DEFAULT 30,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_invoices OWNER TO postgres;

--
-- Name: dealer_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_orders (
    dealer_order_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    dealer_order_number character varying(100) NOT NULL,
    evm_staff_id uuid,
    order_date date NOT NULL,
    expected_delivery_date date,
    total_quantity integer NOT NULL,
    total_amount numeric(15,2) NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    priority character varying(20) DEFAULT 'normal'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_orders OWNER TO postgres;

--
-- Name: dealer_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_payments (
    payment_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    invoice_id uuid,
    payment_number character varying(100) NOT NULL,
    payment_date date NOT NULL,
    amount numeric(15,2) NOT NULL,
    payment_type character varying(50),
    reference_number character varying(100),
    status character varying(50) DEFAULT 'pending'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_payments OWNER TO postgres;

--
-- Name: dealer_targets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealer_targets (
    target_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    target_year integer NOT NULL,
    target_month integer,
    target_type character varying(50) NOT NULL,
    target_amount numeric(15,2) NOT NULL,
    target_quantity integer,
    achieved_amount numeric(15,2) DEFAULT 0,
    achieved_quantity integer DEFAULT 0,
    achievement_rate numeric(5,2) GENERATED ALWAYS AS (
CASE
    WHEN (target_amount > (0)::numeric) THEN ((achieved_amount / target_amount) * (100)::numeric)
    ELSE (0)::numeric
END) STORED,
    target_status character varying(50) DEFAULT 'active'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dealer_targets OWNER TO postgres;

--
-- Name: dealer_performance_report; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.dealer_performance_report AS
 SELECT target_id,
    target_year,
    target_month,
    target_type,
    target_amount,
    target_quantity,
    achieved_amount,
    achieved_quantity,
    achievement_rate,
        CASE
            WHEN (achievement_rate >= (100)::numeric) THEN 'Excellent'::text
            WHEN (achievement_rate >= (80)::numeric) THEN 'Good'::text
            WHEN (achievement_rate >= (60)::numeric) THEN 'Average'::text
            ELSE 'Below Target'::text
        END AS performance_level,
    target_status,
    notes
   FROM public.dealer_targets dt
  WHERE ((target_status)::text = 'active'::text)
  ORDER BY target_year DESC, target_month DESC;


ALTER VIEW public.dealer_performance_report OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    address text,
    date_of_birth date,
    profile_image_url character varying(500),
    profile_image_path character varying(500),
    role_id integer,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: vehicle_brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_brands (
    brand_id integer NOT NULL,
    brand_name character varying(100) NOT NULL,
    country character varying(100),
    founded_year integer,
    brand_logo_url character varying(500),
    brand_logo_path character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vehicle_brands OWNER TO postgres;

--
-- Name: vehicle_colors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_colors (
    color_id integer NOT NULL,
    color_name character varying(100) NOT NULL,
    color_code character varying(20),
    color_swatch_url character varying(500),
    color_swatch_path character varying(500),
    is_active boolean DEFAULT true
);


ALTER TABLE public.vehicle_colors OWNER TO postgres;

--
-- Name: vehicle_deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_deliveries (
    delivery_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id uuid,
    inventory_id uuid,
    customer_id uuid,
    delivery_date date NOT NULL,
    delivery_time time without time zone,
    delivery_address text NOT NULL,
    delivery_contact_name character varying(100),
    delivery_contact_phone character varying(20),
    delivery_status character varying(50) DEFAULT 'scheduled'::character varying,
    delivery_notes text,
    delivered_by uuid,
    delivery_confirmation_date timestamp without time zone,
    customer_signature_url character varying(500),
    customer_signature_path character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vehicle_deliveries OWNER TO postgres;

--
-- Name: vehicle_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_inventory (
    inventory_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    variant_id integer,
    color_id integer,
    warehouse_id uuid,
    warehouse_location character varying(100),
    vin character varying(17),
    chassis_number character varying(50),
    manufacturing_date date,
    arrival_date date,
    status character varying(50) DEFAULT 'available'::character varying,
    cost_price numeric(12,2),
    selling_price numeric(12,2),
    vehicle_images jsonb,
    interior_images jsonb,
    exterior_images jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_vehicle_inventory_exterior_images_valid_json CHECK (((exterior_images IS NULL) OR (jsonb_typeof(exterior_images) = 'object'::text))),
    CONSTRAINT chk_vehicle_inventory_interior_images_valid_json CHECK (((interior_images IS NULL) OR (jsonb_typeof(interior_images) = 'object'::text))),
    CONSTRAINT chk_vehicle_inventory_vehicle_images_valid_json CHECK (((vehicle_images IS NULL) OR (jsonb_typeof(vehicle_images) = 'object'::text)))
);


ALTER TABLE public.vehicle_inventory OWNER TO postgres;

--
-- Name: vehicle_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_models (
    model_id integer NOT NULL,
    brand_id integer,
    model_name character varying(100) NOT NULL,
    model_year integer NOT NULL,
    vehicle_type character varying(50),
    description text,
    specifications jsonb,
    model_image_url character varying(500),
    model_image_path character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_vehicle_models_specifications_valid_json CHECK (((specifications IS NULL) OR (jsonb_typeof(specifications) = 'object'::text)))
);


ALTER TABLE public.vehicle_models OWNER TO postgres;

--
-- Name: vehicle_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_variants (
    variant_id integer NOT NULL,
    model_id integer,
    variant_name character varying(100) NOT NULL,
    battery_capacity numeric(8,2),
    range_km integer,
    power_kw numeric(8,2),
    acceleration_0_100 numeric(4,2),
    top_speed integer,
    charging_time_fast integer,
    charging_time_slow integer,
    price_base numeric(12,2),
    variant_image_url character varying(500),
    variant_image_path character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vehicle_variants OWNER TO postgres;

--
-- Name: delivery_tracking_report; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.delivery_tracking_report AS
 SELECT vd.delivery_id,
    vd.delivery_date,
    vd.delivery_time,
    vd.delivery_status,
    (((c.first_name)::text || ' '::text) || (c.last_name)::text) AS customer_name,
    c.phone AS customer_phone,
    o.order_number,
    (((((vb.brand_name)::text || ' '::text) || (vm.model_name)::text) || ' '::text) || (vv.variant_name)::text) AS vehicle_info,
    vc.color_name,
    vi.vin,
    vd.delivery_address,
    vd.delivery_contact_name,
    vd.delivery_contact_phone,
    (((u.first_name)::text || ' '::text) || (u.last_name)::text) AS delivered_by,
    vd.delivery_confirmation_date
   FROM ((((((((public.vehicle_deliveries vd
     JOIN public.orders o ON ((vd.order_id = o.order_id)))
     JOIN public.customers c ON ((vd.customer_id = c.customer_id)))
     JOIN public.vehicle_inventory vi ON ((vd.inventory_id = vi.inventory_id)))
     JOIN public.vehicle_variants vv ON ((vi.variant_id = vv.variant_id)))
     JOIN public.vehicle_models vm ON ((vv.model_id = vm.model_id)))
     JOIN public.vehicle_brands vb ON ((vm.brand_id = vb.brand_id)))
     JOIN public.vehicle_colors vc ON ((vi.color_id = vc.color_id)))
     LEFT JOIN public.users u ON ((vd.delivered_by = u.user_id)))
  ORDER BY vd.delivery_date DESC;


ALTER VIEW public.delivery_tracking_report OWNER TO postgres;

--
-- Name: installment_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.installment_schedules (
    schedule_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plan_id uuid,
    installment_number integer NOT NULL,
    due_date date NOT NULL,
    amount numeric(10,2) NOT NULL,
    principal_amount numeric(10,2),
    interest_amount numeric(10,2),
    status character varying(50) DEFAULT 'pending'::character varying,
    paid_date date,
    paid_amount numeric(10,2),
    late_fee numeric(10,2) DEFAULT 0,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.installment_schedules OWNER TO postgres;

--
-- Name: inventory_turnover_report; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.inventory_turnover_report AS
 SELECT vb.brand_name,
    vm.model_name,
    vv.variant_name,
    vc.color_name,
    count(vi.inventory_id) AS total_inventory,
    count(
        CASE
            WHEN ((vi.status)::text = 'available'::text) THEN 1
            ELSE NULL::integer
        END) AS available_count,
    count(
        CASE
            WHEN ((vi.status)::text = 'sold'::text) THEN 1
            ELSE NULL::integer
        END) AS sold_count,
    count(
        CASE
            WHEN ((vi.status)::text = 'reserved'::text) THEN 1
            ELSE NULL::integer
        END) AS reserved_count,
    avg(vi.cost_price) AS avg_cost_price,
    avg(vi.selling_price) AS avg_selling_price,
    avg((vi.selling_price - vi.cost_price)) AS avg_profit_margin,
    min(vi.arrival_date) AS first_arrival,
    max(vi.arrival_date) AS last_arrival
   FROM ((((public.vehicle_inventory vi
     JOIN public.vehicle_variants vv ON ((vi.variant_id = vv.variant_id)))
     JOIN public.vehicle_models vm ON ((vv.model_id = vm.model_id)))
     JOIN public.vehicle_brands vb ON ((vm.brand_id = vb.brand_id)))
     JOIN public.vehicle_colors vc ON ((vi.color_id = vc.color_id)))
  GROUP BY vb.brand_name, vm.model_name, vv.variant_name, vc.color_name;


ALTER VIEW public.inventory_turnover_report OWNER TO postgres;

--
-- Name: monthly_sales_summary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.monthly_sales_summary AS
 SELECT EXTRACT(year FROM order_date) AS sales_year,
    EXTRACT(month FROM order_date) AS sales_month,
    count(order_id) AS total_orders,
    sum(total_amount) AS total_revenue,
    sum(deposit_amount) AS total_deposits,
    sum(balance_amount) AS total_balance,
    count(
        CASE
            WHEN ((payment_method)::text = 'cash'::text) THEN 1
            ELSE NULL::integer
        END) AS cash_orders,
    count(
        CASE
            WHEN ((payment_method)::text = 'installment'::text) THEN 1
            ELSE NULL::integer
        END) AS installment_orders,
    avg(total_amount) AS avg_order_value
   FROM public.orders o
  WHERE ((status)::text = ANY ((ARRAY['confirmed'::character varying, 'completed'::character varying])::text[]))
  GROUP BY (EXTRACT(year FROM order_date)), (EXTRACT(month FROM order_date))
  ORDER BY (EXTRACT(year FROM order_date)) DESC, (EXTRACT(month FROM order_date)) DESC;


ALTER VIEW public.monthly_sales_summary OWNER TO postgres;

--
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    promotion_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    variant_id integer,
    title character varying(255) NOT NULL,
    description text,
    discount_percent numeric(5,2),
    discount_amount numeric(12,2),
    start_date date NOT NULL,
    end_date date NOT NULL,
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- Name: quotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotations (
    quotation_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    quotation_number character varying(100) NOT NULL,
    customer_id uuid,
    user_id uuid,
    variant_id integer,
    color_id integer,
    quotation_date date DEFAULT CURRENT_DATE NOT NULL,
    total_price numeric(12,2) NOT NULL,
    discount_amount numeric(12,2) DEFAULT 0,
    final_price numeric(12,2) NOT NULL,
    validity_days integer DEFAULT 7,
    status character varying(50) DEFAULT 'pending'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quotations OWNER TO postgres;

--
-- Name: sales_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_contracts (
    contract_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    contract_number character varying(100) NOT NULL,
    order_id uuid,
    customer_id uuid,
    user_id uuid,
    contract_date date NOT NULL,
    delivery_date date,
    contract_value numeric(15,2) NOT NULL,
    payment_terms text,
    warranty_period_months integer DEFAULT 24,
    contract_status character varying(50) DEFAULT 'draft'::character varying,
    signed_date date,
    contract_file_url character varying(500),
    contract_file_path character varying(500),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sales_contracts OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    description text,
    permissions jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_user_roles_permissions_valid_json CHECK (((permissions IS NULL) OR (jsonb_typeof(permissions) = 'object'::text)))
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: sales_report_by_staff; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sales_report_by_staff AS
 SELECT u.user_id,
    (((u.first_name)::text || ' '::text) || (u.last_name)::text) AS staff_name,
    u.role_id,
    ur.role_name,
    count(o.order_id) AS total_orders,
    sum(o.total_amount) AS total_sales,
    avg(o.total_amount) AS avg_order_value,
    count(
        CASE
            WHEN ((o.status)::text = 'completed'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_orders,
    sum(
        CASE
            WHEN ((o.status)::text = 'completed'::text) THEN o.total_amount
            ELSE (0)::numeric
        END) AS completed_sales
   FROM ((public.users u
     LEFT JOIN public.user_roles ur ON ((u.role_id = ur.role_id)))
     LEFT JOIN public.orders o ON ((u.user_id = o.user_id)))
  WHERE (u.role_id = ANY (ARRAY[3, 4]))
  GROUP BY u.user_id, u.first_name, u.last_name, u.role_id, ur.role_name;


ALTER VIEW public.sales_report_by_staff OWNER TO postgres;

--
-- Name: test_drive_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_drive_schedules (
    schedule_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_id uuid,
    variant_id integer,
    preferred_date date NOT NULL,
    preferred_time time without time zone NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.test_drive_schedules OWNER TO postgres;

--
-- Name: user_roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_role_id_seq OWNER TO postgres;

--
-- Name: user_roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_role_id_seq OWNED BY public.user_roles.role_id;


--
-- Name: vehicle_brands_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicle_brands_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicle_brands_brand_id_seq OWNER TO postgres;

--
-- Name: vehicle_brands_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicle_brands_brand_id_seq OWNED BY public.vehicle_brands.brand_id;


--
-- Name: vehicle_colors_color_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicle_colors_color_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicle_colors_color_id_seq OWNER TO postgres;

--
-- Name: vehicle_colors_color_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicle_colors_color_id_seq OWNED BY public.vehicle_colors.color_id;


--
-- Name: vehicle_models_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicle_models_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicle_models_model_id_seq OWNER TO postgres;

--
-- Name: vehicle_models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicle_models_model_id_seq OWNED BY public.vehicle_models.model_id;


--
-- Name: vehicle_variants_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicle_variants_variant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicle_variants_variant_id_seq OWNER TO postgres;

--
-- Name: vehicle_variants_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicle_variants_variant_id_seq OWNED BY public.vehicle_variants.variant_id;


--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouse (
    warehouse_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    warehouse_name character varying(255) DEFAULT 'Main EV Warehouse'::character varying NOT NULL,
    warehouse_code character varying(50) DEFAULT 'MAIN_WAREHOUSE'::character varying NOT NULL,
    address text NOT NULL,
    city character varying(100),
    province character varying(100),
    postal_code character varying(20),
    phone character varying(20),
    email character varying(255),
    capacity integer,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.warehouse OWNER TO postgres;

--
-- Name: user_roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN role_id SET DEFAULT nextval('public.user_roles_role_id_seq'::regclass);


--
-- Name: vehicle_brands brand_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_brands ALTER COLUMN brand_id SET DEFAULT nextval('public.vehicle_brands_brand_id_seq'::regclass);


--
-- Name: vehicle_colors color_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_colors ALTER COLUMN color_id SET DEFAULT nextval('public.vehicle_colors_color_id_seq'::regclass);


--
-- Name: vehicle_models model_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_models ALTER COLUMN model_id SET DEFAULT nextval('public.vehicle_models_model_id_seq'::regclass);


--
-- Name: vehicle_variants variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_variants ALTER COLUMN variant_id SET DEFAULT nextval('public.vehicle_variants_variant_id_seq'::regclass);


--
-- Data for Name: customer_feedbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_feedbacks (feedback_id, customer_id, order_id, rating, feedback_type, message, response, status, created_at, updated_at) FROM stdin;
3512230a-8c44-46d8-b4c1-c10e2199936a	e9c41a60-f600-4188-80fb-55fbc60ae128	1a242971-a5d8-41ae-9681-0b4081c6a5da	5	general	Dịch vụ tốt, giao xe đúng hẹn	\N	resolved	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
ecba9a9d-180c-41b8-9ca5-d08d413c2c70	23c800a2-5903-4b5e-bb41-c86e0e4a5107	f574227f-d7c9-4145-91bd-a3b2bf409b6a	4	service	Nhân viên tư vấn nhiệt tình	\N	resolved	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
\.


--
-- Data for Name: customer_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_payments (payment_id, order_id, customer_id, payment_number, payment_date, amount, payment_type, payment_method, reference_number, status, processed_by, notes, created_at) FROM stdin;
7f52485c-db0b-4fbf-970d-10cadeeb4472	1a242971-a5d8-41ae-9681-0b4081c6a5da	e9c41a60-f600-4188-80fb-55fbc60ae128	CUST-PAY-2024-001	2024-02-15	236000000.00	down_payment	bank_transfer	\N	completed	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	2025-10-14 23:14:45.443104
5427f291-b31a-48dc-855a-79f269cb4ab7	f574227f-d7c9-4145-91bd-a3b2bf409b6a	23c800a2-5903-4b5e-bb41-c86e0e4a5107	CUST-PAY-2024-002	2024-02-16	800000000.00	full_payment	bank_transfer	\N	completed	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	2025-10-14 23:15:14.855996
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, first_name, last_name, email, phone, date_of_birth, address, city, province, postal_code, credit_score, preferred_contact_method, notes, created_at, updated_at) FROM stdin;
e9c41a60-f600-4188-80fb-55fbc60ae128	Nguyen	Van Minh	minh.nguyen@email.com	+84-901-234-567	\N	123 Le Loi Street, District 1	Ho Chi Minh City	Ho Chi Minh	\N	750	\N	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
23c800a2-5903-4b5e-bb41-c86e0e4a5107	Tran	Thi Lan	lan.tran@email.com	+84-902-345-678	\N	456 Nguyen Trai Street, Thanh Xuan District	Hanoi	Hanoi	\N	720	\N	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
bc295b71-4784-42bb-8711-573b48d28101	Le	Van Nam	nam.le@email.com	+84-903-456-789	\N	789 Dong Khoi Street, District 1	Ho Chi Minh City	Ho Chi Minh	\N	680	\N	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
0766234c-d354-476c-a8f9-200cd74f2d9e	Pham	Thi Hoa	hoa.pham@email.com	+84-904-567-890	\N	321 Hai Ba Trung Street, District 3	Ho Chi Minh City	Ho Chi Minh	\N	800	\N	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
63ca8da6-7a26-4c64-b022-af66f4b27817	Vo	Van Duc	duc.vo@email.com	+84-905-678-901	\N	654 Pasteur Street, District 3	Ho Chi Minh City	Ho Chi Minh	\N	650	\N	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
80ff5c2e-f596-4638-9f14-733ae515bbeb	Van Hoang	Le	hoang.le@email.com	+84-903-456-789	1988-07-20	789 Tran Hung Dao Street, District 5	Ho Chi Minh City	Ho Chi Minh	\N	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
2d374584-fb65-472d-83a5-c1136f26bc38	Thi Thu	Nguyen	thu.nguyen@email.com	+84-904-567-890	1990-11-15	321 Le Van Viet Street, Thu Duc City	Ho Chi Minh City	Ho Chi Minh	\N	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
1dccdf2f-42f0-4cb4-b95e-ecf9555f1ed3	Van Duc	Pham	duc.pham@email.com	+84-905-678-901	1987-04-10	654 Nguyen Thi Minh Khai Street, District 3	Ho Chi Minh City	Ho Chi Minh	\N	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
c9d8700b-8fe3-45e7-8eeb-c9ab1c3e44e4	Thi Mai	Tran	mai.tran@email.com	+84-906-789-012	1992-09-25	987 Vo Van Tan Street, District 3	Ho Chi Minh City	Ho Chi Minh	\N	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
acba6a37-29d9-46f6-8c94-9dfa730d0d89	John	Doe	john.doe@email.com	+84-901-234-567	\N	123 Le Loi Street, District 1	Ho Chi Minh City	Ho Chi Minh	\N	\N	\N	\N	2025-10-15 00:38:33.959218	2025-10-15 00:38:33.959218
78fe7eb0-ceb8-4793-a8af-187a3fe26f67	Jane	Smith	jane.smith@email.com	+84-902-345-678	\N	456 Nguyen Trai Street, Thanh Xuan District	Hanoi	Hanoi	\N	\N	\N	\N	2025-10-15 00:38:33.959218	2025-10-15 00:38:33.959218
\.


--
-- Data for Name: dealer_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_contracts (contract_id, contract_number, contract_type, start_date, end_date, territory, commission_rate, minimum_sales_target, contract_status, signed_date, contract_file_url, contract_file_path, terms_and_conditions, created_at, updated_at) FROM stdin;
f1abe2b8-c6b0-4e1e-b54e-d2f27a349f5d	DC-2024-001	exclusive	2024-01-01	2024-12-31	Ho Chi Minh City	3.50	50000000000.00	active	2023-12-15	https://example.com/contracts/DC-2024-001.pdf	\N	Hợp đồng đại lý độc quyền tại TP.HCM	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
\.


--
-- Data for Name: dealer_discount_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_discount_policies (policy_id, variant_id, policy_name, description, discount_percent, discount_amount, start_date, end_date, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dealer_installment_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_installment_plans (plan_id, invoice_id, total_amount, down_payment_amount, loan_amount, interest_rate, loan_term_months, monthly_payment_amount, first_payment_date, last_payment_date, plan_status, finance_company, contract_number, created_at) FROM stdin;
37516889-d4c8-4118-a715-321e3b53016f	7578326c-b3cb-4c79-99fb-61118f0494e0	2000000000.00	400000000.00	1600000000.00	7.50	24	75000000.00	2024-03-01	2026-02-01	active	EV Finance	EVF-DEALER-2024-001	2025-10-14 23:14:45.443104
\.


--
-- Data for Name: dealer_installment_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_installment_schedules (schedule_id, plan_id, installment_number, due_date, amount, principal_amount, interest_amount, status, paid_date, paid_amount, late_fee, notes, created_at) FROM stdin;
\.


--
-- Data for Name: dealer_invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_invoices (invoice_id, invoice_number, dealer_order_id, evm_staff_id, invoice_date, due_date, subtotal, tax_amount, discount_amount, total_amount, status, payment_terms_days, notes, created_at, updated_at) FROM stdin;
7578326c-b3cb-4c79-99fb-61118f0494e0	INV-2024-001	58798e68-c111-4214-98e4-2ac38bf7e070	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-02-02	2024-03-03	2000000000.00	0.00	0.00	2000000000.00	issued	30	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
db0b4cf2-bed0-4eef-a205-484c91c893e1	INV-2024-002	1322d6b5-89c9-43fd-8006-aea1b2de29c5	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-02-15	2024-03-15	1500000000.00	150000000.00	0.00	1650000000.00	issued	30	Hóa đơn cho đơn hàng DO-2024-002	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
00d9bac4-de71-493f-8663-5652597f9658	INV-2024-003	58798e68-c111-4214-98e4-2ac38bf7e070	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-02-20	2024-03-20	2500000000.00	250000000.00	100000000.00	2650000000.00	issued	30	Hóa đơn cho đơn hàng DO-2024-003 với chiết khấu	2025-10-14 23:18:22.035186	2025-10-14 23:26:46.854412
a881beab-d069-4816-8b62-aa9971c146ba	INV-2024-004	adce34fb-a0c7-4207-805b-648184bfdd88	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-03-01	2024-04-01	4500000000.00	450000000.00	0.00	4950000000.00	issued	30	Hóa đơn cho đơn hàng DO-2024-004	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
5acdfb08-d429-4d7c-b02b-deaf0fec6a9e	INV-2024-005	8b8f66e8-de7d-4e0a-8a3b-3266589b0fbc	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-03-02	2024-04-02	5400000000.00	540000000.00	100000000.00	5840000000.00	issued	30	Hóa đơn cho đơn hàng DO-2024-005	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: dealer_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_orders (dealer_order_id, dealer_order_number, evm_staff_id, order_date, expected_delivery_date, total_quantity, total_amount, status, priority, notes, created_at, updated_at) FROM stdin;
58798e68-c111-4214-98e4-2ac38bf7e070	DO-2024-001	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-02-01	\N	2	2000000000.00	confirmed	normal	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
1322d6b5-89c9-43fd-8006-aea1b2de29c5	DO-2024-002	2d9d55af-f0db-4210-b6a4-3f7ef4f72682	2024-02-10	\N	3	3000000000.00	pending	normal	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
4831a231-6d32-4e3f-a3c2-f8974896c3e1	DO-2024-003	611d8920-389f-44c6-91b4-686c7872b8e3	2024-02-15	\N	2	2500000000.00	confirmed	normal	Đơn hàng thứ 3 của đại lý HCM	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
adce34fb-a0c7-4207-805b-648184bfdd88	DO-2024-004	611d8920-389f-44c6-91b4-686c7872b8e3	2024-03-01	\N	2	5000000000.00	confirmed	normal	Đơn hàng Tesla Model S và Model X	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
8b8f66e8-de7d-4e0a-8a3b-3266589b0fbc	DO-2024-005	611d8920-389f-44c6-91b4-686c7872b8e3	2024-03-02	\N	3	6000000000.00	confirmed	normal	Đơn hàng BMW và Mercedes	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: dealer_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_payments (payment_id, invoice_id, payment_number, payment_date, amount, payment_type, reference_number, status, notes, created_at) FROM stdin;
bc124263-3e11-44d6-be8c-d0346cb5be53	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-001	2024-02-20	400000000.00	down_payment	\N	completed	\N	2025-10-14 23:14:45.443104
c3d93496-1252-46c2-81b1-85e441bf4b1c	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-004	2024-03-01	75000000.00	installment	\N	completed	\N	2025-10-14 23:18:22.035186
b0af5c48-e271-4aa9-a0a7-9ed31f5937b9	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-002	2024-02-25	500000000.00	down_payment	\N	completed	\N	2025-10-14 23:18:22.035186
930e7489-2498-4bed-b79a-b8844d79d68c	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-003	2024-02-28	800000000.00	down_payment	\N	completed	\N	2025-10-14 23:18:22.035186
f22513af-b09a-40ee-a1c9-8592070ff012	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-005	2024-03-01	85000000.00	installment	\N	completed	\N	2025-10-14 23:18:22.035186
fcd43bec-d23c-4aab-949f-80b9a4649c9d	7578326c-b3cb-4c79-99fb-61118f0494e0	DEALER-PAY-2024-006	2024-03-05	90000000.00	installment	\N	pending	\N	2025-10-14 23:18:22.035186
d2ebb5b3-79d3-487b-94c7-01c50999c963	a881beab-d069-4816-8b62-aa9971c146ba	DEALER-PAY-2024-007	2024-03-01	990000000.00	down_payment	\N	completed	\N	2025-10-14 23:46:18.12036
9750add8-b479-47ba-9a1b-16e987d1ddd0	5acdfb08-d429-4d7c-b02b-deaf0fec6a9e	DEALER-PAY-2024-008	2024-03-02	1168000000.00	down_payment	\N	completed	\N	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: dealer_targets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealer_targets (target_id, target_year, target_month, target_type, target_amount, target_quantity, achieved_amount, achieved_quantity, target_status, notes, created_at, updated_at) FROM stdin;
36888548-0f6e-4d2e-9dce-b2960a110dbf	2024	1	monthly	5000000000.00	4	1200000000.00	1	active	Chỉ tiêu tháng 1/2024	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
ca72dcc3-ea16-4c19-91b1-7b98b9a9e836	2024	2	monthly	6000000000.00	5	1180000000.00	1	active	Chỉ tiêu tháng 2/2024	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
87aa5aed-6157-4f80-9e78-90fddf847c42	2024	\N	yearly	60000000000.00	50	2380000000.00	2	active	Chỉ tiêu cả năm 2024	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
\.


--
-- Data for Name: installment_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.installment_plans (plan_id, order_id, customer_id, total_amount, down_payment_amount, loan_amount, interest_rate, loan_term_months, monthly_payment_amount, first_payment_date, last_payment_date, plan_status, finance_company, contract_number, created_at) FROM stdin;
569515c4-22c0-40f6-be0d-d4191e1045bc	1a242971-a5d8-41ae-9681-0b4081c6a5da	e9c41a60-f600-4188-80fb-55fbc60ae128	1180000000.00	236000000.00	944000000.00	8.50	36	30000000.00	2024-03-15	2027-02-15	active	Vietcombank	VCB-INST-2024-001	2025-10-14 23:14:45.443104
d5696832-b27a-4a2c-9d86-62d25826bdfd	c6544d05-f1e6-4842-a1cc-3a6af4a873e7	bc295b71-4784-42bb-8711-573b48d28101	350000000.00	0.00	350000000.00	9.00	24	16000000.00	2024-03-17	2026-02-17	active	BIDV	BIDV-INST-2024-001	2025-10-14 23:15:14.855996
\.


--
-- Data for Name: installment_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.installment_schedules (schedule_id, plan_id, installment_number, due_date, amount, principal_amount, interest_amount, status, paid_date, paid_amount, late_fee, notes, created_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, order_number, quotation_id, customer_id, user_id, inventory_id, order_date, status, total_amount, deposit_amount, balance_amount, payment_method, notes, created_at, updated_at) FROM stdin;
1a242971-a5d8-41ae-9681-0b4081c6a5da	ORD-2024-001	e13dea70-2661-4527-ab52-13284fa3eff9	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	863a8f02-b9ba-4f21-bbf9-5dd09b481532	2024-02-15	confirmed	1180000000.00	236000000.00	944000000.00	installment	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
f574227f-d7c9-4145-91bd-a3b2bf409b6a	ORD-2024-002	869777a2-80ac-4996-a9cb-d7707d4d678b	23c800a2-5903-4b5e-bb41-c86e0e4a5107	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	0b519b1c-e178-4ede-8a42-688362cb3198	2024-02-16	completed	800000000.00	800000000.00	0.00	cash	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
c6544d05-f1e6-4842-a1cc-3a6af4a873e7	ORD-2024-003	2cf9b2c9-db82-40fc-9629-fcee4ddf0c8d	bc295b71-4784-42bb-8711-573b48d28101	52b27bc0-f457-4f96-bcaf-d20daadf9f56	6d43eb8d-6a31-404e-abdb-9389b86e7c17	2024-02-17	pending	350000000.00	0.00	350000000.00	installment	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
9d1df0e1-37e3-4e10-8f7d-a372407c96a3	ORD-2024-004	e13dea70-2661-4527-ab52-13284fa3eff9	\N	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	782dad0d-39d8-42c5-b7b7-961f4ad47372	2024-02-20	confirmed	1800000000.00	360000000.00	1440000000.00	installment	Đơn hàng BMW iX xDrive50 cho Nguyễn Thị Thu	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
3ce3238d-ad13-45b5-aebc-c85522e8588b	ORD-2024-005	e13dea70-2661-4527-ab52-13284fa3eff9	\N	52b27bc0-f457-4f96-bcaf-d20daadf9f56	863a8f02-b9ba-4f21-bbf9-5dd09b481532	2024-02-22	confirmed	2200000000.00	440000000.00	1760000000.00	installment	Đơn hàng Mercedes EQS 450+ cho Phạm Văn Đức	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
d9af974c-0dea-434d-8463-4333596eac52	ORD-2024-006	e13dea70-2661-4527-ab52-13284fa3eff9	\N	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	863a8f02-b9ba-4f21-bbf9-5dd09b481532	2024-02-25	confirmed	1200000000.00	240000000.00	960000000.00	installment	Đơn hàng VinFast VF 5 Plus cho Trần Thị Mai	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
9d035558-89e5-4a9d-a6d9-1b6462f36ab4	ORD-2024-007	e22ada09-2477-41df-ac3a-85058b3fe516	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	5de1fc37-c8a6-4d87-bbf3-b2b7e3ae64f8	2024-03-01	confirmed	2400000000.00	480000000.00	1920000000.00	installment	Đơn hàng Tesla Model S Plaid	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
5993dd7a-c68d-4f13-bf12-d97f4fa8b28b	ORD-2024-008	9b82e51f-30a5-4237-9a21-a7223926c08b	23c800a2-5903-4b5e-bb41-c86e0e4a5107	52b27bc0-f457-4f96-bcaf-d20daadf9f56	a23adebe-e700-451e-b1c9-e54cd8ecc242	2024-03-02	confirmed	2650000000.00	530000000.00	2120000000.00	installment	Đơn hàng Tesla Model X Plaid	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, variant_id, title, description, discount_percent, discount_amount, start_date, end_date, status, created_at, updated_at) FROM stdin;
55db5285-efe6-4e12-9f6e-36919bd61bfe	1	Khuyến mãi mùa hè	Giảm giá 5% cho Tesla Model 3	5.00	\N	2024-06-01	2024-07-01	active	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
534f600d-f319-4b62-8fff-a8655c5d2430	3	Khuyến mãi mùa hè Tesla	Giảm giá 5% cho Tesla Model 3 Standard Range	5.00	\N	2024-06-01	2024-07-01	active	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
99942c2c-c1e5-4ad2-9dee-6580d286bf7f	8	Khuyến mãi VinFast VF 5	Giảm giá 10% cho VinFast VF 5 Standard	10.00	\N	2024-03-01	2024-04-01	active	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
\.


--
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quotations (quotation_id, quotation_number, customer_id, user_id, variant_id, color_id, quotation_date, total_price, discount_amount, final_price, validity_days, status, notes, created_at, updated_at) FROM stdin;
e13dea70-2661-4527-ab52-13284fa3eff9	QT-2024-001	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	1	1	2025-10-14	1200000000.00	20000000.00	1180000000.00	7	pending	Báo giá Tesla Model 3 Standard Range màu trắng	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
869777a2-80ac-4996-a9cb-d7707d4d678b	QT-2024-002	23c800a2-5903-4b5e-bb41-c86e0e4a5107	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	6	4	2025-10-14	800000000.00	0.00	800000000.00	7	pending	Báo giá BYD Atto 3 Standard màu xanh dương	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
2cf9b2c9-db82-40fc-9629-fcee4ddf0c8d	QT-2024-003	bc295b71-4784-42bb-8711-573b48d28101	52b27bc0-f457-4f96-bcaf-d20daadf9f56	8	1	2025-10-14	350000000.00	0.00	350000000.00	7	pending	Báo giá VinFast VF 5 Standard màu trắng	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
9910249d-a3bd-4e4d-a22b-c04225da94a5	QT-2024-004	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	2024-02-18	1900000000.00	100000000.00	1800000000.00	7	accepted	Báo giá cho khách hàng Nguyễn Thị Thu	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
d3ad4833-c0b2-49dd-b40c-6040853e5772	QT-2024-005	e9c41a60-f600-4188-80fb-55fbc60ae128	52b27bc0-f457-4f96-bcaf-d20daadf9f56	11	\N	2024-02-20	2300000000.00	100000000.00	2200000000.00	7	accepted	Báo giá cho khách hàng Phạm Văn Đức	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
5dfe0c7a-0d44-467f-b815-79adedd33f2c	QT-2024-006	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	1	2024-02-22	1250000000.00	50000000.00	1200000000.00	7	accepted	Báo giá cho khách hàng Trần Thị Mai	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
e22ada09-2477-41df-ac3a-85058b3fe516	QT-2024-007	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	21	1	2024-03-01	2500000000.00	100000000.00	2400000000.00	7	pending	Báo giá cho Tesla Model S Plaid	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
9b82e51f-30a5-4237-9a21-a7223926c08b	QT-2024-008	23c800a2-5903-4b5e-bb41-c86e0e4a5107	52b27bc0-f457-4f96-bcaf-d20daadf9f56	22	3	2024-03-02	2800000000.00	150000000.00	2650000000.00	7	accepted	Báo giá cho Tesla Model X Plaid	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
81661b71-7b3c-43bb-8171-0cd6af2762fc	QT-2024-009	80ff5c2e-f596-4638-9f14-733ae515bbeb	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	23	1	2024-03-03	1200000000.00	50000000.00	1150000000.00	7	pending	Báo giá cho BYD Atto 3 Extended Range	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
9bd78eb4-3700-48e3-8e72-84a09aaa3c9e	QT-2024-010	2d374584-fb65-472d-83a5-c1136f26bc38	52b27bc0-f457-4f96-bcaf-d20daadf9f56	24	\N	2024-03-04	2000000000.00	100000000.00	1900000000.00	7	accepted	Báo giá cho BMW iX3 xDrive30	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: sales_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_contracts (contract_id, contract_number, order_id, customer_id, user_id, contract_date, delivery_date, contract_value, payment_terms, warranty_period_months, contract_status, signed_date, contract_file_url, contract_file_path, notes, created_at, updated_at) FROM stdin;
8a6c521b-8618-4416-ab3e-54911a58ed2a	SC-2024-001	1a242971-a5d8-41ae-9681-0b4081c6a5da	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	2024-02-16	2024-03-01	1180000000.00	Trả góp 36 tháng, lãi suất 8.5%/năm	24	signed	2024-02-16	https://example.com/contracts/SC-2024-001.pdf	\N	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
4e153212-9b59-47bb-b801-f02421a259f2	SC-2024-002	f574227f-d7c9-4145-91bd-a3b2bf409b6a	23c800a2-5903-4b5e-bb41-c86e0e4a5107	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	2024-02-17	2024-02-20	800000000.00	Thanh toán một lần	24	signed	2024-02-17	https://example.com/contracts/SC-2024-002.pdf	\N	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
db5615f4-c7f7-4b51-8098-ce1b4680297d	SC-2024-003	c6544d05-f1e6-4842-a1cc-3a6af4a873e7	\N	52b27bc0-f457-4f96-bcaf-d20daadf9f56	2024-02-18	2024-03-05	950000000.00	Trả góp 24 tháng, lãi suất 7.5%/năm	24	signed	2024-02-18	https://example.com/contracts/SC-2024-003.pdf	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
c6b5b1af-b84f-482c-a4ee-a69a66c8ba94	SC-2024-004	1a242971-a5d8-41ae-9681-0b4081c6a5da	\N	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	2024-02-20	2024-03-08	1800000000.00	Trả góp 48 tháng, lãi suất 8.0%/năm	36	signed	2024-02-20	https://example.com/contracts/SC-2024-004.pdf	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
762eaafe-5dc5-4044-887a-b2d9d9065844	SC-2024-005	1a242971-a5d8-41ae-9681-0b4081c6a5da	\N	52b27bc0-f457-4f96-bcaf-d20daadf9f56	2024-02-22	2024-03-10	2200000000.00	Trả góp 60 tháng, lãi suất 8.5%/năm	48	signed	2024-02-22	https://example.com/contracts/SC-2024-005.pdf	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
27794eed-3af2-4b75-8c35-eabd1ee43871	SC-2024-006	1a242971-a5d8-41ae-9681-0b4081c6a5da	\N	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	2024-02-25	2024-03-15	1200000000.00	Trả góp 36 tháng, lãi suất 8.5%/năm	24	pending	\N	https://example.com/contracts/SC-2024-006.pdf	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
879f3482-1b58-417e-8da9-7d5871e60d34	SC-2024-007	9d035558-89e5-4a9d-a6d9-1b6462f36ab4	e9c41a60-f600-4188-80fb-55fbc60ae128	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	2024-03-01	2024-03-15	2400000000.00	Trả góp 48 tháng, lãi suất 8.0%/năm	36	signed	2024-03-01	https://example.com/contracts/SC-2024-007.pdf	\N	\N	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
32e4457e-8c48-434a-9f38-8ce4578f752c	SC-2024-008	5993dd7a-c68d-4f13-bf12-d97f4fa8b28b	23c800a2-5903-4b5e-bb41-c86e0e4a5107	52b27bc0-f457-4f96-bcaf-d20daadf9f56	2024-03-02	2024-03-16	2650000000.00	Trả góp 60 tháng, lãi suất 8.5%/năm	48	signed	2024-03-02	https://example.com/contracts/SC-2024-008.pdf	\N	\N	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: test_drive_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_drive_schedules (schedule_id, customer_id, variant_id, preferred_date, preferred_time, status, notes, created_at, updated_at) FROM stdin;
a0bb45f0-e026-4548-ac0e-7e531a611525	23c800a2-5903-4b5e-bb41-c86e0e4a5107	1	2024-03-20	10:00:00	pending	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
ab2e7251-dcab-46e1-be82-bf42178dc8af	bc295b71-4784-42bb-8711-573b48d28101	8	2024-03-20	10:00:00	pending	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
0bbd5116-4504-4304-8a7d-fec50a78b666	0766234c-d354-476c-a8f9-200cd74f2d9e	3	2024-03-25	14:00:00	pending	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (role_id, role_name, description, permissions, created_at) FROM stdin;
1	admin	System Administrator	{"users": ["create", "read", "update", "delete"], "orders": ["create", "read", "update", "delete"], "dealers": ["create", "read", "update", "delete"], "reports": ["read"], "invoices": ["create", "read", "update", "delete"], "vehicles": ["create", "read", "update", "delete"]}	2025-10-14 23:14:45.443104
2	evm_staff	Electric Vehicle Manufacturer Staff	{"dealers": ["read", "update"], "reports": ["read"], "invoices": ["create", "read", "update"], "vehicles": ["create", "read", "update"]}	2025-10-14 23:14:45.443104
3	dealer_manager	Dealer Manager	{"users": ["read"], "orders": ["create", "read", "update"], "reports": ["read"], "invoices": ["read"], "customers": ["create", "read", "update"]}	2025-10-14 23:14:45.443104
4	dealer_staff	Dealer Staff	{"orders": ["create", "read"], "customers": ["create", "read", "update"], "quotations": ["create", "read", "update"]}	2025-10-14 23:14:45.443104
5	evm_manager	EVM Manager	{"read": true, "write": true, "approve": true}	2025-10-15 00:52:56.216723
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, email, password_hash, first_name, last_name, phone, address, date_of_birth, profile_image_url, profile_image_path, role_id, is_active, created_at, updated_at) FROM stdin;
611d8920-389f-44c6-91b4-686c7872b8e3	dealer_mgr_hcm	manager@dealerhcm.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Nguyen	Van A	+84-28-123-4567	123 Nguyen Hue Street, District 1	\N	https://example.com/profiles/dealer_mgr.jpg	\N	3	t	2025-10-14 23:14:45.443104	2025-10-14 23:18:42.729405
bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	dealer_staff_hcm1	staff1@dealerhcm.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Tran	Thi B	+84-28-123-4568	123 Nguyen Hue Street, District 1	\N	https://example.com/profiles/dealer_staff.jpg	\N	4	t	2025-10-14 23:14:45.443104	2025-10-14 23:18:42.729405
52b27bc0-f457-4f96-bcaf-d20daadf9f56	dealer_staff_hcm2	staff2@dealerhcm.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	Le	Van C	+84-28-123-4569	123 Nguyen Hue Street, District 1	\N	https://example.com/profiles/dealer_staff2.jpg	\N	4	t	2025-10-14 23:15:14.855996	2025-10-14 23:18:42.729405
2d9d55af-f0db-4210-b6a4-3f7ef4f72682	evm_manager	manager@evm.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	John	Smith	+84-123-456-7891	1000 Industrial Zone, District 7	\N	https://example.com/profiles/evm_manager.jpg	\N	2	t	2025-10-14 23:14:45.443104	2025-10-14 23:18:42.729405
0df4dabc-738b-45b5-895e-b1e4ca37921a	admin	admin@evdealer.com	$2a$10$CP8hBtf8GD7o0RkVW6qCkOqlZrnq/1HT4bupLRUA8Db6gUUOJR27q	System	Administrator	0123456789	System Address	\N	\N	\N	\N	t	2025-10-14 17:06:34.702618	2025-10-14 17:06:34.703617
\.


--
-- Data for Name: vehicle_brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_brands (brand_id, brand_name, country, founded_year, brand_logo_url, brand_logo_path, is_active, created_at) FROM stdin;
1	Tesla	USA	2003	https://example.com/logos/tesla-logo.png	\N	t	2025-10-14 23:14:45.443104
2	BYD	China	1995	https://example.com/logos/byd-logo.png	\N	t	2025-10-14 23:14:45.443104
3	VinFast	Vietnam	2017	https://example.com/logos/vinfast-logo.png	\N	t	2025-10-14 23:15:14.855996
4	BMW	Germany	1916	https://example.com/logos/bmw-logo.png	\N	t	2025-10-14 23:15:14.855996
5	Mercedes-Benz	Germany	1926	https://example.com/logos/mercedes-logo.png	\N	t	2025-10-14 23:15:14.855996
6	Mercedes	Germany	1926	\N	\N	t	2025-10-15 00:52:56.216723
\.


--
-- Data for Name: vehicle_colors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_colors (color_id, color_name, color_code, color_swatch_url, color_swatch_path, is_active) FROM stdin;
1	Pearl White	#FFFFFF	https://example.com/colors/pearl-white-swatch.jpg	\N	t
2	Deep Blue Metallic	#1E3A8A	https://example.com/colors/deep-blue-swatch.jpg	\N	t
3	Midnight Black	#000000	https://example.com/colors/midnight-black-swatch.jpg	\N	t
4	Ocean Blue	#0066CC	https://example.com/colors/ocean-blue-swatch.jpg	\N	t
5	Forest Green	#006600	https://example.com/colors/forest-green-swatch.jpg	\N	t
6	Sunset Red	#CC0000	https://example.com/colors/sunset-red-swatch.jpg	\N	t
7	Mineral White	#F5F5F5	\N	\N	t
\.


--
-- Data for Name: vehicle_deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_deliveries (delivery_id, order_id, inventory_id, customer_id, delivery_date, delivery_time, delivery_address, delivery_contact_name, delivery_contact_phone, delivery_status, delivery_notes, delivered_by, delivery_confirmation_date, customer_signature_url, customer_signature_path, created_at, updated_at) FROM stdin;
7258d184-b867-4637-8d70-7ea7235541b7	1a242971-a5d8-41ae-9681-0b4081c6a5da	863a8f02-b9ba-4f21-bbf9-5dd09b481532	e9c41a60-f600-4188-80fb-55fbc60ae128	2024-03-01	14:00:00	123 Le Loi Street, District 1, Ho Chi Minh City	Nguyen Van Minh	+84-901-234-567	scheduled	Giao xe vào buổi chiều	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	\N	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
b50bf23d-4032-4dc7-ae7e-13f35812b6b7	f574227f-d7c9-4145-91bd-a3b2bf409b6a	0b519b1c-e178-4ede-8a42-688362cb3198	23c800a2-5903-4b5e-bb41-c86e0e4a5107	2024-02-20	10:00:00	456 Nguyen Trai Street, Thanh Xuan District, Hanoi	Tran Thi Lan	+84-902-345-678	completed	Giao xe thành công	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	\N	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
8c435592-d7b2-4167-8a3e-5257bd94f078	c6544d05-f1e6-4842-a1cc-3a6af4a873e7	6d43eb8d-6a31-404e-abdb-9389b86e7c17	\N	2024-03-05	14:00:00	789 Tran Hung Dao Street, District 5, Ho Chi Minh City	Le Van Hoang	+84-903-456-789	scheduled	Giao xe BYD Atto 3 Standard	52b27bc0-f457-4f96-bcaf-d20daadf9f56	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:22.035186
36ee9421-1b34-4bdc-933e-9afeefda0f2e	1a242971-a5d8-41ae-9681-0b4081c6a5da	782dad0d-39d8-42c5-b7b7-961f4ad47372	\N	2024-03-08	10:00:00	321 Le Van Viet Street, Thu Duc City, Ho Chi Minh City	Nguyen Thi Thu	+84-904-567-890	scheduled	Giao xe BMW iX xDrive50	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
79d5f0e8-f74f-4027-bd5a-7ef530318894	1a242971-a5d8-41ae-9681-0b4081c6a5da	863a8f02-b9ba-4f21-bbf9-5dd09b481532	\N	2024-03-10	16:00:00	654 Nguyen Thi Minh Khai Street, District 3, Ho Chi Minh City	Pham Van Duc	+84-905-678-901	scheduled	Giao xe Mercedes EQS 450+	52b27bc0-f457-4f96-bcaf-d20daadf9f56	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:26:46.854412
c414bcff-3702-44d9-bb2d-4e57631ad8f8	1a242971-a5d8-41ae-9681-0b4081c6a5da	863a8f02-b9ba-4f21-bbf9-5dd09b481532	\N	2024-03-15	09:00:00	987 Vo Van Tan Street, District 3, Ho Chi Minh City	Tran Thi Mai	+84-906-789-012	completed	Giao xe VinFast VF 5 Plus thành công	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	\N	2025-10-14 23:18:22.035186	2025-10-14 23:26:46.854412
303a02fc-1116-4364-9d20-982acb374d7b	9d035558-89e5-4a9d-a6d9-1b6462f36ab4	5de1fc37-c8a6-4d87-bbf3-b2b7e3ae64f8	e9c41a60-f600-4188-80fb-55fbc60ae128	2024-03-15	14:00:00	123 Le Loi Street, District 1, Ho Chi Minh City	Nguyen Van Minh	+84-901-234-567	scheduled	Giao xe Tesla Model S Plaid	bdfccab5-9e07-49c7-bb2a-9b2f69521eeb	\N	\N	\N	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
2dd3fa6f-e03d-414e-a36d-677de326238a	5993dd7a-c68d-4f13-bf12-d97f4fa8b28b	a23adebe-e700-451e-b1c9-e54cd8ecc242	23c800a2-5903-4b5e-bb41-c86e0e4a5107	2024-03-16	10:00:00	456 Nguyen Trai Street, Thanh Xuan District, Hanoi	Tran Thi Lan	+84-902-345-678	scheduled	Giao xe Tesla Model X Plaid	52b27bc0-f457-4f96-bcaf-d20daadf9f56	\N	\N	\N	2025-10-14 23:46:18.12036	2025-10-14 23:46:18.12036
\.


--
-- Data for Name: vehicle_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_inventory (inventory_id, variant_id, color_id, warehouse_id, warehouse_location, vin, chassis_number, manufacturing_date, arrival_date, status, cost_price, selling_price, vehicle_images, interior_images, exterior_images, created_at, updated_at) FROM stdin;
863a8f02-b9ba-4f21-bbf9-5dd09b481532	1	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	Zone A - Premium	1HGBH41JXMN109186	\N	2024-01-15	2024-02-01	available	1000000000.00	1200000000.00	{"main": "https://example.com/images/vehicles/TSL-M3-SR-01-main.jpg", "rear": "https://example.com/images/vehicles/TSL-M3-SR-01-rear.jpg", "side": "https://example.com/images/vehicles/TSL-M3-SR-01-side.jpg", "front": "https://example.com/images/vehicles/TSL-M3-SR-01-front.jpg", "interior": "https://example.com/images/vehicles/TSL-M3-SR-01-interior.jpg"}	{"seats": "https://example.com/images/interior/TSL-M3-SR-01-seats.jpg", "console": "https://example.com/images/interior/TSL-M3-SR-01-console.jpg", "dashboard": "https://example.com/images/interior/TSL-M3-SR-01-dashboard.jpg"}	{"wheel": "https://example.com/images/exterior/TSL-M3-SR-01-wheel.jpg", "rear_view": "https://example.com/images/exterior/TSL-M3-SR-01-rear.jpg", "side_view": "https://example.com/images/exterior/TSL-M3-SR-01-side.jpg", "front_view": "https://example.com/images/exterior/TSL-M3-SR-01-front.jpg"}	2025-10-14 23:14:45.443104	2025-10-14 23:18:42.729405
c643fb9f-6c4c-4764-8e50-d0c383baab17	2	2	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	Zone B - Standard	1HGBH41JXMN109187	\N	2024-01-20	2024-02-05	available	700000000.00	800000000.00	{"main": "https://example.com/images/vehicles/TSL-MY-LR-01-main.jpg", "rear": "https://example.com/images/vehicles/TSL-MY-LR-01-rear.jpg", "side": "https://example.com/images/vehicles/TSL-MY-LR-01-side.jpg", "front": "https://example.com/images/vehicles/TSL-MY-LR-01-front.jpg", "interior": "https://example.com/images/vehicles/TSL-MY-LR-01-interior.jpg"}	{"seats": "https://example.com/images/interior/TSL-MY-LR-01-seats.jpg", "console": "https://example.com/images/interior/TSL-MY-LR-01-console.jpg", "dashboard": "https://example.com/images/interior/TSL-MY-LR-01-dashboard.jpg"}	{"wheel": "https://example.com/images/exterior/TSL-MY-LR-01-wheel.jpg", "rear_view": "https://example.com/images/exterior/TSL-MY-LR-01-rear.jpg", "side_view": "https://example.com/images/exterior/TSL-MY-LR-01-side.jpg", "front_view": "https://example.com/images/exterior/TSL-MY-LR-01-front.jpg"}	2025-10-14 23:14:45.443104	2025-10-14 23:18:42.729405
0b519b1c-e178-4ede-8a42-688362cb3198	6	4	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	Zone B - Standard	1HGBH41JXMN109188	\N	2024-01-25	2024-02-10	available	700000000.00	800000000.00	{"main": "https://example.com/images/vehicles/BYD-ATTO3-STD-01-main.jpg", "rear": "https://example.com/images/vehicles/BYD-ATTO3-STD-01-rear.jpg", "side": "https://example.com/images/vehicles/BYD-ATTO3-STD-01-side.jpg", "front": "https://example.com/images/vehicles/BYD-ATTO3-STD-01-front.jpg"}	{"seats": "https://example.com/images/interior/BYD-ATTO3-STD-01-seats.jpg", "dashboard": "https://example.com/images/interior/BYD-ATTO3-STD-01-dashboard.jpg"}	{"rear_view": "https://example.com/images/exterior/BYD-ATTO3-STD-01-rear.jpg", "side_view": "https://example.com/images/exterior/BYD-ATTO3-STD-01-side.jpg", "front_view": "https://example.com/images/exterior/BYD-ATTO3-STD-01-front.jpg"}	2025-10-14 23:15:14.855996	2025-10-14 23:18:42.729405
6d43eb8d-6a31-404e-abdb-9389b86e7c17	8	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	Zone C - Local	1HGBH41JXMN109189	\N	2024-02-01	2024-02-15	available	300000000.00	350000000.00	{"main": "https://example.com/images/vehicles/BMW-IX-XDRIVE50-01-main.jpg", "rear": "https://example.com/images/vehicles/BMW-IX-XDRIVE50-01-rear.jpg", "side": "https://example.com/images/vehicles/BMW-IX-XDRIVE50-01-side.jpg", "front": "https://example.com/images/vehicles/BMW-IX-XDRIVE50-01-front.jpg"}	{"seats": "https://example.com/images/interior/BMW-IX-XDRIVE50-01-seats.jpg", "dashboard": "https://example.com/images/interior/BMW-IX-XDRIVE50-01-dashboard.jpg"}	{"rear_view": "https://example.com/images/exterior/BMW-IX-XDRIVE50-01-rear.jpg", "side_view": "https://example.com/images/exterior/BMW-IX-XDRIVE50-01-side.jpg", "front_view": "https://example.com/images/exterior/BMW-IX-XDRIVE50-01-front.jpg"}	2025-10-14 23:15:14.855996	2025-10-14 23:18:42.729405
782dad0d-39d8-42c5-b7b7-961f4ad47372	10	5	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	Zone A - Premium	1HGBH41JXMN109190	\N	2024-02-05	2024-02-20	available	1500000000.00	1800000000.00	{"main": "https://example.com/images/vehicles/MB-EQS450-01-main.jpg", "rear": "https://example.com/images/vehicles/MB-EQS450-01-rear.jpg", "side": "https://example.com/images/vehicles/MB-EQS450-01-side.jpg", "front": "https://example.com/images/vehicles/MB-EQS450-01-front.jpg"}	{"seats": "https://example.com/images/interior/MB-EQS450-01-seats.jpg", "dashboard": "https://example.com/images/interior/MB-EQS450-01-dashboard.jpg"}	{"rear_view": "https://example.com/images/exterior/MB-EQS450-01-rear.jpg", "side_view": "https://example.com/images/exterior/MB-EQS450-01-side.jpg", "front_view": "https://example.com/images/exterior/MB-EQS450-01-front.jpg"}	2025-10-14 23:15:14.855996	2025-10-14 23:18:42.729405
d3105c40-d062-44d1-bd75-c3979af2b38f	\N	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	1HGBH41JXMN109192	\N	\N	\N	available	1000000000.00	1250000000.00	{}	{}	{}	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
e158e831-d652-407d-9b52-891f8526bc78	11	\N	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	1HGBH41JXMN109191	\N	\N	\N	available	1800000000.00	2300000000.00	{"main": "https://example.com/images/vehicles/VF-VF5PLUS-01-main.jpg", "rear": "https://example.com/images/vehicles/VF-VF5PLUS-01-rear.jpg", "side": "https://example.com/images/vehicles/VF-VF5PLUS-01-side.jpg", "front": "https://example.com/images/vehicles/VF-VF5PLUS-01-front.jpg"}	{"seats": "https://example.com/images/interior/VF-VF5PLUS-01-seats.jpg", "dashboard": "https://example.com/images/interior/VF-VF5PLUS-01-dashboard.jpg"}	{"rear_view": "https://example.com/images/exterior/VF-VF5PLUS-01-rear.jpg", "side_view": "https://example.com/images/exterior/VF-VF5PLUS-01-side.jpg", "front_view": "https://example.com/images/exterior/VF-VF5PLUS-01-front.jpg"}	2025-10-14 23:18:22.035186	2025-10-14 23:18:42.729405
902ddb7a-b06b-44da-913b-8f13621789a8	1	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	VIN000000000001	CHASSIS001	2025-08-14	2025-09-14	available	\N	1200000000.00	\N	\N	\N	2025-10-14 16:22:48.637603	2025-10-14 16:22:48.637603
39366961-364f-42c8-8041-1db3e3477756	2	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	VIN000000000002	CHASSIS002	2025-08-14	2025-09-14	available	\N	800000000.00	\N	\N	\N	2025-10-14 16:22:48.641635	2025-10-14 16:22:48.641635
acd3552f-8c31-48f3-9bea-752f67134c41	3	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	VIN000000000003	CHASSIS003	2025-08-14	2025-09-14	available	\N	1200000000.00	\N	\N	\N	2025-10-14 16:22:48.64561	2025-10-14 16:22:48.64561
5de1fc37-c8a6-4d87-bbf3-b2b7e3ae64f8	21	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	TSL-MS-PLAID-01	\N	\N	\N	available	2000000000.00	2500000000.00	\N	\N	\N	2025-10-14 23:34:45.81764	2025-10-14 23:34:45.81764
a23adebe-e700-451e-b1c9-e54cd8ecc242	22	3	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	TSL-MX-PLAID-01	\N	\N	\N	available	2200000000.00	2800000000.00	\N	\N	\N	2025-10-14 23:34:45.81764	2025-10-14 23:34:45.81764
31f94751-180c-4e9e-9940-243257df6a8c	3	1	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	TSL-M3-STD-01	\N	\N	\N	available	1000000000.00	1200000000.00	\N	\N	\N	2025-10-15 00:38:33.959218	2025-10-15 00:38:33.959218
09404900-2861-4e20-8322-239e8b018210	4	3	bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	\N	TSL-M3-LR-01	\N	\N	\N	available	1300000000.00	1500000000.00	\N	\N	\N	2025-10-15 00:52:56.216723	2025-10-15 00:52:56.216723
\.


--
-- Data for Name: vehicle_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_models (model_id, brand_id, model_name, model_year, vehicle_type, description, specifications, model_image_url, model_image_path, is_active, created_at) FROM stdin;
4	2	Seal	2024	sedan	BYD Seal - Premium Electric Sedan	\N	https://example.com/models/byd-seal.jpg	\N	t	2025-10-14 23:15:14.855996
6	3	VF 6	2024	suv	VinFast VF 6 - Mid-size Electric SUV	\N	https://example.com/models/vinfast-vf6.jpg	\N	t	2025-10-14 23:15:14.855996
1	1	Model 3	2024	sedan	Tesla Model 3 - Premium Electric Sedan	{"battery": {"type": "Lithium-ion", "capacity_kwh": 75, "charging_standard": "CCS2"}, "features": ["Autopilot", "Premium Interior", "Glass Roof", "Premium Audio"], "dimensions": {"width_mm": 1933, "height_mm": 1443, "length_mm": 4694, "wheelbase_mm": 2875}, "performance": {"top_speed": 225, "range_wltp": 430, "acceleration_0_100": 4.4}}	https://example.com/models/tesla-model3.jpg	\N	t	2025-10-14 23:14:45.443104
3	1	Model Y	2024	suv	Tesla Model Y - Electric SUV	{"battery": {"type": "Lithium-ion", "capacity_kwh": 60, "charging_standard": "CCS2"}, "features": ["Standard Interior", "Glass Roof", "Premium Audio"], "dimensions": {"width_mm": 1933, "height_mm": 1443, "length_mm": 4694, "wheelbase_mm": 2875}, "performance": {"top_speed": 225, "range_wltp": 430, "acceleration_0_100": 5.6}}	https://example.com/models/tesla-modely.jpg	\N	t	2025-10-14 23:15:14.855996
2	2	Atto 3	2024	suv	BYD Atto 3 - Compact Electric SUV	{"battery": {"type": "Lithium-ion", "capacity_kwh": 50, "charging_standard": "CCS2"}, "features": ["Standard Interior", "Basic Audio"], "dimensions": {"width_mm": 1850, "height_mm": 1660, "length_mm": 4385, "wheelbase_mm": 2600}, "performance": {"top_speed": 160, "range_wltp": 320, "acceleration_0_100": 7.3}}	https://example.com/models/byd-atto3.jpg	\N	t	2025-10-14 23:14:45.443104
7	4	iX	2024	suv	BMW iX - Luxury Electric SUV	{"battery": {"type": "Lithium-ion", "capacity_kwh": 105, "charging_standard": "CCS2"}, "features": ["Luxury Interior", "Panoramic Roof", "Premium Audio", "Advanced Driver Assistance"], "dimensions": {"width_mm": 1967, "height_mm": 1696, "length_mm": 4953, "wheelbase_mm": 3000}, "performance": {"top_speed": 200, "range_wltp": 630, "acceleration_0_100": 4.6}}	https://example.com/models/bmw-ix.jpg	\N	t	2025-10-14 23:15:14.855996
8	5	EQS	2024	sedan	Mercedes EQS - Luxury Electric Sedan	{"battery": {"type": "Lithium-ion", "capacity_kwh": 90, "charging_standard": "CCS2"}, "features": ["Luxury Interior", "Panoramic Roof", "Premium Audio", "Advanced Driver Assistance"], "dimensions": {"width_mm": 1959, "height_mm": 1518, "length_mm": 5125, "wheelbase_mm": 3210}, "performance": {"top_speed": 210, "range_wltp": 580, "acceleration_0_100": 6.2}}	https://example.com/models/mercedes-eqs.jpg	\N	t	2025-10-14 23:15:14.855996
5	3	VF 5	2024	suv	VinFast VF 5 - Compact Electric SUV	{"battery": {"type": "Lithium-ion", "capacity_kwh": 42, "charging_standard": "CCS2"}, "features": ["Standard Interior", "Basic Audio"], "dimensions": {"width_mm": 1713, "height_mm": 1613, "length_mm": 3965, "wheelbase_mm": 2500}, "performance": {"top_speed": 130, "range_wltp": 300, "acceleration_0_100": 8.5}}	https://example.com/models/vinfast-vf5.jpg	\N	t	2025-10-14 23:15:14.855996
11	1	Model S	2024	Sedan	Tesla Model S - Luxury Electric Sedan	\N	\N	\N	t	2025-10-14 23:34:45.81764
12	1	Model X	2024	SUV	Tesla Model X - Luxury Electric SUV	\N	\N	\N	t	2025-10-14 23:34:45.81764
13	2	Atto 3 Extended	2024	SUV	BYD Atto 3 Extended Range	\N	\N	\N	t	2025-10-14 23:46:18.12036
14	4	iX3	2024	SUV	BMW iX3 Electric SUV	\N	\N	\N	t	2025-10-14 23:46:18.12036
15	\N	EQC	2024	SUV	Mercedes EQC Electric SUV	\N	\N	\N	t	2025-10-14 23:46:18.12036
16	3	VF 8	2024	SUV	VinFast VF 8 Electric SUV	\N	\N	\N	t	2025-10-14 23:46:18.12036
17	4	i3	2024	Hatchback	BMW i3 - Electric Hatchback	\N	\N	\N	t	2025-10-14 23:55:04.597762
18	\N	EQS	2024	Sedan	Mercedes EQS - Luxury Electric Sedan	\N	\N	\N	t	2025-10-14 23:55:04.597762
19	3	VF 9	2024	SUV	VinFast VF 9 - Electric SUV	\N	\N	\N	t	2025-10-14 23:55:04.597762
\.


--
-- Data for Name: vehicle_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_variants (variant_id, model_id, variant_name, battery_capacity, range_km, power_kw, acceleration_0_100, top_speed, charging_time_fast, charging_time_slow, price_base, variant_image_url, variant_image_path, is_active, created_at) FROM stdin;
1	1	Standard Range	60.00	430	220.00	\N	\N	\N	\N	1200000000.00	https://example.com/variants/tesla-model3-standard.jpg	\N	t	2025-10-14 23:14:45.443104
2	2	Standard	50.10	480	150.00	\N	\N	\N	\N	800000000.00	https://example.com/variants/byd-atto3-standard.jpg	\N	t	2025-10-14 23:14:45.443104
3	1	Model 3 Standard Range	60.00	430	220.00	\N	\N	\N	\N	1200000000.00	https://example.com/variants/tesla-model3-standard.jpg	\N	t	2025-10-14 23:15:14.855996
4	1	Model 3 Long Range	75.00	560	283.00	\N	\N	\N	\N	1400000000.00	https://example.com/variants/tesla-model3-longrange.jpg	\N	t	2025-10-14 23:15:14.855996
5	3	Model Y Standard Range	60.00	455	220.00	\N	\N	\N	\N	1300000000.00	https://example.com/variants/tesla-modely-standard.jpg	\N	t	2025-10-14 23:15:14.855996
6	2	Atto 3 Standard	50.10	480	150.00	\N	\N	\N	\N	800000000.00	https://example.com/variants/byd-atto3-standard.jpg	\N	t	2025-10-14 23:15:14.855996
7	4	Seal Standard	61.40	550	150.00	\N	\N	\N	\N	1000000000.00	https://example.com/variants/byd-seal-standard.jpg	\N	t	2025-10-14 23:15:14.855996
8	5	VF 5 Standard	37.20	300	110.00	\N	\N	\N	\N	350000000.00	https://example.com/variants/vinfast-vf5-standard.jpg	\N	t	2025-10-14 23:15:14.855996
9	6	VF 6 Standard	42.00	350	150.00	\N	\N	\N	\N	450000000.00	https://example.com/variants/vinfast-vf6-standard.jpg	\N	t	2025-10-14 23:15:14.855996
10	7	iX xDrive40	76.60	425	240.00	\N	\N	\N	\N	1800000000.00	https://example.com/variants/bmw-ix-xdrive40.jpg	\N	t	2025-10-14 23:15:14.855996
11	8	EQS 450+	107.80	770	245.00	\N	\N	\N	\N	2000000000.00	https://example.com/variants/mercedes-eqs-450plus.jpg	\N	t	2025-10-14 23:15:14.855996
12	1	Standard Range	60.00	358	\N	5.60	225	8	\N	1200000000.00	\N	\N	t	2025-10-14 16:23:27.425866
13	1	Long Range	75.00	602	\N	4.40	233	10	\N	1500000000.00	\N	\N	t	2025-10-14 16:23:27.438832
14	3	Standard Range	60.00	455	\N	5.00	217	8	\N	1400000000.00	\N	\N	t	2025-10-14 16:23:27.440832
15	1	Standard Range	60.00	358	\N	5.60	225	8	\N	1200000000.00	\N	\N	t	2025-10-14 16:27:47.286627
16	1	Long Range	75.00	602	\N	4.40	233	10	\N	1500000000.00	\N	\N	t	2025-10-14 16:27:47.291164
17	3	Standard Range	60.00	455	\N	5.00	217	8	\N	1400000000.00	\N	\N	t	2025-10-14 16:27:47.292743
18	1	Standard Range	60.00	358	\N	5.60	225	8	\N	1200000000.00	\N	\N	t	2025-10-14 16:30:50.235328
19	1	Long Range	75.00	602	\N	4.40	233	10	\N	1500000000.00	\N	\N	t	2025-10-14 16:30:50.23784
20	3	Standard Range	60.00	455	\N	5.00	217	8	\N	1400000000.00	\N	\N	t	2025-10-14 16:30:50.239846
21	11	Model S Plaid	100.00	600	750.00	2.10	322	15	360	2500000000.00	\N	\N	t	2025-10-14 23:34:45.81764
22	12	Model X Plaid	100.00	560	750.00	2.60	262	15	360	2800000000.00	\N	\N	t	2025-10-14 23:34:45.81764
23	13	Atto 3 Extended Range	60.00	480	150.00	7.30	160	30	480	1200000000.00	\N	\N	t	2025-10-14 23:46:18.12036
24	14	iX3 xDrive30	80.00	460	210.00	6.80	180	32	450	2000000000.00	\N	\N	t	2025-10-14 23:46:18.12036
25	\N	EQC 400	80.00	417	300.00	5.10	180	40	480	2400000000.00	\N	\N	t	2025-10-14 23:46:18.12036
26	16	VF 8 Plus	87.70	471	300.00	5.50	200	35	420	1500000000.00	\N	\N	t	2025-10-14 23:46:18.12036
27	3	Model Y Long Range	75.00	480	330.00	5.00	217	25	300	1800000000.00	\N	\N	t	2025-10-14 23:55:04.597762
28	17	i3 120Ah	42.20	310	125.00	7.30	150	35	420	1000000000.00	\N	\N	t	2025-10-14 23:55:04.597762
29	\N	EQS 450+	107.80	770	245.00	6.20	210	31	420	2500000000.00	\N	\N	t	2025-10-14 23:55:04.597762
30	19	VF 9 Eco	92.00	438	300.00	6.50	200	35	420	1800000000.00	\N	\N	t	2025-10-14 23:55:04.597762
31	1	Standard Range	60.00	358	\N	5.60	225	8	\N	1200000000.00	\N	\N	t	2025-10-14 17:06:31.856392
32	1	Long Range	75.00	602	\N	4.40	233	10	\N	1500000000.00	\N	\N	t	2025-10-14 17:06:31.873634
33	3	Standard Range	60.00	455	\N	5.00	217	8	\N	1400000000.00	\N	\N	t	2025-10-14 17:06:31.875671
\.


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warehouse (warehouse_id, warehouse_name, warehouse_code, address, city, province, postal_code, phone, email, capacity, is_active, created_at, updated_at) FROM stdin;
bf6844aa-e6d6-4d13-aef2-b2b0aa1a8a5a	EV Main Warehouse	MAIN_WAREHOUSE	1000 Industrial Zone, District 7	Ho Chi Minh City	Ho Chi Minh	\N	+84-28-999-0000	warehouse@evm.com	\N	t	2025-10-14 23:14:45.443104	2025-10-14 23:14:45.443104
327d9ece-ebf8-48cb-96e2-68bf264df4dc	Hanoi Warehouse	HN_WAREHOUSE	500 Industrial Zone, Long Bien	Hanoi	Hanoi	\N	+84-24-999-0000	warehouse.hn@evm.com	800	t	2025-10-14 23:15:14.855996	2025-10-14 23:15:14.855996
6c43d089-8da5-49fa-b521-aac2e094b964	HCM Warehouse	HCM-001	789 Nguyen Van Linh Street, District 7	Ho Chi Minh City	Ho Chi Minh	\N	+84-903-456-789	warehouse@evdealer.com	\N	t	2025-10-15 00:52:56.216723	2025-10-15 00:52:56.216723
\.


--
-- Name: user_roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_role_id_seq', 5, true);


--
-- Name: vehicle_brands_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicle_brands_brand_id_seq', 6, true);


--
-- Name: vehicle_colors_color_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicle_colors_color_id_seq', 7, true);


--
-- Name: vehicle_models_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicle_models_model_id_seq', 20, true);


--
-- Name: vehicle_variants_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicle_variants_variant_id_seq', 33, true);


--
-- Name: customer_feedbacks customer_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_feedbacks
    ADD CONSTRAINT customer_feedbacks_pkey PRIMARY KEY (feedback_id);


--
-- Name: customer_payments customer_payments_payment_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payments
    ADD CONSTRAINT customer_payments_payment_number_key UNIQUE (payment_number);


--
-- Name: customer_payments customer_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payments
    ADD CONSTRAINT customer_payments_pkey PRIMARY KEY (payment_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: dealer_contracts dealer_contracts_contract_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_contracts
    ADD CONSTRAINT dealer_contracts_contract_number_key UNIQUE (contract_number);


--
-- Name: dealer_contracts dealer_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_contracts
    ADD CONSTRAINT dealer_contracts_pkey PRIMARY KEY (contract_id);


--
-- Name: dealer_discount_policies dealer_discount_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_discount_policies
    ADD CONSTRAINT dealer_discount_policies_pkey PRIMARY KEY (policy_id);


--
-- Name: dealer_installment_plans dealer_installment_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_installment_plans
    ADD CONSTRAINT dealer_installment_plans_pkey PRIMARY KEY (plan_id);


--
-- Name: dealer_installment_schedules dealer_installment_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_installment_schedules
    ADD CONSTRAINT dealer_installment_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: dealer_invoices dealer_invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_invoices
    ADD CONSTRAINT dealer_invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: dealer_invoices dealer_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_invoices
    ADD CONSTRAINT dealer_invoices_pkey PRIMARY KEY (invoice_id);


--
-- Name: dealer_orders dealer_orders_dealer_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_orders
    ADD CONSTRAINT dealer_orders_dealer_order_number_key UNIQUE (dealer_order_number);


--
-- Name: dealer_orders dealer_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_orders
    ADD CONSTRAINT dealer_orders_pkey PRIMARY KEY (dealer_order_id);


--
-- Name: dealer_payments dealer_payments_payment_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_payments
    ADD CONSTRAINT dealer_payments_payment_number_key UNIQUE (payment_number);


--
-- Name: dealer_payments dealer_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_payments
    ADD CONSTRAINT dealer_payments_pkey PRIMARY KEY (payment_id);


--
-- Name: dealer_targets dealer_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_targets
    ADD CONSTRAINT dealer_targets_pkey PRIMARY KEY (target_id);


--
-- Name: installment_plans installment_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installment_plans
    ADD CONSTRAINT installment_plans_pkey PRIMARY KEY (plan_id);


--
-- Name: installment_schedules installment_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installment_schedules
    ADD CONSTRAINT installment_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (promotion_id);


--
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (quotation_id);


--
-- Name: quotations quotations_quotation_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_quotation_number_key UNIQUE (quotation_number);


--
-- Name: sales_contracts sales_contracts_contract_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_contracts
    ADD CONSTRAINT sales_contracts_contract_number_key UNIQUE (contract_number);


--
-- Name: sales_contracts sales_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_contracts
    ADD CONSTRAINT sales_contracts_pkey PRIMARY KEY (contract_id);


--
-- Name: test_drive_schedules test_drive_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_drive_schedules
    ADD CONSTRAINT test_drive_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (role_id);


--
-- Name: user_roles user_roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_name_key UNIQUE (role_name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vehicle_brands vehicle_brands_brand_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_brands
    ADD CONSTRAINT vehicle_brands_brand_name_key UNIQUE (brand_name);


--
-- Name: vehicle_brands vehicle_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_brands
    ADD CONSTRAINT vehicle_brands_pkey PRIMARY KEY (brand_id);


--
-- Name: vehicle_colors vehicle_colors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_colors
    ADD CONSTRAINT vehicle_colors_pkey PRIMARY KEY (color_id);


--
-- Name: vehicle_deliveries vehicle_deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_deliveries
    ADD CONSTRAINT vehicle_deliveries_pkey PRIMARY KEY (delivery_id);


--
-- Name: vehicle_inventory vehicle_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_inventory
    ADD CONSTRAINT vehicle_inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: vehicle_inventory vehicle_inventory_vin_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_inventory
    ADD CONSTRAINT vehicle_inventory_vin_key UNIQUE (vin);


--
-- Name: vehicle_models vehicle_models_brand_id_model_name_model_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT vehicle_models_brand_id_model_name_model_year_key UNIQUE (brand_id, model_name, model_year);


--
-- Name: vehicle_models vehicle_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT vehicle_models_pkey PRIMARY KEY (model_id);


--
-- Name: vehicle_variants vehicle_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_variants
    ADD CONSTRAINT vehicle_variants_pkey PRIMARY KEY (variant_id);


--
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (warehouse_id);


--
-- Name: idx_customer_payments_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_payments_order_id ON public.customer_payments USING btree (order_id);


--
-- Name: idx_customer_payments_payment_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_payments_payment_date ON public.customer_payments USING btree (payment_date);


--
-- Name: idx_customer_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_payments_status ON public.customer_payments USING btree (status);


--
-- Name: idx_customers_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_created_at ON public.customers USING btree (created_at);


--
-- Name: idx_customers_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_email ON public.customers USING btree (email);


--
-- Name: idx_customers_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_phone ON public.customers USING btree (phone);


--
-- Name: idx_dealer_contracts_contract_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_contracts_contract_status ON public.dealer_contracts USING btree (contract_status);


--
-- Name: idx_dealer_contracts_contract_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_contracts_contract_type ON public.dealer_contracts USING btree (contract_type);


--
-- Name: idx_dealer_contracts_end_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_contracts_end_date ON public.dealer_contracts USING btree (end_date);


--
-- Name: idx_dealer_contracts_start_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_contracts_start_date ON public.dealer_contracts USING btree (start_date);


--
-- Name: idx_dealer_installment_plans_invoice_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_installment_plans_invoice_id ON public.dealer_installment_plans USING btree (invoice_id);


--
-- Name: idx_dealer_installment_plans_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_installment_plans_status ON public.dealer_installment_plans USING btree (plan_status);


--
-- Name: idx_dealer_installment_schedules_due_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_installment_schedules_due_date ON public.dealer_installment_schedules USING btree (due_date);


--
-- Name: idx_dealer_installment_schedules_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_installment_schedules_plan_id ON public.dealer_installment_schedules USING btree (plan_id);


--
-- Name: idx_dealer_installment_schedules_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_installment_schedules_status ON public.dealer_installment_schedules USING btree (status);


--
-- Name: idx_dealer_payments_invoice_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_payments_invoice_id ON public.dealer_payments USING btree (invoice_id);


--
-- Name: idx_dealer_targets_target_month; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_targets_target_month ON public.dealer_targets USING btree (target_month);


--
-- Name: idx_dealer_targets_target_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_targets_target_status ON public.dealer_targets USING btree (target_status);


--
-- Name: idx_dealer_targets_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_targets_target_type ON public.dealer_targets USING btree (target_type);


--
-- Name: idx_dealer_targets_target_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dealer_targets_target_year ON public.dealer_targets USING btree (target_year);


--
-- Name: idx_installment_plans_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_plans_customer_id ON public.installment_plans USING btree (customer_id);


--
-- Name: idx_installment_plans_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_plans_order_id ON public.installment_plans USING btree (order_id);


--
-- Name: idx_installment_plans_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_plans_status ON public.installment_plans USING btree (plan_status);


--
-- Name: idx_installment_schedules_due_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_schedules_due_date ON public.installment_schedules USING btree (due_date);


--
-- Name: idx_installment_schedules_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_schedules_plan_id ON public.installment_schedules USING btree (plan_id);


--
-- Name: idx_installment_schedules_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_installment_schedules_status ON public.installment_schedules USING btree (status);


--
-- Name: idx_orders_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_customer_id ON public.orders USING btree (customer_id);


--
-- Name: idx_orders_order_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_order_date ON public.orders USING btree (order_date);


--
-- Name: idx_orders_order_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_order_number ON public.orders USING btree (order_number);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_sales_contracts_contract_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sales_contracts_contract_date ON public.sales_contracts USING btree (contract_date);


--
-- Name: idx_sales_contracts_contract_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sales_contracts_contract_status ON public.sales_contracts USING btree (contract_status);


--
-- Name: idx_sales_contracts_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sales_contracts_customer_id ON public.sales_contracts USING btree (customer_id);


--
-- Name: idx_sales_contracts_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sales_contracts_order_id ON public.sales_contracts USING btree (order_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_is_active ON public.users USING btree (is_active);


--
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- Name: idx_vehicle_deliveries_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_deliveries_customer_id ON public.vehicle_deliveries USING btree (customer_id);


--
-- Name: idx_vehicle_deliveries_delivery_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_deliveries_delivery_date ON public.vehicle_deliveries USING btree (delivery_date);


--
-- Name: idx_vehicle_deliveries_delivery_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_deliveries_delivery_status ON public.vehicle_deliveries USING btree (delivery_status);


--
-- Name: idx_vehicle_deliveries_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_deliveries_order_id ON public.vehicle_deliveries USING btree (order_id);


--
-- Name: idx_vehicle_inventory_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_inventory_status ON public.vehicle_inventory USING btree (status);


--
-- Name: idx_vehicle_inventory_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_inventory_variant_id ON public.vehicle_inventory USING btree (variant_id);


--
-- Name: idx_vehicle_inventory_vin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_inventory_vin ON public.vehicle_inventory USING btree (vin);


--
-- Name: idx_vehicle_models_brand_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_models_brand_id ON public.vehicle_models USING btree (brand_id);


--
-- Name: idx_vehicle_variants_model_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_variants_model_id ON public.vehicle_variants USING btree (model_id);


--
-- Name: customer_feedbacks update_customer_feedbacks_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_customer_feedbacks_updated_at BEFORE UPDATE ON public.customer_feedbacks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: customers update_customers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dealer_contracts update_dealer_contracts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_dealer_contracts_updated_at BEFORE UPDATE ON public.dealer_contracts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dealer_discount_policies update_dealer_discount_policies_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_dealer_discount_policies_updated_at BEFORE UPDATE ON public.dealer_discount_policies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dealer_invoices update_dealer_invoices_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_dealer_invoices_updated_at BEFORE UPDATE ON public.dealer_invoices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dealer_orders update_dealer_orders_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_dealer_orders_updated_at BEFORE UPDATE ON public.dealer_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dealer_targets update_dealer_targets_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_dealer_targets_updated_at BEFORE UPDATE ON public.dealer_targets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: orders update_orders_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: promotions update_promotions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_promotions_updated_at BEFORE UPDATE ON public.promotions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: quotations update_quotations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_quotations_updated_at BEFORE UPDATE ON public.quotations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: sales_contracts update_sales_contracts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_sales_contracts_updated_at BEFORE UPDATE ON public.sales_contracts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: test_drive_schedules update_test_drive_schedules_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_test_drive_schedules_updated_at BEFORE UPDATE ON public.test_drive_schedules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: vehicle_deliveries update_vehicle_deliveries_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_vehicle_deliveries_updated_at BEFORE UPDATE ON public.vehicle_deliveries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: vehicle_inventory update_vehicle_inventory_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_vehicle_inventory_updated_at BEFORE UPDATE ON public.vehicle_inventory FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: customer_feedbacks customer_feedbacks_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_feedbacks
    ADD CONSTRAINT customer_feedbacks_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: customer_feedbacks customer_feedbacks_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_feedbacks
    ADD CONSTRAINT customer_feedbacks_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: customer_payments customer_payments_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payments
    ADD CONSTRAINT customer_payments_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: customer_payments customer_payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payments
    ADD CONSTRAINT customer_payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: customer_payments customer_payments_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_payments
    ADD CONSTRAINT customer_payments_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(user_id);


--
-- Name: dealer_discount_policies dealer_discount_policies_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_discount_policies
    ADD CONSTRAINT dealer_discount_policies_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.vehicle_variants(variant_id);


--
-- Name: dealer_installment_plans dealer_installment_plans_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_installment_plans
    ADD CONSTRAINT dealer_installment_plans_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.dealer_invoices(invoice_id);


--
-- Name: dealer_installment_schedules dealer_installment_schedules_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_installment_schedules
    ADD CONSTRAINT dealer_installment_schedules_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.dealer_installment_plans(plan_id);


--
-- Name: dealer_invoices dealer_invoices_dealer_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_invoices
    ADD CONSTRAINT dealer_invoices_dealer_order_id_fkey FOREIGN KEY (dealer_order_id) REFERENCES public.dealer_orders(dealer_order_id);


--
-- Name: dealer_invoices dealer_invoices_evm_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_invoices
    ADD CONSTRAINT dealer_invoices_evm_staff_id_fkey FOREIGN KEY (evm_staff_id) REFERENCES public.users(user_id);


--
-- Name: dealer_orders dealer_orders_evm_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_orders
    ADD CONSTRAINT dealer_orders_evm_staff_id_fkey FOREIGN KEY (evm_staff_id) REFERENCES public.users(user_id);


--
-- Name: dealer_payments dealer_payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealer_payments
    ADD CONSTRAINT dealer_payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.dealer_invoices(invoice_id);


--
-- Name: installment_plans installment_plans_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installment_plans
    ADD CONSTRAINT installment_plans_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: installment_plans installment_plans_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installment_plans
    ADD CONSTRAINT installment_plans_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: installment_schedules installment_schedules_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installment_schedules
    ADD CONSTRAINT installment_schedules_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.installment_plans(plan_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: orders orders_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.vehicle_inventory(inventory_id);


--
-- Name: orders orders_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(quotation_id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: promotions promotions_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.vehicle_variants(variant_id);


--
-- Name: quotations quotations_color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.vehicle_colors(color_id);


--
-- Name: quotations quotations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: quotations quotations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: quotations quotations_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.vehicle_variants(variant_id);


--
-- Name: sales_contracts sales_contracts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_contracts
    ADD CONSTRAINT sales_contracts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: sales_contracts sales_contracts_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_contracts
    ADD CONSTRAINT sales_contracts_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: sales_contracts sales_contracts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_contracts
    ADD CONSTRAINT sales_contracts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: test_drive_schedules test_drive_schedules_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_drive_schedules
    ADD CONSTRAINT test_drive_schedules_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: test_drive_schedules test_drive_schedules_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_drive_schedules
    ADD CONSTRAINT test_drive_schedules_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.vehicle_variants(variant_id);


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(role_id);


--
-- Name: vehicle_deliveries vehicle_deliveries_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_deliveries
    ADD CONSTRAINT vehicle_deliveries_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: vehicle_deliveries vehicle_deliveries_delivered_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_deliveries
    ADD CONSTRAINT vehicle_deliveries_delivered_by_fkey FOREIGN KEY (delivered_by) REFERENCES public.users(user_id);


--
-- Name: vehicle_deliveries vehicle_deliveries_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_deliveries
    ADD CONSTRAINT vehicle_deliveries_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.vehicle_inventory(inventory_id);


--
-- Name: vehicle_deliveries vehicle_deliveries_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_deliveries
    ADD CONSTRAINT vehicle_deliveries_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: vehicle_inventory vehicle_inventory_color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_inventory
    ADD CONSTRAINT vehicle_inventory_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.vehicle_colors(color_id);


--
-- Name: vehicle_inventory vehicle_inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_inventory
    ADD CONSTRAINT vehicle_inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.vehicle_variants(variant_id);


--
-- Name: vehicle_inventory vehicle_inventory_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_inventory
    ADD CONSTRAINT vehicle_inventory_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouse(warehouse_id);


--
-- Name: vehicle_models vehicle_models_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT vehicle_models_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.vehicle_brands(brand_id);


--
-- Name: vehicle_variants vehicle_variants_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_variants
    ADD CONSTRAINT vehicle_variants_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.vehicle_models(model_id);


--
-- PostgreSQL database dump complete
--

\unrestrict h8AdwPP9XCHu7xKpFTjZnH8l4dcKrtoFid3DXcShG2pwFhCB1ehO6UiawBc20pb

