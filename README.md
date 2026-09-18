\# FPGA-Based Hand Gesture Classification



An FPGA-based hand gesture classification system using computer vision, handcrafted image features, and a Decision Tree classifier. The system processes hand gesture images, extracts compact features, and implements the trained classifier on FPGA hardware.



\## Overview



This project implements a hand gesture classification pipeline that combines \*\*image preprocessing, handcrafted feature extraction, machine learning, and FPGA implementation\*\*.



The input image is processed to isolate the hand region. A set of global and regional features is then extracted from the processed image and used to classify the gesture using a Decision Tree model. The trained classification logic is implemented in VHDL for FPGA deployment.



The system supports \*\*14 gesture classes\*\*, consisting of letters and digits.



\## Gesture Classes



The classifier supports the following 14 classes:



\* A

\* I

\* O

\* U

\* C

\* L

\* V

\* X

\* Y

\* 3

\* 4

\* 5

\* 8

\* 9



\## System Pipeline



```text

Input Image

&#x20;    │

&#x20;    ▼

Image Resizing

&#x20;    │

&#x20;    ▼

YCrCb Skin Segmentation

&#x20;    │

&#x20;    ▼

Morphological Filtering

&#x20;    │

&#x20;    ▼

Hand Contour Detection

&#x20;    │

&#x20;    ▼

Crop and Resize

&#x20;    │

&#x20;    ▼

Handcrafted Feature Extraction

&#x20;    │

&#x20;    ▼

Decision Tree Classification

&#x20;    │

&#x20;    ▼

FPGA Implementation

```



\## Image Preprocessing



The image preprocessing stage prepares the input image for feature extraction.



\### 1. Image Resizing



Input images are resized to:



```text

320 × 240 pixels

```



This provides a consistent input size for subsequent processing.



\### 2. YCrCb Skin Segmentation



The input image is converted from \*\*BGR to YCrCb color space\*\*.



A threshold-based segmentation is then applied to identify pixels corresponding to the hand region.



The implemented thresholds are:



```text

Y  : 0 – 255

Cr : 133 – 173

Cb : 77 – 127

```



YCrCb separates luminance information from chrominance components, making it suitable for isolating the skin region during image preprocessing.



\### 3. Morphological Filtering



Morphological processing is applied using a \*\*5 × 5 elliptical kernel\*\* to reduce small gaps and improve the segmented hand region.



\### 4. Hand Detection



Contours are extracted from the processed binary image. The largest valid contour is selected as the hand region, subject to a minimum contour area threshold.



The minimum hand area used in the implementation is:



```text

500 pixels

```



\### 5. Crop and Resize



The detected hand region is cropped from the image and resized to:



```text

64 × 64 pixels

```



This provides a fixed-size representation for feature extraction.



\## Feature Extraction



Instead of directly using the complete image as input to the classifier, the project uses \*\*24 handcrafted features\*\*.



\### Global Features



Eight global features are extracted from the processed hand image.



These features describe characteristics of the overall hand region.



```text

f0 – f7

```



\### Regional Features



The 64 × 64 processed image is divided into a \*\*4 × 4 grid\*\*.



The number of detected hand pixels in each region is calculated, producing 16 regional features:



```text

r0 – r15

```



\### Total Features



```text

8 global features + 16 regional features = 24 features

```



The resulting feature vector is used as the input to the machine learning classifier.



\## Machine Learning Classification



A \*\*Decision Tree classifier\*\* is trained using the extracted feature vectors.



The training pipeline includes:



\* Feature dataset generation

\* Train/test split

\* Decision Tree training

\* Classification report

\* Confusion matrix

\* Decision Tree visualization

\* Extraction of decision thresholds for FPGA implementation



The dataset is divided into training and testing subsets using an \*\*80/20 split\*\* with stratification.



The trained Decision Tree is then used as the basis for the FPGA classification logic.



\## FPGA Implementation



The trained classification pipeline is implemented using \*\*VHDL\*\*.



The FPGA implementation contains separate modules for different parts of the system:



\* Image/feature processing

\* Feature extraction

\* Decision Tree classification

\* UART communication

\* LCD display

\* Top-level system integration



The Decision Tree thresholds generated during the machine learning stage are translated into hardware decision logic.



\## Simulation



A separate simulation environment is included to verify the FPGA modules before hardware deployment.



The simulation folder contains:



\* Decision Tree classifier

\* Feature extraction

\* Preprocessing

\* Testbench for sign language classification



The testbench is used to verify the behavior of the implemented hardware modules.



\## Results



The machine learning model achieved approximately \*\*92.3% classification accuracy\*\* on the held-out test set used during development.



The test set contained \*\*196 samples\*\* across the 14 gesture classes.



The notebook also generates a classification report and confusion matrix to evaluate the model's performance across individual classes.



\## Technologies Used



\### Programming \& Machine Learning



\* Python

\* OpenCV

\* NumPy

\* Scikit-learn

\* Matplotlib

\* Jupyter Notebook



\### Computer Vision



\* Image resizing

\* YCrCb color-space segmentation

\* Morphological image processing

\* Contour detection

\* Region-based feature extraction



