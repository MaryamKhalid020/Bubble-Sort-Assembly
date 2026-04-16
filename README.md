# 8086 Assembly Bubble Sort 🔢

A low-level implementation of the **Bubble Sort** algorithm for the Intel 8086 architecture, simulated via **emu8086**. This project showcases manual memory management, register-level data manipulation, and custom I/O conversion routines.

## 🎯 Project Objective
The goal was to implement a robust sorting utility that:
1. Accepts **7 single-byte numerical values** (0-255) from user input.
2. Converts ASCII input into raw integer data for processing.
3. Performs an in-place **Bubble Sort** with $O(n^2)$ time complexity.
4. Re-converts integer results back to ASCII for display.

## 🛠️ Technical Implementation

### **Low-Level Data Structures**
- **Array:** `db max_elements dup(?)` used for random-access indexing via `SI`.
- **Buffers:** - `input_buffer`: Raw string storage for user keystrokes.
  - `digit_buffer`: Temporary storage for integer-to-ASCII conversion.
- **Stack Operations:** Strategic use of `PUSH`/`POP` to maintain register integrity across procedure calls.

### **Core Modules**
- **Input Module (`read_and_convert_byte`):** - Captures keystrokes via `INT 21h, AH=01h`.
  - Implements an $ASCII \to Integer$ conversion algorithm: `Total = (Total * 10) + (NewDigit - '0')`.
  - Handles 8-bit overflow (caps at 255).
- **Sorting Module:**
  - **Outer Loop:** Controls $N-1$ passes.
  - **Inner Loop:** Executes adjacent comparisons using `JBE`/`JNBE` conditional jumps.
  - **Swap Block:** Executes a 3-step value exchange using the `DL` temporary register.
- **Output Module (`byte_to_ascii_print`):** - Performs repeated division by 10 (`DIV`).
  - Converts remainders to ASCII (`ADD AH, 30h`) and stores them in a buffer for string printing (`INT 21h, AH=09h`).

## ⚙️ How to Run
1. Open the `.asm` file in **emu8086**.
2. **Emulate** and **Run**.
3. Enter 7 numbers when prompted (press Enter after each).
4. View the sorted result in the console.

## 🧠 Why this Matters for AI/ML
Understanding low-level memory manipulation and register management is critical for:
- **Optimization:** Writing efficient kernels for ML model performance.
- **Hardware Acceleration:** Understanding how data flows through a CPU/GPU at the instruction level.
- **Algorithm Design:** Mastering the fundamental logic behind sorting and data arrangement.

---
**Author:** Maryam Khalid  
*Computer Science Undergraduate | Bahria University*
