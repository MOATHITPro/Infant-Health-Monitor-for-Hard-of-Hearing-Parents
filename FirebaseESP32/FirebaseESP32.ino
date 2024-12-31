#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <addons/TokenHelper.h> // لمراقبة حالة التوكن
#include "arduinoFFT.h"

// بيانات Wi-Fi
#define WIFI_SSID "Yemen4G-4D5C94"
#define WIFI_PASSWORD "ZaiYas77Moh#"

// بيانات Firebase
#define API_KEY "AIzaSyDqf8zSPSB-fq0ZAc2Y7-ZVTInSJdJhgOU"
#define DATABASE_URL "https://esp32projectv2-default-rtdb.firebaseio.com/"
#define USER_EMAIL "moath.itpro@gmail.com"
#define USER_PASSWORD "Moath770937324$"

//  Firebase
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// إعدادات مستشعر الصوت
#define SOUND_SENSOR_PIN 35 // الدبوس الذي يتصل به OUT من MAX4466
const uint16_t samples = 64; // عدد العينات في كل دورة
const float samplingFrequency = 1000; // تردد العينة (Hz)
int sound_threshold = 80; // العتبة التي نعتبر عندها أن الطفل يبكي

// مصفوفات لتمثيل البيانات
float vReal[samples];
float vImag[samples];

// كائن FFT
ArduinoFFT FFT = ArduinoFFT(vReal, vImag, samples, samplingFrequency);

void setup() {
  Serial.begin(9600);

  // الاتصال بشبكة Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.println("Connected to Wi-Fi");

  // إعداد Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.token_status_callback = tokenStatusCallback; // لمراقبة حالة التوكن
  Firebase.begin(&config, &auth);
  Serial.println("Initializing Firebase...");

  // التحقق من جاهزية API Key
  bool firebaseInitialized = false;
  for (int i = 0; i < 10; i++) { // نحاول التحقق 10 مرات
    if (Firebase.ready()) {
      firebaseInitialized = true;
      break; // جاهز، نخرج من الحلقة
    }
    Serial.println("Waiting for Firebase to initialize...");
    delay(1000); // الانتظار ثانية واحدة لكل محاولة
  }

  if (firebaseInitialized) {
    Serial.println("Firebase Initialized");
  } else {
    Serial.println("Failed to initialize Firebase. Check API Key or connection.");
    while (true); // توقف البرنامج هنا إذا لم يتم التهيئة
  }

  pinMode(SOUND_SENSOR_PIN, INPUT); // تعريف دبوس الميكروفون كمدخل
  Serial.println("System Ready");
}

void loop() {
  // أخذ عينات من مستشعر الصوت
  for (int i = 0; i < samples; i++) {
    vReal[i] = analogRead(SOUND_SENSOR_PIN); // قراءة البيانات من الميكروفون
    vImag[i] = 0; // المصفوفة التخيلية يجب أن تكون صفر
    delayMicroseconds(1000); // تأخير بسيط للحصول على عينات بمعدل التردد المطلوب
  }

  // حساب FFT
  FFT.windowing(FFTWindow::Hamming, FFTDirection::Forward); // تطبيق نافذة هامينغ
  FFT.compute(FFTDirection::Forward); // حساب FFT
  FFT.complexToMagnitude(); // تحويل الأرقام المركبة إلى قيم الحجم

  // العثور على التردد الأكثر هيمنة (الأعلى)
  float peakFrequency = FFT.majorPeak();

  // طباعة التردد الرئيسي
  Serial.print("Peak Frequency: ");
  Serial.print(peakFrequency);
  Serial.println(" Hz");

  // إذا تجاوز التردد الرئيسي العتبة، يتم اعتبار أن الطفل يبكي
  if (peakFrequency > sound_threshold) {
    Serial.println("=> Baby is crying");

    // إرسال البيانات إلى Firebase
    if (Firebase.ready()) {
      String path = "/baby_status/crying";
      if (Firebase.setString(fbdo, path, "Baby is crying")) {
        Serial.println("Status sent to Firebase: Baby is crying");
      } else {
        Serial.println("Failed to send status: " + fbdo.errorReason());
      }
    }
  } 
  
  //else {
  //  Serial.println("=> Noise detected");

    // إرسال حالة أخرى إلى Firebase
  //  if (Firebase.ready()) {
    //  String path = "/baby_status/crying";
    //  if (Firebase.setString(fbdo, path, "No crying detected")) {
    //    Serial.println("Status sent to Firebase: No crying detected");
    //  } else {
    //    Serial.println("Failed to send status: " + fbdo.errorReason());
    //  }
   // }
 // }

  delay(300); // تأخير بين القراءات
}
