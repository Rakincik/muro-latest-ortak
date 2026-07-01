"""
MURO Podcast TTS Mikroservisi
Birincil Motor: Google Cloud TTS Chirp3-HD (en yuksek kalite)
Yedek Motor: Microsoft Edge TTS (ucretsiz fallback)

Endpoint: POST /synthesize { "script": "...", "voice": "tr-TR-Chirp3-HD-Achird" }
"""
import asyncio
import base64
import io
import os
import json
import tempfile
import requests
from flask import Flask, request, send_file, jsonify

app = Flask(__name__)

# --- Google Cloud TTS ---
GOOGLE_TTS_URL = "https://texttospeech.googleapis.com/v1/text:synthesize"
API_KEY = ""

# Chirp3-HD sesleri (Google'in en kaliteli sesleri)
CHIRP3_VOICES = {
    "tr-TR-Chirp3-HD-Achird":    {"gender": "MALE",   "label": "Kaan (Erkek)"},
    "tr-TR-Chirp3-HD-Enceladus": {"gender": "MALE",   "label": "Emre (Erkek)"},
    "tr-TR-Chirp3-HD-Charon":    {"gender": "MALE",   "label": "Burak (Erkek)"},
    "tr-TR-Chirp3-HD-Fenrir":    {"gender": "MALE",   "label": "Mert (Erkek)"},
    "tr-TR-Chirp3-HD-Puck":      {"gender": "MALE",   "label": "Cem (Erkek)"},
    "tr-TR-Chirp3-HD-Achernar":  {"gender": "FEMALE", "label": "Elif (Kadin)"},
    "tr-TR-Chirp3-HD-Aoede":     {"gender": "FEMALE", "label": "Zeynep (Kadin)"},
    "tr-TR-Chirp3-HD-Kore":      {"gender": "FEMALE", "label": "Ayse (Kadin)"},
    "tr-TR-Chirp3-HD-Leda":      {"gender": "FEMALE", "label": "Selin (Kadin)"},
    "tr-TR-Chirp3-HD-Zephyr":    {"gender": "FEMALE", "label": "Deniz (Kadin)"},
}

# Edge TTS yedek sesler
EDGE_VOICES = {
    "tr-TR-AhmetNeural": {"gender": "MALE",   "label": "Ahmet (Erkek) [Yedek]"},
    "tr-TR-EmelNeural":  {"gender": "FEMALE", "label": "Emel (Kadin) [Yedek]"},
}

DEFAULT_VOICE = "tr-TR-Chirp3-HD-Achird"


# --- Health & Voices ---

@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "ok",
        "primaryEngine": "google-cloud-tts-chirp3-hd",
        "fallbackEngine": "edge-tts",
        "apiKeyConfigured": bool(API_KEY),
        "voices": [{"id": k, "label": v["label"], "gender": v["gender"]} for k, v in CHIRP3_VOICES.items()],
    })


@app.route("/voices", methods=["GET"])
def list_voices():
    voices = [{"id": k, "label": v["label"], "gender": v["gender"]} for k, v in CHIRP3_VOICES.items()]
    return jsonify(voices)


# --- Synthesize ---

@app.route("/synthesize", methods=["POST"])
def synthesize():
    data = request.get_json(force=True)
    script = data.get("script", "").strip()
    voice = data.get("voice", DEFAULT_VOICE)

    if not script:
        return jsonify({"error": "Script bos olamaz."}), 400

    # Edge TTS voice gelirse Chirp3'e map et
    voice = _resolve_to_chirp3(voice)

    # 1. Chirp3-HD ile dene
    if API_KEY:
        try:
            app.logger.info(f"Chirp3-HD ile sentez: {voice}, {len(script)} karakter")
            audio = _google_tts_synthesize(script, voice)
            return send_file(io.BytesIO(audio), mimetype="audio/mpeg", download_name="podcast.mp3")
        except Exception as e:
            app.logger.warning(f"Chirp3-HD basarisiz, Edge TTS'e geciliyor: {e}")

    # 2. Fallback: Edge TTS
    edge_voice = _chirp3_to_edge(voice)
    try:
        app.logger.info(f"Edge TTS fallback: {edge_voice}, {len(script)} karakter")
        audio = asyncio.run(_edge_tts_synthesize(script, edge_voice))
        return send_file(io.BytesIO(audio), mimetype="audio/mpeg", download_name="podcast.mp3")
    except Exception as e:
        app.logger.error(f"Edge TTS de basarisiz: {e}")
        return jsonify({"error": f"TTS hatasi: {str(e)}"}), 500


