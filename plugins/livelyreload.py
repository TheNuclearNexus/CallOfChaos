import datetime
import logging
import time
from beet import Context
from beet.contrib.autosave import Autosave

import socket

logger = logging.getLogger("lively-reload")
startTime = 0


def beet_default(ctx: Context):
    autosave = ctx.inject(Autosave)

    global startTime
    startTime = time.time()

    autosave.add_link(finalize)
    send_commands(
        [
            '/tellraw @a ["\\n", {{"text": "[{curtime}] ", "color": "gray"}}, {{"text": "[Lively Reload] ", "bold": true, "color": "white"}},{{"text": "Changes have been detected, building", "color": "gray"}}]'.format(
                curtime=datetime.datetime.now().strftime("%H:%M")
            ),
        ]
    )


def send_commands(commands: list[str]):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    logger.debug("Connect to socket server")

    try:
        s.connect(("127.0.0.1", 25566))
    except:
        logger.debug("Failed to connect to socket server")
        return

    logger.debug("Connected to socket server, sending commands")

    s.send(bytes("\n".join(commands), "utf-8"))
    logger.debug("Done sending")
    s.close()


def finalize(ctx: Context):
    logger.info("Plugins took %s to complete", time.time() - startTime)

    now = datetime.datetime.now()
    send_commands(
        [
            '/tellraw @a ["", {{"text": "[{curtime}] ", "color": "gray"}}, {{"text": "[Lively Reload] ", "bold": true, "color": "white"}},{{"text": "Project has been built, reloading", "color": "gray"}}]'.format(
                curtime=now.strftime("%H:%M")
            ),
            "/reload",
            '/tellraw @a ["",{{"text": "[{curtime}] ", "color": "gray"}},{{"text": "[Lively Reload] ", "bold": true, "color": "white"}},{{"text": "Reload has been completed", "color": "gray"}}]'.format(
                curtime=now.strftime("%H:%M")
            ),
        ]
    )
