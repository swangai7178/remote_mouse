import asyncio
import websockets
import pyautogui
import json

async def mouse_control(websocket, path):
    async for message in websocket:
        try:
            data = json.loads(message.replace("'", "\""))  # Convert Flutter's message format to JSON
            action = data.get("action")

            if action == "move":
                pyautogui.moveRel(data["dx"], data["dy"])
            elif action == "click":
                pyautogui.click()
        except Exception as e:
            print("Error:", e)

async def main():
    async with websockets.serve(mouse_control, "0.0.0.0", 3000):
        await asyncio.Future()  # Keeps the server running indefinitely

if __name__ == "__main__":
    asyncio.run(main())  # Explicitly start the event loop