# --- Google Cloud TTS ---

def _google_tts_synthesize(text, voice):
    """Tek istekle Google Cloud TTS Chirp3-HD sentezi."""
    if len(text) > 5000:
        return _google_tts_long(text, voice)

    return _google_tts_call(text, voice)


def _google_tts_call(text, voice):
    body = {
        "input": {"text": text},
        "voice": {
            "languageCode": "tr-TR",
            "name": voice,
        },
        "audioConfig": {
            "audioEncoding": "MP3",
            "speakingRate": 0.95,
            "pitch": 0.0,
            "sampleRateHertz": 24000,
            "effectsProfileId": ["headphone-class-device"],
        },
    }
    resp = requests.post(f"{GOOGLE_TTS_URL}?key={API_KEY}", json=body, timeout=30)
    if resp.status_code != 200:
        error_msg = resp.json().get("error", {}).get("message", resp.text)
        raise Exception(f"Google TTS API hatasi ({resp.status_code}): {error_msg}")
    return base64.b64decode(resp.json()["audioContent"])


def _google_tts_long(text, voice):
    """5000+ karakter metinleri parcalara bolerek sentezle."""
    chunks, current = [], ""
    for sentence in text.replace("!", "!|").replace("?", "?|").replace(".", ".|").split("|"):
        sentence = sentence.strip()
        if not sentence:
            continue
        if len(current) + len(sentence) + 1 > 4500:
            if current:
                chunks.append(current)
            current = sentence
        else:
            current = f"{current} {sentence}".strip()
    if current:
        chunks.append(current)

    all_audio = b""
    for chunk in chunks:
        all_audio += _google_tts_call(chunk, voice)
    return all_audio


# --- Edge TTS Fallback ---

async def _edge_tts_synthesize(text, voice):
    import edge_tts
    rate = "-8%"
    pitch = "+2Hz" if "Emel" in voice else "+0Hz"
    communicate = edge_tts.Communicate(text, voice, rate=rate, pitch=pitch)

    with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp:
        tmp_path = tmp.name
    try:
        await communicate.save(tmp_path)
        with open(tmp_path, "rb") as f:
            return f.read()
    finally:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)


# --- Voice Mapping ---

CHIRP3_FEMALE = ["Achernar", "Aoede", "Kore", "Leda", "Zephyr"]

def _resolve_to_chirp3(voice):
    """Herhangi bir voice ID'yi Chirp3-HD'ye cozumle."""
    if voice in CHIRP3_VOICES:
        return voice
    # Edge TTS -> Chirp3
    if voice == "tr-TR-AhmetNeural":
        return "tr-TR-Chirp3-HD-Achird"
    if voice == "tr-TR-EmelNeural":
        return "tr-TR-Chirp3-HD-Aoede"
    return DEFAULT_VOICE


def _chirp3_to_edge(voice):
    """Chirp3 voice'u Edge TTS karsligina cevir (fallback icin)."""
    for name in CHIRP3_FEMALE:
        if name in voice:
            return "tr-TR-EmelNeural"
    return "tr-TR-AhmetNeural"


# --- Main ---

if __name__ == "__main__":
    # API key'i appsettings.json'dan oku
    if not API_KEY:
        try:
            settings_path = os.path.join(os.path.dirname(__file__), "..", "src", "MURO.API", "appsettings.json")
            with open(settings_path) as f:
                settings = json.load(f)
                API_KEY = settings.get("Gemini", {}).get("ApiKey", "")
                if API_KEY:
                    print("[OK] API Key appsettings.json'dan yuklendi")
        except Exception:
            pass

    if not API_KEY:
        API_KEY = os.environ.get("GOOGLE_API_KEY", "")

    print("=" * 60)
    if API_KEY:
        print(f"[OK] API Key: ...{API_KEY[-8:]}")
        print("[*] Birincil Motor: Google Cloud TTS Chirp3-HD")
        print("[*] Yedek Motor: Edge TTS")
    else:
        print("[!] API Key bulunamadi - sadece Edge TTS kullanilacak")
    print(f"[*] Adres: http://localhost:5050")
    print("=" * 60)
    app.run(host="0.0.0.0", port=5050, debug=False)
