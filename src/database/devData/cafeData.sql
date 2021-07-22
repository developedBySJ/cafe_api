--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: assets_type_enum; Type: TYPE; Schema: public; Owner: battlefield
--

CREATE TYPE public.assets_type_enum AS ENUM (
    'avatar',
    'review',
    'menuItem',
    'menu',
    'other'
);


ALTER TYPE public.assets_type_enum OWNER TO battlefield;

--
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: battlefield
--

CREATE TYPE public.users_role_enum AS ENUM (
    'admin',
    'manager',
    'cashier',
    'chef',
    'waiter',
    'customer'
);


ALTER TYPE public.users_role_enum OWNER TO battlefield;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.assets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    public_id character varying NOT NULL,
    url character varying NOT NULL,
    format character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by uuid,
    type public.assets_type_enum NOT NULL
);


ALTER TABLE public.assets OWNER TO battlefield;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.inventory (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    available_stock integer NOT NULL,
    image character varying,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by uuid,
    units text[] DEFAULT '{}'::text[] NOT NULL,
    unit character varying
);


ALTER TABLE public.inventory OWNER TO battlefield;

--
-- Name: inventory_usage; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.inventory_usage (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    qty integer NOT NULL,
    unit character varying,
    is_added boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    "inventoryId" uuid,
    "consumerId" uuid
);


ALTER TABLE public.inventory_usage OWNER TO battlefield;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.menu_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    sub_title character varying,
    images text[] DEFAULT '{}'::text[] NOT NULL,
    is_available boolean DEFAULT false NOT NULL,
    is_veg boolean DEFAULT false NOT NULL,
    price integer NOT NULL,
    discount integer DEFAULT 0 NOT NULL,
    description character varying,
    prep_type integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    "menuId" uuid,
    created_by uuid,
    ingredients text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE public.menu_items OWNER TO battlefield;

--
-- Name: menus; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.menus (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    image character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.menus OWNER TO battlefield;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.orders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    payment character varying,
    "table" character varying,
    total integer NOT NULL,
    status integer NOT NULL,
    notes character varying,
    "orderItems" jsonb NOT NULL,
    delivered_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    "userId" uuid
);


ALTER TABLE public.orders OWNER TO battlefield;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.reviews (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    comment character varying NOT NULL,
    image character varying,
    ratings integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by uuid,
    menu_item uuid
);


ALTER TABLE public.reviews OWNER TO battlefield;

--
-- Name: user_items; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.user_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    qty integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by uuid,
    menu_item uuid
);


ALTER TABLE public.user_items OWNER TO battlefield;

--
-- Name: users; Type: TABLE; Schema: public; Owner: battlefield
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64),
    email character varying(100) NOT NULL,
    password character varying NOT NULL,
    date_of_birth timestamp with time zone,
    role public.users_role_enum DEFAULT 'customer'::public.users_role_enum NOT NULL,
    address character varying(255),
    avatar character varying(512),
    password_reset_token character varying,
    password_reset_request_at timestamp without time zone,
    password_reset_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    current_hashed_refresh_token character varying
);


ALTER TABLE public.users OWNER TO battlefield;

--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.assets (id, public_id, url, format, created_at, created_by, type) FROM stdin;
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.inventory (id, name, available_stock, image, tags, created_at, updated_at, created_by, units, unit) FROM stdin;
01a732fd-11b1-4f9a-9cb0-7eefbdeb0b43	rice	10	\N	{food,imp}	2021-06-27 13:20:02.178199	2021-06-27 13:20:02.178199	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{l,ml}	l
82705060-3d5e-4879-8f3c-15cddf1a67f8	Water	10	\N	{liquid,imp}	2021-06-27 13:20:14.927408	2021-06-27 13:20:14.927408	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{l,ml}	l
f809128f-b4a9-47a0-9675-3aea9ac1a85d	Juice	10	\N	{liquid,food}	2021-06-27 13:23:44.924054	2021-06-27 13:23:44.924054	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{l,ml}	l
9780c5d5-a9a5-47e9-b3f1-7c14d8fb2feb	Mineral Water	10	\N	{Costly,food}	2021-06-27 15:58:12.663653	2021-06-27 15:58:12.663653	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{l,ml}	l
9eecaa5a-9235-4d1f-a138-376905bbbe54	Mineral	10	\N	{Costly,food}	2021-06-27 15:58:36.37702	2021-06-27 15:58:36.37702	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{l,ml}	l
\.


