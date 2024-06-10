using Fusion;
using Fusion.Photon.Realtime;
using Fusion.Sockets;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
using System;

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
        #endregion

        #region Private Fields
        /// <summary>
        /// Session properties
        /// </summary>
        public Dictionary<string, SessionProperty> SessionProperties { get; private set; } = new Dictionary<string, SessionProperty>();
        #endregion

        #region Public fields

        public Region region;
        #endregion


        #region Monobehaviour callbacks
        // Start is called before the first frame update
        async void Start()
        {
            // sStartServer();
#if !UNITY_SERVER
            // SceneManager.LoadScene(1, LoadSceneMode.Single);
#endif

        }
#endregion

        /// <summary>
        /// Start server
        /// </summary>
        public async void StartServer()
        {
            serverRunner.name = $"server {sessionName.text.Trim()}";

            var appSettings = PhotonAppSettings.Instance.AppSettings.GetCopy();

            appSettings.FixedRegion = region.ToString().ToLower();  // Region.asia.ToString().ToLower();

            StartGameArgs startGameArgs = new StartGameArgs()
            {
                SessionName = sessionName.text.Trim(),
                GameMode = GameMode.Server,
                SceneManager = serverRunner.gameObject.AddComponent<NetworkSceneManagerDefault>(),
                Scene = 2,
                Address = NetAddress.Any(ushort.Parse(portNumber.text.Trim())),
                CustomPhotonAppSettings = appSettings,
                PlayerCount = Int32.Parse(playerCount.text.Trim()),
                DisableClientSessionCreation = false,


            };
            var startGame = await serverRunner.StartGame(startGameArgs);


            if (startGame.Ok == true)
            {
                Debug.Log($"Result {startGame.Ok} :\n Game args {startGameArgs}");
            }
            else
            {
                Debug.LogError($"Result {startGame.Ok} :\n Game args {startGameArgs}");
            }
#if UNITY_SERVER

            
#endif
        }


    }
}

