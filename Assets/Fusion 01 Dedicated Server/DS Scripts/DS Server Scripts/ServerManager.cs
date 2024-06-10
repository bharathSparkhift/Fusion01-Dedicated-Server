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

namespace Game15Server
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
        [SerializeField] private Button         startAsServerButton;
        [SerializeField] private Button         getIntoClientScene;
        [SerializeField] private TMP_Dropdown   serverRegion;
        #endregion

        #region private fields
        Region region;
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

        /// <summary>
        /// Start server OnButtonClick()
        /// </summary>
        public async void StartServer()
        {

            
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
            var startGame = await serverRunner.StartGame(startGameArgs);


            if (startGame.Ok == true)
            {
                startAsServerButton.gameObject.SetActive(false);
                getIntoClientScene.gameObject.SetActive(false);
                Debug.Log($"Server Result {startGame.Ok} ");
            }
            else
            {
                Debug.LogError($"Server Result {startGame.ShutdownReason} :\n Game args {startGameArgs}");
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


    }
}