--
-- Data for Name: inventory_usage; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.inventory_usage (id, qty, unit, is_added, created_at, "inventoryId", "consumerId") FROM stdin;
b5870e28-d1d2-4210-8ffb-274c907c22f5	10	l	t	2021-06-27 15:58:12.715492	9780c5d5-a9a5-47e9-b3f1-7c14d8fb2feb	47752669-d9b2-4e21-b2e0-e49c0befbbb2
d2717753-824e-4892-81de-400135f76daf	10	l	t	2021-06-27 15:58:36.382609	9eecaa5a-9235-4d1f-a138-376905bbbe54	47752669-d9b2-4e21-b2e0-e49c0befbbb2
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.menu_items (id, title, sub_title, images, is_available, is_veg, price, discount, description, prep_type, created_at, updated_at, "menuId", created_by, ingredients) FROM stdin;
7b11779c-d11b-4d5b-8316-771b1e98dd1e	BBQ-Chicken 'n' Cheese Sandwich	376 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/145fbf17-1028-4fac-9fba-1670d43c9db3.jpg}	t	f	139	0	Shredded chicken, seasoned with sauces, seasonings and cheese, between toasted, chipotle mayo spread brown bread slices is all that you would need for a scrumptious anytime-meal. Trust us, you'll love it.	9	2021-07-11 22:57:32.388225	2021-07-11 22:57:32.388225	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0c4c4941-ecc3-4334-804a-d4719a9adbb0	Veggie Baked Pizza Sandwich	Continental	{https://d3gy1em549lxx2.cloudfront.net/4cf33c23-0c49-4f5a-a1e9-8adb65dfac57.JPG}	t	t	99	0	Order in this open sandwich to satisfy your savoury tooth! A topping of pizza sauce on a baguette bread base, seasoned corn, broccoli, spinach and mushroom all covered with cheese and baked to bubbly goodness! Garnished with more cheeeese..Perfect for your evening snack..Pair with your fav beverage!	14	2021-07-11 22:57:32.457361	2021-07-11 22:57:32.457361	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
8485cc0c-b138-409f-a216-df3caa4108f2	Citrus Chicken Sandwich	311 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/e6b53633-72a0-44ea-b20e-883f51696adf.jpg}	t	f	129	0	Thousand island spread thoroughly spices up a breast of chicken that is grilled, pulled while warm and moist that is then tossed with julienned onion, peppers, carrot and cabbage and filled between toasted brown bread slices, topped with cheese slice. Serves 1.	11	2021-07-11 22:57:32.495626	2021-07-11 22:57:32.495626	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
d8f006c7-15d7-468a-8957-7a624046fa83	Palak-Paneer Bhurji Wrap	649 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/d7ee7abc-49ee-4546-81de-d5e9c22e5f53.jpg}	t	t	149	0	Bite into this delicious protein-enriched goodness and drive your hunger away. This irresistible wrap is stuffed with shredded spinach sauteed with scrambled paneer, onion, tomato, all rolled in a whole wheat paratha. Go ahead, let your day be hearty.	6	2021-07-11 22:57:32.519036	2021-07-11 22:57:32.519036	65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4919ce1c-f57a-4237-82ec-2522a27cba06	Chef's Signature Grilled Chicken	Continental	{https://d3gy1em549lxx2.cloudfront.net/b440cfb1-20c0-4e10-8aa4-ad92405d2253.jpg}	t	f	249	0	Feast on a succulent chicken breast that is marinated overnight, seared on a hot plate and finished in an oven. Cooked in an exquisite 'Chef's Signature Sauce' made of brown sauce, caramelised onions and herbs. Served on a bed of aromatic herbed rice and crunchy sautéed veggies. All our meals are prepared fresh on order.	11	2021-07-11 22:57:32.545075	2021-07-11 22:57:32.545075	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a8c2624f-5559-46aa-8093-974bcb68f083	Mexican-Burrito Bowl	797 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/15f00ed8-9f00-4d11-a4f9-e0327cc308be.jpg}	t	t	219	0	Here is our all time favourite signature burrito bowl. Paneer steaks, infused with hot and tangy habanero-jalapeno duo, is grilled, sliced and served with an exciting satiating combo of tomato-paprika rice, spicy refried beans, crunchy roasted-corn salsa, tomato salsa and sour cream. All our meals are prepared fresh on order.	7	2021-07-11 22:57:32.569564	2021-07-11 22:57:32.569564	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
860db6f9-a4c4-4fc7-8aac-e2297a19f61d	Mutter Paneer with Jeera rice	Indian	{https://d3gy1em549lxx2.cloudfront.net/b840d1b6-a751-49b3-8f26-bdf478fb0da4.JPG}	t	t	219	0	Paneer cubes are fried and cooked with onions, garlic, spices and a special blend of buttery gravy along with green peas. Accompanied with jeera rice and topped with salad.	7	2021-07-11 22:57:32.592235	2021-07-11 22:57:32.592235	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
67580442-7d7c-4e6b-9a84-023a42935c08	Punjabi-Rajma-Masala Bowl	North Indian	{https://d3gy1em549lxx2.cloudfront.net/c27186fe-b645-438e-b80e-c2f23b3dc923.JPG}	t	t	175	0	Red kidney beans simmered and cooked in a delicious onion-tomato gravy, is paired with ghee jeera rice and crunchy mint laccha onions on top. Authentic punjabi dish loved by all.	8	2021-07-11 22:57:32.612229	2021-07-11 22:57:32.612229	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b2331745-8fd2-4cd5-9530-883987e7de71	Rajma-Rice Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/cdafd23c-e450-406f-bf72-ebbd9119e9ff.JPG}	t	t	189	0	Loaded with simple delicacy, this thali has jeera flavoured basmati rice, rajma curry cooked in a rich onion-tomato gravy, mixed vegetable, boondi raita and pickle.	12	2021-07-11 22:57:32.635255	2021-07-11 22:57:32.635255	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
22fe6ada-53cf-4bf9-a27c-cdc7853c7d43	Homestyle Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/81956ed5-8612-484d-b795-86420dd53a0d.JPG}	t	t	179	0	Dal makhani cooked in a rich buttery gravy is accompanied with jeera flavoured basmati rice, paratha, homemade aloo-carrot-beans dry veg, boondi raita and pickle.	13	2021-07-11 22:57:32.654781	2021-07-11 22:57:32.654781	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
48e77fed-fa10-4c4b-ba4b-2f5352cc2ac5	Schezwan Chicken Rice Bowl	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/384638b6-cb8a-480b-a6d3-f3f0904c6947.jpg}	t	f	229	0	Szechwan food is exemplified by the local fare in Chengdu and this chilli-oil flavoured fried rice, loaded with diced chicken pays tribute to this cuisine. Add in a Chengdu-style sauce and you’ve got Sichuan in a bowl. All our bowls are prepared fresh on your order.	13	2021-07-11 22:57:32.675178	2021-07-11 22:57:32.675178	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2ebe9355-571b-4389-b659-5ff7ec807fbd	Dragon Noodles with Dumplings	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/67b27ee2-76da-4eae-8511-d67f3b5ac54d.jpg}	t	t	229	0	Shiitake mushrooms and a handful of assorted crunchy veggies are seasoned in a hot wok and tossed with a fiery chilli paste and noodles. Pleasant little veggie dumplings made with potatoes, cabbage, carrot and coriander simmered in red and green-chilli infused soy sauce rounds off this lip-smacking meal. This has been one of our most popular meals on the menu. All our bowls are prepared fresh on your order.	7	2021-07-11 22:57:32.695891	2021-07-11 22:57:32.695891	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
3e76afb7-d627-44fc-9956-8d7885ffb76f	Keto Peri Peri Grilled Chicken Twin Steak	612 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/eca09ab8-af9f-4e77-8144-e75fb8002e4d.jpg}	t	f	349	0	Our chicken-steak bowl isn’t just delicious but a KETO meal too! Slices of peri-peri spiced, grilled chicken breasts are served with peppered, assorted veggies and a basil-flavoured cheese jus! Serves 1. Energy (Kcal): 612,Fat (g): 27, Carbs (g):17, Fiber (g):5, Protein (g): 69	12	2021-07-11 22:57:32.723804	2021-07-11 22:57:32.723804	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
31d1d335-7971-4ffa-a3ad-1a97066a6a38	Mutter Paneer Dum-Biriyani-(1KG)	Indian	{https://d3gy1em549lxx2.cloudfront.net/1eabfeff-7c25-401d-995c-49a09245b3e2.jpg}	t	t	479	0	Flavoured with exotic spices and known for its aroma, this dish features mutter paneer made with our own in-house recipe, paneer and green peas tossed in creamy rich onion tomato gravy and served with a delicious raita at the side, this is vegetarian biriyani-bliss reinvented.	14	2021-07-11 22:57:32.76102	2021-07-11 22:57:32.76102	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
65a7a3ed-f00e-4f3e-b74c-43cb106625ca	Murgh Makhani Dum Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/ad5251e4-40c7-4509-8995-868124ff018c.JPG}	t	f	229	0	Chicken tikka cooked in a delicious makhani gravy and essential powdered Indian spices, fiery gravy led by onion, yogurt and spices, are DUM cooked with layers of basmati rice boiled with aromatic whole Indian spices and steamed for an explosion of flavours. Served with Bhurani Raita. If you are up to pampering yourself with every mouthful, here’s what you have to think of!	8	2021-07-11 22:57:32.782626	2021-07-11 22:57:32.782626	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4087c01e-3ae7-43f5-bb2e-23b0883b26bb	Fresh Slaw Sandwich	486 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/a4df3e05-d65c-4505-a14b-700354331b07.jpg}	t	t	85	0	A comfort veg sandwich loaded with cabbage, carrots layered between delicious brown-bread slices. Enjoy this anytime of the day.	5	2021-07-11 22:57:32.45574	2021-07-11 22:57:32.45574	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
7a6e3af7-6334-4cb1-9a9c-29333e3064c9	Homestyle-Chicken Sandwich	348 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/7dc83cfd-a3ad-4c39-859b-cadb10840398.jpg}	t	f	129	0	This Chicken Sandwich is quite the testament. Grilled, pulled chicken, crunchy veggies and crushed black-pepper tossed with a creamy mayo sauce stuffed between layers and buttered brown bread. Serves 1.	9	2021-07-11 22:57:32.493097	2021-07-11 22:57:32.493097	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e5440a7d-f35b-4c37-8673-a7f3d8fc3197	Paneer Bhurji-Sandwich	569 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/d31cd9c7-881a-4293-bca7-33aed011b2e4.jpg}	t	t	129	0	The uncharacteristic paneer is transformed entirely when seasoned and fried with magical and essential Indian spices, tomatoes and coriander. Layered between our signature brown bread, this sandwich is a yummy on-the-go meal! Serves 1.	10	2021-07-11 22:57:32.516764	2021-07-11 22:57:32.516764	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
040ded5e-537d-4b3b-945c-8fab49e1a56d	The Mafia's Meal	622 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/ec687781-b969-4ceb-8fc9-0768c6e883a2.jpg}	t	f	249	0	Loaded with striking flavours, you are about to order your bowl of INDULGENCE. Habanero-spiced, roasted chicken breast topped with gooey mozzarella is served with seasonal veggies and spaghetti tossed with a freshly made herbed tomato sauce. This meal is the real Mexi-talian deal! All our meals are prepared fresh on order.	15	2021-07-11 22:57:32.541801	2021-07-11 22:57:32.541801	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
191f92f1-7ec2-402b-b797-1de377c3c493	Moroccan Spaghetti Meatballs	Continental	{https://d3gy1em549lxx2.cloudfront.net/963469bc-447b-4245-8baa-90cf620c22c4.JPG}	t	f	249	0	Meatballs are the easiest and comfortable way to add protein to almost any dish.These juicy meatballs are flavored with thyme, woodfired smoke seasoning, fresh parsley, eggs are served on a big bed of spaghetti tossed in chunky tomato sauce topped with parsley, olives and dry herbs. This will wow you. Order-in! All our meals are prepared fresh on order.	11	2021-07-11 22:57:32.567	2021-07-11 22:57:32.567	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c256b33f-462a-4b55-8de7-9554c954b12d	Butter Chicken Special Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/ee87ed23-2a8b-4d51-9e1e-b9e22009b276.jpg}	t	f	209	0	Butter Chicken and parathas - the BEST ever meal you could binge on! Accompanied with chole masala, boondi raita and mixed veg pickle. Prepared fresh on your order!	16	2021-07-11 22:57:32.589896	2021-07-11 22:57:32.589896	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c43762c0-6249-4e7c-bb37-79ea60745751	Butter Chicken 'n' Malabari Paratha	Indian	{https://d3gy1em549lxx2.cloudfront.net/54bae623-b4b3-4713-ac0f-1643e508da73.JPG}	t	f	199	0	There's no denying butter and chicken are a match made in heaven. Wholesome chicken legs are marinated, baked and cooked in a rich in-house Makhni gravy. Served along with two malabari parathas, this supreme desi delight is a super hit!	15	2021-07-11 22:57:32.610287	2021-07-11 22:57:32.610287	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
f69bdad4-afdc-45aa-9e41-98714b3ee1cf	Butter Chicken Fiesta Bowl	Indian	{https://d3gy1em549lxx2.cloudfront.net/9205427c-1278-469f-b4ae-a7f2fc12501a.JPG}	t	f	219	0	Butter Chicken gravy along with tawa subzi is a mouthful, not just of words, but of terrific flavour profiles. Grilled boneless chicken leg served on a bed of jeera rice, also tawa subzi alongside; is topped with mint chutney and lachha onions.	12	2021-07-11 22:57:32.633085	2021-07-11 22:57:32.633085	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a409be6c-d017-44c9-b280-f277065ba790	Methi Malai Chicken Thali	Indian	{https://d3gy1em549lxx2.cloudfront.net/d086b815-6ed2-4617-9151-ab452da7baca.jpg}	t	f	209	0	Methi (fresh fenugreek) combines beautifully with marinated chicken leg and fresh cream for an indulgent gravy. Served along with jeera rice, paratha, boondi raita, mixed veg pickle and dal makhani. Add-on a refreshing beverage or an indulgent dessert and enjoy!	11	2021-07-11 22:57:32.652646	2021-07-11 22:57:32.652646	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b8654b1b-f2f7-4f6f-801d-e5ddcb254bf1	Teriyaki Chicken Noodle Bowl	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/dbc3f731-5090-4708-8766-c50132154ca6.JPG}	t	f	219	0	A classic Japanese dish of broiling the chicken in the wok, glazing with Teriyaki and combining the flavours of the sauce in the noodles along with fresh veggies and egg. Truly a creation. This noodle bowl is a must try! All our bowls are prepared fresh on your order.	14	2021-07-11 22:57:32.673514	2021-07-11 22:57:32.673514	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
91494940-177b-4fb7-9670-1a1130eb9c0b	Hoisin Chicken Steak Bowl	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/7e129739-0f0a-4225-9247-fc11fa4cfd59.JPG}	t	f	249	0	This East Asian delight is a delicate balance of oriental flavours. Juicy chicken steak is perfectly marinated and baked, glazed in hoisin sauce to give it a sweet and salty flavour. This is served with aromatic fried rice and sauteed veggies and will have you savouring each bite to the fullest.	17	2021-07-11 22:57:32.69346	2021-07-11 22:57:32.69346	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
02f2a4bc-4f15-42f1-a5cb-601ca9aa3085	Stir-Fried-Chilli-Paneer Superbowl	358 cal | Low Carb	{https://d3gy1em549lxx2.cloudfront.net/3f78039f-c6e2-4145-8e74-c9123792eba1.jpg}	t	t	269	0	This peppery, spicy, and tangy chilli-infused dish is popular on our list of starters and appetizers. When served with a quinoa brown fried rice, this Indo-Chinese combo packs a mean, healthy punch. Serves 1.	14	2021-07-11 22:57:32.721577	2021-07-11 22:57:32.721577	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
597c81af-41c5-42f6-8846-565ad25a09be	Keto Peri Peri Grilled Chicken Steak	444 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/63a5f9ce-1552-4d7b-8ac2-c54c4d7fcae2.jpg}	t	f	229	0	Our chicken-steak bowl isn’t just delicious but a KETO meal too! Slices of peri-peri spiced, grilled chicken breast is served with peppered, assorted veggies and a basil-flavoured cheese jus! Serves 1. Energy (Kcal): 444,Fat (g): 22, Carbs (g):17, Fiber (g):5, Protein (g): 39	7	2021-07-11 22:57:32.753382	2021-07-11 22:57:32.753382	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
926bb85d-8f21-44f5-8241-efeec933223a	Murgh Makhani Dum Biriyani ( 1KG)	Indian	{https://d3gy1em549lxx2.cloudfront.net/ad5251e4-40c7-4509-8995-868124ff018c.JPG}	t	f	499	0	Chicken tikka cooked in a delicious makhani gravy and essential powdered Indian spices, fiery gravy led by onion, yogurt and spices, are DUM cooked with layers of basmati rice boiled with aromatic whole Indian spices and steamed for an explosion of flavours. Served with Bhurani Raita. If you are up to pampering yourself with every mouthful, here’s what you have to think of!	18	2021-07-11 22:57:32.773485	2021-07-11 22:57:32.773485	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
9c918dd6-a020-4008-ab03-cd3e26733f96	Paneer Butter Masala (450 Gms)	North Indian	{https://d3gy1em549lxx2.cloudfront.net/7e669f7c-335f-44d2-868f-fc3416b7a9ee.jpg}	t	t	249	0	Delicious paneer tikka cooked in a rich tomato makhani gravy. Pair up this curry with some homemade rotis/rice. Serves 2	12	2021-07-11 22:57:32.793112	2021-07-11 22:57:32.793112	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
16220440-9f33-4453-9c56-7d4d68c29b5b	Mexican-Pulled Chicken Sandwich	361 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/3c18ed21-0178-42fa-b5b1-cfcbbf2e82f0.jpg}	t	f	139	0	Grilled, pulled chicken tossed with peri-peri spice mix and tangy tomato packed between two buttered and toasted slices of our signature Marbled Brown Bread, with a crunchy mayo-tossed slaw – a meaty, creamy and heavenly sandwich that sums up YUM!	12	2021-07-11 22:57:32.45628	2021-07-11 22:57:32.45628	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
922a6498-ae54-47ec-a116-c3c04893fa2b	Cheesy Veg Sandwich	301 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/a564384f-46eb-4dce-a2e1-4447d4f2e34e.jpg}	t	t	129	0	This veggie sandwich contains loads of veggies like carrot, beans, bell peppers, sweet corn and spicy flavours. Tossed with seasoning and cheese sauce, placed between two slices of toasted brown bread slices.	13	2021-07-11 22:57:32.494058	2021-07-11 22:57:32.494058	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c11525e2-3f90-48d8-8fcc-c80f46eafc25	Fresh-Fruit Bowl	125 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/b8a790b2-a342-4306-910e-b13551c242bb.jpg}	t	t	119	0	A mix of bite sized pineapple, watermelon, muskmelon, papaya, apple, pomegranate; perfect to brighten up your day in the morning and fuel you up for the rest of the day.	12	2021-07-11 22:57:32.517471	2021-07-11 22:57:32.517471	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
99942e86-8b04-45c6-af59-59765dbb5af5	Penne Alfredo	738 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/c147774b-3037-4213-adfc-b37088280205.jpg}	t	t	219	0	Penne pasta tossed in a luscious alfredo sauce along with veggies, finished off with fresh parsley and grated cheese. Bring out the Kid-in-You! All our meals are prepared fresh on order.	12	2021-07-11 22:57:32.542528	2021-07-11 22:57:32.542528	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
23296916-0fcf-43f4-acc1-88b78ad34b76	Creamy Tuscan Chicken Spaghetti	538 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/573cc961-00f2-4bf5-a635-e118febcc89b.jpg}	t	f	239	0	A Tuscan-style hearty-spaghetti meal with creamy, cheesy béchamel, herbed roasted chicken, spinach, sun-dried tomatoes, topped with parmesan and parsley. All our meals are prepared fresh on order.	16	2021-07-11 22:57:32.567988	2021-07-11 22:57:32.567988	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b60435d7-0063-41ce-99e5-ddd0a9616fab	Butter-Chicken Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/f2dd82d9-2a61-4465-a3ae-6f21fd144238.jpg}	t	f	219	0	Packed with a delectable variety of delicacies, this thali is our top selling meal. Known by its name, butter chicken curry cooked in delish gravy is served along with whole wheat laccha paratha, jeera rice, rich dal makhani, pickle and boondi raita.	11	2021-07-11 22:57:32.590756	2021-07-11 22:57:32.590756	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1acaa2e1-ab4a-45ee-b22f-d4c131729820	Veg Makhanwala 'n' Wheat Paratha	North Indian	{https://d3gy1em549lxx2.cloudfront.net/53e0f985-6aed-4aa8-82b3-16f0c6a766ec.JPG}	t	t	175	0	Fresh and creamy cottage cheese is tossed along with colourful veggies in a delicious in-house gravy with indian spices and garnished with fresh cream and butter. Served with wheat parathas. Time to Go Desi today!	12	2021-07-11 22:57:32.611017	2021-07-11 22:57:32.611017	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
56bd860e-c071-4c4c-be88-1c4f6daef8a2	Masala Pepper Chicken Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/68e88281-61be-4822-8fd7-75a3df73ed8c.jpg}	t	f	209	0	The delicacies of this thali include masala pepper chicken starter (with mint chutney), whole wheat laccha paratha, jeera flavoured basmati rice, rich dal makhani, pickle and boondi raita.	17	2021-07-11 22:57:32.634003	2021-07-11 22:57:32.634003	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
d0aa490b-2c5a-437a-b6a9-865c9ea4ffdf	Paneer - Dal Makhani Bowl	561 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/0f7af5c5-f66d-435f-b4dd-4fc4e0fb88cf.jpg}	t	t	219	0	This punjabi bowl is going to be your next FAV, we promise! Dal makhani cooked in a ginger-garlic-tomato gravy. Everyone's favourite Paneer butter masala is cooked in a delish gravy, topped with butter. Your FIESTA bowl will have Jeera rice along with dal makhani and paneer butter masala, garnished with minty laccha onions.	12	2021-07-11 22:57:32.653226	2021-07-11 22:57:32.653226	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
7494e831-3ef5-4a94-9e4e-fab7a04d5bb3	Oriental Grilled Fish	463 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/3ec5ddfd-8f42-4a57-a65a-4a1bcaac5764.jpg}	t	f	289	0	Striking the balance of flavours that Asian cooking is known for, this dish combines spicy and savoury notes perfectly. Basa infused with Oriental herbs is grilled to charry goodness. Served with fried rice and wok tossed vegetables on the side. May contain mushrooms. All our bowls are prepared fresh on your order.	14	2021-07-11 22:57:32.674111	2021-07-11 22:57:32.674111	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c9542763-ab5c-4ae0-ba61-2747eba6ac06	Bangkok Street Noodle Bowl	Asian	{https://d3gy1em549lxx2.cloudfront.net/abccc352-61c5-4884-8fe1-d291deb155a9.JPG}	t	t	209	0	Spicy street style bangkok noodles served with crushed peanuts topping. Be transported to your thai vacay with this noodle bowl. All our bowls are prepared fresh on your order.	10	2021-07-11 22:57:32.694694	2021-07-11 22:57:32.694694	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
6803fa92-8d48-4aaf-a1b2-4f75f3cea672	Spinach-Stuffed Chicken Superbowl	Continental	{https://d3gy1em549lxx2.cloudfront.net/61c53ffd-b0b0-48bd-89d1-dbbb8b92651c.jpg}	t	f	279	0	Succulent chicken is stuffed with a mixture of shredded spinach, onions, mozarella cheese. This is then grilled to perfection and served on a bed of tomato quinoa brown rice. Topped with mexican peri peri sauce, this dish is cheesy, moist and infused with so much flavour!	16	2021-07-11 22:57:32.722361	2021-07-11 22:57:32.722361	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a525d251-fabe-457f-bde0-3b262c8694b6	Tomato Feta Fish Steak	Continental	{https://d3gy1em549lxx2.cloudfront.net/0603a371-b934-4195-9a88-b0a161a99689.JPG}	t	f	299	0	Basa fish marinated in a Latino Adobo spice mix (of chilli, fresh cilantro, onion, black pepper and lemon) is baked and served on a bed of Mexican tomato quinoa brown rice. Topped with delicious saucy veggies and garnished with feta, bring home the tasty flavours of Latin America!	12	2021-07-11 22:57:32.759605	2021-07-11 22:57:32.759605	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
35987d17-374a-4acd-b882-8e756af92a79	Ghee-Roast Chicken Biriyani (1 KG)	South Indian	{https://d3gy1em549lxx2.cloudfront.net/48c13693-f881-42e9-bc32-6d3b19675112.jpg}	t	f	499	0	Chicken ghee roast is a very popular dish. Cooked chicken and rice are layered in a pot and then dum cooked for sometime. This is an absolute delight to eat. Paired with Bhurani Raita.	17	2021-07-11 22:57:32.781589	2021-07-11 22:57:32.781589	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
096341d9-8d95-4e62-bb43-b695b2f022d1	Whole-Wheat-Paratha-(Pack of 4)	Indian	{https://d3gy1em549lxx2.cloudfront.net/429f590f-e9c3-41e9-8710-a02919dabd06.jpg}	t	t	149	0	This consists of 4 Whole wheat parathas. Pair up with our range of curries and have a healthy homely meal!	12	2021-07-11 22:57:32.798928	2021-07-11 22:57:32.798928	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
fad8ba19-0558-4e5c-a4fb-36dda862c11d	Chicken Keema Samosa	Indian	{https://d3gy1em549lxx2.cloudfront.net/6dc687f3-08dd-4ea7-a4a7-45dc410b7f96.JPG}	t	f	199	0	The Chicken Keema Samosa is a delicious blend of minced chicken tossed along with spices, onion, tomato and green chilli, covered with a crispy samosa covering making it perfect for anytime. Served with a delicious mint chutney. Perfect for the Ramadan festive.	15	2021-07-11 22:57:32.815645	2021-07-11 22:57:32.815645	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
288c0344-a5e0-47b4-8a49-6ae15577a81a	Gobi Paratha Combo	North Indian	{https://d3gy1em549lxx2.cloudfront.net/c50f8c40-da0a-4d2e-b162-83be477c031a.jpg}	t	t	99	0	Simple and satisfying, our gobi Paratha served with curd and pickle is a homey meal that is fulfilling and flavourful -- a must-have!	15	2021-07-11 22:57:32.456856	2021-07-11 22:57:32.456856	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
04e3451b-eb82-4598-9b0e-10afa47239f3	Mini Fruit Parfait	107 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/ac53e598-9031-45cf-850b-4575228cb408.jpg}	t	t	69	0	This power-packed parfait has all the nutrition you need. Loaded with vitamins and antioxidants from a variety of fruits, healthy fibre from muesli and probiotics from the yogurt, this little cup of goodness is a must-have in your menu for the day.	7	2021-07-11 22:57:32.494773	2021-07-11 22:57:32.494773	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1132ca94-d00a-4a6b-9027-fc2c0e2b45f8	Cheesy-Veg-Wrap	432 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/23087fdf-98fe-4020-be4b-40977f0fe6fb.jpg}	t	t	139	0	Crunchy onions, golden corn kernels and assorted veggies are sautéed in a cheese sauce with spices, placed on a soft laccha paratha that’s slathered with chipotle mayo spread, rolled and served to you fresh!	7	2021-07-11 22:57:32.518237	2021-07-11 22:57:32.518237	65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
62f111bf-af0f-4ef7-9935-7746f6162aa3	Corn-Pepper Mac 'n' Cheese	560 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/92765dd5-16a3-4b5e-ba2b-563c28d64a2b.jpg}	t	t	219	0	This classic comfort favourite is made with a rich and creamy white sauce along with corn, tri peppers, macaroni pasta, topped with cheese sauce, and mozzarella cheese, baked to perfection. It's finger-licking good. All our meals are prepared fresh on order.	10	2021-07-11 22:57:32.543288	2021-07-11 22:57:32.543288	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
bc4afb39-7b13-40f8-a3bf-efb28c332a5c	Grilled Buttermilk Chicken Steak	Continental	{https://d3gy1em549lxx2.cloudfront.net/d5c3e091-9449-4fb0-be25-020dd4443cfa.JPG}	t	f	269	0	Chicken breast boneless marinated and oven roasted to perfection. Patted with a delicious garlic cheese jus, your mesmerizing steak is ready and served on a bed of mexican quinoa brown rice, with a salad and wedges. Exotic and fulfilling combo, that's recommended by our Chefs!	16	2021-07-11 22:57:32.568841	2021-07-11 22:57:32.568841	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
95f7db48-612d-4438-b208-50aa35e42b4f	Kadhai Paneer-Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/802838d1-55fe-4550-90db-a14be9b59871.jpg}	t	t	209	0	A FEAST for you! This delicious thali has kadhai paneer curry cooked with rich in-house spices, which is accompanied with whole wheat laccha paratha, jeera flavoured basmati rice, dal makhani, pickle and boondi raita.	15	2021-07-11 22:57:32.591547	2021-07-11 22:57:32.591547	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c141a8f0-8cdc-4bb4-8fd6-6f519e4cd816	Banarasi Aloo Mutter with Parathas	Indian	{https://d3gy1em549lxx2.cloudfront.net/b73564d6-ac82-4593-824c-e6b0f9a88166.jpg}	t	t	169	0	Simple and satisfying, this combo contains a delicious banarasi-style aloo mutter side along with 2 fresh lachha parathas. A homey meal that is fulfilling and flavourful -- a must-have!	10	2021-07-11 22:57:32.611644	2021-07-11 22:57:32.611644	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a74bf5da-7a24-440f-803c-6aed8eb5c544	Paneer Butter Masala-Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/393b2e85-b158-4a8c-b36c-8f9623c762b2.jpg}	t	t	209	0	Paneer's most delicious form of curry - paneer butter masala curry along with whole wheat laccha paratha, jeera flavoured basmati rice, dal makhani, boondi raita and pickle, is going to make your meal AMAZING!	14	2021-07-11 22:57:32.634675	2021-07-11 22:57:32.634675	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2873416f-f6fe-4ebd-a17f-ca943ee3015a	Ghee-Roast Chicken Biriyani Thali	Indian	{https://d3gy1em549lxx2.cloudfront.net/87f0c7a3-437e-4d9c-bda7-d2dcfb23863a.jpg}	t	f	299	0	The quintessential Indian thali is more like a cultural exploration and makes for a complete meal in itself. This thali is one of those bestsellers with chicken tikka to start your meal, delish mangalorean ghee roast biriyani, salad and a Bhurani Raita.	8	2021-07-11 22:57:32.653796	2021-07-11 22:57:32.653796	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e6e176fb-0b9e-422c-9c53-cedba1950329	Dan Dan-Chicken Noodles	725 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/d7bb2e4d-21ff-41a5-bc7c-ac5c6fd3d717.jpg}	t	f	209	0	Minced chicken cooked in a piquant broth of chicken stock, Shaoxing wine, Hoisin sauce and Sichuan peppercorns is served with noodles and sir-fried with veggies – street-food, Sichuan style! A very popular Asian meal bowl on our menu. All our bowls are prepared fresh on your order.	10	2021-07-11 22:57:32.67466	2021-07-11 22:57:32.67466	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
ea17b91d-b44a-4873-af98-5de5cc9281ae	Egg Hakka Noodles	550 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/d496040d-68c4-414e-a7d1-85a433747c67.jpg}	t	f	199	0	Noodles are cooked to perfection, flavoured with oriental spices and sauces, and tossed with beaten egg along with fresh veggies like carrot, bell peppers, pokchoy, onion and cabbage. Devour this scrumptious comfort bowl of noodles. All our bowls are prepared fresh on your order.	13	2021-07-11 22:57:32.695297	2021-07-11 22:57:32.695297	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c8b4b18f-5790-432d-a378-5c32e5d255a8	Mexican-Quinoa Burrito Bowl	652 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/95be75be-8868-42d9-aa9d-c554d00e919a.jpg}	t	t	269	0	A steak of paneer, infused with hot and tangy habanero-jalapeno duo, is grilled, sliced and served with an exciting satiating trio of mexican tomato-paprika brown rice, spicy refried beans, crunchy roasted-corn salsa and dill sour cream. Serves 1.	8	2021-07-11 22:57:32.723083	2021-07-11 22:57:32.723083	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
54eb663b-2d82-4e75-9eac-7ca492b2d996	Quinoa Spinach Egg Casserole	Continental	{https://d3gy1em549lxx2.cloudfront.net/5254b3fb-f1eb-4e03-a0e8-66af9c5a9afe.JPG}	t	f	175	0	Treat your taste buds to FreshMenu's special version of this remarkable breakfast. Superfoods like quinoa, foxtail and spinach are sauteed along with fresh bell peppers, eggs, onion and seasoned perfectly to give you a quick fulfilling start to the day!	10	2021-07-11 22:57:32.760431	2021-07-11 22:57:32.760431	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2a3b2290-ca57-4f16-9eef-0c02c3d6289f	Masala Pepper Chicken-Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/54f320eb-8a7a-4745-b5d5-d0abd7826417.jpg}	t	f	219	0	Tender pieces of chicken tossed in fiery hot indian spices and onion-tomato gravy, is dum-cooked and topped on the biriyani rice. Get your hands on to enjoy this biriyani. It's surely a hot-seller! Served with Bhurani Raita.	8	2021-07-11 22:57:32.782132	2021-07-11 22:57:32.782132	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
3436f843-74c9-47ad-96ad-481cc1ef9dc5	Butter Chicken Curry (450 Gms)	North Indian	{https://d3gy1em549lxx2.cloudfront.net/c1e9ae7d-4ac7-4258-a334-378c11d232ae.JPG}	t	f	269	0	A rich buttery, tomato and cream-based gravy, tossed in the tikkas to soften them. Accompany this butter chicken curry with rice/rotis/paratha. Serves 2-3.	8	2021-07-11 22:57:32.799523	2021-07-11 22:57:32.799523	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b4677cc7-a341-4157-89ea-9164688ac6ac	Crispy Fried American Corn	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/1be9ff91-ced3-452b-933b-d1fc40906724.JPG}	t	t	179	0	Sweet, juicy corn kernels dipped in a tempura-style batter and deep fried are tossed with crunchy bell-peppers, onions and hot chillies. Pair it with one of our rustic mains and your meal is good to go!	13	2021-07-11 22:57:32.816178	2021-07-11 22:57:32.816178	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
00627348-e975-4d83-bf9a-964ba83ecb9e	Cheesy Baked Open Sandwich	Continental	{https://d3gy1em549lxx2.cloudfront.net/fd13f374-ac44-48b1-b7d0-4b94c145fc70.JPG}	t	t	99	0	Made with a crusty baguette bread - tri peppers, american corn and oozy cheese are laid on top and baked perfectly. Topped with olives and seasoning generously to intensify the flavours. Savour this delicious evening snack, baked and sealed, Perfect for your hunger pangs!	14	2021-07-11 22:57:32.457982	2021-07-11 22:57:32.457982	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
531f615a-c655-4e17-b27d-3e846a1bcd61	Cucumber Cheese Chutney Sandwich	95 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/cbcce979-ec02-47f7-9ea4-f8ee98f707fd.jpg}	t	t	89	0	A super light sandwich with chutney slathered on brown bread slices, topped with cheese and fresh cucumber slices. They are so good by themselves or when served with a hot cup of tea/coffee!	13	2021-07-11 22:57:32.505772	2021-07-11 22:57:32.505772	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
bcf0ceee-184d-4146-a2f5-86f4dc02090e	Lebanese Falafel Rice Bowl	597 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/87bad43d-0011-41ce-a8a8-24ed036168ba.jpg}	t	t	239	0	A bowl full of greens, veggies, olives, falafel, tomato salsa and salads. Rice is sauteed with onions, garlic, carrot, olives, parseley and seasonings. Served with Tzatziki, tomato salsa, Israeli salad and warm falafels. It's a must-have bowl. All our meals are prepared fresh on order.	10	2021-07-11 22:57:32.530417	2021-07-11 22:57:32.530417	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
ba2e2824-5716-4ab0-afbe-259879e6a929	Creamy Spaghetti Chicken Charcuterie	Continental	{https://d3gy1em549lxx2.cloudfront.net/4e48d341-ff6b-4133-87c7-a460bb6b1c6a.jpg}	t	f	249	0	We use smoked chicken sausages to toss up a creamy spaghetti-meal that is smoky, delicious and a comforting tribute to the art of charcuterie. All our meals are prepared fresh on order.	13	2021-07-11 22:57:32.564436	2021-07-11 22:57:32.564436	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2c6b4e7f-f884-42b4-84b9-8197bfc902b4	Butter Chicken with Jeera Rice	Indian	{https://d3gy1em549lxx2.cloudfront.net/0bbd7b16-43e2-46cb-a299-0881881bb2c5.jpg}	t	f	219	0	A rich buttery, tomato and cream-based gravy and tossed in the tikkas to soften them. This touch of genius gave birth to the indispensable – Butter Chicken. Served with aromatic, steamed jeera-flavoured rice, our homage to this staple is a must try.	7	2021-07-11 22:57:32.599431	2021-07-11 22:57:32.599431	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4922affe-6147-4e59-8e60-54adc4223b8e	Achari Chicken Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/2575f433-21bd-4a20-9f2d-f82d82cd79d1.jpg}	t	f	209	0	Marinated, seared chicken is tossed in a drooling onion-tomato-garlic-pickle gravy made in-house with indian powder spices. This achari chicken curry is served with lachha paratha, jeera rice, Boondi Raita, Pickle, Paratha and dal makhani. Enjoy!	16	2021-07-11 22:57:32.623227	2021-07-11 22:57:32.623227	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a2c02a85-09ab-4fd3-b158-c645c8532220	Schezwan Paneer with Malabari Paratha	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/ecb0f0e3-0236-4fa4-ae46-0851a096e44c.jpg}	t	t	199	0	Relish Asian food from the comfort of your home! Paneer and bell peppers are tossed in a sweet and sour Szechwan sauce made in-house, garnished with spring onion. Accompanied with 2 malabari parathas. Savour till the last bite.	10	2021-07-11 22:57:32.650182	2021-07-11 22:57:32.650182	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
09084dc3-c1b6-4cb8-b0a6-ae43927f239b	Mixed Veg Hakka Noodles	641 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/0710ae37-67f1-43c1-ba8a-32c352a60542.jpg}	t	t	179	0	Classic hakka style noodles loaded with veggies like carrot, beans, onion, cabbage, bell peppers, mushrooms that are stir-fried along with delicious noodles and seasoning Perfectly a great meal to have anytime of the day. All our bowls are prepared fresh on your order.	13	2021-07-11 22:57:32.675644	2021-07-11 22:57:32.675644	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4edee4ef-5281-4b00-bba2-588788848a14	Teriyaki-Chicken-Quinoa-Superbowl	624 cal | Low Carb	{https://d3gy1em549lxx2.cloudfront.net/119e1ee7-5c71-4bef-8046-adafd46f3fff.jpg}	t	f	249	0	This Teriyaki Chicken Quinoa Bowl is a perfect healthy meal option for lunch or dinner. Featuring a juicy chicken leg, diced and marinated in Teriyaki sauce. Served with a delicious bell pepper quinoa brown rice. It's high in protein, fiber, healthy and delicious!	13	2021-07-11 22:57:32.696459	2021-07-11 22:57:32.696459	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
21f74f17-53e6-4ab1-ac97-c42fc8c4d1c5	Signature Grilled Chicken 'n' Brown Rice	489 cal | Low Carb	{https://d3gy1em549lxx2.cloudfront.net/62235200-53ae-47c7-9026-28dc4e394c47.jpg}	t	f	269	0	Boiled quinoa and brown rice are tossed with garlic butter, spinach, and olives, making it the perfect ‘side-dish’ to our signature steak that is served with a handful of sauteed crunchy veggies! Serves 1.	16	2021-07-11 22:57:32.750231	2021-07-11 22:57:32.750231	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4ffdf26d-96a9-4f50-8711-35823a2fe9c5	Masala Pepper-Chicken Biriyani (1KG)	Indian	{https://d3gy1em549lxx2.cloudfront.net/54f320eb-8a7a-4745-b5d5-d0abd7826417.jpg}	t	f	479	0	Tender pieces of chicken tossed in fiery hot indian spices and onion-tomato gravy, is dum-cooked and topped on the biriyani rice. Get your hands on to enjoy this biriyani. It's surely a hot-seller! Served with Bhurani Raita.	20	2021-07-11 22:57:32.77408	2021-07-11 22:57:32.77408	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
793e12d6-37c5-47b9-ab1f-d2a1b9399171	Kadhai Paneer (450 Gms)	Fusion	{https://d3gy1em549lxx2.cloudfront.net/40caaeb3-983b-425b-9428-a44a9eb91fda.jpg}	t	t	249	0	An Indian preparation of kadhai paneer, right with aromatic spices and choice vegetables like onion, tomato, bell peppers is a delicious curry to pair with your homemade rotis/rice. Serves 2-3.	15	2021-07-11 22:57:32.7937	2021-07-11 22:57:32.7937	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5e784a3f-11c8-4a2e-a822-f029b8fec9f0	Nimbu-Makhmali-Machhli	284 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/09293233-cc66-4f64-87fa-04551d8ad7b0.jpg}	t	f	279	0	Tender hand-made croquettes of fish (double marinated) are oven-roasted to give a delectable flavour to the fish and turn it into a lip-smacking dish. A mint chutney on the side, adds a delicious zing to this brilliant appetizer.	16	2021-07-11 22:57:32.810176	2021-07-11 22:57:32.810176	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
92c1f2b9-ef35-47ee-b6cc-5c6f562b6797	Ghee-Roast Chicken	586 cal | Keto Friendly	{https://d3gy1em549lxx2.cloudfront.net/92e7357f-e20e-48f0-9dcf-3677d1a45802.jpg}	t	f	219	0	Chicken marinated overnight in our specially crafted ghee-roast masala are cradled and cooked in a tomato-based gravy whose flavours are heightened by curry leaves. Must-Have!	14	2021-07-11 22:57:32.827665	2021-07-11 22:57:32.827665	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0e9b1e70-04b1-49cc-8328-cd2b6ffd148e	Salt Pepper Veggies	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/bd5339b2-c969-4c2a-a6fb-2dbc06c4bc53.jpg}	t	t	169	0	Crisp, batter-fried assorted seasonal-veggies are tossed in a luscious, seasoned sweet and hot plum-sauce. May contain mushroom. No added MSG.	7	2021-07-11 22:57:32.8454	2021-07-11 22:57:32.8454	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4bc2c840-fd82-4b07-a32c-8db013239202	Mini Ghee roast chicken biriyani + Shahi tukda + Masala lemonade	South Indian	{https://d3gy1em549lxx2.cloudfront.net/d2463421-67b4-426d-9abb-95cd86411458.jpeg}	t	f	269	0	This combo pack consists of your delectable dum cooked mini ghee roast chicken biriyani paired along with raita, a fresh beverage masala lemonade and a yummy Shahi tukda to end this happy meal!	12	2021-07-11 22:57:32.862851	2021-07-11 22:57:32.862851	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
41a96525-fe63-4710-b924-4a08dfb22bde	Quinoa-Masala-Upma	494 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/bb6b8e8f-c9a1-4243-9956-a1fcb9cc8e2d.JPG}	t	t	169	0	New, delicious and packed with protein, Quinoa Masala Upma is our take on the CLASSIC go-to breakfast option. Boiled quinoa, diced and blanched carrot, beans and peas are tossed with a flavourful ginger, curry-leaf, mustard-seed and dried red-chilli ghee tadka, and served with a wedge of lime.	14	2021-07-11 22:57:32.458453	2021-07-11 22:57:32.458453	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
38df2491-850b-4c62-8de6-44c842ff74be	Steak Egg 'n' Cheese Sandwich	427 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/911cfde8-5ec0-45ac-b6f8-94ed8bea91a4.jpg}	t	f	139	0	This chicken-omelette sandwich stuffed with peri-peri shredded chicken, cheese and cheese omelette stacked between toasted slices of brown bread and spread with chipotle mayo spread. This makes a satisfying breakfast or a great tea-snack.	14	2021-07-11 22:57:32.514354	2021-07-11 22:57:32.514354	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
3e72e333-0c56-4469-a65e-01b0252792de	Creamy Peppercorn Steak	Continental	{https://d3gy1em549lxx2.cloudfront.net/9f2d2abb-58f6-4ed9-870f-4813205b3685.JPG}	t	f	269	0	A melange of colourful and spiced assorted veggies and pasta tossed with broccoli, tri bell peppers is served alongside a herb marinated chicken steak, topped with peppercorn loaded cheese sauce. All our meals are prepared fresh on order.	9	2021-07-11 22:57:32.552845	2021-07-11 22:57:32.552845	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1ed288bc-bdb0-44fb-b083-3b905ded47c0	Special Kadhai Paneer Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/5aa81e89-0d1f-45b2-abb3-691d54e23954.jpg}	t	t	209	0	A scrumptious north indian thali to give you a fullfilling experience consisting of 2 lachha parathas, kadhai paneer curry, chole masala, boondi raita and pickle. Pair it up with a masala lemonade and enjoy!	16	2021-07-11 22:57:32.578786	2021-07-11 22:57:32.578786	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0f696fe0-f74e-4f4b-896a-911e8db1ffa0	Tandoori Chicken Tikka-Makhani Bowl	571 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/af03f957-89ab-4ffc-b35b-757791a70a45.jpg}	t	f	219	0	Dal makhani cooked in a ginger-garlic-tomato gravy. Everyone's favourite chicken tikka is cooked deliciously tandoori-style. Your FIESTA bowl will have jeera rice along with dal makhani and tandoori chicken tikka, garnished with minty laccha onions.	11	2021-07-11 22:57:32.605952	2021-07-11 22:57:32.605952	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
67bfa868-8568-4c63-a40c-6347efa7f681	Banarasi Aloo Mutter Thali	Indian	{https://d3gy1em549lxx2.cloudfront.net/a22fe2c7-2a9d-4cee-ab1e-fe23dd6ef4b1.JPG}	t	t	179	0	This scrumptious thali consists of aunthentic and rich banarasi aloo mutter curry. Served along with whole wheat paratha, pickle, jeera flavoured rice, dal makhani and boondi raita.	10	2021-07-11 22:57:32.642921	2021-07-11 22:57:32.642921	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e59d9c21-11c4-4286-8e0c-9a4360946f55	Smoke That Bowl	526 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/0db8455a-3e86-43c7-bb40-53fe8c02571c.jpg}	t	t	229	0	Crisp-tender vegetables with paneer doused in a smokey and hot BBQ sauce, is accompanied with burnt garlic fried rice. A must-have asian bowl. All our bowls are prepared fresh on your order.	13	2021-07-11 22:57:32.664363	2021-07-11 22:57:32.664363	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
f65cd43a-d1da-4f32-a669-1d284690e1f8	Mongolian Hot Pot	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/fd4f117b-097a-4b75-8279-2f326cde6881.jpg}	t	t	209	0	A colourful assortment of peppers, zucchini, broccoli and mushroom in a toasted-peanut red-chilli sauce accompanied with a spicy chilli-bean fried rice – a delightful summer meal! All our bowls are prepared fresh on your order.\nVEG\nCONTAINS NUTS	8	2021-07-11 22:57:32.690594	2021-07-11 22:57:32.690594	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
7c4ef0d7-d8cf-46f1-be39-8d96a1061723	Signature Manchow Soup	202 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/67c030be-5c3e-4f98-b97f-8ed9368bdf35.jpg}	t	f	159	0	A must-have from the oriental world, this is going to be your next favourite. Double chicken (Julienne and mince) along with fresh vegetables boiled in the warmth of this appetizing soup in a bowl is a blessing! Served with Fried noodles.	6	2021-07-11 22:57:32.724407	2021-07-11 22:57:32.724407	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
aa747a73-5531-4bbc-a46b-1a822a322e87	Chicken-Tikka Dum Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/72df9641-f433-49eb-a4dc-bcfb75b747cc.JPG}	t	f	219	0	Most-loved juicy chicken tikkas with freshly ground biriyani masala and premium basmati steamed shut in the age-old dum phukt style – a delicious fare of delectable flavours. Served with Bhurani Raita.	10	2021-07-11 22:57:32.761559	2021-07-11 22:57:32.761559	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
cdc6f203-af7e-413f-9fcc-e865e6f9754c	Ghee-Roast Chicken-Biriyani Combo	South Indian	{https://d3gy1em549lxx2.cloudfront.net/f35de660-afd6-4855-a707-f6d756606abc.jpg}	t	f	229	0	Chicken ghee roast is a very popular dish. Cooked chicken and rice are layered in a pot and then dum cooked for sometime. This is an absolute delight to eat. Paired with Bhurani Raita.	12	2021-07-11 22:57:32.783111	2021-07-11 22:57:32.783111	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5b826ed0-68d1-4454-b0bd-11d17e57084e	Malabari-Paratha-(Pack of 4)	Indian	{https://d3gy1em549lxx2.cloudfront.net/3f01c9fe-affa-430b-9470-53e222ff1d09.jpg}	t	t	139	0	This consists of 4 Malabari Parathas	12	2021-07-11 22:57:32.800478	2021-07-11 22:57:32.800478	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
14cb070e-f757-4bea-822e-eb6a4ef8370e	Garlic Bread Supreme	Continental	{https://d3gy1em549lxx2.cloudfront.net/f105ee7f-c398-4872-9a22-7bb66de9459f.jpg}	t	t	169	0	This savoury snack has olives, chili peppers and oozy mozzarella cheese spread generously on toasted bread and baked. Simply finger-licking we say!	11	2021-07-11 22:57:32.817253	2021-07-11 22:57:32.817253	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e96ee783-6af2-4e65-9a96-c8ca3ecab083	Black-Pepper Chicken Stir-Fry	245 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/9060cc0e-8504-4c27-920b-a0ab7cbf5f91.jpg}	t	f	199	0	We’ll help you achieve your KETO goals without compromising on taste or DELIGHT – sliced chicken and assorted seasonal veggies stir-fried with a HOT black pepper sauce.	15	2021-07-11 22:57:32.842729	2021-07-11 22:57:32.842729	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
18e76fb9-de9f-43bb-b499-f5e112cdee43	Peri-Peri Paneer burger Combo	Continental	{https://d3gy1em549lxx2.cloudfront.net/8da5aa80-dcb5-4c46-b010-fca6348d2962.jpeg}	t	t	299	0	Peri peri paneer burger, peri peri paneer burger, masala lemonade	13	2021-07-11 22:57:32.869339	2021-07-11 22:57:32.869339	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
af5130e4-843e-40bc-af58-a58696a1e4a5	Rainbow Pastry	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/b6cc0f0a-251a-4b5f-adcf-0dd729528a9d.jpg}	t	t	99	0	If you have ever wondered what a rainbow tasted like, well, now you can finally know. Layers of vanilla pound-cake coloured in the shades of the rainbow are blanketed with sweet cream-cheese and topped off with red-velvet crumble. Tell us if you spot a unicorn, okay? Serves 1.	15	2021-07-11 22:57:32.888237	2021-07-11 22:57:32.888237	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
f7156dfd-67b0-4dd6-9d12-f56e90f01f90	Choco Fudge Blackout Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/b5f302fa-e2d5-43a6-ad07-56c9f0619299.JPG}	t	t	89	0	Dark chocolate sponge layered with milk chocolate truffle and dark chocolate truffles, is sure to be a perfect treat. Double layers mean double fun!	10	2021-07-11 22:57:32.904842	2021-07-11 22:57:32.904842	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
19c59f2c-f11c-4d4e-85c9-50724e4d19fc	Spinach Corn Sandwich	391 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/b6ef217e-3533-4662-9799-dbaa16f77ff2.jpg}	t	t	129	0	This sandwich has fresh spinach and sweet corn which are cooked in a cheesy sauce, stuffed between toasted brown bread with cheese slices giving you the best snack option anytime of the day!	14	2021-07-11 22:57:32.459135	2021-07-11 22:57:32.459135	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a3ee86d9-d1ba-48e6-9a49-6846ed9b9b89	Chicken Tikka Club Sandwich	Continental	{https://d3gy1em549lxx2.cloudfront.net/5429d25d-2d90-42c8-9f40-77d5ba2fefbe.JPG}	t	f	179	0	Bite into the scrumptious goodness of these three layers of absolute pleasure! Sandwiched between the wholesome layers, are portions of luscious chicken tikka, fresh coleslaw, an omelette and a nice thick slice of cheese. You don't want to miss out on this flavoursome experience!	14	2021-07-11 22:57:32.497876	2021-07-11 22:57:32.497876	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
eff2a57e-3880-46b3-9d7a-774800619707	Peri-Peri Paneer Burger	Fusion	{https://d3gy1em549lxx2.cloudfront.net/37828ad3-e22a-4c8d-a0d9-4cb2cb855689.jpg}	t	t	179	0	A twist in itself, this delicious burger is loaded with ingredients to count on. Marinated cottage cheese steak is grilled to perfection, placed on a bed of fresh lettuce, onion, topped with ranch spread and cole slaw. Served with potato Crisps. Must-have. Served along with Potato wedges	15	2021-07-11 22:57:32.521151	2021-07-11 22:57:32.521151	65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c68b3953-1c43-410d-b80e-fc916765ef42	Spinach-Stuffed Chicken 'n' Herb Rice	Continental	{https://d3gy1em549lxx2.cloudfront.net/38ca345d-1a9a-48fa-9b9f-2d50deb11e50.JPG}	t	f	269	0	Chicken breast stuffed with a creamy spinach, mozzarella cheese filling and pan seared to perfection. Served on a bed of aromatic herb rice, with a portion of thyme-infused buttered veggies and a delicious mexican peri-peri sauce. Sealed with Love, this dish is a must-order!	15	2021-07-11 22:57:32.546172	2021-07-11 22:57:32.546172	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
d46f4f0e-7b99-47c9-85e5-ac2ec0fda58e	Cheesemelt Chicken Steak	Continental	{https://d3gy1em549lxx2.cloudfront.net/4a320616-d169-408a-b61a-d027320b88c7.JPG}	t	f	269	0	A supremely satisfying chicken breast, stuffed with a cheesy-cheesy mix and oven roasted. Smeared with a flavourful garlic cheese jus accompanied with a wholesome fresh salad and yummy peri-peri potato wedges! Enjoy this combo with your favourite beverage on the side..	8	2021-07-11 22:57:32.571786	2021-07-11 22:57:32.571786	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
203f3d27-a303-4a1c-95a6-a4eb600ceac1	Chole 'n' Jeera-Rice	North Indian	{https://d3gy1em549lxx2.cloudfront.net/ba46ef6a-df9e-4fc9-a25f-ff1694f50fbd.jpg}	t	t	165	0	Classic punjabi style chole-masala served with jeera-flavoured basmati is a meal that is reminiscent of much-loved homely aromas!	9	2021-07-11 22:57:32.593466	2021-07-11 22:57:32.593466	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
412e3b44-05e7-4569-bc04-8dfb274ddc19	Vegetable Korma 'n' Malabari Paratha	413 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/15ebb092-dd1b-4764-a594-54fe619eb37c.jpg}	t	t	179	0	The delicious fresh veggies in this dish, makes it a winner by choice. Bite into this dish that comes with paneer, cauliflower, beans, green peas and carrot cooked in a rich gravy. The dish is finished with cashewnuts and raisins. Served with two fresh Malabari parathas.	14	2021-07-11 22:57:32.614002	2021-07-11 22:57:32.614002	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
423a20be-91ea-48f6-868f-28245c061f3b	Mutter-Paneer Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/750f48bd-91fb-44d2-a9d2-2923fd996563.JPG}	t	t	209	0	Best of north India's mutter paneer gravy is served with a whole wheat laccha paratha. A mixed-veg white pulao is accompanied with aloo-gobhi dry, raita and a tangy mixed veg pickle. Oh so yumm!	13	2021-07-11 22:57:32.636203	2021-07-11 22:57:32.636203	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
93f4cfcb-a2d3-45a2-b300-0d1fb709cc3c	American Lo Mein	523 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/89d3cf1c-ff15-4aa8-b560-0fc31a3cec49.jpg}	t	t	185	0	Comfort food at its best, our bowl of American Lo Mein is just the umami kick you are looking for! Fresh assorted veggies and steaming-hot noodles straight out of the boiling pot are tossed in a sweet and hot Teriyaki-based sauce. All our bowls are prepared fresh on your order. Energy (Kcal)-523, Fat (g)-2, Carbs (g)-99, Fiber (g)-4, Protein (g)-21, Sugar(g)-9	12	2021-07-11 22:57:32.658417	2021-07-11 22:57:32.658417	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
fd63190d-1ee8-485c-9ddf-f1c9edd634be	Black Pepper Honey Chicken Noodles	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/07d5a141-eb43-43a3-99c7-b8ddb8a70842.JPG}	t	f	219	0	A crunch here and crunch there, in a mildly spiced hakka noodles works stupendously well with a luscious crushed black-pepper and honey infused, chilli and oyster sauce teeming with batter-fried bits of chicken. May contain mushrooms. All our bowls are prepared fresh on your order.	15	2021-07-11 22:57:32.676199	2021-07-11 22:57:32.676199	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5d220849-fefb-42ac-bf9a-6293f646e779	Ultimate-Quinoa-Burrito	758 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/afa5a71e-10db-4d54-8f7b-88b4d913db9a.jpg}	t	t	269	0	This bowl contains mexican quinoa brown rice loaded with toppings to give you a full-satisfying meal. Fresh paneer cubes, corn-bean,tangy tomato salsa and sour cream garnished with jalapeno and cheese. Packed with a burst of flavours.	8	2021-07-11 22:57:32.700039	2021-07-11 22:57:32.700039	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
41363897-f8d3-48f9-ab26-a23063362f68	Keto Cheesy Chicken Steak	366 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/a89108ab-3d2d-4ad6-8e61-f9ee0ee3e0d0.jpg}	t	f	229	0	Here’s a tenaciously hot KETO steak that will leave you craving for more – rested with a fabulously flavourful marinade of habanero seasoning, grilled and topped with mozzarella cheese. A velvety and lip-smacking paprika cheese sauce; and buttered and sautéed assorted veggies accompany the steak! Serves 1	16	2021-07-11 22:57:32.725774	2021-07-11 22:57:32.725774	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
aab7f970-b8d5-4ad8-a5f3-8188435f4184	Foxtail Millet Curd Rice	305 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/3d566e99-0584-4cce-948e-1685285958d8.jpg}	t	t	99	0	Foxtail millet is rich in dietary fibre, protein and low in fat unlike rice. Boiled foxtail millet along with milk, curd and cream is garnished with roasted indian herbs, giving you the best healthy dish. Craving it already?	12	2021-07-11 22:57:32.754488	2021-07-11 22:57:32.754488	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4ac6a915-da0e-4b45-8a5a-97609ea395c2	Kolhapuri Paneer Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/c446b49d-8661-4d39-916a-023071a985ba.JPG}	t	t	219	0	Assembling a Kolhapuri Paneer Biriyani is often considered as a test of culinary expertise – some believe to have mastered it, others continue to strive to find the perfect balance of flavours. A mouthful of our Kolhapuri Paneer Biriyani is a testament of how far our chefs have come! Served with Bhurani Raita.	10	2021-07-11 22:57:32.77722	2021-07-11 22:57:32.77722	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
30c8e8a0-e136-4777-952b-e5197e9c0ae6	Whole-Wheat Paratha (Pack of 2)	Indian	{https://d3gy1em549lxx2.cloudfront.net/cc073a13-1601-4799-b4bf-986660789af3.jpg}	t	t	79	0	This consists of 2 Whole wheat parathas. Pair up with our range of curries and have a healthy homely meal!	12	2021-07-11 22:57:32.795609	2021-07-11 22:57:32.795609	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
032e3c56-94cc-4da8-b96c-22f79a63b601	BBQ Chicken Club Sandwich	Continental	{https://d3gy1em549lxx2.cloudfront.net/ce9e7e52-46d5-43c6-b4ce-b1057774c63f.jpg}	t	f	189	0	This BBQ Chicken Club Sandwich is anything but ordinary, oozing with cheese and layered with chicken, egg and the stellar pulled, barbequed chicken. An extra dose of BBQ sauce, gives the mix that sweet-hot woody kick. You don't want to miss out on this flavoursome experience! Serves 1. ENERGY (KCAL): 677, Fat (g): 31, Carbs (g): 61, Fiber (g): 3, Protein (g): 32, Sugar(g): 15	11	2021-07-11 22:57:32.459681	2021-07-11 22:57:32.459681	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
10727fcf-ec43-4c13-8374-15e3e5518f88	Cucumber Cheese Chutney Sandwich + Mini Parfait	Fusion	{https://d3gy1em549lxx2.cloudfront.net/fba3ca50-f77d-4ca5-8023-f665ee159799.png}	t	t	239	0	A super light sandwich with chutney slathered on brown bread slices, topped with cheese and fresh cucumber slices. Served with a delish mini fruit parfait.	11	2021-07-11 22:57:32.49886	2021-07-11 22:57:32.49886	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a8dd7a46-0cd4-44bd-ad1a-51169e0ee92f	Chicken-Tikka Wrap	444 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/ec35dcad-93bf-4934-aa58-819260bde78b.jpg}	t	f	149	0	A fuss-free wrap with grilled chicken tikkas on a bed of onion with chipotle mayo, rolled in a soft Lachha paratha, with chipotle mayo spread. Hungry already? Order on-the-go!	9	2021-07-11 22:57:32.521873	2021-07-11 22:57:32.521873	65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
20fd5549-ae0c-4c8f-ae7e-6b5814d9f7f4	Fish 'n' Chips	Continental	{https://d3gy1em549lxx2.cloudfront.net/191ba057-432e-458a-927f-80079eda5001.jpeg}	t	f	279	0	An appetizer we bring to you which nobody can resist the delectable combination of moist, white fish batter-fried to a crisp served on a portion of warm potato wedges. All our meals are prepared fresh on order.	17	2021-07-11 22:57:32.546795	2021-07-11 22:57:32.546795	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a54a29fe-bee2-443f-8fa9-9ac19206fb5d	Classic Mac 'n' Cheese	Continental	{https://d3gy1em549lxx2.cloudfront.net/33891319-50a1-4bfe-9f91-59a59e930451.jpg}	t	t	209	0	Macaroni tossed with white cheese and Béchamel sauce, topped with cheddar, oregano and bread crumbs, baked to a golden crust. All our meals are prepared fresh on order.	14	2021-07-11 22:57:32.572627	2021-07-11 22:57:32.572627	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b6f111fe-7b7b-416e-838b-923e0534118c	Chana Masala 'n' Pulao	North Indian	{https://d3gy1em549lxx2.cloudfront.net/1996e2d0-7b09-4fb6-9a64-de861189b8e4.jpg}	t	t	179	0	Classic punjabi style chole-masala served with a mild assorted veggie-pulao is a meal that is reminiscent of much-loved homely aromas!	11	2021-07-11 22:57:32.594354	2021-07-11 22:57:32.594354	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e2b03705-6fbb-4fee-9d7e-7fc314141ddd	Veg Makhanwala Thali	Indian	{https://d3gy1em549lxx2.cloudfront.net/e416858b-92b2-4947-8166-e2ed6070f7bd.jpeg}	t	t	209	0	A wholesome indian meal to give you some home-like food feels! Sumptuous jeera rice packed along with rich dal makhani, lachha paratha, mixed veg pickle, raita and a yumm veg makhanwala curry. Indulge and enjoy with your fav dessert!	16	2021-07-11 22:57:32.61459	2021-07-11 22:57:32.61459	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
07c90d95-3f07-4df3-831a-91cff7aa111b	Aloo Gobhi Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/5dd14631-adc1-476e-b313-7aa883af345a.jpg}	t	t	175	0	Simple and sober like your mum's homemade food, this thali has aloo gobhi dry veg, whole wheat laccha paratha, Dal makhani, jeera flavoured basmati rice, pickle and boondi raita.	11	2021-07-11 22:57:32.6372	2021-07-11 22:57:32.6372	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b4fb8069-cddd-41e3-8e16-c40d765fd1ff	Teriyaki Chicken Rice Bowl	Japanese	{https://d3gy1em549lxx2.cloudfront.net/7beb844f-172b-4f88-bf79-c5eaab2bf32e.jpg}	t	f	229	0	FreshMenu's signature Teriyaki Rice Bowl is an all time favourite meal with our guests. Diced, grilled chicken, leeks, broccoli, bell peppers, carrot and Chinese cabbage are seasoned, sautéed and simmered in a rice-wine vinegar infused japanese teriyaki sauce. Served with a portion of vegetable fried-rice. May contain mushrooms. All our bowls are prepared fresh on your order.	10	2021-07-11 22:57:32.6591	2021-07-11 22:57:32.6591	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
abffb041-576a-4165-8659-860e9441db8e	Black Pepper Honey Chicken Bowl	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/15f6b852-6dd9-421e-968f-004187b87bf7.JPG}	t	f	229	0	A crunch here and crunch there, in a mild fried rice works stupendously well with a luscious crushed black-pepper and honey infused, chilli and oyster sauce teeming with batter-fried bits of chicken. May contain mushrooms.	8	2021-07-11 22:57:32.676852	2021-07-11 22:57:32.676852	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
94b68d3f-d9c8-4aa6-b002-e59f8a086dd3	Roasted Garlic Chicken Soup	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/fe7321c7-610b-46f4-a4b5-69364b63df00.jpg}	t	f	149	0	We give the ultimate comfort food a creamy, garlicky spin, making it even more delectable. Topped off with cream, butter and a good sprinkle of fresh parsley, our Roasted Garlic Chicken Soup is what will perk you up even if you aren’t ill. Serves 1.	7	2021-07-11 22:57:32.700784	2021-07-11 22:57:32.700784	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
bd6cfbc5-5364-4f8a-98ba-e08911de2c36	Peri Peri Chicken 'n' Quinoa Olive Rice	594 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/66ac7bd9-4b56-45b0-b27c-8056ed4cbd1b.jpg}	t	f	269	0	Peri-peri flavoured cooked leg of chicken and roasted veggies are accompanied by a delish quinoa-rice jumble in a fiery tangy sauce to complete the meal. A meal that's protein-packed, delicious and hearty – all in one serving!	11	2021-07-11 22:57:32.726724	2021-07-11 22:57:32.726724	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
20c1a593-9300-4abe-b444-a1019a5bf56d	Asian-Greens Superbowl	538 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/02ccc9f3-2594-4e53-9da2-f942a068f0c8.jpg}	t	t	249	0	The humble veggie quinoa brown rice livened with a hit of seasonings, and paired with bok choy, Chinese cabbage, broccoli and bell peppers, tossed with a lip-smacking chilli-garlic sauce – this bowl of asian greens will take you straight to seventh heaven!	9	2021-07-11 22:57:32.755287	2021-07-11 22:57:32.755287	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
20424ece-c094-4553-b209-98e959f37ed4	Masala Anda Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/d3c3c7e1-334a-4a69-9e50-bbdb6675f3eb.JPG}	t	f	189	0	Assembling a Masala Anda Biriyani is often considered as a test of culinary expertise – some believe to have mastered it, others continue to strive to find the perfect balance of flavours. A mouthful of our Masala Anda Biriyani is a testament of how far our chefs have come! Served with Bhurani Raita.	11	2021-07-11 22:57:32.778146	2021-07-11 22:57:32.778146	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
cfae9327-26d8-47e7-ba0b-1303e34ab5c5	Dal Makhani (450 Gms)	North Indian	{https://d3gy1em549lxx2.cloudfront.net/daa56ec9-4b03-4746-989a-fe12ad1b82d9.jpg}	t	t	179	0	Kashmiri rajma and urad dal simmered in our signature creamy tomato-based gravy, is garnished with fresh cream. Pair this curry with your homemade rotis/rice. Serves 2.	11	2021-07-11 22:57:32.796132	2021-07-11 22:57:32.796132	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
06808521-f099-485f-a718-6cc801ce3a43	Chilli Paneer	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/c167e968-8658-49fc-86b2-3fe9338a95e2.jpg}	t	t	189	0	A fresh and unaged cheese that Indians love experimenting with, is our iconic, yet humble, paneer. This peppery, spicy, and tangy chilli-infused dish is popular on our list of starters and appetizers. Whether eaten as a side-dish or an appetizer by itself, this Indo-Chinese dish packs a mean punch when it comes to flavour and taste!	9	2021-07-11 22:57:32.813175	2021-07-11 22:57:32.813175	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
76e8ffa0-334d-4096-a53a-2ed1ac81766e	Chicken Tikka Sandwich	422 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/cbb08c68-c059-4b92-a44b-82e67fd09938.jpg}	t	f	139	0	Enjoy the best of fusion flavours in this flavoursome sandwich. Chicken pieces are flavoured with a in-house tikka masala and layered in a toasted brown bread with chipotle-mayo, purple cabbage, green peppers and carrot.	12	2021-07-11 22:57:32.460357	2021-07-11 22:57:32.460357	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a65df1fd-8f97-47ca-b27b-3cfc5a856f57	Omelette Cheese Sandwich	320 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/d8256874-98ad-43c4-9682-4ae0400f2e85.jpg}	t	f	119	0	A humble, fluffy omelette, stuffed between two slices of our signature brown bread is a delicious, hearty breakfast-affair that will have you up and running! Serves 1.	8	2021-07-11 22:57:32.499833	2021-07-11 22:57:32.499833	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a21611cb-4b91-4813-8d71-1756bea43e18	Kolkata Paneer Wrap	422 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/731b0da8-75f6-4854-a67b-63fb001e313e.jpg}	t	t	129	0	We've perked up the ever-popular kolkata paneer with a mix of fresh peppers and paneer in a delish mixture. This mix is wrapped in fresh laccha paratha, making it delicious and sumptuous with every bite you take. Perfect Street-Style!	13	2021-07-11 22:57:32.522502	2021-07-11 22:57:32.522502	65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
4d294d59-9ba3-4bf5-bdde-d0c7029f1c3c	Peri-Peri Chicken Steak Bowl	601 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/35ec8885-2f72-4900-b082-bfb861148c21.jpg}	t	f	239	0	Peri-peri flavoured cooked chicken leg boneless steak and roasted veggies are accompanied by a delish rice jumble in a fiery tangy sauce to complete the meal. Everyone's favourite peri-peri bowl! All our meals are prepared fresh on order.	14	2021-07-11 22:57:32.54739	2021-07-11 22:57:32.54739	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
810cdadd-c3c5-401e-9c26-3ba108d9e969	Ultimate Burrito Bowl	637 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/d1f0facf-94b7-4d9b-bfe9-a5a701a718fa.jpg}	t	t	219	0	This bowl contains mexican tomato rice loaded with toppings to give you a full-satisfying meal. Fresh paneer cubes, corn-bean,tangy tomato salsa and sour cream garnished with jalapeno and cheese. Packed with a burst of flavours. All our meals are prepared fresh on order.	10	2021-07-11 22:57:32.573279	2021-07-11 22:57:32.573279	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
10743ea1-416d-46d7-ac38-1ebee089b3f9	Rajma-Masala Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/b18e7926-6cf8-4a6c-bea9-c054fc0dc29c.JPG}	t	t	179	0	Delicious and flavourful rajma curry accompanied with a whole wheat paratha, jeera flavoured rice, mixed veg subzi, boondi raita and a yummy pickle.	13	2021-07-11 22:57:32.595036	2021-07-11 22:57:32.595036	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
509c7f75-b2cf-4e4a-81c9-76fb1287e151	Chicken-Tikka Dum Biriyani Thali	Indian	{https://d3gy1em549lxx2.cloudfront.net/245d7ec1-7834-482e-ba85-5c5bfd61046f.jpg}	t	f	289	0	This thali has chicken tikka starter with mint chutney, aromatic chicken tikka dum biriyani, kachumber salad and Bhurani Raita,..Must-have!	17	2021-07-11 22:57:32.615157	2021-07-11 22:57:32.615157	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
98698ac6-323d-4d3f-b647-6eba67cddef4	Paneer Butter-Masala 'n' Peas Pulao	North Indian	{https://d3gy1em549lxx2.cloudfront.net/e71d5d3d-d9cc-46e0-b0ad-84bc99e677c8.jpg}	t	t	209	0	Delicious paneer tikka cooked in a rich makhani gravy served on a bed of aromatic coriander peas pulao. Our signature combo is pretty popular and its sure to leave you feeling awesome!	15	2021-07-11 22:57:32.6381	2021-07-11 22:57:32.6381	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
66f21a5f-dd76-4c0c-a9f5-3538766b77e0	Chilli Garlic Chicken Noodles	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/c957be0a-4b55-429e-a088-7215b466a4a6.JPG}	t	f	219	0	Heat things up with this big bowl of spicy goodness! Juicy chicken pieces batter fried and tossed in a spicy chilli sauce are served with a healthy portion of assorted veggie fried noodles. A flavoursome and hearty meal. May contain mushrooms. All our bowls are prepared fresh on your order.	10	2021-07-11 22:57:32.691394	2021-07-11 22:57:32.691394	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
44ff8a6a-5936-462a-bd55-0cf863d83800	Keto Cheesy Chicken Twin Steak	Continental	{https://d3gy1em549lxx2.cloudfront.net/b440c276-0fdc-4ea1-87a6-4db04ec9b5b8.jpg}	t	f	349	0	Here’s a tenaciously hot KETO steak that will leave you craving for more – rested with a fabulously flavourful marinade of habanero seasoning, grilled and topped with mozzarella cheese. A velvety and lip-smacking paprika cheese sauce; and buttered and sautéed assorted veggies accompany two steaks!	14	2021-07-11 22:57:32.733878	2021-07-11 22:57:32.733878	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
d04674a6-8ed6-44d9-8576-4ffde8f2348d	Mutter Paneer-Dum-Biriyani Combo	Indian	{https://d3gy1em549lxx2.cloudfront.net/1eabfeff-7c25-401d-995c-49a09245b3e2.jpg}	t	t	219	0	Flavoured with exotic spices and known for its aroma, this dish features mutter paneer made with our own in-house recipe, paneer and green peas tossed in creamy rich onion tomato gravy and served with a delicious Bhurani Raita at the side, this is vegetarian biriyani-bliss reinvented.	13	2021-07-11 22:57:32.77628	2021-07-11 22:57:32.77628	cdbf15d4-c061-4eee-8a8a-4a237f3265d0	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5bffa95f-da58-4420-a160-d6b5a7d2a981	Lasooni Murgh Curry (450 Gms)	Indian	{https://d3gy1em549lxx2.cloudfront.net/0f329ac5-0b41-48c5-bbdc-efd5f640c23d.JPG}	t	f	269	0	This traditional Indian dish is creamy and full of flavor. Enjoy this garlic flavored spicy chicken malai tikka, cooked in a delicious gravy with some rice, potatoes, naan or rotis and you would love the meal! 450 Gms of curry!	9	2021-07-11 22:57:32.807287	2021-07-11 22:57:32.807287	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
379ff738-cd3e-4255-9a0f-dfdecbcbcae2	Chilli Garlic Potato Shots	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/f85ad183-0b5a-4739-a07a-53eb7bda89fd.JPG}	t	t	125	0	Who doesn't love potatoes? And more so when they are deliciously cheesy, hearty, filling and a total party-starter. Shots filled with cheese, chilli and garlic flavoured, Served with peri-peri and thousand island dip. Dig-in!	8	2021-07-11 22:57:32.835807	2021-07-11 22:57:32.835807	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
19230f4b-bac6-4ba5-ab26-9075e33970e8	Honey Chicken Peppers + Veggies in chilli garlic sauce + Sesame chicken bites	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/58ec35ab-fccf-4737-916f-6847d5aea523.jpg}	t	f	529	0	Bestseller appetizers, honey chicken peppers, veggies in chilli-garlic sauce and sesame chicken bites make this combo drooling.. The perfect platter for your family-time, we're sure this combo box will leave you craving for more.	17	2021-07-11 22:57:32.85326	2021-07-11 22:57:32.85326	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1e4cfa84-9ac8-4cb2-8213-179f2f082fd9	Methi-Paratha-Combo	North Indian	{https://d3gy1em549lxx2.cloudfront.net/3bd9b730-1e99-498f-a0cc-2a0c2f84d357.JPG}	t	t	149	0	Simple and satisfying, our Methi Paratha served with curd and pickle is a homey meal that is fulfilling and flavourful -- a must-have!	11	2021-07-11 22:57:32.460909	2021-07-11 22:57:32.460909	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0f1aafa2-043f-44b2-917b-97540ecdb28b	Muesli Yogurt Parfait	273 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/93f9b935-f84d-4cf3-83a5-8582b6b61227.jpg}	t	t	129	0	Indulge in the goodness of greek yogurt, freshly cut fruits and home-made crunchy muesli - all packed together to give you a wholesome meal, any time of the day! Serves 1.	10	2021-07-11 22:57:32.500671	2021-07-11 22:57:32.500671	be0a9f7b-da91-4728-aac7-e3ae4b95f213	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
743b553b-bdfb-444d-a948-ffe46079fdb5	Penne Arrabbiata	309 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/0ab1e8cc-1531-4482-b5e0-e543b7ea0635.jpg}	t	t	209	0	A handful of seasonal vegetables and penne done just right are tossed in a chunky tomato-concasse simmered in chilli oil. Finished with torn basil, chilli flakes and cheese, our Penne Arrabbiata will pleasantly surprise you! All our meals are prepared fresh on order.	11	2021-07-11 22:57:32.523122	2021-07-11 22:57:32.523122	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2a607af6-4691-45b0-ba88-727c534aaa26	Creamy Mushroom Pasta	Continental	{https://d3gy1em549lxx2.cloudfront.net/aa9b43ab-c837-41f3-b82e-aa182315f7a6.JPG}	t	t	229	0	From Italy with love. This classic pasta is made with everything from zucchini to mushrooms. Then mixed with creamy mushroom sauce for flavour and generous amounts of parmesan cheese. Garnished with black olives. All our meals are prepared fresh on order.	9	2021-07-11 22:57:32.547974	2021-07-11 22:57:32.547974	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
bf0ead50-66f8-4ae9-ba09-5cb29754a065	Shredded Chicken Spaghetti	Continental	{https://d3gy1em549lxx2.cloudfront.net/f4377499-6c55-4cea-abbb-fa702972ace8.JPG}	t	f	229	0	Shredded chicken breast is marinated with herbs, garlic and oven roasted to perfection. Tossed with spaghetti arrabiata and garnished with parmesan cheese, this' a perfect dish to serve on a chilly evening or windy, sunny afternoon.	7	2021-07-11 22:57:32.57392	2021-07-11 22:57:32.57392	81302a13-9b4f-4eef-93e4-16798bb1580f	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
6d8c2bf4-cfea-4eb2-82f4-c6ce2f92b94c	Ghee-Roast Chicken Thali	North Indian	{https://d3gy1em549lxx2.cloudfront.net/41a162df-e379-450e-8245-23b132e77dcf.jpeg}	t	f	209	0	Begin your meal with a DELISH mangalorean ghee roast chicken starter, rich dal makhani accompanied with whole wheat laccha paratha, jeera flavoured rice, boondi raita and pickle. Hot-selling and delicious!	11	2021-07-11 22:57:32.595612	2021-07-11 22:57:32.595612	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
ba2839d2-af34-4fd0-858b-7450703a8aab	Kadhai Paneer Duo Bowl	North Indian	{https://d3gy1em549lxx2.cloudfront.net/4ee2b207-0f58-46d7-807e-dc5dcdb4c76e.JPG}	t	t	219	0	An Indian preparation of kadhai paneer, right with aromatic spices and choice vegetables like onion, tomato, bell peppers is made rich to pair with dal tadka and jeera rice along with mint chutney and lachha onions. There's everything you will want in a bowl!	13	2021-07-11 22:57:32.61573	2021-07-11 22:57:32.61573	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1ae9914c-ceee-42e3-ae3e-3db11368dc7f	Banarasi Aloo-Mutter Bowl	636 cal | Low Calorie	{https://d3gy1em549lxx2.cloudfront.net/dfbc7029-525c-468c-b435-87b86ca24a93.JPG}	t	t	169	0	Potato dices with green peas are simmered in a flavoursome banarasi style rich gravy. Served on top of flavourful jeera rice.	13	2021-07-11 22:57:32.638757	2021-07-11 22:57:32.638757	532975e4-a104-422c-afdd-4cffe4c62d78	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a1f2e5d5-f178-4c34-9308-e88f41804f92	Teriyaki-Chicken Hot Pot	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/fd0c62b2-3c65-4f68-be42-c01167216900.jpg}	t	f	249	0	FreshMenu's signature Teriyaki sauce is an all time favourite meal with our guests. Teriyaki chicken steak is served with leeks, broccoli, mushroom, bell pepper, carrot and Chinese cabbage seasoned, sautéed and simmered in a rice-wine vinegar infused teriyaki sauce. Served with a portion of spicy chilli-garlic fried rice. May contain mushrooms. All our bowls are prepared fresh on your order.	12	2021-07-11 22:57:32.660018	2021-07-11 22:57:32.660018	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
85cc075b-9e48-4b68-8317-5e1796473d10	Pan-Asian Egg 'n' Chicken Chowmein	518 cal | Calorie	{https://d3gy1em549lxx2.cloudfront.net/16835397-84e9-4aef-a7ee-98e3dfb37f8d.jpg}	t	f	219	0	A classic dish of stir-fried noodles wok-tossed with pulled chicken, egg, bok choy, Chinese cabbage, carrot and bell peppers. This makes for one satisfying meal full of goodness from veggies and chicken. May contain mushrooms. All our bowls are prepared fresh on your order.	16	2021-07-11 22:57:32.677451	2021-07-11 22:57:32.677451	593750cf-33a4-437a-ac70-0d498a3acac8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
537bf1d3-21ec-49d8-803d-9d463a6aa403	Lebanese Falafel Superbowl	553 cal | High Protein	{https://d3gy1em549lxx2.cloudfront.net/a47925a0-b413-4e65-8dbe-f3d0c5d0684e.jpg}	t	t	269	0	A bowl full of greens and veggies. Quinoa brown rice is sauteed with onions, garlic, carrot, olives, parseley and seasonings. Served with Tzatziki, tomato salsa, Israeli salad and falafels. It's a must-have healthy bowl.	10	2021-07-11 22:57:32.701576	2021-07-11 22:57:32.701576	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
f81c34ba-4123-421f-9ab1-c99468cefd04	Keto Creamy Tuscan Chicken	380 cal | Keto Friendly	{https://d3gy1em549lxx2.cloudfront.net/fb695225-9b14-46e8-8f51-710a2f48d0fb.jpg}	t	f	225	0	A hearty and creamy Tuscan-style chicken-veggie casserole made lively with sundried-tomato pesto and oodles of cheese sauce.	8	2021-07-11 22:57:32.72777	2021-07-11 22:57:32.72777	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0ed80150-86de-475d-8768-b7e48b1ba538	Broccolli Quinoa Casserole	Continental	{https://d3gy1em549lxx2.cloudfront.net/7d527ea4-3ff4-4a76-888c-efd4d8a132ec.JPG}	t	t	239	0	Here’s a lip-smacking dish exemplary of casseroles: broccoli, cauliflower, onions, foxtail-quinoa millets are tossed, folded in along with milk, cream and seasoned and baked perfectly. This casserole is quite the hearty, creamy companion if you are looking for one!	10	2021-07-11 22:57:32.756011	2021-07-11 22:57:32.756011	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
11be21e7-5c6a-4374-b03c-ea1fdac157eb	Chicken Lemon Coriander Soup	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/f06ab8b0-6020-42ec-aa82-189e7c248211.jpg}	t	f	149	0	Chopped carrots, cabbage and strands of boneless chicken are cooked to perfection in a delicious lemon-coriander broth. Chicken soup for the soul anyone? Serves 1. ENERGY (KCAL) 200, Fat (g) 7.6, Carbs (g) 13, Fiber (g) 3, Protein (g) 19	14	2021-07-11 22:57:32.778988	2021-07-11 22:57:32.778988	b81fede0-bc1a-4009-a258-212b957dbdaf	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
7310a450-143a-49a1-ae6b-052ddd9fc901	Chicken Tikka Masala (450 Gms)	North Indian	{https://d3gy1em549lxx2.cloudfront.net/b3ac36dd-9cd1-4f31-a422-9fec1a5c8811.jpg}	t	f	279	0	Boneless chicken chunks marinated with Indian spices and cooked in a rich masala gravy. Accompany this gravy with your favourite rice/parathas/rotis and your meal is ready! Serves 2-3	8	2021-07-11 22:57:32.796609	2021-07-11 22:57:32.796609	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
fb327df2-0279-4cf5-b6e8-7a1a6f71694e	Southwestern Fried Chicken Strips	Continental	{https://d3gy1em549lxx2.cloudfront.net/2252501f-0c32-4fe3-8ae1-d20f2120dd33.jpg}	t	f	219	0	We take on the ‘southern-fried chicken’ for tinier, delectable bites. Strips of deboned chicken marinated in Cajun-spiced yogurt, are breaded, deep fried and served with a hot, sweet and creamy jalapeño-mango-mayo dip. Serves 2-3.	11	2021-07-11 22:57:32.813628	2021-07-11 22:57:32.813628	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
03245998-0b87-4d43-ba66-eab5cca022a4	Malabari Paratha (Pack of 2)	Indian	{https://d3gy1em549lxx2.cloudfront.net/e43033b1-52de-4236-a40d-95e295aedadb.jpg}	t	t	69	0	This consists of 2 Malabari Parathas	13	2021-07-11 22:57:32.800013	2021-07-11 22:57:32.800013	fd261909-81e3-4c93-9f65-e4c3922e6b6a	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a6b7accc-c8e7-431d-94b4-d5573faf620f	Asian BBQ Paneer	Asian	{https://d3gy1em549lxx2.cloudfront.net/e339276b-42d6-4418-9db1-06f64ec3d354.JPG}	t	t	219	0	Sweet and Spicy smokey BBQ flavors in this Asian BBQ Paneer starter. Spice up your meal with this all time favorite Asian BBQ flavor.	7	2021-07-11 22:57:32.816699	2021-07-11 22:57:32.816699	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
83f71a87-32ce-4734-9724-66eb0d8548ce	Cheesy Chicken Popcorn	Fusion	{https://d3gy1em549lxx2.cloudfront.net/1b0dbeaa-2997-4852-ba89-1409544ac7d6.jpg}	t	f	219	0	Our Cheese Loaded Chicken Popcorn is a dreamy beginning to your meal – deboned and diced chicken coated with ghost-chilli flakes, fried till golden brown is served with a spicy salsa and finally loaded with a luscious cheese sauce!	10	2021-07-11 22:57:32.835297	2021-07-11 22:57:32.835297	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
cce2a3d7-0f8b-4a5b-b85d-5db12be4a0d9	Teriyaki chicken rice bowl + Pan-asian egg 'n' chicken chowmein + Mint lemonade	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/6bc3a303-405a-4b7f-936e-4abddf3e4b9b.jpg}	t	f	499	0	Wholesome combo for the family. This combo has Pan asian egg 'n' chicken chowmein, teriyaki chicken rice bowl and a freshly made mint lemonade. Enjoy!	19	2021-07-11 22:57:32.85277	2021-07-11 22:57:32.85277	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1fe789b4-226a-4f4b-ad96-9dac34261cd2	Fresh Cream Truffle Balls (Pack of 2)	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/aeb6c47e-a39d-4546-b61b-6241f12257e3.JPG}	t	t	79	0	Get popping with fresh cream layered with chocolate ganache and dreamy chocolatey flavours. Have fun this season as you begin your indulgence with the sinful truffle pops!	10	2021-07-11 22:57:32.86886	2021-07-11 22:57:32.86886	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
33c6696c-1260-4cab-adec-441e71695139	Red Velvet Cheesecake Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/b9eaf9e8-c261-4e7e-b512-bdda47b8eec2.JPG}	t	t	149	0	This delightfully delicious jar dessert comes with layers of spongy red velvet cake with rich cream cheese. Topped with white chocolate flakes and red velvet sponge crumbs. Go ahead and pamper yourself.\nVEG\nCONTAINS SOY\nCONTAINS NUTS	9	2021-07-11 22:57:32.887664	2021-07-11 22:57:32.887664	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0479bc94-2d9d-4415-8c4e-e10d95866338	Melting Moments Cookies (Pack of 10)	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/e0862db0-c17c-4da5-987b-c445fd5e464f.JPG}	t	t	79	0	Vanilla flavoured cookie rolled on corn flakes and baked to perfection. These yummy cookies make some great moments. Indulge!	10	2021-07-11 22:57:32.904372	2021-07-11 22:57:32.904372	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0734c246-caf4-454d-97a7-cd46d6c7bb4e	Irish Coffee Lava Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/39606318-f1a8-4e4c-a1fa-8adbf010380e.jpg}	t	t	149	0	Happiness is when you are drunk on dessert! The bold Irish coffee meets the beautiful lava cake in this jar of decadence. Layers of Irish cream, molten chocolate cake, English pound cake and white chocolate ganache might just be the ultimate marriage of sweet flavours! Served in paper container.	11	2021-07-11 22:57:32.920817	2021-07-11 22:57:32.920817	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
86ef3ffa-fec3-42cd-bbff-7e66d0fca183	RAW Aloe Vera Lemonade	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/b5f69c3d-f2b7-4079-8a31-663f29e81e9f.jpg}	t	t	67	0	Get energized with this refreshing cold-pressed Aloe Vera Juice, enhanced with the flavours of tangy lemon and zingy ginger.	9	2021-07-11 22:57:32.938035	2021-07-11 22:57:32.938035	3fb8ba79-82b1-49df-9f86-8308601b4f48	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
bc6ddebf-60f8-42b7-8b95-5c7b53171d25	Veg Spring Rolls	Indian	{https://d3gy1em549lxx2.cloudfront.net/766d9e02-d0f6-4c56-b05b-fd14fbb4a057.jpg}	t	t	189	0	Experience a mouthful of fresh veggies and juicy cottage cheese rolled in wonton sheets as you bite into this hot and crunchy Appetizer. It is served with an Asian hot garlic sauce on the side.	15	2021-07-11 22:57:32.809602	2021-07-11 22:57:32.809602	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
30557847-5669-4321-8133-4c5d2a1d1f35	Honey Chicken Peppers	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/ad9836ee-6238-479e-835b-a25749c034d9.JPG}	t	f	189	0	Sugar, spice and everything nice is exactly what this Oriental-style hors d’oeuvre is! Deboned chicken leg, diced, marinated in soy-infused hot sauce is deep fried, tossed with assorted bell pepper, chilli, garlic and honey to deliver a contrasting but well-balanced sweet and hot punch.	7	2021-07-11 22:57:32.826914	2021-07-11 22:57:32.826914	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
193b00d0-aa3a-481c-95c9-3454ef0eb69b	Peri-Peri Potato Wedges	Fusion	{https://d3gy1em549lxx2.cloudfront.net/c69d26e4-f98d-44ae-a0fb-bd301436af0c.jpg}	t	t	149	0	Who doesn't love potatoes? And more so when they are deliciously crispy! Hearty, filling and a total party-starter, these baked potato wedges seasoned with peri-peri spice (Peri Peri in Swahili means ‘pepper-pepper’), are served with chipotle mayo.	12	2021-07-11 22:57:32.844813	2021-07-11 22:57:32.844813	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
89b97e0d-aeb9-4307-985e-4345c2f4f378	Ghee roast chicken biriyani + Shahi tukda + Raita + Masala lemonade	Indian	{https://d3gy1em549lxx2.cloudfront.net/00226247-67df-468e-90a2-0a62d326530a.jpg}	t	f	399	0	You mealtime set during this cricket season. Mouth-watering, dum cooked ghee roast chicken biriyani is accompanied with a Bhurani Raita, a shahi tukda and a refreshing masala lemonade..	18	2021-07-11 22:57:32.862185	2021-07-11 22:57:32.862185	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0b0c8f11-8f6f-42bd-b8f2-8d4887023894	Crumble-Blueberry-Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/f3d6fff1-eb8e-4372-9786-7abb56382fc9.JPG}	t	t	89	0	An exotic wild berry cake filled with Berries of the forest and a delicious Buttery Streusel Topping, a traditional recipe handed over through generations... the wild berry crumb cake is the perfect dessert for all occasions and also as a morning breakfast cake.	5	2021-07-11 22:57:32.912457	2021-07-11 22:57:32.912457	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
55f4e515-47db-490f-8d06-619dca2ab840	Double Treat Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/3cc8e625-33eb-46da-9411-4705926acb18.jpg}	t	t	239	0	This combo consists of Lava cake in a Jar + Death By chocolate Jar.	10	2021-07-11 22:57:32.934161	2021-07-11 22:57:32.934161	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2a210685-be2d-40a3-a245-219385dca664	Chilli-Corn 65	Indian	{https://d3gy1em549lxx2.cloudfront.net/2799a34e-8035-4ebf-b87b-ba6f9cefee08.JPG}	t	t	179	0	A veggie twist on an indian favourite! Relish these spicy deep-fried sweet corn tossed in a masala of chilli, mustard seeds, curry leaves, coriander leaves and african peri-peri seasoning. This is snacky heaven!	9	2021-07-11 22:57:32.812667	2021-07-11 22:57:32.812667	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
37f0cea6-645d-4381-9dc0-a1fbbebb3ba5	Madras-Chicken-Cutlets	Indian	{https://d3gy1em549lxx2.cloudfront.net/5ea82fff-15fb-4260-898d-8a3e6d143c5a.jpg}	t	f	189	0	Perfect chicken cutlets which comes with a patty made with potato, chicken mince, carrot, celery, and sautéed garlic and onion, coated with bread crumbs. This is perfectly golden fried and it's oh-so-yummmm! Served with paprika dip.	14	2021-07-11 22:57:32.829568	2021-07-11 22:57:32.829568	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
8bb947b9-ad56-4b54-bd77-f2e70c0e6e03	Maori Fish Fingers	Continental	{https://d3gy1em549lxx2.cloudfront.net/c4695a80-4f08-4b78-8408-29c123a69d41.jpg}	t	f	269	0	Fried fish never disappoints! The classic fish-fingers are given a twist with a dash of exotic Maori spices to tantalize your taste buds. Served with a jalapeño and green-chilli sauce, these fish fingers will have you smacking your lips till the last bite. Contains 6 pieces.	10	2021-07-11 22:57:32.848183	2021-07-11 22:57:32.848183	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b27bb0c9-a60c-4340-b00a-eff94a2b6e0d	Mini Ultimate Burrito Bowl + Rainbow Pastry	Continental	{https://d3gy1em549lxx2.cloudfront.net/0366b53f-8765-4161-bc3a-7a46652a38ae.jpeg}	t	t	249	0	An combo value meal for you, with our bestseller ultimate burrito bowl (mini) along with freshly baked rainbow pastry.	10	2021-07-11 22:57:32.864654	2021-07-11 22:57:32.864654	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
0b64ed23-5ab0-4107-9c4c-16d7e9a14738	Salted Caramel Chocolate Tart	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/0e2b209f-76e6-4254-82f6-75d7c399ed6f.jpg}	t	t	139	0	Salt and caramel – a combination that has for long puzzled French chefs and will continue to remain a rarity among culinary obsessions. Let’s introduce chocolate to this elite combination and pipe the trio into a flaky tart – can you imagine the flavours and textures at play here? Try it, already!	13	2021-07-11 22:57:32.883034	2021-07-11 22:57:32.883034	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
fd095045-7bce-473f-86ac-a1425945c870	Hazelnut Crunchy Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/e8d69036-26b1-482b-8df3-e9111a941177.JPG}	t	t	139	0	The ultimate chocolate fantasy for a chocoholic... Layers of Turkish slow roasted Hazelnut and Belgium dark chocolate mixture folded with premium marquise and sandwiched between OREO cake crumble with a generous shower of toasted Hazelnut...Time to dig in and enjoy it, when topped with vanilla ice cream or just shared with your loved ones!!	10	2021-07-11 22:57:32.933671	2021-07-11 22:57:32.933671	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
3a827ed7-efed-45b8-9374-faab586c8e1e	Chicken-Tikka	408 cal | Keto Friendly	{https://d3gy1em549lxx2.cloudfront.net/fa7a5e74-7cec-4222-a3a2-9cc98bafc5e4.jpg}	t	f	199	0	This tongue tickling starter comes with boneless chicken tikka that's roasted to perfection. Sprinkled with chaat masala, fresh coriander leaves to recreate the best Indian street food experience. Served with mint chutney to give you the perfect lip-smacking indulgence.	14	2021-07-11 22:57:32.830371	2021-07-11 22:57:32.830371	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
9bcdf33f-6117-400d-a971-821e419e0487	Falafel Platter	Middle Eastern	{https://d3gy1em549lxx2.cloudfront.net/4541c2d0-0847-4937-adc8-2de200c45f04.jpg}	t	t	189	0	A naturally gluten-free high protein mediterranean favourite flavoured with coriander, paprika, garlic, cumin, peppers and cilantro. Coupled with homemade hummus and chef's special tzatziki. Enjoy the taste of Arabia!	11	2021-07-11 22:57:32.848946	2021-07-11 22:57:32.848946	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
361c6462-7f5b-4ef1-b531-a8c58bffaea4	Signature Piri-Piri Steak Family Combo	Continental	{https://d3gy1em549lxx2.cloudfront.net/e2d27acf-dd5f-475a-a16f-4595aa6934bc.jpg}	t	f	399	0	Bringing a family meal to binge on. A delicious veggie loaded penne rustica served along with peri-peri grilled twin chicken steak, some potato wedges and a cheesy jalapeno dip sauce. Enjoy!	10	2021-07-11 22:57:32.86519	2021-07-11 22:57:32.86519	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2a00c29a-46a5-4d94-8efc-3c9d605e27d0	Shahi-Tukda	Indian	{https://d3gy1em549lxx2.cloudfront.net/5b529aab-82fc-4c53-85a3-b8a15d080b9a.JPG}	t	t	89	0	Shahi tukda is a rich, royal Mughlai dessert to indulge this festive season. Sugar coated bread topped and soaked with fragrant creamy sweet thickened milk or rabri and garnished with dry fruits. Order now	6	2021-07-11 22:57:32.883704	2021-07-11 22:57:32.883704	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
dda7f0fa-19c3-4340-a952-ff2d2b5f924a	Dutch Truffle Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/009fa3ec-fd88-4d4e-a941-b7032b38f332.JPG}	t	t	99	0	Love chocolate? Then this tender, luxurious layer cake is for you. With a ganache glaze and a fabulous filling, the indulgence is so worth it, freshly baked with much love by our chefs in-house!	6	2021-07-11 22:57:32.901161	2021-07-11 22:57:32.901161	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
163e877e-db8c-40df-a948-887388744362	Tiramisu Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/9ac36570-575a-49af-9828-99f5fa459929.JPG}	t	t	149	0	This exotic Italian Jar comes with a heavenly combination of pure dark coffee extract, velvety whipped cream cheese with white chocolate truffle. Go ahead and treat yourself. Served in paper container.	9	2021-07-11 22:57:32.917718	2021-07-11 22:57:32.917718	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
56933565-a7af-480b-a979-94a8a891d8bc	Brownie Tiramisu	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/16146462-ddb5-40c5-bf8f-feaaecfea64d.JPG}	t	t	99	0	An elegant and rich layered dessert, Tiramisu is “pick me up” in Italian. Brownie topped with a piping of crumbled chocolate, whipped cream and cream cheese. This delicious tiramisu garnished with coffee and cocoa, is for sure a crowd pleaser!	9	2021-07-11 22:57:32.934747	2021-07-11 22:57:32.934747	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
8dfaf9f3-cc27-4c3e-828e-a90bd140bed4	Hawker's Chilli Chicken	Asian	{https://d3gy1em549lxx2.cloudfront.net/2b2b903c-9f5a-4510-a98d-400fa6c6bfff.JPG}	t	f	189	0	Hawker style chilli chicken for a perfect start to your meal with its burst of spicy, savoury and a hint of sweet flavours.	7	2021-07-11 22:57:32.83089	2021-07-11 22:57:32.83089	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
530999b2-29ae-44a1-9444-79707766678e	Chilli Cheese Toast	Continental	{https://d3gy1em549lxx2.cloudfront.net/ffc037e2-e9ff-4184-b7ee-b8cefe7c71ae.jpg}	t	t	129	0	In time, the Egyptians discovered a fantastic way to preserve their bread, to scorch it on a hot stone in front of an open fire, and, voila, ‘toast’ was born! Now if you are quite ‘toast’ today and need a quick bite to pep you up, try our Chilli Cheese Toast – cheesy, spicy and downright addictive! Serves 1.	14	2021-07-11 22:57:32.849504	2021-07-11 22:57:32.849504	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c1d05b80-72b2-40f1-8664-1e56ddbc50a4	Spinach Corn Sandwich + Blueberry Oatmeal Cake	Continental	{https://d3gy1em549lxx2.cloudfront.net/4d644631-af37-4b2a-95ea-546f20856191.png}	t	t	199	0	A veggie combo to fulfill your breakfast or snack cravings. This combo consists of Spinach Corn Sandwich and Blueberry Oatmeal Cake slice	10	2021-07-11 22:57:32.865698	2021-07-11 22:57:32.865698	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
df581413-878b-444e-a670-0daeb1d8314f	Red-Velvet Swiss Roll	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/0411effa-5f6b-41c5-acb0-386ba01fe00b.JPG}	t	t	89	0	Red-Velvet sponge smothered with Italian cream-cheese, whipped cream and white chocolate, rolled and packed in a box that’s simply YOURS for the taking.	8	2021-07-11 22:57:32.884357	2021-07-11 22:57:32.884357	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
e200b530-643b-4255-bf1e-d8b3bbdd53a3	Brownie Sandwich Cookies	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/691b508b-96f2-468c-8d4a-593abf82595f.jpg}	t	f	99	0	Two brownie cookies sandwiched with some indulgent Irish Coffee Cream – the flavour that explodes in your mouth, that’s magic… pure magic!	6	2021-07-11 22:57:32.90162	2021-07-11 22:57:32.90162	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
af69f59a-a200-446e-9cdf-7ac5f7ac6220	Death-By-Chocolate Mousse Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/c5a409ee-785a-4738-9d79-8345fc6a66ad.JPG}	t	t	129	0	Old-fashioned baked American Devil's food cake layered with rich dark chocolate Marquise glazed with butter candy sauce and topped with pure Belgian dark chocolate shavings...truly a sinful chocolate jar. Prepared fresh in our in-house bakery daily with no added preservatives.	6	2021-07-11 22:57:32.918475	2021-07-11 22:57:32.918475	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5e656586-7689-423c-845b-7ba817a94844	Chocolate Mousse Mudcake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/24285b61-e355-4681-ba34-7180729aa9ad.JPG}	t	t	99	0	Deliciously moist and rich, this is definitely THE best ever cake for chocolate lovers. Covered in a creamy chocolate ganache and more ganache is finally garnished with butter scotchnuts and choco flakes. One piece is never enough!	6	2021-07-11 22:57:32.935228	2021-07-11 22:57:32.935228	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
77df1aee-8854-4683-9cb2-4b1b09afe10e	Veggies in Chilli-Garlic Sauce	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/4859b9fb-ed15-4998-8160-8985e4b17ff6.JPG}	t	t	179	0	Batter-fried veggies are tossed in a chilli-garlic sauce along with onions and spices, garnished with spring onion. This is your go-to Starter when you want a little bit of everything!	12	2021-07-11 22:57:32.83415	2021-07-11 22:57:32.83415	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
9c6d55c2-78d5-4248-96ac-7f677faa5adc	Chilli corn 65 + Peri-peri potato wedges + Veg spring rolls	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/2d895052-dd54-4d27-bade-35b38aba9541.jpg}	t	t	489	0	Lip-smacking starters this IPL season. This combo contains chilli-corn 65, peri-peri potato wedges and veg spring rolls. Accompany with your favourite beverages and enjoy the match..All the bestsellers-in-one!	16	2021-07-11 22:57:32.851698	2021-07-11 22:57:32.851698	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5d4c0792-5edf-470a-97bf-381dabf4ac01	Bold Bites Combo	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/dcaa48b8-5be1-4919-8d92-daf7ce2134ae.JPG}	t	t	599	0	Bring home this exciting platter for you and your family which has chilli potato shots (10nos.), veg spring rolls (4pcs), crispy fried corn, chilli paneer and a sweet chilli sauce to accompany. We're sure you will enjoy with your fav series/match!	16	2021-07-11 22:57:32.867863	2021-07-11 22:57:32.867863	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5654a2ea-4c36-4316-bc66-e52c2baea012	Homemade Chocolate-Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/8059ae5c-6153-430f-8b5e-0b84cd9aabe1.jpg}	t	t	89	0	A double-layered chocolate sponge and chocolate ganache extravaganza – creamy, chocolatey with indulgence in each bite!	6	2021-07-11 22:57:32.886584	2021-07-11 22:57:32.886584	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
ac3d9b0f-0747-4139-a26f-82508195e198	Lemon Tart	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/47f7c3c5-f04d-4bf5-abd2-abce090b0195.jpg}	t	f	119	0	The French say a good lemon tart is the way to a woman’s heart. And for that, a calming yet contrasting balance between the lemons and a flaky, sweet base is essential. Try our Lemon Tart and you’ll probably give in to a dozen more – a rich lemony custard graces a crumbly tart before being baked till the sweet, citrusy aromas remind us that the tarts are done! Serves 1.\nCONTAINS EGG	11	2021-07-11 22:57:32.903245	2021-07-11 22:57:32.903245	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
3f3db52b-9a71-490d-a93f-d6b714f78a1b	Choco Chunk Banana Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/8c5ce4e4-4371-46a8-b18f-72bc5759aeea.JPG}	t	t	85	0	Looking for a sweet treat? Bite into this cake enriched with dark chocolate chunks, rich banana with the goodness of jaggery and baked to perfection. We bet you can't eat just one!	8	2021-07-11 22:57:32.919846	2021-07-11 22:57:32.919846	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
2d2ceac8-40ad-4ac2-84b5-f1c97266f451	Lemon Cheesecake	Universal	{https://d3gy1em549lxx2.cloudfront.net/639d635f-2bc1-4f49-a451-8c4140033449.jpg}	t	f	149	0	New york style baked cheesecake enriched with creamy Philadelphia creamcheese and slow baked on a bed of home-baked golden cookie crumble crust and topped with a rossette of zesty lemon curd and silvers of Afghanian pistachios.	15	2021-07-11 22:57:32.936743	2021-07-11 22:57:32.936743	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
d3b428c8-1290-41a7-a840-6f81d5e570ae	Sesame-Chicken-Bites	Pan-Asian	{https://d3gy1em549lxx2.cloudfront.net/a1ff5158-2aec-4ce5-8d17-c4b6e395c9fa.jpg}	t	f	189	0	These crispy cousins of the now-famous chicken popcorn are, and believe us when we say this, quite addictive. Succulent chunks of deboned chicken rested-well in a spicy chilli-soy marinade are crumb fried until golden, garnished with sesame seeds for that extra nutty-crunch and served with a divine hot and sweet chilli-plum sauce.	13	2021-07-11 22:57:32.834753	2021-07-11 22:57:32.834753	3dcc81e4-a728-4a9a-b4e9-4d400fd24344	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
8546e30a-4ebf-4352-a7b7-fa48d6fc7bee	Chicken Tikka Sandwich + Mini Fruit Parfait	Continental	{https://d3gy1em549lxx2.cloudfront.net/7dcb19e0-c2dc-4c32-830d-3c22df89a843.JPG}	t	f	199	0	Wholesome breakfast or snack combo consisting of Chicken Tikka Sandwich and a Mini Fruit Parfait.	9	2021-07-11 22:57:32.852286	2021-07-11 22:57:32.852286	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
274f291e-518c-44fa-90e1-8f33e5cff341	Jumbo Asian Appetizers Combo	Fusion	{https://d3gy1em549lxx2.cloudfront.net/a98de430-fce4-4ed3-a1e6-2887ef0dcbe0.JPG}	t	f	469	0	Your best accompaniment anytime..Asian veg spring rolls, sesame chicken bites, honey chicken peppers and crispy fried corn along with a sweet chilli sauce. Need we say more? Indulge now and enjoy!	11	2021-07-11 22:57:32.868385	2021-07-11 22:57:32.868385	4df08324-7d8a-4567-843d-adf9b9a443a8	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
cd23e99c-51fe-4011-9c07-b7745411ef85	Rabdi Gulab Jamun Tart	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/28fe8003-4d6a-4648-938b-57523c49c3de.JPG}	t	t	169	0	A french butter-crust pie layered with rose flavoured heavenly golden fried jamun and baked on a bed of creamy 'rabdi' with Afghani pistachios..Let the celebrations begin!	10	2021-07-11 22:57:32.887149	2021-07-11 22:57:32.887149	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c18fc1ac-f2b2-4b68-888e-cbffa4753249	Red-Velvet Pop-(Pack of 2)	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/62f259b7-bc96-4c03-a0de-3db2d3c50311.jpg}	t	t	89	0	This cake pop, baked and mixed with strawberry compote, dunked in white chocolate and drizzled with dark chocolate – the perfect n-the-go dessert to satiate your sweet-tooth. Pack of 2 pops!	8	2021-07-11 22:57:32.903871	2021-07-11 22:57:32.903871	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a4f44412-7e06-42bb-b326-ef050152fa0f	Classic Rabdi Gulab-Jamun	Fusion	{https://d3gy1em549lxx2.cloudfront.net/3281f636-df24-4f21-b994-e9c962cdf4fd.jpg}	t	t	89	0	Classic Indian dessert, where Gulab ]amuns combine with a creamy Rabri makes a tasty combination. Small sized golden gulab jamuns floating in creamy, sweet saffron flavored rabdi or rabri garnished with pistachio and almond silvers is what you would experience a TREAT. Served chilled.	5	2021-07-11 22:57:32.92036	2021-07-11 22:57:32.92036	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
f8c40f88-b76c-4b22-b18a-93c25a72fbb1	Masala Lemonade	Universal	{https://d3gy1em549lxx2.cloudfront.net/020c54f1-1ff3-4aaf-afcc-6190a03df451.jpg}	t	t	89	0	Classic lemonade with a twist of Indian spices makes this invigorating drink a perfect Summer drink. Made with freshly squeezed lemon juice.	13	2021-07-11 22:57:32.93735	2021-07-11 22:57:32.93735	3fb8ba79-82b1-49df-9f86-8308601b4f48	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
cabef0b6-6bb1-4195-8e68-782d2986b6cf	Sea-Salt Brownie Cookies (2 pieces)	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/79263d1f-dc25-4240-b3ec-eb03032434db.jpg}	t	f	99	0	What makes something sweeter? A pinch of salt, of course! Glorious and gooey brownie-cookie enriched with a sprinkle of sea-salt crystals, adding to an already interesting flavour-profile! TRY!	7	2021-07-11 22:57:32.877375	2021-07-11 22:57:32.877375	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
ba81ef4c-a286-4dd5-b17e-be098278cc47	Lava-Cake in a Jar	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/35072d84-da9c-4db3-a6b5-22879cc77573.jpg}	t	t	129	0	This 'cake in a jar' is truly a delectable dessert. It is carefully designed with layers of dark chocolate, crunchy nuts and dry fruit crumble. A melody of dark chocolate sprinkle is added to make it all the more indulgent. This dessert has won the hearts of many and is a stellar dish. Served in a paper container.	11	2021-07-11 22:57:32.89891	2021-07-11 22:57:32.89891	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
b6b94300-ddbe-4c9b-961f-44d2f694d4a7	Zero Sugar Coffee Pot de creme	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/c211d4ba-2801-41ce-b0a6-2094118374f8.JPG}	t	f	149	0	All you healthy dessert lovers, we have whipped out a coffee-licious dessert for you. At the base of this rests sugarfree chocolate chunks, along with creme mixture, topped with French coffee pot de creme! Enjoy guilt-free with this Zero-sugar jar!	8	2021-07-11 22:57:32.928286	2021-07-11 22:57:32.928286	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
db9a08ef-a56d-4ac5-a2a3-b929babae544	RAW Sugarcane Juice	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/64c63f40-fb80-4da1-8331-cda4c49a2153.jpg}	t	t	76	0	Energy K(Cal)- 152, Carbs- 28g, Fat- 0.2g, Protein- 3g, Fiber- 4g, Sodium- 48g Get energized with this refreshing cold pressed sugarcane juice, enhanced with the flavors of tangy lemon and zingy ginger.	8	2021-07-11 22:57:32.947596	2021-07-11 22:57:32.947596	3fb8ba79-82b1-49df-9f86-8308601b4f48	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
c26b3c31-ebac-4274-827d-dd33f5930f9d	Double-Chocolate Cake Slice	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/0150b7ac-b3f6-4098-9ea3-0f8405e0e1b6.JPG}	t	t	89	0	There's nothing like too much chocolate! And here's another reason to pamper your sweet tooth with this chocolate cake, loaded with the decadence of milk chocolate and dark chocolate. Double chocolate for all the chocolate lovers!	12	2021-07-11 22:57:32.879612	2021-07-11 22:57:32.879612	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
9db1fc19-8867-4aac-b3bf-b27d74a4ec94	Blueberry Oatmeal Cake	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/0b253a70-b5fc-4cdc-b488-78fce8ce7584.jpg}	t	t	89	0	An eggless Canadian blue berry cake enhanced with the goodness of milk soaked oats folded with jaggery and butter and golden baked with homemade cinnamon-blue berry compote. A perfect breakfast treat... can be enjoyed as a dessert with a scoop of ice cream or with hot cocoa.	6	2021-07-11 22:57:32.8969	2021-07-11 22:57:32.8969	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
1cd979c8-17aa-4711-a2bc-11955f6f7b88	Chocolate-Cinnamon Roll	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/8db68abe-d034-4071-8bfa-adc8e7456db3.JPG}	t	t	79	0	Dark-chocolate ganache, cinnamon-brown-sugar sprinkle, strawberry compote and raisins packed into a flaky, buttery Danish pastry – we call it the BLISS roll!	10	2021-07-11 22:57:32.914172	2021-07-11 22:57:32.914172	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
9e4a1aae-20fd-46a7-a80b-eb57649c78b0	Dulce de Leche Cheesecake Brownie	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/12c23c5a-fae4-455e-8f04-79205ef64d00.JPG}	t	f	149	0	A decadent moist chocolate fudge brownie with a layer of cheesecake and LOTS of dulce de leche (thickened milk and sugar) to indulge. Sweet caramelly milky and creamy. Heaven!	9	2021-07-11 22:57:32.931119	2021-07-11 22:57:32.931119	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
a6096d42-69ee-4789-bdda-cc917a503d43	Mint Chaas	Indian	{https://d3gy1em549lxx2.cloudfront.net/3867c0c8-6e4f-441e-8972-494790ce3070.JPG}	t	t	89	0	Beat the heat with this pack of buttermilk, made with smoothly whipping-up curd, chaat masala, fragrant cumin powder and water. Garnished with fresh mint and coriander leaves, it surely quenches your thirst!	13	2021-07-11 22:57:32.950429	2021-07-11 22:57:32.950429	3fb8ba79-82b1-49df-9f86-8308601b4f48	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
65c1f332-80c3-47c6-8b6f-11f67bba87b1	Nutty Truffle Jar (Pack of 10)	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/2ac3cd14-82b8-435b-aac6-39aed257a947.JPG}	t	t	279	0	These nutty truffles are soft and nutty on the inside and covered in crunchy dark chocolate. This truffle jar is such a delightful treat, a perfect healthy TREAT.	15	2021-07-11 22:57:32.9213	2021-07-11 22:57:32.9213	8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
5a1286f9-97b6-4f30-b66e-467a3672d078	Mint Lemonade	World Cuisine	{https://d3gy1em549lxx2.cloudfront.net/62a7864c-54e8-4aa9-8625-5858d6972259.jpg}	t	t	89	0	Our tribute to the all-time-favourite lemonade with fresh mint leaves, lemon and water makes this refreshing drink an instant Summer cooler. A hint of black salt and sugar give that perfect finsh to this drink!	10	2021-07-11 22:57:32.938623	2021-07-11 22:57:32.938623	3fb8ba79-82b1-49df-9f86-8308601b4f48	47752669-d9b2-4e21-b2e0-e49c0befbbb2	{}
\.


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.menus (id, name, is_active, image, created_at, updated_at) FROM stdin;
ba89d5e2-8204-4426-a8da-3ab53f1b63f6	Spicy	f	\N	2021-06-17 19:00:35.433413	2021-06-17 19:00:35.433413
81302a13-9b4f-4eef-93e4-16798bb1580f	CONTINENTAL	t	https://images.unsplash.com/photo-1535567465397-7523840f2ae9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1014&q=80	2021-07-11 20:12:28.559943	2021-07-11 20:12:28.559943
532975e4-a104-422c-afdd-4cffe4c62d78	INDIAN / THALIS	t	https://images.unsplash.com/photo-1546833999-b9f581a1996d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.577461	2021-07-11 20:12:28.577461
be0a9f7b-da91-4728-aac7-e3ae4b95f213	SANDWICHES & MORE	t	https://images.unsplash.com/photo-1528735602780-2552fd46c7af?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1053&q=80	2021-07-11 20:12:28.510024	2021-07-11 20:12:28.510024
593750cf-33a4-437a-ac70-0d498a3acac8	WOK-STATION	t	https://images.unsplash.com/photo-1593181520415-5d48196b5ecb?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.552733	2021-07-11 20:12:28.552733
3fb8ba79-82b1-49df-9f86-8308601b4f48	FRESH BEVERAGES	t	https://images.unsplash.com/photo-1560508180-03f285f67ded?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.550379	2021-07-11 20:12:28.550379
8cd72eae-53c6-47b8-b749-9ec0f6e2d7ef	FRESH DESSERTS	t	https://images.unsplash.com/photo-1582716401301-b2407dc7563d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1054&q=80	2021-07-11 20:12:28.521728	2021-07-11 20:12:28.521728
65a11383-1fb6-4cc1-ad57-ce6fbf813c7e	BURGERS & WRAPS	t	https://images.unsplash.com/photo-1586816001966-79b736744398?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.611257	2021-07-11 20:12:28.611257
b81fede0-bc1a-4009-a258-212b957dbdaf	FIT N FAB	t	https://images.unsplash.com/photo-1577594990850-e843a8e91512?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.612036	2021-07-11 20:12:28.612036
fd261909-81e3-4c93-9f65-e4c3922e6b6a	LARGE PLATES	t	https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1224&q=80	2021-07-11 20:12:28.618727	2021-07-11 20:12:28.618727
3dcc81e4-a728-4a9a-b4e9-4d400fd24344	APPETIZERS	t	https://images.unsplash.com/photo-1607098665874-fd193397547b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80	2021-07-11 20:12:28.634821	2021-07-11 20:12:28.634821
4df08324-7d8a-4567-843d-adf9b9a443a8	FAMILY COMBOS	t	https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80	2021-07-11 20:12:28.662235	2021-07-11 20:12:28.662235
cdbf15d4-c061-4eee-8a8a-4a237f3265d0	BIG BIRIYANI CO.	t	https://images.unsplash.com/photo-1589302168068-964664d93dc0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80	2021-07-11 20:12:28.663208	2021-07-11 20:12:28.663208
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.orders (id, payment, "table", total, status, notes, "orderItems", delivered_at, created_at, updated_at, deleted_at, "userId") FROM stdin;
cf88bfb6-23a5-4c73-a619-fa5d62d1e32f	\N	\N	2000	0	\N	[{"id": "8c80d7a9-829a-478e-9a46-dc7f3c7353b0", "qty": 1, "menuItem": {"id": "86b939f3-a0fe-4713-bc65-1c89d1ab5684", "menu": {"id": "ba89d5e2-8204-4426-a8da-3ab53f1b63f6", "name": "Spicy", "image": null, "isActive": false, "createdAt": "2021-06-17T13:30:35.433Z", "updatedAt": "2021-06-17T13:30:35.433Z"}, "isVeg": true, "price": 2000, "title": "Paneer 2", "images": [], "discount": 0, "prepTime": null, "subTitle": null, "createdAt": "2021-06-17T15:32:18.995Z", "updatedAt": "2021-06-17T15:32:18.995Z", "description": null, "isAvailable": false}, "createdAt": "2021-07-05T16:01:59.175Z"}]	\N	2021-07-05 21:32:24.011817	2021-07-05 21:32:24.011817	\N	47752669-d9b2-4e21-b2e0-e49c0befbbb2
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.reviews (id, title, comment, image, ratings, created_at, created_by, menu_item) FROM stdin;
\.


--
-- Data for Name: user_items; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.user_items (id, qty, created_at, created_by, menu_item) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: battlefield
--

COPY public.users (id, first_name, last_name, email, password, date_of_birth, role, address, avatar, password_reset_token, password_reset_request_at, password_reset_at, created_at, updated_at, current_hashed_refresh_token) FROM stdin;
0cec9878-d83e-4b89-8b0f-614231c7c88c	Margot	Leuschke	cashier@cafe.com	$2b$10$ISe1bpdHo0DzweW6hMo43OwOh72I4h8vj2XANV3oDVClS9m.LF0PG	1959-11-03 05:06:43.355+05:30	cashier	Abagail Via,Apt. 658,Hiramfurt,96863	https://cdn.fakercloud.com/avatars/victorstuber_128.jpg	\N	\N	\N	2021-07-11 13:11:27.164373	2021-07-11 13:11:27.164373	\N
1ad5685f-f13d-4d08-a09e-abeacb62c317	Kaci	Ledner	chef@cafe.com	$2b$10$0clzMVDpn5N9iJS/rFjzI.BQcTMferpJT5ZlIpyWmKCInQhiX9teG	1950-03-12 04:58:09.435+05:30	chef	Barton Glen,Apt. 187,Schoenshire,55202-5982	https://cdn.fakercloud.com/avatars/daniloc_128.jpg	\N	\N	\N	2021-07-11 13:11:27.165109	2021-07-11 13:11:27.165109	\N
ae6d9802-eb0b-4e41-99c4-f64811674f53	Peggie	Mayert	manager@cafe.com	$2b$10$sGUaBgN/qF0Yuk3/9VrL4OHaTfkMBWPN7NMhHy2zeCJ.JtqqEFUcO	1975-07-28 14:07:18.967+05:30	manager	Beahan Row,Apt. 426,Waukegan,33900-3107	https://cdn.fakercloud.com/avatars/manekenthe_128.jpg	\N	\N	\N	2021-07-11 13:11:27.164021	2021-07-11 13:11:27.164021	\N
ba299f83-ce53-4173-b0ec-d7274a0df1fd	Edison	McLaughlin	waiter@cafe.com	$2b$10$RldrSKNlGt13Knsn8nm3xOOyw0va80NAVuinhuURC78NTHOGm5Qiq	1980-10-25 00:10:01.187+05:30	waiter	Milford Cove,Suite 167,Hodkiewiczburgh,33847	https://cdn.fakercloud.com/avatars/curiousonaut_128.jpg	\N	\N	\N	2021-07-11 13:11:27.216591	2021-07-11 13:11:27.216591	\N
baa0ea26-689c-41e3-b156-686124bc555a	Thea	MacGyver	admin@cafe.com	$2b$10$iCamTRDjYNaA6QnRBE6uBebe53onjBSDAoVtlMpYcV.947YT2WTre	1975-05-26 01:38:02.187+05:30	admin	Conroy Port,Apt. 274,West Wilma,06107	https://cdn.fakercloud.com/avatars/badlittleduck_128.jpg	\N	\N	\N	2021-07-11 13:11:27.164783	2021-07-11 13:11:27.164783	\N
46b695be-07fe-4ad5-8139-510516d4395d	Alaina	Bernhard	customer@cafe.com	$2b$10$9AEdet3HyXN6gmKl52QeBOVsCx2pwGzO8dhBY/we9PfQDy/q.1fcC	1989-11-17 01:21:56.543+05:30	customer	Clark Fort,Suite 717,Cruickshankborough,41332	https://cdn.fakercloud.com/avatars/ah_lice_128.jpg	\N	\N	\N	2021-07-11 13:11:27.216937	2021-07-11 13:11:27.216937	\N
47752669-d9b2-4e21-b2e0-e49c0befbbb2	Admin	\N	admin@admin.com	$2b$10$gInqu7iFNSKpaKCBc4D1iuwZZNt7I7JnxeYHU2Sz.b3eZtNyp6NNa	\N	admin	\N	https://uifaces.co/our-content/donated/gPZwCbdS.jpg	\N	\N	2021-07-08 23:03:37.347	2021-06-17 15:01:14.104922	2021-07-19 22:44:58.994062	$2b$10$CeBQxJg6e1Um6S0QFIzW8ueoKSXu3kqnICdUvloGoBjPAG2KezRLC
\.


--
-- Name: reviews PK_231ae565c273ee700b283f15c1d; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "PK_231ae565c273ee700b283f15c1d" PRIMARY KEY (id);


--
-- Name: menus PK_3fec3d93327f4538e0cbd4349c4; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT "PK_3fec3d93327f4538e0cbd4349c4" PRIMARY KEY (id);


--
-- Name: menu_items PK_57e6188f929e5dc6919168620c8; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "PK_57e6188f929e5dc6919168620c8" PRIMARY KEY (id);


--
-- Name: orders PK_710e2d4957aa5878dfe94e4ac2f; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_710e2d4957aa5878dfe94e4ac2f" PRIMARY KEY (id);


--
-- Name: user_items PK_73bc2ecd8f15ae345af4d8c3c09; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.user_items
    ADD CONSTRAINT "PK_73bc2ecd8f15ae345af4d8c3c09" PRIMARY KEY (id);


--
-- Name: inventory PK_82aa5da437c5bbfb80703b08309; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "PK_82aa5da437c5bbfb80703b08309" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: assets PK_da96729a8b113377cfb6a62439c; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT "PK_da96729a8b113377cfb6a62439c" PRIMARY KEY (id);


--
-- Name: inventory_usage PK_f48d66746355d746884006934f4; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory_usage
    ADD CONSTRAINT "PK_f48d66746355d746884006934f4" PRIMARY KEY (id);


--
-- Name: assets UQ_0746bafde253682f68d791a19db; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT "UQ_0746bafde253682f68d791a19db" UNIQUE (public_id);


--
-- Name: reviews UQ_95a0dc326986513d3df9ce645d8; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "UQ_95a0dc326986513d3df9ce645d8" UNIQUE (created_by, menu_item);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: menus UQ_a8bb3519a45e021a147bc87e49a; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT "UQ_a8bb3519a45e021a147bc87e49a" UNIQUE (name);


--
-- Name: menu_items UQ_cd7efcf2000d58b2f8d04c1bddc; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "UQ_cd7efcf2000d58b2f8d04c1bddc" UNIQUE (title, "menuId");


--
-- Name: inventory UQ_fb3b5167049bd49cb7be3e37045; Type: CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "UQ_fb3b5167049bd49cb7be3e37045" UNIQUE (name);


--
-- Name: inventory FK_00d310023a664e19b44f0d1ec31; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT "FK_00d310023a664e19b44f0d1ec31" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: orders FK_151b79a83ba240b0cb31b2302d1; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_151b79a83ba240b0cb31b2302d1" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: menu_items FK_1aebe39f161df2d252ce6055708; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "FK_1aebe39f161df2d252ce6055708" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inventory_usage FK_2f278a5177fccb31ca61c99ecc6; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory_usage
    ADD CONSTRAINT "FK_2f278a5177fccb31ca61c99ecc6" FOREIGN KEY ("inventoryId") REFERENCES public.inventory(id) ON DELETE CASCADE;


--
-- Name: reviews FK_521eb76938aa13ac7acb4c652be; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_521eb76938aa13ac7acb4c652be" FOREIGN KEY (menu_item) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: inventory_usage FK_53f1369adc442d1fb190cc0dff3; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.inventory_usage
    ADD CONSTRAINT "FK_53f1369adc442d1fb190cc0dff3" FOREIGN KEY ("consumerId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_items FK_6337598f629b28b00d041ea6244; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.user_items
    ADD CONSTRAINT "FK_6337598f629b28b00d041ea6244" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reviews FK_64ecc7f4d384fefe410200927e5; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_64ecc7f4d384fefe410200927e5" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: menu_items FK_a6b42bf45dbdef19cbf05a4cacf; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "FK_a6b42bf45dbdef19cbf05a4cacf" FOREIGN KEY ("menuId") REFERENCES public.menus(id) ON DELETE CASCADE;


--
-- Name: user_items FK_c0009b9f040d8772ab15c67cdcb; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.user_items
    ADD CONSTRAINT "FK_c0009b9f040d8772ab15c67cdcb" FOREIGN KEY (menu_item) REFERENCES public.menu_items(id);


--
-- Name: assets FK_dccd1dbe2c036b9ab80876466b7; Type: FK CONSTRAINT; Schema: public; Owner: battlefield
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT "FK_dccd1dbe2c036b9ab80876466b7" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

