# Database Helper for Flutter

A simple Dart application to make connecting Flutter with databases easier.

---

## Purpose

This app helps you:

1. Create **data tables in SQLite**.  
2. Generate **accessible models** from SQLite data.  
3. Generate **accessible models** from JSON data.

---

## Requirements

- Dart SDK: `>=2.18.2 <3.0.0` (works perfectly with `^3.8.1`)  
- Flutter is optional if you plan to integrate the generated models in a Flutter project.

---

## How to Use

1. **Prepare your schema file**  
   Place your schema file in the `bin/schema` folder following the provided example.

2. **Run the application**  
   Open a terminal inside the project folder and type:

   ```bash
   dart run