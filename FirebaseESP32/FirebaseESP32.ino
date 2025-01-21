
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <addons/TokenHelper.h> // لمراقبة حالة التوكن
#include "arduinoFFT.h"

// بيانات Wi-Fi
#define WIFI_SSID "MoathAbbas"
#define WIFI_PASSWORD "12345678"

// بيانات Firebase
#define API_KEY "AIzaSyDHPCO59os2xnUkgSUIR1h1Fy3PgZPiyQI"
#define DATABASE_URL "https://esp32-7c93b-default-rtdb.firebaseio.com/"
#define USER_EMAIL "raghad.aba24@gmail.com"
#define USER_PASSWORD "plmplmokn"




// Firebase
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// إعدادات مستشعر الصوت
#define SOUND_SENSOR_PIN 35 // الدبوس الذي يتصل به OUT من MAX9814
const uint16_t samples = 64; // عدد العينات في كل دورة
const float samplingFrequency = 1000; // تردد العينة (Hz)
int sound_threshold = 91; // العتبة التي نعتبر عندها أن الطفل يبكي

// مصفوفات لتمثيل البيانات
float vReal[samples];
float vImag[samples];

// كائن FFT
ArduinoFFT FFT = ArduinoFFT(vReal, vImag, samples, samplingFrequency);

// متغير لتخزين الوقت الأخير الذي تم فيه الإرسال إلى Firebase
unsigned long lastSendTime = 0; // الوقت الافتراضي صفر
const unsigned long sendInterval = 60000; // مدة الانتظار بالدقائق (60,000ms = دقيقة واحدة)

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

    // التحقق مما إذا كانت المدة المطلوبة قد مرت منذ الإرسال الأخير
    unsigned long currentTime = millis();
    if (currentTime - lastSendTime >= sendInterval) {
      // تحديث الوقت الأخير
      lastSendTime = currentTime;

      // إرسال البيانات إلى Firebase
      if (Firebase.ready()) {
        String path = "/baby_status/crying";
        if (Firebase.setString(fbdo, path, "Baby is crying")) {
          Serial.println("Status sent to Firebase: Baby is crying");
        } else {
          Serial.println("Failed to send status: " + fbdo.errorReason());
        }
      }
    } else {
      // إذا لم تمر دقيقة، لا يتم الإرسال، ويستمر التحليل
      Serial.println("A cry detected, but waiting for the interval to pass before sending.");
    }
  }

  // تأخير بسيط بين الدورات
  delay(300); // تأخير بين القراءات

}