using Fusion;
using Fusion.Photon.Realtime;
using Fusion.Sockets;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
using System;
using UnityEngine.UI;
using LegacyLoot_API;
using System.Threading.Tasks;

namespace LegacyLoot
{
    /// <summary>
    /// ServerManager
    /// </summary>
    public class ServerManager : MonoBehaviour
    {

        public enum Region
        {
            asia,  
            kr,
            us  
        }

        #region Serialize Private Fields
        [SerializeField] private NetworkRunner  serverRunner;
        

        [SerializeField] private TMP_InputField sessionName;
        [SerializeField] private TMP_InputField portNumber;
        [SerializeField] private TMP_InputField playerCount;
        [SerializeField] private Button         startServerButton;
        [SerializeField] private Button         killServerButton;
        [SerializeField] private Button         getIntoClientScene;
        [SerializeField] private TMP_Dropdown   serverRegion;
        [SerializeField] private TMP_Text       messageText;
        #endregion

        #region Public fields
        public Server_API_Handler APIHandler;
        #endregion

        #region private fields
        Region region;
        NetworkRunner _cacheServerRunner;
        #endregion

        private void Start()
        {
#if UNITY_SERVER
            StartServer();
            Debug.Log("Server Platform");

            // Instantiate network runner for server
             
            Instantiate(serverRunner);
#endif
        }

        private void OnEnable()
        {
            _cacheServerRunner = serverRunner;
        }

        private void OnDestroy()
        {
            APIHandler.ShutDownServer();
        }               

        private void OnApplicationQuit()
        {

            
        }

        

        
        /// <summary>
        /// Check the server with the inputs OnButtonClick
        /// </summary>
        public void CheckServerWithInputRequirements()
        {
            GameRoom gameRoom = APIHandler.CreateRoomOnServerStart(portNumber: portNumber.text.Trim(),
                roomName: sessionName.text.Trim(),
                region: region.ToString().Trim(),
                maxPlayers: playerCount.text.Trim());

            Debug.Log($"{nameof(CheckServerWithInputRequirements)} \n {gameRoom.responseCode}");

            
        }

        /// <summary>
        /// Start server OnButtonClick()
        /// </summary>
        public async void StartServer()
        {
            if(serverRunner == null)
            {
                serverRunner = _cacheServerRunner;
            }

            serverRunner.name = $"Server Network Runner";

            var photonAppSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();

            photonAppSettings.FixedRegion = region.ToString().Trim();

            StartGameArgs startGameArgs = new StartGameArgs()
            {
                SessionName = sessionName.text.Trim(),
                GameMode = GameMode.Server,
                SceneManager = serverRunner.gameObject.AddComponent<NetworkSceneManagerDefault>(),
                Scene = 2,
                Address = NetAddress.Any(ushort.Parse(portNumber.text.Trim())),
                CustomPhotonAppSettings = photonAppSettings,
                PlayerCount = Int32.Parse(playerCount.text.Trim()),
                DisableClientSessionCreation = false,
            };

            StartGameResult startGame = await serverRunner.StartGame(startGameArgs);

            if (startGame.Ok == true)
            {
                ToggleButtons(false);
                messageText.text = $"Start Game Result {startGame}";
                Debug.Log($"{messageText.text}");
            }
            else
            {
                messageText.text = $"<color=red>Server Result {startGame.ShutdownReason} :\n Game args {startGameArgs}</color>";
                Debug.Log($"{messageText.text}");
            }

        }

        

        /// <summary>
        /// Get into the client scene
        /// </summary>
        public void GetIntoClientScene()
        {
            SceneManager.LoadSceneAsync(1);
        }

        /// <summary>
        /// Drop down OnValue Changed()
        /// </summary>
        /// <param name="value"></param>
        public void RegionOnValueChanged(int value)
        {

            switch (value) { 
                case 0:
                    region = Region.asia;
                    break;
                case 1:
                    region = Region.kr;
                    break;
                case 2:
                    region = Region.us;
                    break;
            }

            Debug.Log($"{nameof(RegionOnValueChanged)} \t Region name {region}");
        }

        public void ToggleButtons(bool value)
        {
            startServerButton.gameObject.SetActive(value);
            killServerButton.gameObject.SetActive(!value);
            getIntoClientScene.gameObject.SetActive(value);
        }


    }
}

