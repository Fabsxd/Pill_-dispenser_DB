-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- 1. Patients with scheduled prescriptions between 6 AM and 12 PM
SELECT "patients"."name", "medicines"."name", "prescription_schedules"."hour"
FROM "prescription_schedules"
JOIN "prescriptions" ON "prescription_schedules"."prescription_id" = "prescriptions"."id"
JOIN "patients" ON "prescriptions"."patient_id" = "patients"."id"
JOIN "medicines" ON "prescriptions"."medicine_id" = "medicines"."id"
WHERE time("prescription_schedules"."hour") BETWEEN time('06:00') AND time('12:00')
ORDER BY "prescription_schedules"."hour";

-- 2. Floor and room of patient with ID 5
SELECT "floor", "room"
FROM "patients"
WHERE "id" = 5;

-- 3. Medication and patient scheduled at 8 PM
SELECT "patients"."name", "medicines"."name", "prescription_schedules"."hour"
FROM "prescription_schedules"
JOIN "prescriptions" ON "prescription_schedules"."prescription_id" = "prescriptions"."id"
JOIN "patients" ON "prescriptions"."patient_id" = "patients"."id"
JOIN "medicines" ON "prescriptions"."medicine_id" = "medicines"."id"
WHERE "prescription_schedules"."hour" = '20:00';

-- 4. Medicine with lowest available quantity
SELECT "medicines"."name", "medicines_inventory"."available_quantity"
FROM "medicines_inventory"
JOIN "medicines" ON "medicines_inventory"."medicine_id" = "medicines"."id"
ORDER BY "medicines_inventory"."available_quantity" ASC
LIMIT 1;

-- 5. Count of emergency prescriptions between 7 AM and 9 AM
SELECT COUNT(*) AS "count_emergencies"
FROM "emergency_prescriptions"
WHERE time("datetime") BETWEEN time('07:00') AND time('09:00');

-- 6. Count of purchase orders created today
SELECT COUNT(*) AS "today_purchases"
FROM "purchase_list"
WHERE date("date_needed") = date('now');

-- 7. Average available quantity per medicine
SELECT "medicines"."name", AVG("medicines_inventory"."available_quantity") AS "average_stock"
FROM "medicines_inventory"
JOIN "medicines" ON "medicines_inventory"."medicine_id" = "medicines"."id"
GROUP BY "medicines"."name";

-- 8. Top 3 patients with the highest number of prescriptions
SELECT "patients"."name", COUNT("prescriptions"."id") AS "total_prescriptions"
FROM "prescriptions"
JOIN "patients" ON "prescriptions"."patient_id" = "patients"."id"
GROUP BY "patients"."name"
ORDER BY "total_prescriptions" DESC
LIMIT 3;

-- View 1: Today's Prescription Schedule
CREATE VIEW "today_schedule" AS
SELECT
    "patients"."name" AS "patient_name",
    "medicines"."name" AS "medicine",
    "prescription_schedules"."hour"
FROM "prescriptions"
JOIN "patients" ON "prescriptions"."patient_id" = "patients"."id"
JOIN "medicines" ON "prescriptions"."medicine_id" = "medicines"."id"
JOIN "prescription_schedules" ON "prescriptions"."id" = "prescription_schedules"."prescription_id"
WHERE DATE("prescription_schedules"."hour") = DATE('now');

-- View 2: Low Stock Medicines
CREATE VIEW "low_stock_medicines" AS
SELECT
    "medicines"."name",
    "medicines_inventory"."available_quantity",
    "medicines_inventory"."minimum_quantity"
FROM "medicines_inventory"
JOIN "medicines" ON "medicines_inventory"."medicine_id" = "medicines"."id"
WHERE "available_quantity" < "minimum_quantity";
