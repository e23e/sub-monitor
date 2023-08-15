import requests
import os
from libs.utils import get_logger
import time

BOT_TOKEN = os.getenv("TELEGRAM_TOKEN")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")
TELEGRAM_API = "https://api.telegram.org"
HEADERS = {
    "accept" : "application/json",
    "content-type" : "application/json"
}


logger = get_logger()

def send_message(message: str):
    logger.info(f"Sending message: {message}")
    url = f"{TELEGRAM_API}/bot{BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id" : CHAT_ID,
        "text" : message
    }
    res = requests.post(url=url, json=payload, headers=HEADERS, verify=False)
    if res.status_code != 200:
        logger.error(f"Unknown error occurd at sending messages status code {res.status_code}\
                     test: {res.text}")

def send_photos(photos_path: str):
    logger.info("Sending photos!")
    url = f"{TELEGRAM_API}/bot{BOT_TOKEN}/sendPhoto"
    all_images = []
    for f in os.listdir(photos_path):
        if os.path.isfile(photos_path+"/"+f) and f.endswith("png"):
            all_images.append(os.path.join(photos_path,f))
    for image_path in all_images:
        try:
            payload = {
                "photo" : open(image_path, "rb")
                }
            res = requests.post(url, {"caption" : f"{image_path}","chat_id" : CHAT_ID }, files=payload, verify=False)
            if res.status_code != 200:
                err_msg = f"Unknown status: {res.status_code} text: {res.text}"
                logger.error(err_msg)
                send_message(err_msg)
        except Exception as e:
            err_msg = f"Unknown error occurd at sending photos {e}"
            logger.error(err_msg)
            send_message(err_msg)
        time.sleep(3.1)

