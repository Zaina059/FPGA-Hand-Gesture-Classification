# FPGA-Based Hand Gesture Classification

**Computer Vision · Machine Learning · FPGA · VHDL**

> An FPGA-based hand gesture classification system combining computer vision, handcrafted feature extraction, and a Decision Tree classifier for recognizing 14 hand gesture classes.

## ✨ Highlights

|                    |                                        |
| ------------------ | -------------------------------------- |
| **14 Classes**     | Letters and digits                     |
| **92.3% Accuracy** | On 196 held-out test samples           |
| **24 Features**    | Global + regional handcrafted features |
| **FPGA**           | VHDL hardware implementation           |

---

## 🔄 System Pipeline

```text
Input Image
     ↓
320 × 240 Resize
     ↓
YCrCb Skin Segmentation
     ↓
Morphological Filtering
     ↓
Hand Contour Detection
     ↓
64 × 64 Hand Region
     ↓
24 Handcrafted Features
     ↓
Decision Tree
     ↓
FPGA / VHDL Implementation
```

## 🖐️ Gesture Classes

`A` `I` `O` `U` `C` `L` `V` `X` `Y` `3` `4` `5` `8` `9`

## 🧠 Machine Learning

The classification pipeline uses a **Decision Tree** trained on 24 handcrafted features:

* **8 global features**
* **16 regional features**
* **80/20 stratified train-test split**
* Confusion matrix and classification report for evaluation

## 👁️ Computer Vision

The preprocessing pipeline consists of:

**Resize → YCrCb segmentation → Morphological filtering → Contour detection → Crop & resize**

The hand region is extracted and resized to **64 × 64 pixels** before feature extraction.

## ⚙️ FPGA Implementation

The trained model is translated into VHDL-based hardware logic.

The implementation includes:

* Decision Tree classifier
* Feature extraction
* UART communication
* LCD display
* Top-level system integration

A separate simulation environment is also included for hardware verification.

## 📊 Results

**Classification Accuracy: 92.3%**

Evaluated on **196 test samples** across 14 gesture classes.

## 🛠️ Technologies

`Python` `OpenCV` `NumPy` `Scikit-learn` `Matplotlib` `Jupyter Notebook` `VHDL` `FPGA`
