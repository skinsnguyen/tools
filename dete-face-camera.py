import cv2
import os
import json
from datetime import datetime

class FaceSaver:
    def __init__(self, save_path="face_records"):
        self.save_path = save_path
        self.faces_folder = os.path.join(save_path, "faces")
        self.frames_folder = os.path.join(save_path, "full_frames")
        self.metadata_file = os.path.join(save_path, "metadata.json")
        
        # Tạo thư mục
        os.makedirs(self.faces_folder, exist_ok=True)
        os.makedirs(self.frames_folder, exist_ok=True)
        
        # Load metadata hiện có
        self.metadata = self.load_metadata()
        self.record_id = len(self.metadata)
    
    def load_metadata(self):
        if os.path.exists(self.metadata_file):
            with open(self.metadata_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    
    def save_metadata(self):
        with open(self.metadata_file, 'w', encoding='utf-8') as f:
            json.dump(self.metadata, f, indent=4, ensure_ascii=False)
    
    def save_face(self, frame, face_coords):
        x, y, w, h = face_coords
        timestamp = datetime.now()
        
        # Cắt khuôn mặt
        padding = 20
        y1 = max(0, y - padding)
        y2 = min(frame.shape[0], y + h + padding)
        x1 = max(0, x - padding)
        x2 = min(frame.shape[1], x + w + padding)
        face_img = frame[y1:y2, x1:x2]
        
        # Tạo tên file
        date_str = timestamp.strftime("%Y%m%d_%H%M%S_%f")
        face_filename = f"face_{self.record_id:05d}_{date_str}.jpg"
        frame_filename = f"frame_{self.record_id:05d}_{date_str}.jpg"
        
        face_path = os.path.join(self.faces_folder, face_filename)
        frame_path = os.path.join(self.frames_folder, frame_filename)
        
        # Lưu ảnh
        cv2.imwrite(face_path, face_img)
        cv2.imwrite(frame_path, frame)
        
        # Lưu metadata
        record = {
            "id": self.record_id,
            "timestamp": timestamp.strftime("%Y-%m-%d %H:%M:%S"),
            "face_image": face_filename,
            "full_frame": frame_filename,
            "coordinates": {"x": int(x), "y": int(y), "w": int(w), "h": int(h)},
            "face_size": f"{w}x{h}"
        }
        
        self.metadata.append(record)
        self.save_metadata()
        self.record_id += 1
        
        return face_filename

# Sử dụng
rtsp_url = "rtsp://username:password@camera_ip:554/Streaming/Channels/101"
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

cap = cv2.VideoCapture(rtsp_url, cv2.CAP_FFMPEG)
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)

saver = FaceSaver(save_path="face_records")

print("Nhấn 's' để lưu khuôn mặt | 'q' để thoát")

while True:
    ret, frame = cap.read()
    if not ret:
        break
    
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.2, minNeighbors=5)
    
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
    
    cv2.putText(frame, f'Faces: {len(faces)} | Saved: {saver.record_id}', 
               (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)
    cv2.imshow('Face Saver', frame)
    
    key = cv2.waitKey(1) & 0xFF
    if key == ord('s') and len(faces) > 0:
        for face in faces:
            filename = saver.save_face(frame, face)
            print(f"✓ Đã lưu: {filename}")
    elif key == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
print(f"Tổng số record: {saver.record_id}")
