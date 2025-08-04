# Design Document

By Fabio Ramirez

Video overview: [Video Link](https://drive.google.com/file/d/1JPVCLzLLGNRuArwdgx-dK2cNcUy3QbU_/view?usp=sharing)

## Scope

* What is the purpose of your database?

  The purpose is to keep track of solid pharmaceuticals in a medical unit. It records information about patients, medications, medication records, prescriptions, and supply routines. The system is intended to simplify medication management, ensure timely administration, and detect low inventory for proactive resupply.

* Which people, places, things, etc. are you including in the scope of your database?

  Patients, medicines, medicine inventory levels, prescriptions, prescription schedules, emergency prescriptions, and purchase orders.

* Which people, places, things, etc. are *outside* the scope of your database?

  Billing, staffing schedules, detailed medical records, and insurance processing.

## Functional Requirements

* Users can create, read, update, and delete patient records.
* Users can manage medicines and inventory levels.
* Users can schedule and view prescription doses for patients.
* Users can record emergency prescriptions and generate purchase orders when stock is low.
* Users may also generate reports summarizing current prescriptions and low inventory alerts, aiding in hospital inventory planning.
* Beyond scope: analytics dashboards, user authentication, and external system integrations.

## Representation

### Entities

* **patients** (`id`, `name`, `age`, `floor`, `room`)
* **medicines** (`id`, `name`, `location`)
* **medicines_inventory** (`medicine_id`, `available_quantity`, `minimum_quantity`)
* **prescriptions** (`id`, `patient_id`, `medicine_id`, `pill_per_day`, `frequency_hr`)
* **prescription_schedules** (`id`, `prescription_id`, `hour`)
* **emergency_prescriptions** (`id`, `patient_id`, `medicine_id`, `datetime`, `notes`)
* **purchase_list** (`id`, `medicine_id`, `date_needed`, `quantity_needed`)

We chose types to match real-world constraints (e.g., `floor` between 1–5) and enforce data integrity with primary keys and foreign keys. Checks are used to ensure no invalid quantities or ages are inserted.

### Relationships

The relationships modeled in this database are:

- One patient can have many prescriptions (`patients` → `prescriptions`).
- One medicine can be prescribed to many patients (`medicines` → `prescriptions`).
- One prescription can have multiple scheduled administration times (`prescriptions` → `prescription_schedules`).
- Emergency prescriptions are tracked separately but still connect a `patient` and a `medicine`.
- `medicines_inventory` stores the available and minimum quantity of each medicine.
- When available quantity falls below minimum, a record is added to `purchase_list` indicating that restocking is needed.

This design allows efficient management and tracking of medication flow within the facility.

## Optimizations

* Indexes on frequent lookups:
  - `prescriptions(patient_id)`, `prescriptions(medicine_id)`
  - Partial index for low-stock inventory
  - Index on `prescription_schedules(hour)`
* Trigger to auto-create purchase orders when inventory falls below threshold
* Views for low-stock and today’s schedules for fast reporting.
* Indexes were carefully selected to optimize SELECT performance during routine queries for schedules and stock levels.
* Although not implemented here, partitioning strategies could be added later to scale for large datasets.

## Limitations

* Does not support patient billing or insurance claims.
* No role-based access control or authentication.
* Limited to simple scheduling; no time zones or complex dosage rules.
* The system assumes consistent naming and data input, which may require validation layers in a real deployment.
* In the future, the system could support dose logging, multi-language support, or mobile interfaces for on-site staff.
* A logging mechanism for changes made to prescriptions could help with auditability and compliance.
