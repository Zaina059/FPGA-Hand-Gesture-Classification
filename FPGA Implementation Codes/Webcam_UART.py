import cv2
import numpy as np
import serial
import time
import os

COM_PORT = "COM5"
BAUD = 115200

ser = serial.Serial(COM_PORT, BAUD, timeout=1)
time.sleep(2)

def extract_features(mask64):
    binary = (mask64 > 0).astype(np.uint8)
    total = int(binary.sum())

    ys, xs = np.where(binary == 1)

    if total == 0:
        centroid_x = 0
        centroid_y = 0
    else:
        centroid_x = int(xs.mean() * 255 / 63)
        centroid_y = int(ys.mean() * 255 / 63)

    f0 = int(total * 255 / 4096)
    f1 = centroid_x
    f2 = centroid_y
    f3 = int(binary[:32, :].sum() * 255 / 2048)
    f4 = int(binary[32:, :].sum() * 255 / 2048)
    f5 = int(binary[:, :32].sum() * 255 / 2048)
    f6 = int(binary[:, 32:].sum() * 255 / 2048)
    f7 = int(binary[24:40, 24:40].sum() * 255 / 256)

    regions = []
    for row in range(4):
        for col in range(4):
            block = binary[row*16:(row+1)*16, col*16:(col+1)*16]
            regions.append(int(block.sum() * 255 / 256))

    return regions + [f0, f1, f2, f3, f4, f5, f6, f7]


def crop_largest_blob(mask):
    num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(mask)

    if num_labels <= 1:
        return np.zeros((64, 64), dtype=np.uint8), mask

    areas = stats[1:, cv2.CC_STAT_AREA]
    largest_label = 1 + np.argmax(areas)

    x = stats[largest_label, cv2.CC_STAT_LEFT]
    y = stats[largest_label, cv2.CC_STAT_TOP]
    w = stats[largest_label, cv2.CC_STAT_WIDTH]
    h = stats[largest_label, cv2.CC_STAT_HEIGHT]

    pad = 30

    x1 = max(x - pad, 0)
    y1 = max(y - pad, 0)
    x2 = min(x + w + pad, mask.shape[1])
    y2 = min(y + h + pad, mask.shape[0])

    cropped = mask[y1:y2, x1:x2]

    mask64 = cv2.resize(cropped, (64, 64), interpolation=cv2.INTER_NEAREST)

    debug_mask = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)
    cv2.rectangle(debug_mask, (x1, y1), (x2, y2), (0, 255, 0), 2)

    return mask64, debug_mask


cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()

    if not ret:
        break

    frame = cv2.flip(frame, 1)

    ycrcb = cv2.cvtColor(frame, cv2.COLOR_BGR2YCrCb)

    lower = np.array([0, 135, 85], dtype=np.uint8)
    upper = np.array([255, 180, 135], dtype=np.uint8)

    mask = cv2.inRange(ycrcb, lower, upper)

    kernel = np.ones((5, 5), np.uint8)

    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)

    mask64, debug_mask = crop_largest_blob(mask)

    features = extract_features(mask64)

    cv2.imshow("Webcam", frame)
    cv2.imshow("Skin Mask with Crop Box", debug_mask)
    cv2.imshow("64x64 Cropped Binary", mask64)

    key = cv2.waitKey(1) & 0xFF

    if key == ord('s'):
        binary64 = (mask64 > 0).astype(np.uint8)

        with open("fpga_input.txt", "w") as f:
            for y in range(64):
                for x in range(64):
                    f.write(f"{x} {y} {binary64[y, x]}\n")

        print("Saved to:", os.path.abspath("fpga_input.txt"))
        print("Features:")
        print(features)

        ser.write(bytes([0xAA]))

        for y in range(64):
            for x in range(64):
                ser.write(bytes([int(binary64[y, x])]))

        print("Frame sent to FPGA")

    if key == 27:
        break

cap.release()
ser.close()
cv2.destroyAllWindows()