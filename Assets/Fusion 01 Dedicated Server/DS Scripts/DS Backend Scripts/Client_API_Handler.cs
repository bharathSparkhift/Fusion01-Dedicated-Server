using LegacyLoot;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Networking;


namespace LegacyLoot_API {

    [Serializable]
    public class GameRoomList
    {
        public List<GameRoom> gameRooms = new List<GameRoom>();
    }
    // Helper class to handle JSON arrays
    public static class JsonHelper
    {
        public static T[] FromJson<T>(string json)
        {
            string newJson = "{ \"array\": " + json + "}";
            Wrapper<T> wrapper = JsonUtility.FromJson<Wrapper<T>>(newJson);
            return wrapper.array;
        }

        [Serializable]
        private class Wrapper<T>
        {
            public T[] array;
        }
    }

    public class Client_API_Handler : MonoBehaviour
    {
        [SerializeField] private ClientManager clientManager;

        private const string GetRoomEndPoints = "http://localhost:8080/api/gameroom/all";

        public GameRoom[] GameRoomsArray { get; private set; }

        // Start is called before the first frame update
        void Start()
        {
            GameRoomsArray = new GameRoom[10];
        }


        private void OnEnable()
        {
            StartCoroutine(GetListOfRoomOnClientStart(GetRoomEndPoints));
        }


        private void OnApplicationFocus(bool focus)
        {
            StartCoroutine(GetListOfRoomOnClientStart(GetRoomEndPoints));
            Debug.Log($"<color=blue>{nameof(OnApplicationFocus)} \t focus {focus}</color>");
        }

        private void OnApplicationPause(bool pause)
        {
            Debug.Log($"<color=blue>{nameof(OnApplicationPause)}</color>");
        }


        IEnumerator GetListOfRoomOnClientStart(string uri)
        {
            UnityWebRequest webRequest = new UnityWebRequest(uri, "GET");
            webRequest.SetRequestHeader("content-type", "application/json");
            webRequest.downloadHandler = new DownloadHandlerBuffer();
            
            yield return webRequest.SendWebRequest();

            if(webRequest.responseCode == 200 || webRequest.result == UnityWebRequest.Result.Success)
            {
                // List<GameRoom> gameRooms = JsonUtility.FromJson<List<GameRoom>>(webRequest.downloadHandler.text);
                Debug.Log(webRequest.downloadHandler.text);
                // GameRoomList roomList = JsonUtility.FromJson<GameRoomList>(webRequest.downloadHandler.text);

                // Deserialize the JSON array
                GameRoomsArray = JsonHelper.FromJson<GameRoom>(webRequest.downloadHandler.text);

                if (GameRoomsArray != null && GameRoomsArray.Length > 0)
                {
                    int i = 0;
                    foreach (GameRoom gameRoom in GameRoomsArray)
                    {
                        Debug.Log($"Game Room name: {gameRoom.room_name} \t Port: {gameRoom.port_number} \t Region: {gameRoom.region} \t Max Players: {gameRoom.max_players}");
                        StartCoroutine(clientManager.UpdateUi(i, gameRoom));
                        i++;
                    }
                }
                else
                {
                    Debug.Log("No game rooms found or failed to parse response.");
                }
            }
            if (webRequest.responseCode != 200 || webRequest.result == UnityWebRequest.Result.ConnectionError)
            {
                Debug.Log($"<color=red>Response code {webRequest.responseCode} \t Failed to connect with the server.</color>");
            }
            
            
            


        }
    }

}


