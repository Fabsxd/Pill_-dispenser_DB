-- Create patients table
CREATE TABLE "patients" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "age" INTEGER NOT NULL CHECK ("age" > 0),
    "floor" INTEGER NOT NULL CHECK ("floor" BETWEEN 1 AND 5),
    "room" INTEGER NOT NULL CHECK ("room" BETWEEN 1 AND 12)
);

-- Create medicines catalog
CREATE TABLE "medicines" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL UNIQUE,
    "location" TEXT NOT NULL
);

-- Create medicines inventory
CREATE TABLE "medicines_inventory" (
    "medicine_id" INTEGER PRIMARY KEY REFERENCES "medicines"("id"),
    "available_quantity" INTEGER NOT NULL CHECK ("available_quantity" >= 0),
    "minimum_quantity" INTEGER NOT NULL CHECK ("minimum_quantity" > 0)
);

-- Create prescriptions table
CREATE TABLE "prescriptions" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "patient_id" INTEGER NOT NULL REFERENCES "patients"("id"),
    "medicine_id" INTEGER NOT NULL REFERENCES "medicines"("id"),
    "pill_per_day" INTEGER NOT NULL CHECK ("pill_per_day" > 0),
    "frequency_hr" INTEGER NOT NULL CHECK ("frequency_hr" BETWEEN 1 AND 24)
);

-- Create prescription schedules table
DROP TABLE IF EXISTS prescription_schedules;

CREATE TABLE "prescription_schedules" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "prescription_id" INTEGER NOT NULL REFERENCES "prescriptions"("id"),
    "hour" TEXT NOT NULL
);
-- Create emergency prescriptions table
CREATE TABLE "emergency_prescriptions" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "patient_id" INTEGER NOT NULL REFERENCES "patients"("id"),
    "medicine_id" INTEGER NOT NULL REFERENCES "medicines"("id"),
    "datetime" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT -- Additional notes
);

-- Create automatic purchase list table
CREATE TABLE "purchase_list" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "medicine_id" INTEGER NOT NULL REFERENCES "medicines"("id"),
    "date_needed" TEXT NOT NULL DEFAULT CURRENT_DATE,
    "quantity_needed" INTEGER NOT NULL CHECK ("quantity_needed" > 0)
);

-- Indexes for performance
-- CREATE INDEX "idx1" ON "prescriptions"("patient_id");
-- CREATE INDEX "idx2" ON "prescriptions"("medicine_id");
-- CREATE INDEX "idx3" ON "medicines_inventory"("available_quantity");
-- CREATE INDEX "idx4" ON "prescription_schedules"("hour");
-- CREATE TRIGGER trg_auto_purchase
-- AFTER UPDATE OF "available_quantity" ON "medicines_inventory"
-- FOR EACH ROW
-- EXECUTE FUNCTION auto_purchase_order();
