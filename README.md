# 📊 Enterprise Sales Data Platform — Snowflake Cloud Data Warehouse

Snowflake bulut Data Warehouse'iga qurilgan, Star Schema asosidagi sotuv tahlili tizimi. Ushbu loyiha zamonaviy cloud-native Data Engineering yondashuvini — SQL orqali bulutda ma'lumotlar bazasini loyihalash va uni to'g'ridan-to'g'ri Business Intelligence vositasiga ulashni — namoyish etadi.

## 🎯 Loyiha maqsadi

Real kompaniya muhitiga o'xshash sharoitda — mahalliy fayllar o'rniga **cloud Data Warehouse** (Snowflake) ishlatib, Star Schema modellashtirish, DAX orqali biznes ko'rsatkichlarni hisoblash va Power BI orqali interaktiv sotuv tahlili dashboardini qurish.

## 🏗️ Arxitektura

```
SQL DDL/DML (Star Schema yaratish)
        ↓
SNOWFLAKE (Cloud Data Warehouse)
   ├── SALES_DATA_PLATFORM (Database)
   └── SALES_ANALYTICS (Schema)
        ├── dim_product     (mahsulot dimension)
        ├── dim_customer    (mijoz dimension)
        ├── dim_date        (sana dimension)
        └── fact_sales      (sotuv fact jadvali)
        ↓
Power BI Desktop (to'g'ridan-to'g'ri Snowflake ulanish, Import rejimi)
   ├── Data Model (avtomatik aniqlangan Relationships)
   ├── DAX Measures (SUM, AVERAGE, CALCULATE)
   └── Interactive Dashboard
```

## 🛠️ Ishlatilgan texnologiyalar

| Bosqich | Texnologiya |
|---|---|
| Cloud Data Warehouse | Snowflake (Standard Edition, trial) |
| Modellashtirish | Star Schema (SQL DDL) |
| Vizualizatsiya | Power BI Desktop (native Snowflake connector) |
| Ulanish rejimi | Import |

## ⭐ Star Schema dizayni

**Grain:** Har bir qator — bitta sotuv tranzaksiyasi (bitta mijozning bitta mahsulotdan, ma'lum sanada qilgan xaridi).

```sql
dim_product ──┐
dim_customer ─┼── fact_sales
dim_date ─────┘
```

- **`dim_product`** — mahsulot nomi, kategoriyasi, birlik narxi
- **`dim_customer`** — mijoz nomi, mintaqasi (region), davlati
- **`dim_date`** — to'liq sana, oy, chorak, yil
- **`fact_sales`** — o'lchanadigan qiymatlar: miqdor (quantity) va umumiy summa (total_amount)

## 📊 DAX Measures

```dax
Total Revenue = SUM(FACT_SALES[TOTAL_AMOUNT])

Total Quantity Sold = SUM(FACT_SALES[QUANTITY])

Average Sale Value = AVERAGE(FACT_SALES[TOTAL_AMOUNT])

Electronics Revenue = CALCULATE(
    SUM(FACT_SALES[TOTAL_AMOUNT]),
    DIM_PRODUCT[CATEGORY] = "Electronics"
)

Furniture Revenue = CALCULATE(
    SUM(FACT_SALES[TOTAL_AMOUNT]),
    DIM_PRODUCT[CATEGORY] = "Furniture"
)
```

`CALCULATE()` funksiyasi — SQL'dagi `WHERE` shartiga o'xshab, mavjud agregatsiyani (SUM) qo'shimcha filtr bilan qayta hisoblaydi. Bu — kategoriya bo'yicha filtrlangan KPI ko'rsatkichlarini dinamik tarzda olish imkonini beradi.

## 📈 Dashboard imkoniyatlari

- **KPI kartochkalari** — Total Revenue, Electronics Revenue, Furniture Revenue
- **Region bo'yicha ustunli grafik** — qaysi geografik mintaqa eng ko'p daromad keltirgani
- **Mahsulot bo'yicha ustunli grafik** — eng ko'p sotilgan mahsulotlar taqqoslamasi
- **Mijozlar jadvali** — har mijozning jami va o'rtacha xarid summasi

## 📂 Loyiha tuzilmasi

```
enterprise-sales-data-platform/
├── README.md
├── snowflake_setup.sql              # To'liq Star Schema DDL va namuna ma'lumotlar
└── Sales_Analytics_Snowflake.pbix   # Power BI dashboard fayli
```

## 🚀 Loyihani qanday ishga tushirish

1. Snowflake trial akkaunt yarating (https://signup.snowflake.com)
2. Snowsight'da yangi SQL Worksheet oching
3. `snowflake_setup.sql` faylini to'liq nusxalab, ishga tushiring (bu Database, Schema, jadvallarni va namuna ma'lumotlarni yaratadi)
4. Power BI Desktop'da **Get Data → Snowflake** orqali ulaning:
   - Server: `<sizning_account_identifier>.snowflakecomputing.com`
   - Warehouse: `COMPUTE_WH`
5. `Sales_Analytics_Snowflake.pbix` faylini oching va ma'lumot manbasini yangilang

## 📌 Muhim texnik izohlar

- **Import vs DirectQuery:** Bu loyihada **Import** rejimi tanlangan, chunki ma'lumot hajmi kichik va real-vaqt yangilanishi talab qilinmagan. Katta hajmdagi productionда esa **DirectQuery** yoki **Scheduled Refresh** bilan Import kombinatsiyasi tavsiya etiladi.
- **CREATE OR REPLACE** ishlatilgan — bu SQL skriptni istalgan vaqtda xatosiz qayta ishga tushirish imkonini beradi (idempotent skript).

## 📈 Kelajakda rivojlantirish rejalari

- Ma'lumot hajmini kengaytirish (yuzlab/minglab qator)
- Row-Level Security (RLS) — mintaqa (region) bo'yicha kirish cheklovi
- SCD Type 2 — `dim_customer` uchun tarixiy o'zgarishlarni kuzatish
- Power BI Service'ga Publish qilib, Scheduled Refresh sozlash
- Snowflake Streams & Tasks orqali avtomatik incremental yangilanish

## 👤 Muallif

Data Engineering yo'nalishida ishlashga tayyorlanayotgan nomzod tomonidan, cloud Data Warehouse tajribasini amalda ko'rsatish maqsadida yaratilgan portfolio loyihasi.
