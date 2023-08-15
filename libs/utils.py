import logging

LOG_FORMAT = "%(asctime)s - %(levelname)-8s [%(filename)s:%(lineno)d] - %(message)s"

def get_logger():
    logging.basicConfig(filename="log.log",level="INFO",format=LOG_FORMAT)
    logger = logging.getLogger("Sub Monitor")
    return logger



