using Game15Server;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Networking;

using LegacyLoot;
using System;
namespace LegacyLoot_API
{
    [Serializable]
    public class GameRoom
    {
        // public string room_Id;
        public string port_number;
        public string room_name;
        public string region;
        public string max_players;
        public string responseCode;
        public string message;
    }

    public class Server_API_Handler : MonoBehaviour
    {
        [SerializeField] private ServerManager serverManager;

        private const string CreateRoomEndPoint = "http://localhost:8080/api/gameroom/create";
        private const string DeleteRoomEndPoint = "http://localhost:8080/api/gameroom/deleteAllRooms"; 

        GameRoom Game_Room;

        public int RoomCreationResponseCode { get; private set; }


        private void Awake()
        {
            
        }

        public GameRoom CreateRoomOnServerStart(string portNumber, string roomName, string region, string maxPlayers)
        {
            
            Game_Room = new GameRoom();
            Game_Room.port_number = portNumber;
            Game_Room.room_name = roomName;
            Game_Room.region = region;
            Game_Room.max_players = maxPlayers;

            string json = JsonUtility.ToJson(Game_Room);
            StartCoroutine(CreateRoomWithUnityWebRequest(CreateRoomEndPoint, json, Game_Room));
            Debug.Log($"{nameof(CreateRoomOnServerStart)}");
            return Game_Room;
        }

        IEnumerator CreateRoomWithUnityWebRequest(string uri, string jsonData, GameRoom gameRoom)
        {
            UnityWebRequest createRoomWebRequest = new UnityWebRequest(uri, "POST");
            createRoomWebRequest.SetRequestHeader("content-type", "application/json");

            byte[] jsonToSend = new UTF8Encoding().GetBytes(jsonData);
            createRoomWebRequest.uploadHandler = new UploadHandlerRaw(jsonToSend);
            createRoomWebRequest.downloadHandler = new DownloadHandlerBuffer();

            yield return createRoomWebRequest.SendWebRequest();
            Debug.Log($"{createRoomWebRequest.downloadHandler.text}");
            GameRoom gameRoomOutPut = JsonUtility.FromJson<GameRoom>(createRoomWebRequest.downloadHandler.text);
            
           
            if(gameRoomOutPut.responseCode == "200")
            {
                serverManager.StartServer();
                RoomCreationResponseCode = 200;
                Debug.Log($"<color=green>Response Code {gameRoomOutPut.responseCode} \t Message {gameRoomOutPut.message}</color>");
                Debug.Log($"<color=green>Game room output {gameRoomOutPut}</color>");
            }
            else
            {
                RoomCreationResponseCode = 500;
                Debug.Log($"<color=red>Response Code {gameRoomOutPut.responseCode} \t Message {gameRoomOutPut.message}</color>");
                Debug.Log($"<color=red>Game room output {gameRoomOutPut}</color>");
            }
            
            createRoomWebRequest.Dispose();
        }

        /// <summary>
        /// Kill all the running server OnButtonClick
        /// </summary>
        public async void ShutDownServer()
        {
            
            ServerGameController serverGameController = FindObjectOfType<ServerGameController>();
            if (serverGameController == null)
                return;
            serverGameController.ShutDownServer();
            serverManager.ToggleButtons(true);
            StartCoroutine(DeleteRoomWithUnityWebRequest(DeleteRoomEndPoint));

            Debug.Log($"{nameof(ShutDownServer)}");
        }

        IEnumerator DeleteRoomWithUnityWebRequest(string deleteRoomEndPoint)
        {
            UnityWebRequest deleteRoomWebRequest = new UnityWebRequest(deleteRoomEndPoint, "POST");
            deleteRoomWebRequest.SetRequestHeader("content-type", "application/json");

            yield return deleteRoomWebRequest.SendWebRequest();
            if(deleteRoomWebRequest.responseCode == 200)
            {
                Debug.Log($"<color=green>Response Code {deleteRoomWebRequest.responseCode} \t All the rooms are deleted</color>");
            }
            else
            {
                Debug.Log($"<color=red>Response Code {deleteRoomWebRequest.responseCode} \t Failed to deleted the existing rooms</color>");
            }
        }
    }
}

