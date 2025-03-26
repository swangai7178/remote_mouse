import asyncio
import websockets
import pyautogui
import json

async def mouse_control(websocket, path):  # Ensure 'path' is included
    print("Function called from mouse_server.py") #debug line
    async for message in websocket:
        try:
            print("Received message:", message) #debug line
            data = json.loads(message.replace("'", "\""))
            action = data.get("action")

            if action == "move":
                pyautogui.moveRel(data["dx"], data["dy"])
            elif action == "click":
                pyautogui.click()
        except Exception as e:
            print("Error:", e)

async def main():
    async with websockets.serve(mouse_control, "0.0.0.0", 3000):
        print("WebSocket server started on ws://0.0.0.0:3000 (mouse_server.py)")
        await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())